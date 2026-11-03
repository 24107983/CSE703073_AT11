<?php

namespace App\Services;

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Support\Facades\DB;
use RuntimeException;

class ThanhToanService
{
    public function xuLyThanhToan(int $datChoId, string $ketQua): DatCho
    {
        return DB::transaction(function () use ($datChoId, $ketQua) {
            $datCho = DatCho::where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException('Không tìm thấy đặt chỗ.');
            }

            if ($datCho->trang_thai !== 'pending_payment') {
                throw new RuntimeException(
                    'Đặt chỗ không ở trạng thái chờ thanh toán.'
                );
            }

            if ($datCho->het_han_giu && $datCho->het_han_giu->isPast()) {
                throw new RuntimeException('Đặt chỗ đã hết hạn giữ chỗ.');
            }

            if (!in_array($ketQua, ['success', 'failed'], true)) {
                throw new RuntimeException('Kết quả thanh toán không hợp lệ.');
            }

            if ($ketQua === 'failed') {
                return $datCho;
            }

            $lich = LichKhaDungHanhTrinh::where(
                'lich_kha_dung_id',
                $datCho->lich_kha_dung_id
            )
                ->lockForUpdate()
                ->first();

            if (!$lich) {
                throw new RuntimeException('Không tìm thấy lịch khả dụng.');
            }

            if ($lich->so_cho_held < $datCho->so_khach) {
                throw new RuntimeException('Số chỗ giữ không hợp lệ.');
            }

            $lich->decrement('so_cho_held', $datCho->so_khach);
            $lich->increment('so_cho_sold', $datCho->so_khach);

            $datCho->update([
                'trang_thai' => 'confirmed',
                'het_han_giu' => null,
            ]);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => 'pending_payment',
                'den_trang_thai' => 'confirmed',
                'nguoi_thuc_hien_id' => $datCho->nguoi_dung_id,
                'ly_do' => 'Thanh toán thử nghiệm thành công',
            ]);

            return $datCho->fresh();
        });
    }
}
