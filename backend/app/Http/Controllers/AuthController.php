<?php

namespace App\Http\Controllers;

use App\Models\NguoiDung;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'ho_ten' => 'required|string|max:150',
            'email' => 'required|email|max:150|unique:nguoi_dung,email',
            'mat_khau' => 'required|string|min:6',
        ]);

        $nguoiDung = NguoiDung::create([
            'ho_ten' => $validated['ho_ten'],
            'email' => $validated['email'],
            'mat_khau' => Hash::make($validated['mat_khau']),
            'vai_tro' => 'khach_du_lich',
        ]);

        return response()->json([
            'message' => 'Đăng ký thành công',
            'data' => [
                'nguoi_dung_id' => $nguoiDung->nguoi_dung_id,
                'ho_ten' => $nguoiDung->ho_ten,
                'email' => $nguoiDung->email,
                'vai_tro' => $nguoiDung->vai_tro,
            ],
        ], 201);
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'mat_khau' => 'required|string',
        ]);

        $nguoiDung = NguoiDung::where('email', $credentials['email'])->first();

        if (!$nguoiDung || !Hash::check($credentials['mat_khau'], $nguoiDung->mat_khau)) {
            return response()->json([
                'message' => 'Email hoặc mật khẩu không đúng',
            ], 401);
        }

        $request->session()->regenerate();

        Auth::login($nguoiDung);

        return response()->json([
            'message' => 'Đăng nhập thành công',
            'data' => [
                'nguoi_dung_id' => $nguoiDung->nguoi_dung_id,
                'ho_ten' => $nguoiDung->ho_ten,
                'email' => $nguoiDung->email,
                'vai_tro' => $nguoiDung->vai_tro,
            ],
        ]);
    }

    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json(null, 204);
    }
}