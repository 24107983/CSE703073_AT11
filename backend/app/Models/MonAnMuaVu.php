<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAnMuaVu extends Model
{
    protected $table = 'mon_an_mua_vu';

    public $timestamps = false;

    protected $primaryKey = null;

    public $incrementing = false;

    protected $fillable = [
        'mon_an_id',
        'mua_vu_id',
        'ghi_chu',
    ];

    public function monAn()
    {
        return $this->belongsTo(
            MonAn::class,
            'mon_an_id',
            'mon_an_id'
        );
    }

    public function muaVu()
    {
        return $this->belongsTo(
            MuaVu::class,
            'mua_vu_id',
            'mua_vu_id'
        );
    }
}