<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MonAnController;
use App\Http\Controllers\BookingController;

// ==================== AUTH ====================

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/logout', [AuthController::class, 'logout']);

// ==================== MON AN ====================

Route::get('/mon-an', [MonAnController::class, 'index']);
Route::get('/mon-an/{id}', [MonAnController::class, 'show']);

Route::post('/mon-an', [MonAnController::class, 'store'])
    ->middleware('admin');

Route::put('/mon-an/{id}', [MonAnController::class, 'update'])
    ->middleware('admin');

Route::delete('/mon-an/{id}', [MonAnController::class, 'destroy'])
    ->middleware('admin');

Route::get('v1/admin/mon-an', function () {
    return response()->json([
        'message' => 'Khong co quyen truy cap trang quan tri.'
    ], 403);
});

// ==================== BOOKING ====================

Route::middleware('auth')->group(function () {
    Route::post('/booking/hold', [BookingController::class, 'hold']);

    Route::post('/booking/{id}/confirm', [BookingController::class, 'confirm']);

    Route::post('/booking/{id}/cancel', [BookingController::class, 'cancel']);
});