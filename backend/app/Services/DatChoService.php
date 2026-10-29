<?php

namespace App\Services;

use App\Models\DatCho;
use App\Models\GiaoDichThanhToan;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use App\Notifications\DatChoNotification;
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
            )
                ->lockForUpdate()
                ->first();

            if (!$lich) {
                throw new RuntimeException('Không tìm thấy lịch khả dụng.');
}

// Không cho giữ chỗ với lịch đã qua ngày phục vụ.
            if ($lich->ngay_phuc_vu->lt(today())) {
                throw new RuntimeException(
        'Không thể giữ chỗ cho lịch đã qua ngày phục vụ.'
    );
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

    public function cancel(int $datChoId): DatCho
    {
        return DB::transaction(function () use ($datChoId) {
            $datCho = DatCho::where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException('Không tìm thấy đặt chỗ.');
            }

            if ((int) $datCho->nguoi_dung_id !== (int) Auth::id()) {
                throw new RuntimeException(
                    'Bạn không có quyền thao tác trên đặt chỗ này.'
                );
            }

            if ($datCho->trang_thai !== 'confirmed') {
                throw new RuntimeException(
                    'Chỉ có thể hủy đặt chỗ đã xác nhận.'
                );
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

            if ($lich->so_cho_sold < $datCho->so_khach) {
                throw new RuntimeException(
                    'Số chỗ đã bán không hợp lệ.'
                );
            }

            $lich->decrement('so_cho_sold', $datCho->so_khach);

            $datCho->update([
                'trang_thai' => 'cancelled',
            ]);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => 'confirmed',
                'den_trang_thai' => 'cancelled',
                'nguoi_thuc_hien_id' => Auth::id(),
                'ly_do' => 'Khách hàng hủy đặt chỗ',
            ]);

            $nguoiDung = \App\Models\NguoiDung::find(
                $datCho->nguoi_dung_id
            );

            if ($nguoiDung) {
                $nguoiDung->notify(new DatChoNotification(
                    $datCho->dat_cho_id,
                    $datCho->ma_dat_cho,
                    'cancelled',
                    'Đặt chỗ của bạn đã được hủy.'
                ));
            }

            return $datCho->fresh();
        });
    }

    public function refund(int $datChoId): DatCho
    {
        return DB::transaction(function () use ($datChoId) {
            $datCho = DatCho::where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException(
                    'Không tìm thấy đặt chỗ.'
                );
            }

            if ((int) $datCho->nguoi_dung_id !== (int) Auth::id()) {
                throw new RuntimeException(
                    'Bạn không có quyền thao tác trên đặt chỗ này.'
                );
            }

            if ($datCho->trang_thai !== 'cancelled') {
    		throw new RuntimeException(
        	'Chỉ có thể hoàn tiền cho đặt chỗ đã hủy.'
     	   	);
	   }

		$daThanhToan = GiaoDichThanhToan::where(
    		'dat_cho_id',
   		 $datCho->dat_cho_id
		)
    		->where('ket_qua', 'success')
    		->exists();

	if (!$daThanhToan) {
    	throw new RuntimeException(
        'Không thể hoàn tiền cho đặt chỗ chưa thanh toán thành công.'
    	);
	}

            $datCho->update([
                'trang_thai' => 'refunded',
            ]);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => 'cancelled',
                'den_trang_thai' => 'refunded',
                'nguoi_thuc_hien_id' => Auth::id(),
                'ly_do' => 'Hoàn tiền thử nghiệm sau khi hủy đặt chỗ',
            ]);

            $nguoiDung = \App\Models\NguoiDung::find(
                $datCho->nguoi_dung_id
            );

            if ($nguoiDung) {
                $nguoiDung->notify(new DatChoNotification(
                    $datCho->dat_cho_id,
                    $datCho->ma_dat_cho,
                    'refunded',
                    'Đặt chỗ của bạn đã được hoàn tiền thử nghiệm.'
                ));
            }

            return $datCho->fresh();
        });
    }
}
