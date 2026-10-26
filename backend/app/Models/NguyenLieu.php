<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NguyenLieu extends Model
{
    protected $table = 'nguyen_lieu';

    protected $primaryKey = 'nguyen_lieu_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_nguyen_lieu',
    ];

    public function monAn()
    {
        return $this->belongsToMany(
            MonAn::class,
            'mon_an_nguyen_lieu',
            'nguyen_lieu_id',
            'mon_an_id'
        )->withPivot('so_luong', 'don_vi');
    }
}