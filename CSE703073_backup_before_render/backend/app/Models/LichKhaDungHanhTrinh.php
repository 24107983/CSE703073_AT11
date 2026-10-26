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
        'so_cho_total' => 'integer',
        'so_cho_held' => 'integer',
        'so_cho_sold' => 'integer',
        'gia_tham_khao' => 'decimal:2',
    ];

    public function hanhTrinh()
    {
        return $this->belongsTo(
            HanhTrinhAmThuc::class,
            'hanh_trinh_id',
            'hanh_trinh_id'
        );
    }

    public function getSoChoConLaiAttribute()
    {
        return $this->so_cho_total
            - $this->so_cho_held
            - $this->so_cho_sold;
    }
}