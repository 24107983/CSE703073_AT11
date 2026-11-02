<?php

use Illuminate\Support\Facades\Schedule;

// Tự động giải phóng các đơn đặt chỗ đã hết hạn mỗi phút.
Schedule::command('bookings:release-expired')
    ->everyMinute()
    ->withoutOverlapping();