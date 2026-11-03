<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HanhTrinhAmThuc extends Model
{
    protected $table = 'hanh_trinh_am_thuc';

    protected $primaryKey = 'hanh_trinh_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_hanh_trinh',
        'mo_ta',
        'thoi_luong',
    ];

    public function lichKhaDung()
    {
        return $this->hasMany(
            LichKhaDungHanhTrinh::class,
            'hanh_trinh_id',
            'hanh_trinh_id'
        );
    }
}