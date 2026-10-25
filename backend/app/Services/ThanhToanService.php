<?php

namespace App\Services;

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\GiaoDichThanhToan;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use RuntimeException;

class ThanhToanService
{
    public function xuLyThanhToan(
        int $datChoId,
        string $ketQua
    ): DatCho {
        return DB::transaction(function () use ($datChoId, $ketQua) {
            $datCho = DatCho::where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException('Không tìm thấy đặt chỗ.');
            }

            if ((int) $datCho->nguoi_dung_id !== (int) Auth::id()) {
                throw new RuntimeException(
                    'Bạn không có quyền thanh toán đặt chỗ này.'
                );
            }

            if ($datCho->trang_thai !== 'pending_payment') {
                throw new RuntimeException(
                    'Đặt chỗ không ở trạng thái chờ thanh toán.'
                );
            }

            if (
                $datCho->het_han_giu
                && $datCho->het_han_giu->isPast()
            ) {
                throw new RuntimeException(
                    'Đặt chỗ đã hết hạn giữ chỗ.'
                );
            }

            if (!in_array($ketQua, ['success', 'failed'], true)) {
                throw new RuntimeException(
                    'Kết quả thanh toán không hợp lệ.'
                );
            }

            // Ghi nhận giao dịch thanh toán thử nghiệm.
            // Mỗi lần thử tạo một mã giao dịch riêng.
            GiaoDichThanhToan::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'ma_giao_dich' => (string) Str::uuid(),
                'so_tien' => $datCho->tong_tien,
                'ket_qua' => $ketQua,
                'phuong_thuc' => 'test',
            ]);

            // Thanh toán thất bại:
            // Giữ nguyên trạng thái và số chỗ đang giữ.
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
                throw new RuntimeException(
                    'Không tìm thấy lịch khả dụng.'
                );
            }

            if ($lich->so_cho_held < $datCho->so_khach) {
                throw new RuntimeException(
                    'Số chỗ giữ không hợp lệ.'
                );
            }

            // Chuyển số chỗ từ đang giữ sang đã bán.
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
