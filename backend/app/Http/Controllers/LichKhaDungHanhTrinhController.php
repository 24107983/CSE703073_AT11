<?php

namespace App\Http\Controllers;

use App\Models\HanhTrinhAmThuc;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Http\Request;

class LichKhaDungHanhTrinhController extends Controller
{
    public function index(Request $request, int $hanhTrinhId)
    {
        // Kiểm tra hành trình có tồn tại hay không.
        if (!HanhTrinhAmThuc::where('hanh_trinh_id', $hanhTrinhId)->exists()) {
            return response()->json([
                'message' => 'Không tìm thấy hành trình ẩm thực.',
            ], 404);
        }

        // Kiểm tra định dạng ngày nếu người dùng truyền tham số.
        $validated = $request->validate([
            'ngay_phuc_vu' => ['sometimes', 'required', 'date_format:Y-m-d'],
        ]);

        // Khởi tạo truy vấn lịch khả dụng của hành trình.
        $query = LichKhaDungHanhTrinh::query()
            ->where('hanh_trinh_id', $hanhTrinhId);

        if (isset($validated['ngay_phuc_vu'])) {
            // Nếu có ngày cụ thể, chỉ lấy lịch của ngày đó.
            $query->whereDate(
                'ngay_phuc_vu',
                $validated['ngay_phuc_vu']
            );
        } else {
            // Mặc định chỉ hiển thị lịch từ hôm nay trở đi.
            $query->whereDate(
                'ngay_phuc_vu',
                '>=',
                now()->toDateString()
            );
        }

        $query->orderBy('ngay_phuc_vu');

        // Lấy lịch và tính số chỗ còn lại.
        $data = $query->get()->map(function ($lich) {
            $soChoConLai = (int) $lich->so_cho_total
                - (int) $lich->so_cho_held
                - (int) $lich->so_cho_sold;

            return [
                'lich_kha_dung_id' => $lich->lich_kha_dung_id,
                'hanh_trinh_id' => $lich->hanh_trinh_id,
                'ngay_phuc_vu' => $lich->ngay_phuc_vu?->format('Y-m-d'),
                'so_cho_total' => $lich->so_cho_total,
                'so_cho_held' => $lich->so_cho_held,
                'so_cho_sold' => $lich->so_cho_sold,
                'so_cho_con_lai' => max(0, $soChoConLai),
                'gia_tham_khao' => $lich->gia_tham_khao,
            ];
        })->values();

        return response()->json([
            'data' => $data,
        ]);
    }
}
