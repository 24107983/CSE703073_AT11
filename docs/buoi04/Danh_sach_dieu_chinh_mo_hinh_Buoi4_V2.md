# DANH SÁCH ĐIỀU CHỈNH MÔ HÌNH DỮ LIỆU – BUỔI 4

## 1. Thông tin

- Đề tài: ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền
- Vai trò: V2 – Kiến trúc sư dữ liệu
- Buổi: 4
- Tài liệu đối chiếu:
  - API Contract v0.1
  - Mô hình dữ liệu / Schema
  - ERD

---

## 2. Mục đích

Đối chiếu hợp đồng API v0.1 với mô hình dữ liệu hiện tại để phát hiện các trường dữ liệu mà API hoặc yêu cầu chức năng cần nhưng cơ sở dữ liệu chưa có.

Kết quả đối chiếu được sử dụng để đề xuất điều chỉnh mô hình dữ liệu trước khi triển khai API.

---

## 3. Kết quả đối chiếu

| STT | API / Yêu cầu chức năng | Trường cần có | Bảng dữ liệu | Hiện trạng | Kết quả | Đề xuất |
|---|---|---|---|---|---|---|
| 1 | GET /mon-an | loai_mon | mon_an | Chưa có | Thiếu | Bổ sung trường loai_mon |
| 2 | RQ-F-05 / GET /mon-an/{id} | hinh_anh | mon_an | Chưa có | Thiếu | Bổ sung trường hinh_anh |

---

## 4. Chi tiết điều chỉnh

### 4.1. Trường loai_mon

**Bảng:** `mon_an`

**Nguồn yêu cầu:** GET /api/mon-an

API Contract yêu cầu bộ lọc `loai_mon` cho chức năng danh sách món ăn. Hiện tại bảng `mon_an` chưa có trường `loai_mon`.

**Đề xuất điều chỉnh:**

`loai_mon VARCHAR(100)`

**Mục đích:**

Lưu loại/nhóm món ăn và hỗ trợ chức năng lọc món ăn theo loại món.

---

### 4.2. Trường hinh_anh

**Bảng:** `mon_an`

**Nguồn yêu cầu:** RQ-F-05

RQ-F-05 yêu cầu hiển thị hình ảnh món ăn. API Contract cũng ghi chú rằng bảng `mon_an` hiện chưa có trường `hinh_anh`.

**Đề xuất điều chỉnh:**

`hinh_anh TEXT`

**Mục đích:**

Lưu đường dẫn hoặc thông tin hình ảnh của món ăn để phục vụ việc hiển thị trên giao diện.

---

## 5. Đề xuất cập nhật mô hình

Bảng `mon_an` dự kiến bổ sung hai trường:

```sql
loai_mon VARCHAR(100),
hinh_anh TEXT