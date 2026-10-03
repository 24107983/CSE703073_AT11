<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DatCho extends Model
{
    protected $table = 'dat_cho';

    protected $primaryKey = 'dat_cho_id';

    public $timestamps = false;

    protected $fillable = [
        'ma_dat_cho',
        'nguoi_dung_id',
        'lich_kha_dung_id',
        'so_khach',
        'don_gia',
        'tong_tien',
        'trang_thai',
        'het_han_giu',
        'ngay_tao',
    ];

    protected $casts = [
        'so_khach' => 'integer',
        'don_gia' => 'decimal:2',
        'tong_tien' => 'decimal:2',
        'het_han_giu' => 'datetime',
        'ngay_tao' => 'datetime',
    ];

    public function lichKhaDung()
    {
        return $this->belongsTo(
            LichKhaDungHanhTrinh::class,
            'lich_kha_dung_id',
            'lich_kha_dung_id'
        );
    }

    public function nguoiDung()
    {
        return $this->belongsTo(
            NguoiDung::class,
            'nguoi_dung_id',
            'nguoi_dung_id'
        );
    }

    public function lichSu()
    {
        return $this->hasMany(
            DatChoLichSu::class,
            'dat_cho_id',
            'dat_cho_id'
        );
    }
}