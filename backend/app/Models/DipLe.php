<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DipLe extends Model
{
    protected $table = 'dip_le';

    protected $primaryKey = 'dip_le_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_dip_le',
        'thoi_gian',
        'mo_ta',
    ];

    public function monAn()
    {
        return $this->belongsToMany(
            MonAn::class,
            'mon_an_dip_le',
            'dip_le_id',
            'mon_an_id'
        )->withPivot('ghi_chu');
    }
}