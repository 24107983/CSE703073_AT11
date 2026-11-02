<?php

namespace Tests\Unit;

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use App\Services\BookingService;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

#[\PHPUnit\Framework\Attributes\RunTestsInSeparateProcesses]
#[\PHPUnit\Framework\Attributes\PreserveGlobalState(false)]
class ReleaseExpiredHoldsTest extends TestCase
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

        Carbon::setTestNow(Carbon::parse('2026-11-02 12:00:00'));

        Schema::create('lich_kha_dung_hanh_trinh', function ($table) {
            $table->increments('lich_kha_dung_id');
            $table->unsignedInteger('hanh_trinh_id')->default(1);
            $table->date('ngay_phuc_vu')->nullable();
            $table->integer('so_cho_total')->default(0);
            $table->integer('so_cho_held')->default(0);
            $table->integer('so_cho_sold')->default(0);
            $table->decimal('gia_tham_khao', 12, 2)->nullable();
        });

        Schema::create('dat_cho', function ($table) {
            $table->increments('dat_cho_id');
            $table->string('ma_dat_cho', 50)->unique();
            $table->unsignedInteger('nguoi_dung_id');
            $table->unsignedInteger('lich_kha_dung_id');
            $table->integer('so_khach');
            $table->decimal('don_gia', 12, 2);
            $table->decimal('tong_tien', 14, 2);
            $table->string('trang_thai')->default('draft');
            $table->dateTime('het_han_giu')->nullable();
            $table->dateTime('ngay_tao');
        });

        Schema::create('dat_cho_lich_su', function ($table) {
            $table->increments('dat_cho_lich_su_id');
            $table->unsignedInteger('dat_cho_id');
            $table->string('tu_trang_thai')->nullable();
            $table->string('den_trang_thai');
            $table->unsignedInteger('nguoi_thuc_hien_id')->nullable();
            $table->string('ly_do', 255)->nullable();
            $table->dateTime('ngay_tao');
        });
    }

    protected function tearDown(): void
    {
        Carbon::setTestNow();
        DB::disconnect('sqlite');

        parent::tearDown();
    }

    private function createSchedule(int $held = 5): int
    {
        return DB::table('lich_kha_dung_hanh_trinh')->insertGetId([
            'hanh_trinh_id' => 1,
            'ngay_phuc_vu' => '2026-11-10',
            'so_cho_total' => 20,
            'so_cho_held' => $held,
            'so_cho_sold' => 0,
            'gia_tham_khao' => 100000,
        ], 'lich_kha_dung_id');
    }

    private function createBooking(
        int $scheduleId,
        string $status = 'pending_payment',
        ?string $expiry = '2026-11-02 11:59:00',
        int $guests = 2
    ): int {
        return DB::table('dat_cho')->insertGetId([
            'ma_dat_cho' => 'TEST-' . uniqid(),
            'nguoi_dung_id' => 1,
            'lich_kha_dung_id' => $scheduleId,
            'so_khach' => $guests,
            'don_gia' => 100000,
            'tong_tien' => 100000 * $guests,
            'trang_thai' => $status,
            'het_han_giu' => $expiry,
            'ngay_tao' => '2026-11-02 11:00:00',
        ], 'dat_cho_id');
    }

    public function test_expired_booking_releases_seats_and_records_history(): void
    {
        $scheduleId = $this->createSchedule(5);
        $bookingId = $this->createBooking($scheduleId);

        $count = app(BookingService::class)->releaseExpiredHolds();

        $this->assertSame(1, $count);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'expired',
            'het_han_giu' => null,
        ]);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $scheduleId,
            'so_cho_held' => 3,
        ]);

        $this->assertDatabaseHas('dat_cho_lich_su', [
            'dat_cho_id' => $bookingId,
            'tu_trang_thai' => 'pending_payment',
            'den_trang_thai' => 'expired',
            'nguoi_thuc_hien_id' => null,
        ]);
    }

    public function test_booking_that_has_not_expired_is_unchanged(): void
    {
        $scheduleId = $this->createSchedule(5);

        $bookingId = $this->createBooking(
            $scheduleId,
            'pending_payment',
            '2026-11-02 12:10:00'
        );

        $count = app(BookingService::class)->releaseExpiredHolds();

        $this->assertSame(0, $count);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'pending_payment',
            'het_han_giu' => '2026-11-02 12:10:00',
        ]);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $scheduleId,
            'so_cho_held' => 5,
        ]);

        $this->assertDatabaseCount('dat_cho_lich_su', 0);
    }

    public function test_confirmed_booking_is_not_released(): void
    {
        $scheduleId = $this->createSchedule(5);

        $bookingId = $this->createBooking(
            $scheduleId,
            'confirmed',
            '2026-11-02 11:00:00'
        );

        $count = app(BookingService::class)->releaseExpiredHolds();

        $this->assertSame(0, $count);

        $this->assertDatabaseHas('dat_cho', [
            'dat_cho_id' => $bookingId,
            'trang_thai' => 'confirmed',
        ]);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $scheduleId,
            'so_cho_held' => 5,
        ]);

        $this->assertDatabaseCount('dat_cho_lich_su', 0);
    }

    public function test_running_release_multiple_times_does_not_release_twice(): void
    {
        $scheduleId = $this->createSchedule(5);
        $bookingId = $this->createBooking($scheduleId);

        $service = app(BookingService::class);

        $firstCount = $service->releaseExpiredHolds();
        $secondCount = $service->releaseExpiredHolds();

        $this->assertSame(1, $firstCount);
        $this->assertSame(0, $secondCount);

        $this->assertDatabaseHas('lich_kha_dung_hanh_trinh', [
            'lich_kha_dung_id' => $scheduleId,
            'so_cho_held' => 3,
        ]);

        $this->assertSame(
            1,
            DB::table('dat_cho_lich_su')
                ->where('dat_cho_id', $bookingId)
                ->where('den_trang_thai', 'expired')
                ->count()
        );
    }
}