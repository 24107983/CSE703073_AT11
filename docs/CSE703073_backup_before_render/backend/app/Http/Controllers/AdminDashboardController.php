<?php

namespace App\Http\Controllers;

use App\Models\DatCho;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class AdminDashboardController extends Controller
{
    public function stats(): JsonResponse
    {
        $totalBookings = DatCho::count();

        $confirmedBookings = DatCho::whereIn('trang_thai', [
            'confirmed',
            'completed',
        ])->count();

        $cancelledBookings = DatCho::where('trang_thai', 'cancelled')
            ->count();

        $totalRevenue = DatCho::whereIn('trang_thai', [
            'confirmed',
            'completed',
        ])->sum('tong_tien');

        $bookingStatus = DatCho::select(
                'trang_thai',
                DB::raw('COUNT(*) as so_luong')
            )
            ->groupBy('trang_thai')
            ->orderBy('trang_thai')
            ->get();

        $revenueByDate = DatCho::whereIn('trang_thai', [
                'confirmed',
                'completed',
            ])
            ->select(
                DB::raw('DATE(ngay_tao) as ngay'),
                DB::raw('SUM(tong_tien) as doanh_thu')
            )
            ->groupBy(DB::raw('DATE(ngay_tao)'))
            ->orderBy('ngay')
            ->get();

        return response()->json([
            'message' => 'Lấy thống kê dashboard thành công.',
            'data' => [
                'summary' => [
                    'total_bookings' => $totalBookings,
                    'confirmed_bookings' => $confirmedBookings,
                    'cancelled_bookings' => $cancelledBookings,
                    'total_revenue' => (float) $totalRevenue,
                ],
                'booking_status' => $bookingStatus,
                'revenue_by_date' => $revenueByDate,
            ],
        ]);
    }
}
