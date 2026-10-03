<?php

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Artisan;

Artisan::command('dat-cho:expire', function () {
    $count = 0;

    DatCho::where('trang_thai', 'pending_payment')
        ->whereNotNull('het_han_giu')
        ->where('het_han_giu', '<=', now())
        ->chunkById(100, function ($datChos) use (&$count) {
            foreach ($datChos as $datCho) {
                DB::transaction(function () use ($datCho, &$count) {
                    $booking = DatCho::where('dat_cho_id', $datCho->dat_cho_id)
                        ->lockForUpdate()
                        ->first();

                    if (!$booking || $booking->trang_thai !== 'pending_payment') {
                        return;
                    }

                    $lich = \App\Models\LichKhaDungHanhTrinh::where(
                        'lich_kha_dung_id',
                        $booking->lich_kha_dung_id
                    )->lockForUpdate()->first();

                    if (!$lich) {
                        return;
                    }

                    $lich->decrement('so_cho_held', $booking->so_khach);

                    $booking->update([
                        'trang_thai' => 'expired',
                    ]);

                    DatChoLichSu::create([
                        'dat_cho_id' => $booking->dat_cho_id,
                        'tu_trang_thai' => 'pending_payment',
                        'den_trang_thai' => 'expired',
                        'ly_do' => 'Hết thời gian giữ chỗ',
                    ]);

                    $count++;
                });
            }
        });

    $this->info("Đã hết hạn {$count} đặt chỗ.");
});
