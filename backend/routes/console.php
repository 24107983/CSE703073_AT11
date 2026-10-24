<?php

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Schedule;

Artisan::command('dat-cho:expire', function () {
    $count = 0;
    $skipped = 0;

    DatCho::query()
        ->where('trang_thai', 'pending_payment')
        ->whereNotNull('het_han_giu')
        ->where('het_han_giu', '<=', now())
        ->chunkById(100, function ($datChos) use (&$count, &$skipped) {
            foreach ($datChos as $datCho) {
                DB::transaction(function () use ($datCho, &$count, &$skipped) {
                    // Khoa don truoc de hai tien trinh khong xu ly trung.
                    $booking = DatCho::where(
                        'dat_cho_id',
                        $datCho->dat_cho_id
                    )->lockForUpdate()->first();

                    // Kiem tra lai trang thai va han giu sau khi lay khoa.
                    if (
                        !$booking ||
                        $booking->trang_thai !== 'pending_payment' ||
                        !$booking->het_han_giu ||
                        $booking->het_han_giu->gt(now())
                    ) {
                        return;
                    }

                    $lich = LichKhaDungHanhTrinh::where(
                        'lich_kha_dung_id',
                        $booking->lich_kha_dung_id
                    )->lockForUpdate()->first();

                    if (!$lich) {
                        $skipped++;
                        Log::warning('Khong tim thay lich khi het han dat cho.', [
                            'dat_cho_id' => $booking->dat_cho_id,
                            'lich_kha_dung_id' => $booking->lich_kha_dung_id,
                        ]);
                        return;
                    }

                    // Khong de so cho giu bi am neu du lieu khong khop.
                    if ((int) $lich->so_cho_held < (int) $booking->so_khach) {
                        $skipped++;
                        Log::warning('Khong du so cho dang giu de tra khi het han.', [
                            'dat_cho_id' => $booking->dat_cho_id,
                            'so_cho_held' => $lich->so_cho_held,
                            'so_khach' => $booking->so_khach,
                        ]);
                        return;
                    }

                    $lich->so_cho_held =
                        (int) $lich->so_cho_held - (int) $booking->so_khach;
                    $lich->save();

                    $booking->update([
                        'trang_thai' => 'expired',
                    ]);

                    DatChoLichSu::create([
                        'dat_cho_id' => $booking->dat_cho_id,
                        'tu_trang_thai' => 'pending_payment',
                        'den_trang_thai' => 'expired',
                        'ly_do' => 'Het thoi gian giu cho',
                    ]);

                    $count++;
                }, 3);
            }
        }, 'dat_cho_id');

    $this->info("Da het han {$count} dat cho.");
    if ($skipped > 0) {
        $this->warn("Bo qua {$skipped} dat cho do du lieu khong hop le; xem laravel.log.");
    }
});

// Dang ky lich chay moi phut.
Schedule::command('dat-cho:expire')->everyMinute();