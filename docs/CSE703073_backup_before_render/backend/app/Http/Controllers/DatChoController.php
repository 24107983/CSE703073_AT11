<?php

namespace App\Http\Controllers;

use App\Services\DatChoService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use RuntimeException;

class DatChoController extends Controller
{
    public function __construct(
        private DatChoService $datChoService
    ) {}

    public function hold(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'message' => 'Bạn cần đăng nhập.'
            ], 401);
        }

        $validated = $request->validate([
            'lich_kha_dung_id' => [
                'required',
                'integer',
                'exists:lich_kha_dung_hanh_trinh,lich_kha_dung_id'
            ],
            'so_khach' => [
                'required',
                'integer',
                'min:1'
            ],
        ]);

        try {
            $datCho = $this->datChoService->hold(
                $validated['lich_kha_dung_id'],
                $validated['so_khach']
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

    public function cancel(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'message' => 'Bạn cần đăng nhập.'
            ], 401);
        }

        $validated = $request->validate([
            'dat_cho_id' => [
                'required',
                'integer',
                'exists:dat_cho,dat_cho_id'
            ],
        ]);

        try {
            $datCho = $this->datChoService->cancel(
                $validated['dat_cho_id']
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

    public function refund(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'message' => 'Bạn cần đăng nhập.'
            ], 401);
        }

        $validated = $request->validate([
            'dat_cho_id' => [
                'required',
                'integer',
                'exists:dat_cho,dat_cho_id'
            ],
        ]);

        try {
            $datCho = $this->datChoService->refund(
                $validated['dat_cho_id']
            );

            return response()->json([
                'message' => 'Hoàn tiền thử nghiệm thành công.',
                'data' => $datCho,
            ]);

        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 409);
        }
    }
}