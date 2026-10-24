<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Support\Facades\DB;

class DatabaseConfigTest extends TestCase
{
    public function test_uses_sqlite_in_memory_for_testing(): void
    {
        $this->assertSame('sqlite', config('database.default'));
        $this->assertSame(':memory:', config('database.connections.sqlite.database'));

        DB::connection()->select('SELECT 1');

        $this->assertTrue(true);
    }
}