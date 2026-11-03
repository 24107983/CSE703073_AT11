<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class NguoiDung extends Authenticatable
{
    use Notifiable;

    protected $table = 'nguoi_dung';

    protected $primaryKey = 'nguoi_dung_id';

    public $timestamps = false;

    protected $fillable = [
        'ho_ten',
        'email',
        'mat_khau',
        'vai_tro',
    ];

    protected $hidden = [
        'mat_khau',
    ];

    public function getAuthPassword()
    {
        return $this->mat_khau;
    }
}
