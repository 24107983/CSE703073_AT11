<?php

namespace Tests\Feature;

use App\Models\LichKhaDungHanhTrinh;
use App\Services\BookingService;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

#[\PHPUnit\Framework\Attributes\RunTestsInSeparateProcesses]
#[\PHPUnit\Framework\Attributes\PreserveGlobalState(false)]
class BookingConcurrencyTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

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

        Schema::create(
            'lich_kha_dung_hanh_trinh',
            function (Blueprint $table) {
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
            }
        );

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
        DB::disconnect('sqlite');
        DB::purge('sqlite');

        parent::tearDown();
    }

    public function test_only_one_booking_can_hold_the_last_seat(): void
    {
        $userId = DB::table('nguoi_dung')->insertGetId([
            'ho_ten' => 'Test User',
            'email' => 'test-concurrency@example.com',
            'mat_khau' => 'test',
            'vai_tro' => 'khach_du_lich',
        ]);

        $journeyId = DB::table('hanh_trinh_am_thuc')->insertGetId([
            'ten_hanh_trinh' => 'Test Journey',
            'mo_ta' => null,
            'thoi_luong' => '1 day',
        ]);

        $availabilityId = DB::table('lich_kha_dung_hanh_trinh')
            ->insertGetId([
                'hanh_trinh_id' => $journeyId,
                'ngay_phuc_vu' => '2026-11-01',
                'so_cho_total' => 1,
                'so_cho_held' => 0,
                'so_cho_sold' => 0,
                'gia_tham_khao' => 100000,
            ]);

        $service = app(BookingService::class);

        // The first booking should hold the only available seat.
        $booking = $service->hold($userId, $availabilityId, 1);

        $this->assertSame('pending_payment', $booking->trang_thai);

        // The second booking must be rejected because no seats remain.
        $exception = null;

        try {
            $service->hold($userId, $availabilityId, 1);
        } catch (\Throwable $e) {
            $exception = $e;
        }

        $this->assertNotNull($exception);
        $this->assertSame(
            \RuntimeException::class,
            get_class($exception)
        );

        $lich = LichKhaDungHanhTrinh::findOrFail($availabilityId);

        $this->assertSame(1, (int) $lich->so_cho_held);
        $this->assertSame(0, (int) $lich->so_cho_sold);

        $this->assertSame(
            1,
            DB::table('dat_cho')
                ->where('lich_kha_dung_id', $availabilityId)
                ->where('trang_thai', 'pending_payment')
                ->count()
        );

        $this->assertSame(
            1,
            DB::table('dat_cho_lich_su')
                ->where('dat_cho_id', $booking->dat_cho_id)
                ->count()
        );
    }
}