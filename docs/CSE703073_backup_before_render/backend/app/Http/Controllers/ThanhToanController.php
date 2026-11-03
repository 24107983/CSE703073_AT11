<?php

namespace App\Http\Controllers;

use App\Services\ThanhToanService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use RuntimeException;

class ThanhToanController extends Controller
{
    public function __construct(
        private ThanhToanService $thanhToanService
    ) {}

    public function xuLy(Request $request)
    {
        if (!Auth::check()) {
            return response()->json([
                'message' => 'Bạn cần đăng nhập.'
            ], 401);
        }

        $validated = $request->validate([
            'dat_cho_id' => ['required', 'integer', 'exists:dat_cho,dat_cho_id'],
            'ket_qua' => ['required', 'in:success,failed'],
        ]);

        try {
            $datCho = $this->thanhToanService->xuLyThanhToan(
                $validated['dat_cho_id'],
                $validated['ket_qua']
            );

            return response()->json([
                'message' => $validated['ket_qua'] === 'success'
                    ? 'Thanh toán thử nghiệm thành công.'
                    : 'Thanh toán thử nghiệm thất bại.',
                'data' => $datCho,
            ]);
        } catch (RuntimeException $e) {
            return response()->json([
                'message' => $e->getMessage(),
            ], 409);
        }
    }
}
