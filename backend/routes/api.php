<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\DiaDiemController;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/logout', [AuthController::class, 'logout']);
use App\Http\Controllers\MonAnController;
Route::get('/mon-an', [MonAnController::class, 'index']);
Route::get('/mon-an/{id}', [MonAnController::class, 'show']);

Route::post('/mon-an', [MonAnController::class, 'store'])->middleware('admin');
Route::put('/mon-an/{id}', [MonAnController::class, 'update'])->middleware('admin');
Route::delete('/mon-an/{id}', [MonAnController::class, 'destroy'])->middleware('admin');
Route::post('/dat-cho/hold', [App\Http\Controllers\DatChoController::class, 'hold']);
Route::post('/dat-cho/cancel', [App\Http\Controllers\DatChoController::class, 'cancel']);
Route::post('/dat-cho/refund', [App\Http\Controllers\DatChoController::class, 'refund']);
use App\Http\Controllers\HanhTrinhAmThucController;

Route::get('/hanh-trinh-am-thuc', [HanhTrinhAmThucController::class, 'index']);
Route::get('/hanh-trinh-am-thuc/{id}', [HanhTrinhAmThucController::class, 'show']);
use App\Http\Controllers\LichKhaDungHanhTrinhController;

Route::get('/hanh-trinh-am-thuc/{hanhTrinhId}/lich-kha-dung', [LichKhaDungHanhTrinhController::class, 'index']);
Route::post('/thanh-toan/test', [App\Http\Controllers\ThanhToanController::class, 'xuLy']);
Route::get('/python/recommend/{productId}', [App\Http\Controllers\PythonRecommendationController::class, 'recommend']);
Route::get('/admin/dashboard/stats', [App\Http\Controllers\AdminDashboardController::class, 'stats'])
    ->middleware('admin');
Route::get('/dia-diem', [DiaDiemController::class, 'index']);
Route::get('/dia-diem/{id}', [DiaDiemController::class, 'show']);