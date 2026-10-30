from contextlib import asynccontextmanager
from pathlib import Path
from typing import Any

import pymysql
from dotenv import dotenv_values
from fastapi import FastAPI, HTTPException, Query
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity


# Read Laravel environment variables without exposing credentials in code.
BACKEND_ENV = Path(__file__).resolve().parent.parent / ".env"
ENV = dotenv_values(BACKEND_ENV)


def get_db_config() -> dict[str, Any]:
    required = ["DB_HOST", "DB_PORT", "DB_DATABASE", "DB_USERNAME"]
    missing = [key for key in required if not ENV.get(key)]

    if missing:
        raise RuntimeError(
            "Missing MySQL settings in backend/.env: " + ", ".join(missing)
        )

    return {
        "host": ENV["DB_HOST"],
        "port": int(ENV["DB_PORT"]),
        "database": ENV["DB_DATABASE"],
        "user": ENV["DB_USERNAME"],
        "password": ENV.get("DB_PASSWORD") or "",
        "charset": "utf8mb4",
	"use_unicode": True,
        "cursorclass": pymysql.cursors.DictCursor,
        "connect_timeout": 5,
    }


def load_data() -> list[dict[str, Any]]:
    connection = pymysql.connect(**get_db_config())

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT
                    ma.mon_an_id AS id,
                    ma.ten_mon AS name,
                    COALESCE(ma.mo_ta, '') AS description,
                    ma.gia_tham_khao AS price,
                    ma.vung_mien_id AS region_id,
                    vm.ten_vung AS region_name,
                    ma.tinh_thanh_id AS province_id,
                    tt.ten_tinh AS province_name
                FROM mon_an ma
                LEFT JOIN vung_mien vm
                    ON ma.vung_mien_id = vm.vung_mien_id
                LEFT JOIN tinh_thanh tt
                    ON ma.tinh_thanh_id = tt.tinh_thanh_id
                WHERE ma.ten_mon NOT LIKE '%Mon an mo phong%'
                  AND ma.ten_mon NOT LIKE '%Test%'
                ORDER BY ma.mon_an_id
            """)
            dishes = cursor.fetchall()

            cursor.execute("""
                SELECT
                    mal.mon_an_id AS dish_id,
                    nl.ten_nguyen_lieu AS ingredient
                FROM mon_an_nguyen_lieu mal
                JOIN nguyen_lieu nl
                    ON mal.nguyen_lieu_id = nl.nguyen_lieu_id
            """)
            ingredient_rows = cursor.fetchall()

        ingredients_by_dish: dict[int, list[str]] = {}

        for row in ingredient_rows:
            dish_id = int(row["dish_id"])
            ingredients_by_dish.setdefault(dish_id, []).append(
                row["ingredient"]
            )

        for dish in dishes:
            dish["id"] = int(dish["id"])
            dish["region_id"] = (
                int(dish["region_id"])
                if dish["region_id"] is not None else None
            )
            dish["province_id"] = (
                int(dish["province_id"])
                if dish["province_id"] is not None else None
            )
            dish["ingredients"] = ingredients_by_dish.get(dish["id"], [])

            dish["text"] = " ".join([
                str(dish["name"] or ""),
                str(dish["description"] or ""),
                str(dish["province_name"] or ""),
                str(dish["region_name"] or ""),
                " ".join(dish["ingredients"]),
            ])

        if not dishes:
            raise RuntimeError("No dishes found in table mon_an.")

        return dishes

    finally:
        connection.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    dishes = load_data()

    vectorizer = TfidfVectorizer(
        lowercase=True,
        ngram_range=(1, 2),
        max_features=5000,
        strip_accents="unicode",
    )

    texts = [dish["text"] for dish in dishes]
    matrix = vectorizer.fit_transform(texts)

    app.state.dishes = dishes
    app.state.dish_by_id = {dish["id"]: i for i, dish in enumerate(dishes)}
    app.state.vectorizer = vectorizer
    app.state.matrix = matrix

    print(f"Loaded {len(dishes)} dishes into memory.")

    yield

    app.state.dishes = []
    app.state.matrix = None


app = FastAPI(
    title="AT-11 Culinary Recommendation API",
    version="1.0.0",
    lifespan=lifespan,
)


@app.get("/")
def health_check():
    return {
        "status": "ok",
        "service": "AT-11 Python Recommendation Service",
        "loaded_dishes": len(app.state.dishes),
    }

@app.get("/health")
def health():
    """Kiểm tra Python service và kết nối database."""
    try:
        connection = get_db_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1 AS ok")
                cursor.fetchone()
        finally:
            connection.close()

        return {
            "status": "ok",
            "database": "connected",
            "loaded_dishes": len(app.state.dishes),
        }
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail=f"Database connection failed: {str(e)}",
        )


@app.get("/test-timeout")
def test_timeout():
    import time
    time.sleep(10)
    return {"message": "This should not be reached before Laravel timeout"}


@app.get("/test-error")
def test_error():
    raise HTTPException(
        status_code=500,
        detail="Test Python internal server error",
    )
@app.get("/recommend/{product_id}")
def recommend(
    product_id: int,
    k: int = Query(default=5, ge=1, le=20),
):
    dishes = app.state.dishes
    dish_by_id = app.state.dish_by_id

    if product_id not in dish_by_id:
        raise HTTPException(status_code=404, detail="Dish not found.")

    source_index = dish_by_id[product_id]
    source = dishes[source_index]

    similarities = cosine_similarity(
        app.state.matrix[source_index],
        app.state.matrix,
    ).flatten()

    results = []

    for index, candidate in enumerate(dishes):
        if candidate["id"] == product_id:
            continue

        score = float(similarities[index])

        if (
            source["province_id"] is not None
            and candidate["province_id"] == source["province_id"]
        ):
            score += 0.30

        elif (
            source["region_id"] is not None
            and candidate["region_id"] == source["region_id"]
        ):
            score += 0.15

        source_ingredients = set(source["ingredients"])
        candidate_ingredients = set(candidate["ingredients"])

        if source_ingredients and candidate_ingredients:
            union = source_ingredients | candidate_ingredients
            ingredient_score = len(
                source_ingredients & candidate_ingredients
            ) / len(union)

            score += 0.20 * ingredient_score

        results.append({
            "id": candidate["id"],
            "name": candidate["name"],
            "score": round(score, 4),
        })

    results.sort(key=lambda item: item["score"], reverse=True)

    return {
        "product_id": product_id,
        "recommendations": results[:k],
    }
