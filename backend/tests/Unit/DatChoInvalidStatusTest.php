<?php

namespace Tests\Unit;

use App\Services\DatChoService;
use Illuminate\Support\Facades\Auth;
use Mockery;
use RuntimeException;
use Tests\TestCase;

class DatChoInvalidStatusTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();

        parent::tearDown();
    }

    public function test_cancel_rejects_booking_not_confirmed(): void
    {
        Auth::shouldReceive('id')->once()->andReturn(1);

        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn((object) [
                'dat_cho_id' => 10,
                'nguoi_dung_id' => 1,
                'trang_thai' => 'pending_payment',
            ]);

        $model = Mockery::mock('alias:App\Models\DatCho');
        $model->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 10)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage(
            'Chỉ có thể hủy đặt chỗ đã xác nhận.'
        );

        app(DatChoService::class)->cancel(10);
    }

    public function test_refund_rejects_booking_not_cancelled(): void
    {
        Auth::shouldReceive('id')->once()->andReturn(1);

        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn((object) [
                'dat_cho_id' => 10,
                'nguoi_dung_id' => 1,
                'trang_thai' => 'confirmed',
            ]);

        $model = Mockery::mock('alias:App\Models\DatCho');
        $model->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 10)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage(
            'Chỉ có thể hoàn tiền cho đặt chỗ đã hủy.'
        );

        app(DatChoService::class)->refund(10);
    }
}