<?php

namespace App\Http\Controllers;

use App\Models\HanhTrinhAmThuc;
use App\Models\LichKhaDungHanhTrinh;
use Illuminate\Http\Request;

class LichKhaDungHanhTrinhController extends Controller
{
    public function index(Request $request, int $hanhTrinhId)
    {
        if (!HanhTrinhAmThuc::where('hanh_trinh_id', $hanhTrinhId)->exists()) {
            return response()->json([
                'message' => 'Không tìm thấy hành trình ẩm thực.'
            ], 404);
        }

        $query = LichKhaDungHanhTrinh::query()
            ->where('hanh_trinh_id', $hanhTrinhId)
            ->orderBy('ngay_phuc_vu');

        if ($request->filled('ngay_phuc_vu')) {
            $request->validate([
                'ngay_phuc_vu' => ['date'],
            ]);

            $query->whereDate('ngay_phuc_vu', $request->input('ngay_phuc_vu'));
        }

        $data = $query->get()->map(function ($lich) {
            return [
                'lich_kha_dung_id' => $lich->lich_kha_dung_id,
                'hanh_trinh_id' => $lich->hanh_trinh_id,
                'ngay_phuc_vu' => $lich->ngay_phuc_vu?->format('Y-m-d'),
                'so_cho_total' => $lich->so_cho_total,
                'so_cho_held' => $lich->so_cho_held,
                'so_cho_sold' => $lich->so_cho_sold,
                'so_cho_con_lai' => max(
                    0,
                    $lich->so_cho_total - $lich->so_cho_held - $lich->so_cho_sold
                ),
                'gia_tham_khao' => $lich->gia_tham_khao,
            ];
        });

        return response()->json([
            'data' => $data,
        ]);
    }
}
