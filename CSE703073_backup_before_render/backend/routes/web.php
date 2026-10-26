<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'success' => true,
        'message' => 'Du Lich So API is running',
        'api' => [
            'mon_an' => '/api/mon-an',
            'hanh_trinh_am_thuc' => '/api/hanh-trinh-am-thuc',
        ],
    ]);
});