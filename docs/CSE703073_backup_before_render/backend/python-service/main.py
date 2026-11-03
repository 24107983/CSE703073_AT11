from fastapi import FastAPI, HTTPException

app = FastAPI(title="AT-11 Python Recommendation Service")

@app.get("/test-timeout")
def test_timeout():
    import time
    time.sleep(10)
    return {"message": "This should not be reached before Laravel timeout"}

@app.get("/test-error")
def test_error():
    raise HTTPException(
        status_code=500,
        detail="Test Python internal server error"
    )

@app.get("/recommend/{product_id}")
def recommend(product_id: int, k: int = 5):
    if k < 1 or k > 20:
        raise HTTPException(
            status_code=400,
            detail="k must be between 1 and 20"
        )

    recommendations = [
        {
            "id": product_id + i,
            "name": f"Món ăn gợi ý {product_id + i}",
            "score": round(1 - (i * 0.05), 2)
        }
        for i in range(1, k + 1)
    ]

    return {
        "product_id": product_id,
        "recommendations": recommendations
    }