<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DiaDiemController extends Controller
{
    public function index(Request $request)
    {
        $perPage = min(
            max((int) $request->query('per_page', 100), 1),
            100
        );

        $query = DB::table('dia_diem')
            ->leftJoin('tinh_thanh', function ($join) {
                $join->on(
                    DB::raw('tinh_thanh.tinh_thanh_id'),
                    '=',
                    DB::raw('(dia_diem.tinh_thanh_id + 100)')
                );
            })
		->leftJoin('vung_mien', function ($join) {
 		   $join->on(
		        'vung_mien.vung_mien_id',
 		       '=',
 		       DB::raw('tinh_thanh.vung_mien_id + 12')
 		   );
		})
            ->select([
                'dia_diem.dia_diem_id',
                'dia_diem.ten_dia_diem',
                'dia_diem.dia_chi',
                'dia_diem.kinh_do',
                'dia_diem.vi_do',
                'dia_diem.tinh_thanh_id',
                'tinh_thanh.ten_tinh',
                'vung_mien.ten_vung',
                DB::raw("
                    CASE
                        WHEN vung_mien.ten_vung = 'Miền Bắc' THEN 'Bắc'
                        WHEN vung_mien.ten_vung = 'Miền Trung' THEN 'Trung'
                        WHEN vung_mien.ten_vung = 'Miền Nam' THEN 'Nam'
                        ELSE NULL
                    END AS vung_mien
                "),
            ])
            ->orderBy('dia_diem.dia_diem_id');

        return response()->json($query->paginate($perPage));
    }
}
