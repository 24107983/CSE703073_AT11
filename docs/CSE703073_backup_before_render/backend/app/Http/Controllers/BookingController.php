<?php

namespace App\Http\Controllers;

use App\Services\BookingService;
use Illuminate\Http\Request;
use RuntimeException;

class BookingController extends Controller
{
    public function __construct(
        private BookingService $bookingService
    ) {
    }

    public function hold(Request $request)
    {
        $validated = $request->validate([
            'lich_kha_dung_id' => 'required|integer|min:1',
            'so_khach' => 'required|integer|min:1',
        ]);

        $nguoiDungId = $request->user()?->nguoi_dung_id;

        if (!$nguoiDungId) {
            return response()->json([
                'message' => 'Bạn cần đăng nhập để đặt chỗ.',
            ], 401);
        }

        try {
            $datCho = $this->bookingService->hold(
                $nguoiDungId,
                (int) $validated['lich_kha_dung_id'],
                (int) $validated['so_khach']
            );

            return response()->json([
                'message' => 'Giữ chỗ thành công.',
                'data' => $datCho,
            ], 201);
        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 409);
        }
    }

    public function confirm(Request $request, int $id)
    {
        $nguoiThucHienId = $request->user()?->nguoi_dung_id;

        try {
            $datCho = $this->bookingService->confirm(
                $id,
                $nguoiThucHienId
            );

            return response()->json([
                'message' => 'Xác nhận đặt chỗ thành công.',
                'data' => $datCho,
            ]);
        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 409);
        }
    }

    public function cancel(Request $request, int $id)
    {
        $nguoiThucHienId = $request->user()?->nguoi_dung_id;

        try {
            $datCho = $this->bookingService->cancel(
                $id,
                $nguoiThucHienId
            );

            return response()->json([
                'message' => 'Hủy đặt chỗ thành công.',
                'data' => $datCho,
            ]);
        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 409);
        }
    }
}