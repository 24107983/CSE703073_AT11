<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAnDiUng extends Model
{
    protected $table = 'mon_an_di_ung';

    public $timestamps = false;

    protected $primaryKey = null;

    public $incrementing = false;

    protected $fillable = [
        'mon_an_id',
        'di_ung_id',
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

    public function diUngThucPham()
    {
        return $this->belongsTo(
            DiUngThucPham::class,
            'di_ung_id',
            'di_ung_id'
        );
    }
}