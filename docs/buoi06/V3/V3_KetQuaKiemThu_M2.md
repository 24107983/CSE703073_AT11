# V3 – KẾT QUẢ KIỂM THỬ MỐC M2

## 1. Kiểm thử tìm kiếm

| STT | Nội dung | Kết quả |
|---|---|---|
| 1 | Tìm kiếm theo tên món `q=phở` | PASS |
| 2 | Lọc theo vùng miền | PASS |
| 3 | Lọc theo tỉnh thành | PASS |
| 4 | Lọc theo khoảng giá | PASS |
| 5 | Lọc theo địa điểm | PASS |
| 6 | Sắp xếp giá tăng dần | PASS |
| 7 | Sắp xếp giá giảm dần | PASS |
| 8 | Phân trang dữ liệu | PASS |

## 2. Kiểm thử giữ chỗ

- Tạo đặt chỗ thành công.
- Trạng thái `pending_payment`.
- Thời hạn giữ chỗ 15 phút.
- `so_cho_held` tăng đúng số khách.
- Có bản ghi lịch sử.

**Kết quả: PASS**

## 3. Kiểm thử hết hạn giữ chỗ

Command:

`php artisan dat-cho:expire`

Kết quả:

- Đặt chỗ chuyển `pending_payment` → `expired`.
- `so_cho_held` được giảm.
- Chỗ được trả lại.
- Lịch sử chuyển trạng thái được ghi nhận.

**Kết quả: PASS**

## 4. Kiểm thử tranh chấp chỗ cuối

Điều kiện:

- `so_cho_total = 1`
- `so_cho_held = 0`
- `so_cho_sold = 0`

Phiên 1 giữ 1 chỗ → thành công.

Phiên 2 tiếp tục giữ 1 chỗ → bị từ chối với thông báo:

`Không đủ chỗ trống.`

Kết quả:

- Chỉ phiên đầu tạo được đặt chỗ.
- Không tạo đặt chỗ thứ hai.
- Số chỗ còn lại bằng 0.

**Kết quả: PASS**

## 5. Cơ chế xử lý tranh chấp

Hệ thống sử dụng:

`DB::transaction()`

kết hợp với:

`lockForUpdate()`

Bản ghi lịch khả dụng được khóa trước khi kiểm tra và cập nhật số chỗ.

## 6. Tổng hợp

| Nhóm kiểm thử | Kết quả |
|---|---|
| Tìm kiếm | PASS |
| Lọc | PASS |
| Sắp xếp | PASS |
| Phân trang | PASS |
| Giữ chỗ | PASS |
| Hết hạn giữ chỗ | PASS |
| Tranh chấp chỗ cuối | PASS |
