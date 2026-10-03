<?php

namespace App\Services;

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use RuntimeException;

class DatChoService
{
    public function hold(int $lichKhaDungId, int $soKhach): DatCho
    {
        return DB::transaction(function () use ($lichKhaDungId, $soKhach) {
            $lich = LichKhaDungHanhTrinh::where(
                'lich_kha_dung_id',
                $lichKhaDungId
            )->lockForUpdate()->first();

            if (!$lich) {
                throw new RuntimeException('Không tìm thấy lịch khả dụng.');
            }

            $soChoConLai = $lich->so_cho_total
                - $lich->so_cho_held
                - $lich->so_cho_sold;

            if ($soKhach > $soChoConLai) {
                throw new RuntimeException('Không đủ chỗ trống.');
            }

            $donGia = (float) $lich->gia_tham_khao;
            $tongTien = $donGia * $soKhach;

            $datCho = DatCho::create([
                'ma_dat_cho' => 'DC-' . strtoupper(Str::random(10)),
                'nguoi_dung_id' => Auth::id(),
                'lich_kha_dung_id' => $lich->lich_kha_dung_id,
                'so_khach' => $soKhach,
                'don_gia' => $donGia,
                'tong_tien' => $tongTien,
                'trang_thai' => 'pending_payment',
                'het_han_giu' => now()->addMinutes(15),
            ]);

            $lich->increment('so_cho_held', $soKhach);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => null,
                'den_trang_thai' => 'pending_payment',
                'nguoi_thuc_hien_id' => Auth::id(),
                'ly_do' => 'Giữ chỗ 15 phút',
            ]);

            return $datCho;
        });
    }
}
