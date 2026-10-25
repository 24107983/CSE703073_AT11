<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GiaoDichThanhToan extends Model
{
    protected $table = 'giao_dich_thanh_toan';

    protected $primaryKey = 'giao_dich_id';

    public $timestamps = false;

    protected $fillable = [
        'dat_cho_id',
        'ma_giao_dich',
        'so_tien',
        'ket_qua',
        'phuong_thuc',
    ];

    protected $casts = [
        'so_tien' => 'decimal:2',
        'ngay_tao' => 'datetime',
    ];
}
