<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAnDipLe extends Model
{
    protected $table = 'mon_an_dip_le';

    public $timestamps = false;

    protected $primaryKey = null;

    public $incrementing = false;

    protected $fillable = [
        'mon_an_id',
        'dip_le_id',
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

    public function dipLe()
    {
        return $this->belongsTo(
            DipLe::class,
            'dip_le_id',
            'dip_le_id'
        );
    }
}