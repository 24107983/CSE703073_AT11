<?php

namespace Tests\Unit;

use App\Services\DatChoService;
use Illuminate\Support\Facades\DB;
use Mockery;
use RuntimeException;
use Tests\TestCase;

class DatChoNotFoundTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();

        parent::tearDown();
    }

    public function test_cancel_rejects_nonexistent_booking(): void
    {
        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn(null);

        $model = Mockery::mock('alias:App\Models\DatCho');
        $model->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 999)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Không tìm thấy đặt chỗ.');

        app(DatChoService::class)->cancel(999);
    }

    public function test_refund_rejects_nonexistent_booking(): void
    {
        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn(null);

        $model = Mockery::mock('alias:App\Models\DatCho');
        $model->shouldReceive('where')
            ->once()
            ->with('dat_cho_id', 999)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Không tìm thấy đặt chỗ.');

        app(DatChoService::class)->refund(999);
    }
}