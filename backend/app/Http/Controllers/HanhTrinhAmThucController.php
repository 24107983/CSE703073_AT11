<?php

namespace App\Http\Controllers;

use App\Models\HanhTrinhAmThuc;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class HanhTrinhAmThucController extends Controller
{
    public function index(Request $request)
    {
        $page = max(1, (int) $request->input('page', 1));
        $perPage = (int) $request->input('per_page', 10);
        $perPage = max(1, min($perPage, 100));

        $data = HanhTrinhAmThuc::query()
            ->orderBy('hanh_trinh_id')
            ->paginate($perPage, ['*'], 'page', $page)
            ->withQueryString();

        return response()->json([
            'data' => $data,
        ]);
    }

    public function show(int $id)
    {
        $hanhTrinh = HanhTrinhAmThuc::find($id);

        if (!$hanhTrinh) {
            return response()->json([
                'message' => 'Không tìm thấy hành trình ẩm thực.'
            ], 404);
        }

        $monAn = DB::table('hanh_trinh_mon_an')
            ->join(
                'mon_an',
                'hanh_trinh_mon_an.mon_an_id',
                '=',
                'mon_an.mon_an_id'
            )
            ->where('hanh_trinh_mon_an.hanh_trinh_id', $id)
            ->orderBy('hanh_trinh_mon_an.thu_tu')
            ->select(
                'mon_an.mon_an_id',
                'mon_an.ten_mon',
                'hanh_trinh_mon_an.thu_tu',
                'hanh_trinh_mon_an.ghi_chu'
            )
            ->get();

        return response()->json([
            'data' => [
                'hanh_trinh_id' => $hanhTrinh->hanh_trinh_id,
                'ten_hanh_trinh' => $hanhTrinh->ten_hanh_trinh,
                'mo_ta' => $hanhTrinh->mo_ta,
                'thoi_luong' => $hanhTrinh->thoi_luong,
                'mon_an' => $monAn,
            ],
        ]);
    }
}
