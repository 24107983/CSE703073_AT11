<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DiUngThucPham extends Model
{
    protected $table = 'di_ung_thuc_pham';

    protected $primaryKey = 'di_ung_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_chat_di_ung',
        'mo_ta',
    ];

    public function monAn()
    {
        return $this->belongsToMany(
            MonAn::class,
            'mon_an_di_ung',
            'di_ung_id',
            'mon_an_id'
        )->withPivot('ghi_chu');
    }
}