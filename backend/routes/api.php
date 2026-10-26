<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MonAnController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\HanhTrinhAmThucController;
use App\Http\Controllers\LichKhaDungHanhTrinhController;
use App\Http\Controllers\DatChoController;
use App\Http\Controllers\ThanhToanController;
use App\Http\Controllers\PythonRecommendationController;
use App\Http\Controllers\AdminDashboardController;
use App\Http\Controllers\DiaDiemController;

// AUTH
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/logout', [AuthController::class, 'logout']);

// MON AN
Route::get('/mon-an', [MonAnController::class, 'index']);
Route::get('/mon-an/{id}', [MonAnController::class, 'show']);
Route::post('/mon-an', [MonAnController::class, 'store'])->middleware('admin');
Route::put('/mon-an/{id}', [MonAnController::class, 'update'])->middleware('admin');
Route::delete('/mon-an/{id}', [MonAnController::class, 'destroy'])->middleware('admin');

Route::get('v1/admin/mon-an', function () {
    return response()->json([
        'message' => 'Khong co quyen truy cap trang quan tri.'
    ], 403);
});

// BOOKING CU
Route::middleware('auth')->group(function () {
    Route::post('/booking/hold', [BookingController::class, 'hold']);
    Route::post('/booking/{id}/confirm', [BookingController::class, 'confirm']);
    Route::post('/booking/{id}/cancel', [BookingController::class, 'cancel']);
});

// DAT CHO V3
Route::post('/dat-cho/hold', [DatChoController::class, 'hold']);
Route::post('/dat-cho/cancel', [DatChoController::class, 'cancel']);
Route::post('/dat-cho/refund', [DatChoController::class, 'refund']);

// HANH TRINH
Route::get('/hanh-trinh-am-thuc', [HanhTrinhAmThucController::class, 'index']);
Route::get('/hanh-trinh-am-thuc/{id}', [HanhTrinhAmThucController::class, 'show']);
Route::get('/hanh-trinh-am-thuc/{hanhTrinhId}/lich-kha-dung', [LichKhaDungHanhTrinhController::class, 'index']);

// THANH TOAN, GOI Y, THONG KE
Route::post('/thanh-toan/test', [ThanhToanController::class, 'xuLy']);
Route::get('/python/recommend/{productId}', [PythonRecommendationController::class, 'recommend']);

Route::get('/admin/dashboard/stats', [AdminDashboardController::class, 'stats'])
    ->middleware('admin');

// DIA DIEM V3
Route::get('/dia-diem', [DiaDiemController::class, 'index']);
Route::get('/dia-diem/{id}', [DiaDiemController::class, 'show']);