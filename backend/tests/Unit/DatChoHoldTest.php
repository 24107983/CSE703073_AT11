<?php

namespace Tests\Unit;

use App\Models\LichKhaDungHanhTrinh;
use App\Services\DatChoService;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use RuntimeException;
use Tests\TestCase;

class DatChoHoldTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        config([
            'database.default' => 'sqlite',
            'database.connections.sqlite.database' => ':memory:',
        ]);

        DB::purge('sqlite');
        DB::setDefaultConnection('sqlite');

        Schema::dropIfExists('lich_kha_dung_hanh_trinh');

        Schema::create('lich_kha_dung_hanh_trinh', function ($table) {
            $table->increments('lich_kha_dung_id');
            $table->unsignedInteger('hanh_trinh_id')->default(1);
            $table->date('ngay_phuc_vu')->nullable();
            $table->integer('so_cho_total')->default(0);
            $table->integer('so_cho_held')->default(0);
            $table->integer('so_cho_sold')->default(0);
            $table->decimal('gia_tham_khao', 12, 2)->default(0);
        });
    }

    public function test_hold_rejects_nonexistent_availability(): void
    {
        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Không tìm thấy lịch khả dụng.');

        app(DatChoService::class)->hold(999, 2);
    }

    public function test_hold_rejects_when_not_enough_seats(): void
    {
        LichKhaDungHanhTrinh::create([
            'hanh_trinh_id' => 1,
            'ngay_phuc_vu' => '2026-11-01',
            'so_cho_total' => 5,
            'so_cho_held' => 2,
            'so_cho_sold' => 2,
            'gia_tham_khao' => 100000,
        ]);

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('Không đủ chỗ trống.');

        app(DatChoService::class)->hold(1, 2);
    }
}
