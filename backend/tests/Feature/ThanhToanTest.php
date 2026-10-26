<?php

namespace Tests\Feature;

use App\Models\NguoiDung;
use App\Notifications\DatChoNotification;
use App\Services\DatChoService;
use App\Services\ThanhToanService;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Schema;
use RuntimeException;
use Tests\TestCase;

#[\PHPUnit\Framework\Attributes\RunTestsInSeparateProcesses]
#[\PHPUnit\Framework\Attributes\PreserveGlobalState(false)]
class ThanhToanTest extends TestCase
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

        Schema::create('lich_kha_dung_hanh_trinh', function (Blueprint $table) {
            $table->increments('lich_kha_dung_id');
            $table->unsignedInteger('hanh_trinh_id');
            $table->date('ngay_phuc_vu');
            $table->unsignedInteger('so_cho_total')->default(0);
            $table->unsignedInteger('so_cho_held')->default(0);
            $table->unsignedInteger('so_cho_sold')->default(0);
            $table->decimal('gia_tham_khao', 12, 2)->nullable();
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

        Schema::create('giao_dich_thanh_toan', function (Blueprint $table) {
            $table->bigIncrements('giao_dich_id');
            $table->unsignedInteger('dat_cho_id');
            $table->string('ma_giao_dich', 100)->unique();
            $table->decimal('so_tien', 14, 2);
            $table->string('ket_qua');
            $table->string('phuong_thuc', 50)->default('test');
            $table->dateTime('ngay_tao')->useCurrent();

            $table->foreign('dat_cho_id')
                ->references('dat_cho_id')
                ->on('dat_cho');
        });
    }

    private function createBooking(): array
    {
        $userId = DB::table('nguoi_dung')->insertGetId([
            'ho_ten' => 'Test User',
            'email' => 'payment-test@example.com',
            'mat_khau' => 'test',
            'vai_tro' => 'khach_du_lich',
        ]);

        $journeyId = DB::table('hanh_trinh_am_thuc')->insertGetId([
            'ten_hanh_trinh' => 'Hành trình kiểm thử',
            'mo_ta' => null,
            'thoi_luong' => '1 ngày',
        ]);

        $availabilityId = DB::table('lich_kha_dung_hanh_trinh')
            ->insertGetId([
                'hanh_trinh_id' => $journeyId,
                'ngay_phuc_vu' => '2026-11-01',
                'so_cho_total' => 10,
                'so_cho_held' => 2,
                'so_cho_sold' => 1,
                'gia_tham_khao' => 150000,
            ]);

        $bookingId = DB::table('dat_cho')->insertGetId([
            'ma_dat_cho' => 'TEST-' . uniqid(),
            'nguoi_dung_id' => $userId,
            'lich_kha_dung_id' => $availabilityId,
            'so_khach' => 2,
            'don_gia' => 150000,
            'tong_tien' => 300000,
            'trang_thai' => 'pending_payment',
            'het_han_giu' => now()->addMinutes(15),
            'ngay_tao' => now(),
        ]);

        Auth::login(NguoiDung::findOrFail($userId));

        return [$userId, $availabilityId, $bookingId];
    }
public function test_successful_payment_records_transaction_and_confirms_booking(): void
    {
        [, $availabilityId, $bookingId] = $this->createBooking();

        $booking = app(ThanhToanService::class)
            ->xuLyThanhToan($bookingId, 'success');

        $this->assertSame('confirmed', $booking->trang_thai);

        $this->assertDatabaseHas('giao_dich_thanh_toan', [
            'dat_cho_id' => $bookingId,
            'so_tien' => 300000,
            'ket_qua' => 'success',
            'phuong_thuc' => 'test',
        ]);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $availabilityId,
            'so_cho_held' => 0,
            'so_cho_sold' => 3,
        ]);

        $this->assertDatabaseHas('dat_cho_lich_su', [
            'dat_cho_id' => $bookingId,
            'tu_trang_thai' => 'pending_payment',
            'den_trang_thai' => 'confirmed',
        ]);
    }

    public function test_failed_payment_records_failure_without_changing_booking_or_capacity(): void
    {
        [, $availabilityId, $bookingId] = $this->createBooking();

        $booking = app(ThanhToanService::class)
            ->xuLyThanhToan($bookingId, 'failed');

                $this->assertSame('pending_payment', $booking->trang_thai);

        $this->assertDatabaseHas('giao_dich_thanh_toan', [
            'dat_cho_id' => $bookingId,
            'so_tien' => 300000,
            'ket_qua' => 'failed',
            'phuong_thuc' => 'test',
        ]);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'pending_payment',
        ]);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $availabilityId,
            'so_cho_held' => 2,
            'so_cho_sold' => 1,
        ]);

        $this->assertDatabaseMissing('dat_cho_lich_su', [
            'dat_cho_id' => $bookingId,
            'den_trang_thai' => 'confirmed',
        ]);
    }
    public function test_payment_rejects_booking_owned_by_another_user(): void
    {
        [, , $bookingId] = $this->createBooking();

        $otherUserId = DB::table('nguoi_dung')->insertGetId([
            'ho_ten' => 'Other User',
            'email' => 'other-payment-test@example.com',
            'mat_khau' => 'test',
            'vai_tro' => 'khach_du_lich',
        ]);

        Auth::login(NguoiDung::findOrFail($otherUserId));

        try {
            app(ThanhToanService::class)
                ->xuLyThanhToan($bookingId, 'success');

            $this->fail('Thanh toán phải bị từ chối với người dùng khác.');
        } catch (RuntimeException $e) {
            $this->assertSame(
                'Bạn không có quyền thanh toán đặt chỗ này.',
                $e->getMessage()
            );
        }

        $this->assertDatabaseMissing('giao_dich_thanh_toan', [
            'dat_cho_id' => $bookingId,
        ]);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'pending_payment',
        ]);
    }
	
    public function test_refund_rejects_cancelled_booking_without_successful_payment(): void
    {
        [, , $bookingId] = $this->createBooking();

        DB::table('dat_cho')
            ->where('dat_cho_id', $bookingId)
            ->update(['trang_thai' => 'cancelled']);

        try {
            app(DatChoService::class)->refund($bookingId);

            $this->fail('Phải từ chối hoàn tiền khi chưa thanh toán thành công.');
        } catch (RuntimeException $e) {
            $this->assertSame(
                'Không thể hoàn tiền cho đặt chỗ chưa thanh toán thành công.',
                $e->getMessage()
            );
        }

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'cancelled',
        ]);

        $this->assertDatabaseMissing('dat_cho_lich_su', [
            'dat_cho_id' => $bookingId,
            'den_trang_thai' => 'refunded',
        ]);
    }

    public function test_refund_allows_cancelled_booking_with_successful_payment(): void
    {
        Notification::fake();

        [, , $bookingId] = $this->createBooking();

        DB::table('dat_cho')
            ->where('dat_cho_id', $bookingId)
            ->update(['trang_thai' => 'cancelled']);

        DB::table('giao_dich_thanh_toan')->insert([
            'dat_cho_id' => $bookingId,
            'ma_giao_dich' => 'REFUND-TEST-' . uniqid(),
            'so_tien' => 300000,
            'ket_qua' => 'success',
            'phuong_thuc' => 'test',
            'ngay_tao' => now(),
        ]);

        $booking = app(DatChoService::class)->refund($bookingId);

        $this->assertSame('refunded', $booking->trang_thai);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'refunded',
        ]);

        $this->assertDatabaseHas('dat_cho_lich_su', [
            'dat_cho_id' => $bookingId,
            'tu_trang_thai' => 'cancelled',
            'den_trang_thai' => 'refunded',
        ]);

        Notification::assertSentTo(
            NguoiDung::findOrFail(DB::table('dat_cho')
                ->where('dat_cho_id', $bookingId)
                ->value('nguoi_dung_id')),
            DatChoNotification::class
        );
    }
	
	protected function tearDown(): void
    {
        Auth::logout();

        DB::disconnect('sqlite');
        DB::purge('sqlite');

        parent::tearDown();
    }
}
