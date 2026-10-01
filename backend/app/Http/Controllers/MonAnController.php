<?php

namespace App\Http\Controllers;

use App\Models\MonAn;
use Illuminate\Http\Request;

class MonAnController extends Controller
{
    // Xem danh sách món ăn
    public function index()
    {
        return response()->json([
            'data' => MonAn::orderBy('mon_an_id')->paginate(10),
        ]);
    }

    // Xem một món ăn
    public function show($id)
    {
        $monAn = MonAn::find($id);

        if (!$monAn) {
            return response()->json([
                'message' => 'Không tìm thấy món ăn',
            ], 404);
        }

        return response()->json([
            'data' => $monAn,
        ]);
    }

    // Thêm món ăn
    public function store(Request $request)
    {
        $validated = $request->validate([
            'ten_mon' => 'required|string|max:150',
            'mo_ta' => 'nullable|string',
            'gia_tham_khao' => 'nullable|numeric|min:0',
            'vung_mien_id' => 'required|integer|exists:vung_mien,vung_mien_id',
            'tinh_thanh_id' => 'required|integer|exists:tinh_thanh,tinh_thanh_id',
            'dia_diem_id' => 'nullable|integer|exists:dia_diem,dia_diem_id',
        ]);

        $monAn = MonAn::create($validated);

        return response()->json([
            'message' => 'Thêm món ăn thành công',
            'data' => $monAn,
        ], 201);
    }

    // Sửa món ăn
    public function update(Request $request, $id)
    {
        $monAn = MonAn::find($id);

        if (!$monAn) {
            return response()->json([
                'message' => 'Không tìm thấy món ăn',
            ], 404);
        }

        $validated = $request->validate([
            'ten_mon' => 'sometimes|required|string|max:150',
            'mo_ta' => 'nullable|string',
            'gia_tham_khao' => 'nullable|numeric|min:0',
            'vung_mien_id' => 'sometimes|required|integer|exists:vung_mien,vung_mien_id',
            'tinh_thanh_id' => 'sometimes|required|integer|exists:tinh_thanh,tinh_thanh_id',
            'dia_diem_id' => 'nullable|integer|exists:dia_diem,dia_diem_id',
        ]);

        $monAn->update($validated);

        return response()->json([
            'message' => 'Cập nhật món ăn thành công',
            'data' => $monAn->fresh(),
        ]);
    }

    // Xóa món ăn
    public function destroy($id)
    {
        $monAn = MonAn::find($id);

        if (!$monAn) {
            return response()->json([
                'message' => 'Không tìm thấy món ăn',
            ], 404);
        }

        $monAn->delete();

        return response()->json([
            'message' => 'Xóa món ăn thành công',
        ]);
    }
}