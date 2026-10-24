<?php

namespace Tests\Feature;

use App\Models\NguoiDung;
use App\Services\DatChoService;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

#[\PHPUnit\Framework\Attributes\RunTestsInSeparateProcesses]
#[\PHPUnit\Framework\Attributes\PreserveGlobalState(false)]
class DatChoHoldIntegrationTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // Dùng SQLite in-memory để không ảnh hưởng database thật.
        config([
            'database.default' => 'sqlite',
            'database.connections.sqlite.database' => ':memory:',
        ]);

        DB::purge('sqlite');
        DB::setDefaultConnection('sqlite');

        $this->createTestSchema();
    }

    private function createTestSchema(): void
    {
        Schema::create('nguoi_dung', function (Blueprint $table) {
            $table->increments('nguoi_dung_id');
            $table->string('ho_ten', 150);
            $table->string('email', 150)->nullable()->unique();
            $table->string('mat_khau', 255)->nullable();
            $table->string('vai_tro')->default('khach_du_lich');
        });

        Schema::create('hanh_trinh_am_thuc', function (Blueprint $table) {
            $table->increments('hanh_trinh_id');
            $table->string('ten_hanh_trinh', 200);
            $table->text('mo_ta')->nullable();
            $table->string('thoi_luong', 100)->nullable();
        });

        Schema::create('lich_kha_dung_hanh_trinh', function (Blueprint $table) {
            $table->increments('lich_kha_dung_id');
            $table->unsignedInteger('hanh_trinh_id');
            $table->date('ngay_phuc_vu');
            $table->unsignedInteger('so_cho_total')->default(0);
            $table->unsignedInteger('so_cho_held')->default(0);
            $table->unsignedInteger('so_cho_sold')->default(0);
            $table->decimal('gia_tham_khao', 12, 2)->nullable();

            $table->foreign('hanh_trinh_id')
                ->references('hanh_trinh_id')
                ->on('hanh_trinh_am_thuc');
        });

        Schema::create('dat_cho', function (Blueprint $table) {
            $table->increments('dat_cho_id');
            $table->string('ma_dat_cho', 50)->unique();
            $table->unsignedInteger('nguoi_dung_id');
            $table->unsignedInteger('lich_kha_dung_id');
            $table->unsignedInteger('so_khach');
            $table->decimal('don_gia', 12, 2);
            $table->decimal('tong_tien', 14, 2);
            $table->string('trang_thai');
            $table->dateTime('het_han_giu')->nullable();
            $table->dateTime('ngay_tao')->useCurrent();

            $table->foreign('nguoi_dung_id')
                ->references('nguoi_dung_id')
                ->on('nguoi_dung');

            $table->foreign('lich_kha_dung_id')
                ->references('lich_kha_dung_id')
                ->on('lich_kha_dung_hanh_trinh');
        });

        Schema::create('dat_cho_lich_su', function (Blueprint $table) {
            $table->increments('dat_cho_lich_su_id');
            $table->unsignedInteger('dat_cho_id');
            $table->string('tu_trang_thai')->nullable();
            $table->string('den_trang_thai');
            $table->unsignedInteger('nguoi_thuc_hien_id')->nullable();
            $table->string('ly_do', 255)->nullable();
            $table->dateTime('ngay_tao')->useCurrent();

            $table->foreign('dat_cho_id')
                ->references('dat_cho_id')
                ->on('dat_cho');

            $table->foreign('nguoi_thuc_hien_id')
                ->references('nguoi_dung_id')
                ->on('nguoi_dung');
        });
    }

    protected function tearDown(): void
    {
        Auth::logout();

        DB::disconnect('sqlite');
        DB::purge('sqlite');

        parent::tearDown();
    }

    public function test_hold_persists_booking_capacity_and_history(): void
    {
        // Tạo người dùng kiểm thử.
        $userId = DB::table('nguoi_dung')->insertGetId([
            'ho_ten' => 'Test User',
            'email' => 'test-hold@example.com',
            'mat_khau' => 'test',
            'vai_tro' => 'khach_du_lich',
        ]);

        // Tạo hành trình ẩm thực.
        $journeyId = DB::table('hanh_trinh_am_thuc')->insertGetId([
            'ten_hanh_trinh' => 'Hành trình kiểm thử',
            'mo_ta' => null,
            'thoi_luong' => '1 ngày',
        ]);

        // Tạo lịch khả dụng có sẵn 10 chỗ.
        $availabilityId = DB::table('lich_kha_dung_hanh_trinh')
            ->insertGetId([
                'hanh_trinh_id' => $journeyId,
                'ngay_phuc_vu' => '2026-11-01',
                'so_cho_total' => 10,
                'so_cho_held' => 1,
                'so_cho_sold' => 2,
                'gia_tham_khao' => 150000,
            ]);

        Auth::login(NguoiDung::findOrFail($userId));

        // Cố định thời gian để kiểm tra thời hạn giữ chỗ chính xác.
        $startedAt = now();
        $this->travelTo($startedAt);

        // Giữ chỗ cho 3 khách — chỉ gọi hold() một lần.
        $booking = app(DatChoService::class)->hold(
            $availabilityId,
            3
        );

        // Kiểm tra bản ghi đặt chỗ.
        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $booking->dat_cho_id,
            'nguoi_dung_id' => $userId,
            'lich_kha_dung_id' => $availabilityId,
            'so_khach' => 3,
            'don_gia' => 150000,
            'tong_tien' => 450000,
            'trang_thai' => 'pending_payment',
        ]);

        // 1 chỗ đã giữ trước đó + 3 chỗ mới = 4 chỗ đang giữ.
        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $availabilityId,
            'so_cho_held' => 4,
        ]);

        // Kiểm tra lịch sử chuyển trạng thái.
        $this->assertDatabaseHas('dat_cho_lich_su', [
            'dat_cho_id' => $booking->dat_cho_id,
            'tu_trang_thai' => null,
            'den_trang_thai' => 'pending_payment',
            'nguoi_thuc_hien_id' => $userId,
            'ly_do' => 'Giữ chỗ 15 phút',
        ]);

        // Kiểm tra thời điểm hết hạn giữ chỗ.
        $this->assertNotNull($booking->het_han_giu);

        $this->assertEquals(
            $startedAt->copy()->addMinutes(15)->timestamp,
            $booking->het_han_giu->timestamp
        );
    }
}
