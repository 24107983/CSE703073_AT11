<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VungMien extends Model
{
    protected $table = 'vung_mien';

    protected $primaryKey = 'vung_mien_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_vung',
        'mo_ta',
    ];
}