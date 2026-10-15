<?php

namespace Tests\Unit;

use App\Services\DatChoService;
use Illuminate\Support\Facades\Auth;
use Mockery;
use RuntimeException;
use Tests\TestCase;

class DatChoHoldTest extends TestCase
{
    protected function tearDown(): void
    {
        Mockery::close();

        parent::tearDown();
    }

    public function test_hold_rejects_nonexistent_availability(): void
    {
        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn(null);

        $model = Mockery::mock(
            'alias:App\Models\LichKhaDungHanhTrinh'
        );

        $model->shouldReceive('where')
            ->once()
            ->with('lich_kha_dung_id', 999)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage(
            'Không tìm thấy lịch khả dụng.'
        );

        app(DatChoService::class)->hold(999, 2);
    }

    public function test_hold_rejects_when_not_enough_seats(): void
    {

        $query = Mockery::mock();
        $query->shouldReceive('lockForUpdate')
            ->once()
            ->andReturnSelf();
        $query->shouldReceive('first')
            ->once()
            ->andReturn((object) [
                'lich_kha_dung_id' => 10,
                'so_cho_total' => 5,
                'so_cho_held' => 2,
                'so_cho_sold' => 2,
                'gia_tham_khao' => 100000,
            ]);

        $model = Mockery::mock(
            'alias:App\Models\LichKhaDungHanhTrinh'
        );

        $model->shouldReceive('where')
            ->once()
            ->with('lich_kha_dung_id', 10)
            ->andReturn($query);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Không đủ chỗ trống.');

        app(DatChoService::class)->hold(10, 2);
    }
}
