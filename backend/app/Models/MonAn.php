<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MonAn extends Model
{
    protected $table = 'mon_an';

    protected $primaryKey = 'mon_an_id';

    public $timestamps = false;

    protected $fillable = [
        'ten_mon',
        'mo_ta',
        'gia_tham_khao',
        'vung_mien_id',
        'tinh_thanh_id',
        'dia_diem_id',
    ];

    /**
     * Quan hệ với vùng miền
     */
    public function vungMien()
    {
        return $this->belongsTo(
            VungMien::class,
            'vung_mien_id',
            'vung_mien_id'
        );
    }

    /**
     * Quan hệ với tỉnh thành
     */
    public function tinhThanh()
    {
        return $this->belongsTo(
            TinhThanh::class,
            'tinh_thanh_id',
            'tinh_thanh_id'
        );
    }

    /**
     * Quan hệ với địa điểm
     */
    public function diaDiem()
    {
        return $this->belongsTo(
            DiaDiem::class,
            'dia_diem_id',
            'dia_diem_id'
        );
    }

    /**
     * Quan hệ với nguyên liệu
     */
    public function nguyenLieu()
    {
        return $this->belongsToMany(
            NguyenLieu::class,
            'mon_an_nguyen_lieu',
            'mon_an_id',
            'nguyen_lieu_id'
        )->withPivot('so_luong', 'don_vi');
    }

    /**
     * Quan hệ với mùa vụ
     */
    public function muaVu()
    {
        return $this->belongsToMany(
            MuaVu::class,
            'mon_an_mua_vu',
            'mon_an_id',
            'mua_vu_id'
        )->withPivot('ghi_chu');
    }

    /**
     * Quan hệ với dị ứng thực phẩm
     */
    public function diUngThucPham()
    {
        return $this->belongsToMany(
            DiUngThucPham::class,
            'mon_an_di_ung',
            'mon_an_id',
            'di_ung_id'
        )->withPivot('ghi_chu');
    }

    /**
     * Quan hệ với dịp lễ
     */
    public function dipLe()
    {
        return $this->belongsToMany(
            DipLe::class,
            'mon_an_dip_le',
            'mon_an_id',
            'dip_le_id'
        )->withPivot('ghi_chu');
    }

    /**
     * Quan hệ với câu chuyện văn hóa
     */
    public function cauChuyenVanHoa()
    {
        return $this->hasMany(
            CauChuyenVanHoa::class,
            'mon_an_id',
            'mon_an_id'
        );
    }
}
