<?php

namespace App\Console\Commands;

use App\Services\BookingService;
use Illuminate\Console\Command;

class ReleaseExpiredBookings extends Command
{
    protected $signature = 'bookings:release-expired';

    protected $description = 'Giải phóng các lượt giữ chỗ đã hết thời gian';

    public function handle(BookingService $bookingService): int
    {
        $count = $bookingService->releaseExpiredHolds();

        $this->info(
            "Đã giải phóng {$count} lượt giữ chỗ hết hạn."
        );

        return self::SUCCESS;
    }
}