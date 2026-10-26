<?php

namespace Tests\Feature;

use Illuminate\Http\Client\ConnectionException;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class PythonRecommendationTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        config([
            'services.python.url' => 'http://python.test',
        ]);
    }

    public function test_recommendation_returns_python_results_when_service_works(): void
    {
        Http::fake([
            '*' => Http::response([
                'recommendations' => [
                    [
                        'id' => 10,
                        'name' => 'Mon an thu nghiem',
                        'score' => 0.95,
                    ],
                ],
            ], 200),
        ]);

        $response = $this->getJson('/api/python/recommend/10?k=3');

        $response
            ->assertOk()
            ->assertJsonPath('product_id', 10)
            ->assertJsonPath(
                'recommendations.0.name',
                'Mon an thu nghiem'
            );

        Http::assertSent(function ($request) {
            return str_contains($request->url(), '/recommend/10')
                && $request['k'] == 3;
        });
    }

    public function test_recommendation_uses_fallback_when_python_returns_http_error(): void
    {
        Http::fake([
            '*' => Http::response(['error' => 'Service unavailable'], 503),
        ]);

        $response = $this->getJson('/api/python/recommend/25');

        $response
            ->assertOk()
            ->assertJsonPath('product_id', 25)
            ->assertJsonPath('recommendations.0.id', 25)
            ->assertJsonPath(
                'recommendations.0.name',
                'Gợi ý mặc định'
            )
            ->assertJsonPath('recommendations.0.score', 0);
    }

    public function test_recommendation_uses_fallback_when_python_connection_fails(): void
    {
        Http::fake(function ($request, $options) {
            throw new ConnectionException('Connection refused');
        });

        $response = $this->getJson('/api/python/recommend/30');

        $response
            ->assertOk()
            ->assertJsonPath('product_id', 30)
            ->assertJsonPath('recommendations.0.id', 30)
            ->assertJsonPath(
                'recommendations.0.name',
                'Gợi ý mặc định'
            );
    }

    public function test_recommendation_uses_fallback_when_python_response_is_invalid(): void
    {
        Http::fake([
            '*' => Http::response([
                'unexpected' => 'invalid format',
            ], 200),
        ]);

        $response = $this->getJson('/api/python/recommend/40');

        $response
            ->assertOk()
            ->assertJsonPath('product_id', 40)
            ->assertJsonPath('recommendations.0.id', 40)
            ->assertJsonPath(
                'recommendations.0.name',
                'Gợi ý mặc định'
            );
    }

    public function test_recommendation_skips_invalid_items_and_keeps_valid_items(): void
    {
        Http::fake([
            '*' => Http::response([
                'recommendations' => [
                    [
                        'id' => 12,
                        'name' => 'Mon an thieu score',
                    ],
                    [
                        'id' => '8',
                        'name' => 'Banh xeo mien Tay',
                        'score' => '0.87',
                    ],
                ],
            ], 200),
        ]);

        $response = $this->getJson('/api/python/recommend/10');

        $response
            ->assertOk()
            ->assertJsonPath('recommendations.0.id', 8)
            ->assertJsonPath(
                'recommendations.0.name',
                'Banh xeo mien Tay'
            )
            ->assertJsonPath('recommendations.0.score', 0.87)
            ->assertJsonCount(1, 'recommendations');
    }

    public function test_recommendation_uses_fallback_when_all_items_are_invalid(): void
    {
        Http::fake([
            '*' => Http::response([
                'recommendations' => [
                    [
                        'id' => 12,
                        'name' => 'Mon an thieu score',
                    ],
                ],
            ], 200),
        ]);

        $response = $this->getJson('/api/python/recommend/10');

        $response
            ->assertOk()
            ->assertJsonPath('product_id', 10)
            ->assertJsonPath('recommendations.0.id', 10)
            ->assertJsonPath(
                'recommendations.0.name',
                'Gợi ý mặc định'
            )
            ->assertJsonPath('recommendations.0.score', 0);
    }

}
