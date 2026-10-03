<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DatChoLichSu extends Model
{
    protected $table = 'dat_cho_lich_su';

    protected $primaryKey = 'dat_cho_lich_su_id';

    public $timestamps = false;

    protected $fillable = [
        'dat_cho_id',
        'tu_trang_thai',
        'den_trang_thai',
        'nguoi_thuc_hien_id',
        'ly_do',
    ];

    protected $casts = [
        'ngay_tao' => 'datetime',
    ];
}
