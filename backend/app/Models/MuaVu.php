<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MuaVu extends Model
{
    protected $table = 'mua_vu';

    protected $primaryKey = 'mua_vu_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_mua',
        'mo_ta',
    ];

    public function monAn()
    {
        return $this->belongsToMany(
            MonAn::class,
            'mon_an_mua_vu',
            'mua_vu_id',
            'mon_an_id'
        )->withPivot('ghi_chu');
    }
}