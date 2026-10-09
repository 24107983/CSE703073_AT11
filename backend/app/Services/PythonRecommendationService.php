<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PythonRecommendationService
{
    public function recommend(int $productId, int $k = 5): array
    {
        try {
            $url = rtrim(config('services.python.url'), '/')
                . '/recommend/'
                . $productId;

            $response = Http::timeout(3)
                ->get($url, ['k' => $k]);

            if ($response->successful()) {
                $data = $response->json();

                if (
                    isset($data['recommendations'])
                    && is_array($data['recommendations'])
                ) {
                    return $data['recommendations'];
                }

                Log::warning(
                    'Python service trả response không đúng format.',
                    [
                        'product_id' => $productId,
                        'response' => $data,
                    ]
                );

                return $this->fallback($productId);
            }

            Log::error('Python service trả lỗi HTTP.', [
                'product_id' => $productId,
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return $this->fallback($productId);

        } catch (\Throwable $e) {
            Log::error(
                'Không thể gọi Python recommendation service.',
                [
                    'product_id' => $productId,
                    'message' => $e->getMessage(),
                ]
            );

            return $this->fallback($productId);
        }
    }

    public function testError(): array
    {
        try {
            $url = config('services.python.url') . '/test-error';

            $response = Http::timeout(3)->get($url);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('Python test endpoint trả lỗi HTTP.', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            return $this->fallback(0);

        } catch (\Throwable $e) {
            Log::error(
                'Python test endpoint timeout hoặc không kết nối được.',
                [
                    'message' => $e->getMessage(),
                ]
            );

            return $this->fallback(0);
        }
    }

    public function testTimeout(): array
    {
        try {
            $url = config('services.python.url') . '/test-timeout';

            $response = Http::timeout(3)->get($url);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error(
                'Python test timeout endpoint trả lỗi HTTP.',
                [
                    'status' => $response->status(),
                    'body' => $response->body(),
                ]
            );

            return $this->fallback(0);

        } catch (\Throwable $e) {
            Log::error(
                'Python test timeout: Laravel đã kích hoạt fallback.',
                [
                    'message' => $e->getMessage(),
                ]
            );

            return $this->fallback(0);
        }
    }

    private function fallback(int $productId): array
    {
        return [
            [
                'id' => $productId,
                'name' => 'Gợi ý mặc định',
                'score' => 0,
            ],
        ];
    }
}