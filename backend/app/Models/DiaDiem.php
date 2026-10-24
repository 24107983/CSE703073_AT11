<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DiaDiem extends Model
{
    protected $table = 'dia_diem';

    protected $primaryKey = 'dia_diem_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_dia_diem',
        'dia_chi',
        'kinh_do',
        'vi_do',
        'tinh_thanh_id',
    ];

    protected $casts = [
        'dia_diem_id' => 'integer',
        'kinh_do' => 'float',
        'vi_do' => 'float',
        'tinh_thanh_id' => 'integer',
    ];
}