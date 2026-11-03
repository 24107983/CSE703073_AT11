<?php

namespace App\Http\Controllers;

use App\Services\PythonRecommendationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class PythonRecommendationController extends Controller
{
    public function __construct(
        private PythonRecommendationService $pythonRecommendationService
    ) {}

    public function recommend(Request $request, int $productId): JsonResponse
    {
        $validated = $request->validate([
            'k' => ['sometimes', 'integer', 'min:1', 'max:20'],
        ]);

        $k = $validated['k'] ?? 5;

        $recommendations = $this->pythonRecommendationService
            ->recommend($productId, $k);

        return response()->json([
            'product_id' => $productId,
            'recommendations' => $recommendations,
        ]);
    }
}