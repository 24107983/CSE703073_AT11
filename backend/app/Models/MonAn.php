<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAn extends Model
{
    protected $table = 'mon_an';

    protected $primaryKey = 'mon_an_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_mon',
        'mo_ta',
        'gia_tham_khao',
        'vung_mien_id',
        'tinh_thanh_id',
        'dia_diem_id',
    ];
}