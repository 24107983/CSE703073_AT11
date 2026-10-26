<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CauChuyenVanHoa extends Model
{
    protected $table = 'cau_chuyen_van_hoa';

    protected $primaryKey = 'cau_chuyen_id';

    public $timestamps = false;

    protected $fillable = [
        'tieu_de',
        'noi_dung',
        'mon_an_id',
    ];

    public function monAn()
    {
        return $this->belongsTo(
            MonAn::class,
            'mon_an_id',
            'mon_an_id'
        );
    }
}