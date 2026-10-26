import os
import re
import math
from pathlib import Path

import pymysql
from fastapi import FastAPI, HTTPException, Query

app = FastAPI(title="AT-11 Python Recommendation Service")

# Đọc cấu hình từ file .env của Laravel.
# Không ghi mật khẩu trực tiếp vào mã nguồn.
def load_env_file():
    env_path = Path(__file__).resolve().parent.parent / ".env"

    if not env_path.is_file():
        return

    for line in env_path.read_text(encoding="utf-8-sig").splitlines():
        line = line.strip()

        if not line or line.startswith("#") or "=" not in line:
            continue

        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip()

        if len(value) >= 2 and value[0] == value[-1] and value[0] in ("'", '"'):
            value = value[1:-1]

        if key.startswith("DB_") and key not in os.environ:
            os.environ[key] = value


load_env_file()


def get_db_connection():
    if os.getenv("DB_CONNECTION", "mysql").lower() != "mysql":
        raise RuntimeError("Python service hiện chỉ hỗ trợ MySQL.")

    return pymysql.connect(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USERNAME", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_DATABASE", "am_thuc_vung_mien"),
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor,
        connect_timeout=3,
        read_timeout=5,
        write_timeout=5,
    )


def is_mock_dish(name):
    """Loại tên món mô phỏng khỏi kết quả gợi ý."""
    normalized = re.sub(r"\s+", " ", name.strip().lower())

    mock_patterns = (
        "mon an mo phong",
        "món ăn mô phỏng",
        "món ăn mô phong",
        "mon an gia lap",
        "món ăn giả lập",
        "món ăn gợi ý",
    )

    return any(pattern in normalized for pattern in mock_patterns)


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

        return {"status": "ok", "database": "connected"}

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Python service không kết nối được database.",
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
    k: int = Query(default=5),
):
    if k < 1 or k > 20:
        raise HTTPException(
            status_code=400,
            detail="k must be between 1 and 20",
        )

    try:
        connection = get_db_connection()

        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    SELECT
                        m.mon_an_id,
                        m.ten_mon,
                        nl.nguyen_lieu_id
                    FROM mon_an AS m
                    LEFT JOIN mon_an_nguyen_lieu AS mnl
                        ON m.mon_an_id = mnl.mon_an_id
                    LEFT JOIN nguyen_lieu AS nl
                        ON mnl.nguyen_lieu_id = nl.nguyen_lieu_id
                    ORDER BY m.mon_an_id
                    """
                )
                rows = cursor.fetchall()
        finally:
            connection.close()

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Không thể truy cập dữ liệu món ăn.",
        )

    dishes = {}

    for row in rows:
        dish_id = row["mon_an_id"]
        name = (row["ten_mon"] or "").strip()

        if dish_id not in dishes:
            dishes[dish_id] = {
                "id": dish_id,
                "name": name,
                "ingredients": set(),
            }

        if row["nguyen_lieu_id"] is not None:
            dishes[dish_id]["ingredients"].add(row["nguyen_lieu_id"])

    source = dishes.get(product_id)

    if source is None or not source["name"]:
        raise HTTPException(
            status_code=404,
            detail="Không tìm thấy món ăn.",
        )

    if is_mock_dish(source["name"]):
        raise HTTPException(
            status_code=404,
            detail="Món ăn này là dữ liệu mô phỏng, không hỗ trợ gợi ý.",
        )

    if not source["ingredients"]:
        return {
            "product_id": product_id,
            "recommendations": [],
        }

    scored = []

    for candidate_id, candidate in dishes.items():
        # Không gợi ý chính món đang xem.
        if candidate_id == product_id:
            continue

        # Chỉ dùng món có tên thật và có nguyên liệu.
        if not candidate["name"] or is_mock_dish(candidate["name"]):
            continue

        candidate_ingredients = candidate["ingredients"]

        if not candidate_ingredients:
            continue

        common = source["ingredients"] & candidate_ingredients
        union = source["ingredients"] | candidate_ingredients

        if not common or not union:
            continue

        # Jaccard = số nguyên liệu chung / tổng số nguyên liệu khác nhau.
        score = len(common) / len(union)

        scored.append({
            "id": candidate_id,
            "name": candidate["name"],
            "score": round(score, 4),
        })

    # Ưu tiên điểm cao; nếu bằng điểm thì ưu tiên ID nhỏ hơn.
    scored.sort(key=lambda item: (-item["score"], item["id"]))

    return {
        "product_id": product_id,
        "recommendations": scored[:k],
    }
