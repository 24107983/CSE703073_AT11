<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TinhThanh extends Model
{
    protected $table = 'tinh_thanh';

    protected $primaryKey = 'tinh_thanh_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_tinh',
        'vung_mien_id',
    ];
}