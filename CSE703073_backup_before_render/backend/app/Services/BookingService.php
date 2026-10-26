<?php

namespace App\Services;

use App\Models\DatCho;
use App\Models\DatChoLichSu;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use RuntimeException;

class BookingService
{
    /**
     * Tạo giữ chỗ trong 15 phút.
     */
    public function hold(
        int $nguoiDungId,
        int $lichKhaDungId,
        int $soKhach
    ): DatCho {
        if ($soKhach < 1) {
            throw new RuntimeException(
                'Số khách phải lớn hơn hoặc bằng 1.'
            );
        }

        return DB::transaction(function () use (
            $nguoiDungId,
            $lichKhaDungId,
            $soKhach
        ) {
            $lich = LichKhaDungHanhTrinh::query()
                ->where('lich_kha_dung_id', $lichKhaDungId)
                ->lockForUpdate()
                ->first();

            if (!$lich) {
                throw new RuntimeException(
                    'Không tìm thấy lịch khả dụng.'
                );
            }

            $soChoConLai =
                $lich->so_cho_total
                - $lich->so_cho_held
                - $lich->so_cho_sold;

            if ($soChoConLai < $soKhach) {
                throw new RuntimeException(
                    'Không đủ chỗ trống cho số khách yêu cầu.'
                );
            }

            $donGia = $lich->gia_tham_khao ?? 0;
            $tongTien = $donGia * $soKhach;
            $hetHanGiu = now()->addMinutes(15);

            $datCho = DatCho::create([
                'ma_dat_cho' => $this->generateBookingCode(),
                'nguoi_dung_id' => $nguoiDungId,
                'lich_kha_dung_id' => $lichKhaDungId,
                'so_khach' => $soKhach,
                'don_gia' => $donGia,
                'tong_tien' => $tongTien,
                'trang_thai' => 'pending_payment',
                'het_han_giu' => $hetHanGiu,
                'ngay_tao' => now(),
            ]);

            $lich->increment(
                'so_cho_held',
                $soKhach
            );

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => 'draft',
                'den_trang_thai' => 'pending_payment',
                'nguoi_thuc_hien_id' => $nguoiDungId,
                'ly_do' => 'Giữ chỗ khi tạo đặt chỗ.',
                'ngay_tao' => now(),
            ]);

            return $datCho->fresh();
        });
    }

    /**
     * Xác nhận đặt chỗ.
     */
    public function confirm(
        int $datChoId,
        ?int $nguoiThucHienId = null
    ): DatCho {
        return DB::transaction(function () use (
            $datChoId,
            $nguoiThucHienId
        ) {
            $datCho = DatCho::query()
                ->where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException(
                    'Không tìm thấy đặt chỗ.'
                );
            }

            if ($datCho->trang_thai !== 'pending_payment') {
                throw new RuntimeException(
                    'Đặt chỗ không ở trạng thái chờ thanh toán.'
                );
            }

            $lich = LichKhaDungHanhTrinh::query()
                ->where(
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

            /*
             * Nếu đã hết thời gian giữ:
             * - trả lại số chỗ
             * - chuyển trạng thái sang expired
             * - ghi lịch sử
             *
             * Không throw ở đây vì throw sẽ làm transaction rollback.
             */
            if (
                $datCho->het_han_giu !== null
                && $datCho->het_han_giu->isPast()
            ) {
                $this->expireLockedBooking(
                    $datCho,
                    $lich,
                    $nguoiThucHienId
                );

                return $datCho->fresh();
            }

            if ($lich->so_cho_held < $datCho->so_khach) {
                throw new RuntimeException(
                    'Số chỗ giữ không hợp lệ.'
                );
            }

            /*
             * Chuyển số chỗ:
             * held -> sold
             */
            $lich->decrement(
                'so_cho_held',
                $datCho->so_khach
            );

            $lich->increment(
                'so_cho_sold',
                $datCho->so_khach
            );

            $tuTrangThai = $datCho->trang_thai;

            $datCho->update([
                'trang_thai' => 'confirmed',
                'het_han_giu' => null,
            ]);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => $tuTrangThai,
                'den_trang_thai' => 'confirmed',
                'nguoi_thuc_hien_id' => $nguoiThucHienId,
                'ly_do' => 'Xác nhận thanh toán.',
                'ngay_tao' => now(),
            ]);

            return $datCho->fresh();
        });
    }

    /**
     * Hủy đặt chỗ.
     */
    public function cancel(
        int $datChoId,
        ?int $nguoiThucHienId = null
    ): DatCho {
        return DB::transaction(function () use (
            $datChoId,
            $nguoiThucHienId
        ) {
            $datCho = DatCho::query()
                ->where('dat_cho_id', $datChoId)
                ->lockForUpdate()
                ->first();

            if (!$datCho) {
                throw new RuntimeException(
                    'Không tìm thấy đặt chỗ.'
                );
            }

            $lich = LichKhaDungHanhTrinh::query()
                ->where(
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

            /*
             * Nếu đơn đang giữ chỗ:
             * trả số chỗ về kho khả dụng.
             */
            if ($datCho->trang_thai === 'pending_payment') {
                if ($lich->so_cho_held < $datCho->so_khach) {
                    throw new RuntimeException(
                        'Số chỗ giữ không hợp lệ.'
                    );
                }

                $lich->decrement(
                    'so_cho_held',
                    $datCho->so_khach
                );
            }

            $tuTrangThai = $datCho->trang_thai;

            $datCho->update([
                'trang_thai' => 'cancelled',
                'het_han_giu' => null,
            ]);

            DatChoLichSu::create([
                'dat_cho_id' => $datCho->dat_cho_id,
                'tu_trang_thai' => $tuTrangThai,
                'den_trang_thai' => 'cancelled',
                'nguoi_thuc_hien_id' => $nguoiThucHienId,
                'ly_do' => 'Hủy đặt chỗ.',
                'ngay_tao' => now(),
            ]);

            return $datCho->fresh();
        });
    }

    /**
     * Tự động giải phóng các đơn đã hết thời gian giữ.
     */
    public function releaseExpiredHolds(): int
    {
        $count = 0;

        DatCho::query()
            ->where('trang_thai', 'pending_payment')
            ->whereNotNull('het_han_giu')
            ->where('het_han_giu', '<=', now())
            ->orderBy('dat_cho_id')
            ->chunkById(
                100,
                function ($bookings) use (&$count) {
                    foreach ($bookings as $booking) {
                        DB::transaction(
                            function () use (
                                $booking,
                                &$count
                            ) {
                                $datCho = DatCho::query()
                                    ->where(
                                        'dat_cho_id',
                                        $booking->dat_cho_id
                                    )
                                    ->lockForUpdate()
                                    ->first();

                                if (!$datCho) {
                                    return;
                                }

                                /*
                                 * Có thể một tiến trình khác
                                 * đã xử lý đơn này.
                                 */
                                if (
                                    $datCho->trang_thai
                                        !== 'pending_payment'
                                    || $datCho->het_han_giu === null
                                    || $datCho->het_han_giu->isFuture()
                                ) {
                                    return;
                                }

                                $lich =
                                    LichKhaDungHanhTrinh::query()
                                        ->where(
                                            'lich_kha_dung_id',
                                            $datCho->lich_kha_dung_id
                                        )
                                        ->lockForUpdate()
                                        ->first();

                                if (!$lich) {
                                    return;
                                }

                                $soKhach =
                                    $datCho->so_khach;

                                if (
                                    $lich->so_cho_held
                                    < $soKhach
                                ) {
                                    return;
                                }

                                /*
                                 * Trả lại số chỗ.
                                 */
                                $lich->decrement(
                                    'so_cho_held',
                                    $soKhach
                                );

                                $tuTrangThai =
                                    $datCho->trang_thai;

                                $datCho->update([
                                    'trang_thai' => 'expired',
                                    'het_han_giu' => null,
                                ]);

                                DatChoLichSu::create([
                                    'dat_cho_id' =>
                                        $datCho->dat_cho_id,
                                    'tu_trang_thai' =>
                                        $tuTrangThai,
                                    'den_trang_thai' =>
                                        'expired',
                                    'nguoi_thuc_hien_id' =>
                                        null,
                                    'ly_do' =>
                                        'Hết thời gian giữ chỗ.',
                                    'ngay_tao' => now(),
                                ]);

                                $count++;
                            }
                        );
                    }
                }
            );

        return $count;
    }

    /**
     * Sinh mã đặt chỗ duy nhất.
     */
    private function generateBookingCode(): string
    {
        do {
            $code =
                'DC-'
                . strtoupper(
                    Str::random(10)
                );
        } while (
            DatCho::query()
                ->where('ma_dat_cho', $code)
                ->exists()
        );

        return $code;
    }

    /**
     * Xử lý một đơn đã hết hạn trong transaction hiện tại.
     */
    private function expireLockedBooking(
        DatCho $datCho,
        LichKhaDungHanhTrinh $lich,
        ?int $nguoiThucHienId
    ): void {
        if (
            $lich->so_cho_held
            >= $datCho->so_khach
        ) {
            $lich->decrement(
                'so_cho_held',
                $datCho->so_khach
            );
        }

        $tuTrangThai =
            $datCho->trang_thai;

        $datCho->update([
            'trang_thai' => 'expired',
            'het_han_giu' => null,
        ]);

        DatChoLichSu::create([
            'dat_cho_id' => $datCho->dat_cho_id,
            'tu_trang_thai' => $tuTrangThai,
            'den_trang_thai' => 'expired',
            'nguoi_thuc_hien_id' => $nguoiThucHienId,
            'ly_do' => 'Hết thời gian giữ chỗ.',
            'ngay_tao' => now(),
        ]);
    }
}