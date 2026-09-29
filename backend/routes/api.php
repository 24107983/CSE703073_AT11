<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/logout', [AuthController::class, 'logout']);
use App\Http\Controllers\MonAnController;
Route::get('/mon-an', [MonAnController::class, 'index']);
Route::get('/mon-an/{id}', [MonAnController::class, 'show']);

Route::post('/mon-an', [MonAnController::class, 'store'])->middleware('admin');
Route::put('/mon-an/{id}', [MonAnController::class, 'update'])->middleware('admin');
Route::delete('/mon-an/{id}', [MonAnController::class, 'destroy'])->middleware('admin');