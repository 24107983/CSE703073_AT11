# V3 – Buổi 3: Index và đo hiệu năng truy vấn

## 1. Mục tiêu

Kiểm tra hiệu quả của index đối với các truy vấn tìm kiếm dữ liệu món ăn theo tỉnh/thành phố và theo khoảng giá.

Dữ liệu benchmark gồm 1.000 bản ghi trong bảng `mon_an`. Trong đó, 990 bản ghi bổ sung là dữ liệu mô phỏng phục vụ kiểm thử hiệu năng, không đại diện cho dữ liệu khảo sát thực tế.

## 2. Index kiểm thử

| Index | Bảng | Cột |
|---|---|---|
| `idx_mon_an_tinh_thanh` | `mon_an` | `tinh_thanh_id` |
| `idx_mon_an_gia` | `mon_an` | `gia_tham_khao` |

## 3. Kết quả EXPLAIN

### 3.1. Query 1 – Tìm món ăn theo tỉnh

```sql
SELECT *
FROM mon_an
WHERE tinh_thanh_id = 1;
```

### BEFORE INDEX

```sql
EXPLAIN
SELECT *
FROM mon_an IGNORE INDEX (idx_mon_an_tinh_thanh)
WHERE tinh_thanh_id = 1;
```

Kết quả:

- Access type: `ALL`
- Key: `NULL`
- Rows: `1000`
- Extra: `Using where`

Kết quả `EXPLAIN ANALYZE`:

- Execution plan: `Table scan on mon_an`
- Actual time: `0.031..0.722 ms`
- Rows: `1000`
- Loops: `1`
- Rows sau Filter: `112`
- Filter actual time: `0.0327..0.786 ms`

**Nhận xét:** Trước khi sử dụng index, MySQL phải quét toàn bộ 1.000 bản ghi của bảng `mon_an` để tìm các bản ghi có `tinh_thanh_id = 1`.

### AFTER INDEX

```sql
EXPLAIN
SELECT *
FROM mon_an
WHERE tinh_thanh_id = 1;
```

Kết quả:

- Access type: `ref`
- Key: `idx_mon_an_tinh_thanh`
- Rows: `112`
- Ref: `const`

Kết quả `EXPLAIN ANALYZE`:

- Execution plan: `Index lookup on mon_an using idx_mon_an_tinh_thanh`
- Actual time: `0.0243..0.261 ms`
- Rows: `112`
- Loops: `1`

**Nhận xét:** Sau khi sử dụng index, MySQL chuyển execution plan từ Table Scan sang Index Lookup và sử dụng `idx_mon_an_tinh_thanh`. Số dòng dự kiến được truy xuất giảm từ 1.000 xuống 112.

---

### 3.2. Query 2 – Lọc món ăn theo khoảng giá

Khoảng giá kiểm thử là `31.443–32.000` đồng. Với khoảng giá này, dữ liệu hiện tại có 2 bản ghi phù hợp và optimizer lựa chọn sử dụng index.

```sql
SELECT *
FROM mon_an
WHERE gia_tham_khao BETWEEN 31443 AND 32000;
```

### BEFORE INDEX

```sql
EXPLAIN
SELECT *
FROM mon_an IGNORE INDEX (idx_mon_an_gia)
WHERE gia_tham_khao BETWEEN 31443 AND 32000;
```

Kết quả:

- Access type: `ALL`
- Key: `NULL`
- Rows: `1000`
- Extra: `Using where`

Kết quả `EXPLAIN ANALYZE`:

- Execution plan: `Table scan on mon_an`
- Actual time: `0.0384..0.771 ms`
- Rows: `1000`
- Loops: `1`
- Rows sau Filter: `2`
- Filter actual time: `0.925..0.964 ms`

**Nhận xét:** Trước khi sử dụng index, MySQL phải quét toàn bộ 1.000 bản ghi để tìm các món có giá nằm trong khoảng 31.443–32.000 đồng.

### AFTER INDEX

```sql
EXPLAIN
SELECT *
FROM mon_an
WHERE gia_tham_khao BETWEEN 31443 AND 32000;
```

Kết quả:

- Access type: `range`
- Key: `idx_mon_an_gia`
- Rows: `2`
- Extra: `Using index condition`

Kết quả `EXPLAIN ANALYZE`:

- Execution plan: `Index range scan on mon_an using idx_mon_an_gia`
- Actual time: `0.0345..0.0457 ms`
- Rows: `2`
- Loops: `1`

**Nhận xét:** Sau khi sử dụng index, MySQL thực hiện Index Range Scan trên `idx_mon_an_gia` và chỉ truy xuất 2 bản ghi phù hợp thay vì quét toàn bộ bảng.

---

## 4. Bảng so sánh execution plan

| Truy vấn | BEFORE – Access | BEFORE – Rows | AFTER – Access | AFTER – Rows | Kết quả |
|---|---|---:|---|---:|---|
| Tìm theo tỉnh | `ALL` – Table Scan | 1000 | `ref` – Index Lookup | 112 | Index được sử dụng |
| Lọc theo khoảng giá | `ALL` – Table Scan | 1000 | `range` – Index Range Scan | 2 | Index được sử dụng |

## 5. Bảng so sánh thời gian

| Truy vấn | BEFORE | AFTER |
|---|---:|---:|
| Tìm món theo tỉnh | `0.031..0.722 ms` | `0.0243..0.261 ms` |
| Lọc món theo khoảng giá | `0.0384..0.771 ms` | `0.0345..0.0457 ms` |

**Lưu ý:** Thời gian thực tế ở mức mili-giây và có thể dao động giữa các lần chạy. Vì vậy, hiệu quả index được đánh giá chủ yếu dựa trên execution plan và số dòng được truy xuất, không chỉ dựa vào thời gian của một lần chạy.

## 6. Kết luận

Qua kiểm thử, index `idx_mon_an_tinh_thanh` trên cột `tinh_thanh_id` được MySQL sử dụng khi thực hiện truy vấn tìm món ăn theo tỉnh. Execution plan chuyển từ Table Scan sang Index Lookup và số dòng dự kiến được truy xuất giảm từ 1.000 xuống 112.

Đối với truy vấn khoảng giá `31.443–32.000` đồng, index `idx_mon_an_gia` được MySQL sử dụng dưới dạng Index Range Scan. Execution plan chuyển từ Table Scan sang Index Range Scan và số dòng được truy xuất giảm từ 1.000 xuống 2.

Kết quả cho thấy index có thể giúp MySQL giảm số lượng bản ghi phải quét khi điều kiện truy vấn có tính chọn lọc cao. Việc optimizer có sử dụng index hay không phụ thuộc vào đặc điểm dữ liệu và chi phí ước tính của truy vấn.

## 7. Ghi chú dữ liệu benchmark

Dữ liệu benchmark gồm 1.000 bản ghi trong bảng `mon_an`. Trong đó, 10 bản ghi ban đầu đến từ dữ liệu seed của nhóm và 990 bản ghi bổ sung được tạo dưới dạng dữ liệu mô phỏng phục vụ kiểm thử hiệu năng.

Các bản ghi mô phỏng không đại diện cho dữ liệu khảo sát thực tế và không sử dụng thông tin cá nhân thật.
