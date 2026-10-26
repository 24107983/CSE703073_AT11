<?php

namespace Tests\Feature;

use App\Models\NguoiDung;
use Illuminate\Support\Facades\Route;
use Tests\TestCase;

class AdminMiddlewareTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        // Tạo route thử nghiệm để kiểm tra riêng middleware.
        Route::middleware('admin')->get(
            '/_test/admin-only',
            fn () => response()->json(['ok' => true])
        );
    }

    public function test_guest_cannot_access_admin_route(): void
    {
        $response = $this->getJson('/_test/admin-only');

        $response->assertUnauthorized();
    }

    public function test_tourist_cannot_access_admin_route(): void
    {
        $tourist = new NguoiDung();
        $tourist->nguoi_dung_id = 999999;
        $tourist->ho_ten = 'Test Tourist';
        $tourist->email = 'tourist-test@example.com';
        $tourist->vai_tro = 'khach_du_lich';

        $response = $this->actingAs($tourist, 'web')
            ->getJson('/_test/admin-only');

        $response->assertForbidden();
    }

    public function test_admin_can_access_admin_route(): void
    {
        $admin = new NguoiDung();
        $admin->nguoi_dung_id = 999998;
        $admin->ho_ten = 'Test Admin';
        $admin->email = 'admin-test@example.com';
        $admin->vai_tro = 'quan_tri_vien';

        $response = $this->actingAs($admin, 'web')
            ->getJson('/_test/admin-only');

        $response->assertOk();
    }
}