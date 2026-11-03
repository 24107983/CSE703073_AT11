<?php

namespace Tests\Feature;

use App\Models\LichKhaDungHanhTrinh;
use App\Services\BookingService;
use Illuminate\Foundation\Testing\WithoutMiddleware;
use Tests\TestCase;

class BookingConcurrencyTest extends TestCase
{
    use WithoutMiddleware;

    public function test_only_one_booking_can_hold_the_last_seat(): void
    {
        $lich = LichKhaDungHanhTrinh::findOrFail(1);

        $lich->update([
            'so_cho_total' => 1,
            'so_cho_held' => 0,
            'so_cho_sold' => 0,
        ]);

        $service = app(BookingService::class);

        $success = 0;
        $failed = 0;

        try {
            $service->hold(14, 1, 1);
            $success++;
        } catch (\Throwable $e) {
            $failed++;
        }

        try {
            $service->hold(14, 1, 1);
            $success++;
        } catch (\Throwable $e) {
            $failed++;
        }

        $lich->refresh();

        $this->assertSame(1, $success);
        $this->assertSame(1, $failed);

        $this->assertSame(1, $lich->so_cho_held);
        $this->assertSame(0, $lich->so_cho_sold);

        $this->assertSame(
            1,
            \App\Models\DatCho::where(
                'lich_kha_dung_id',
                1
            )->where(
                'trang_thai',
                'pending_payment'
            )->count()
        );
    }
}