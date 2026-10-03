<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class LichKhaDungHanhTrinh extends Model
{
    protected $table = 'lich_kha_dung_hanh_trinh';

    protected $primaryKey = 'lich_kha_dung_id';

    public $timestamps = false;

    protected $fillable = [
        'hanh_trinh_id',
        'ngay_phuc_vu',
        'so_cho_total',
        'so_cho_held',
        'so_cho_sold',
        'gia_tham_khao',
    ];

    protected $casts = [
        'ngay_phuc_vu' => 'date',
        'gia_tham_khao' => 'decimal:2',
    ];
}
