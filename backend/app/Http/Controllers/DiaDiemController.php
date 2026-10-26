<?php

namespace App\Http\Controllers;

use App\Models\DiaDiem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DiaDiemController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'tinh_thanh_id' => ['sometimes', 'integer', 'min:1'],
            'page' => ['sometimes', 'integer', 'min:1'],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:100'],
        ]);

        $query = DiaDiem::query()
            ->select([
                'dia_diem_id',
                'ten_dia_diem',
                'dia_chi',
                'kinh_do',
                'vi_do',
                'tinh_thanh_id',
            ]);

        if (isset($validated['tinh_thanh_id'])) {
            $query->where(
                'tinh_thanh_id',
                $validated['tinh_thanh_id']
            );
        }

        $perPage = $validated['per_page'] ?? 10;

        $paginator = $query
            ->orderBy('dia_diem_id')
            ->paginate($perPage);

        return response()->json([
            'data' => $paginator->items(),
            'meta' => [
                'current_page' => $paginator->currentPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    public function show(int $id): JsonResponse
    {
        $diaDiem = DiaDiem::query()
            ->select([
                'dia_diem_id',
                'ten_dia_diem',
                'dia_chi',
                'kinh_do',
                'vi_do',
                'tinh_thanh_id',
            ])
            ->find($id);

        if (!$diaDiem) {
            return response()->json([
                'message' => 'Không tìm thấy địa điểm.',
            ], 404);
        }

        return response()->json([
            'data' => $diaDiem,
        ]);
    }
}