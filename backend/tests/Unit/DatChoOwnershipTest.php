<?php

namespace Tests\Unit;

use App\Models\DatCho;
use App\Services\DatChoService;
use Illuminate\Support\Facades\Auth;
use Mockery;
use RuntimeException;
use Tests\TestCase;

class DatChoOwnershipTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();

        parent::tearDown();
    }

    public function test_cancel_rejects_booking_owned_by_another_user(): void
    {
        Auth::shouldReceive('id')->once()->andReturn(2);

        $booking = Mockery::mock('alias:App\Models\DatCho');

        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')->once()->andReturnSelf();
        $query->shouldReceive('first')->once()->andReturn(
            (object) [
                'dat_cho_id' => 10,
                'nguoi_dung_id' => 1,
                'trang_thai' => 'confirmed',
            ]
        );

        $booking->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 10)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage(
            'Bạn không có quyền thao tác trên đặt chỗ này.'
        );

        app(DatChoService::class)->cancel(10);
    }

    public function test_refund_rejects_booking_owned_by_another_user(): void
    {
        Auth::shouldReceive('id')->once()->andReturn(2);

        $booking = Mockery::mock('alias:App\Models\DatCho');

        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')->once()->andReturnSelf();
        $query->shouldReceive('first')->once()->andReturn(
            (object) [
                'dat_cho_id' => 10,
                'nguoi_dung_id' => 1,
                'trang_thai' => 'cancelled',
            ]
        );

        $booking->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 10)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage(
            'Bạn không có quyền thao tác trên đặt chỗ này.'
        );

        app(DatChoService::class)->refund(10);
    }
}