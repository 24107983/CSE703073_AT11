<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAnNguyenLieu extends Model
{
    protected $table = 'mon_an_nguyen_lieu';

    public $timestamps = false;

    protected $primaryKey = null;

    public $incrementing = false;

    protected $fillable = [
        'mon_an_id',
        'nguyen_lieu_id',
        'so_luong',
        'don_vi',
    ];

    public function monAn()
    {
        return $this->belongsTo(
            MonAn::class,
            'mon_an_id',
            'mon_an_id'
        );
    }

    public function nguyenLieu()
    {
        return $this->belongsTo(
            NguyenLieu::class,
            'nguyen_lieu_id',
            'nguyen_lieu_id'
        );
    }
}