<?php

namespace App\Http\Controllers;

use App\Models\MonAn;
use Illuminate\Http\Request;

class MonAnController extends Controller
{
    // Xem danh sách món ăn: tìm kiếm, lọc, sắp xếp, phân trang
    public function index(Request $request)
    {
        $query = MonAn::query();

        // Tìm kiếm theo tên món
      if ($request->filled('q')) {
        $query->whereRaw(
        'ten_mon COLLATE utf8mb4_0900_as_ci LIKE ?',
        ['%' . $request->q . '%']
       );
       }
        // Lọc theo vùng miền
        if ($request->filled('vung_mien_id')) {
            $query->where('vung_mien_id', $request->vung_mien_id);
        }

        // Lọc theo tỉnh/thành
        if ($request->filled('tinh_thanh_id')) {
            $query->where('tinh_thanh_id', $request->tinh_thanh_id);
        }

        // Lọc theo địa điểm
        if ($request->filled('dia_diem_id')) {
            $query->where('dia_diem_id', $request->dia_diem_id);
        }

        // Lọc theo giá
        if ($request->filled('gia_min')) {
            $query->where('gia_tham_khao', '>=', $request->gia_min);
        }

        if ($request->filled('gia_max')) {
            $query->where('gia_tham_khao', '<=', $request->gia_max);
        }

        // Sắp xếp
        $sortBy = $request->input('sort_by', 'mon_an_id');
        $sortOrder = $request->input('sort_order', 'asc');

        $allowedSorts = [
            'mon_an_id',
            'ten_mon',
            'gia_tham_khao',
        ];

        if (!in_array($sortBy, $allowedSorts)) {
            $sortBy = 'mon_an_id';
        }

        if (!in_array($sortOrder, ['asc', 'desc'])) {
            $sortOrder = 'asc';
        }

        $query->orderBy($sortBy, $sortOrder);

        // Phân trang
        $perPage = (int) $request->input('per_page', 10);

        if ($perPage < 1) {
            $perPage = 10;
        }

        if ($perPage > 100) {
            $perPage = 100;
        }

        return response()->json([
            'data' => $query->paginate($perPage)->withQueryString(),
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