# DANH SÁCH ĐIỀU CHỈNH MÔ HÌNH DỮ LIỆU – BUỔI 4

## 1. Thông tin

- Đề tài: ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền
- Vai trò: V2 – Kiến trúc sư dữ liệu
- Buổi: 4
- Tài liệu đối chiếu:
  - API Contract v0.1
  - Schema cơ sở dữ liệu
  - ERD Buổi 3

---

## 2. Mục đích

Đối chiếu hợp đồng API v0.1 với mô hình dữ liệu hiện tại nhằm phát hiện các trường dữ liệu mà API yêu cầu nhưng cơ sở dữ liệu chưa có.

Kết quả đối chiếu được sử dụng để đề xuất điều chỉnh mô hình dữ liệu trước khi triển khai API.

---

## 3. Kết quả đối chiếu

| STT | API/Chức năng | Trường API yêu cầu | Bảng dữ liệu | Schema hiện tại | Kết quả | Đề xuất |
|-----|---------------|--------------------|--------------|-----------------|---------|---------|
| 1 | GET /mon-an | loai_mon | mon_an | Chưa có | Thiếu | Bổ sung trường loai_mon |
| 2 | GET /mon-an/{id} | hinh_anh | mon_an | Chưa có | Thiếu | Bổ sung trường hinh_anh |

---

## 4. Chi tiết điều chỉnh

### 4.1. Bổ sung trường loai_mon

**Bảng:** mon_an

**Vấn đề:**

API yêu cầu bộ lọc `loai_mon` trong endpoint:

GET /api/mon-an

Trường này hiện chưa tồn tại trong bảng `mon_an`.

**Đề xuất:**

Bổ sung:

`loai_mon VARCHAR(100)`

**Mục đích:**

Lưu loại món/nhóm món để hỗ trợ chức năng lọc món ăn theo loại món trong API.

---

### 4.2. Bổ sung trường hinh_anh

**Bảng:** mon_an

**Vấn đề:**

Yêu cầu chức năng RQ-F-05 cần hiển thị hình ảnh món ăn. Tuy nhiên bảng `mon_an` hiện chưa có trường lưu hình ảnh.

**Đề xuất:**

Bổ sung:

`hinh_anh TEXT`

**Mục đích:**

Lưu đường dẫn hoặc thông tin hình ảnh của món ăn để API có thể trả về dữ liệu hình ảnh cho giao diện.

---

## 5. Đề xuất cập nhật bảng mon_an

Sau khi thống nhất với nhóm, bảng `mon_an` dự kiến bổ sung:

```sql
loai_mon VARCHAR(100),
hinh_anh TEXT