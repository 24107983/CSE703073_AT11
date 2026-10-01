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
        'ngay_tao',
    ];

    protected $casts = [
        'ngay_tao' => 'datetime',
    ];

    public function datCho()
    {
        return $this->belongsTo(
            DatCho::class,
            'dat_cho_id',
            'dat_cho_id'
        );
    }

    public function nguoiThucHien()
    {
        return $this->belongsTo(
            NguoiDung::class,
            'nguoi_thuc_hien_id',
            'nguoi_dung_id'
        );
    }
}