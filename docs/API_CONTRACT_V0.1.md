# API Contract v0.1
## Dự án ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền

### 1. Thông tin chung

- **Tên hệ thống:** Bản đồ số du lịch ẩm thực vùng miền
- **Mã đề tài:** ĐT-11
- **Phiên bản API:** v0.1
- **Backend:** PHP 8.3 + Laravel 11
- **Cơ sở dữ liệu:** MySQL 8
- **Kiểu API:** RESTful API
- **Định dạng dữ liệu:** JSON

### 2. Mục đích

API cung cấp giao diện trao đổi dữ liệu giữa hệ thống máy chủ và giao diện người dùng, phục vụ các chức năng tìm kiếm, lọc, xem thông tin món ăn, địa điểm/cơ sở ẩm thực, dữ liệu văn hóa, đánh giá, bộ sưu tập, hành trình ẩm thực và đóng góp dữ liệu.

### 3. Phạm vi phiên bản v0.1

Phiên bản API v0.1 tập trung vào các chức năng đã được xác định trong yêu cầu chức năng của hệ thống:

- Tài khoản người dùng
- Tìm kiếm
- Lọc dữ liệu
- Bản đồ và địa điểm
- Chi tiết món ăn
- Dữ liệu ẩm thực liên quan
- Cơ sở ẩm thực
- Đánh giá
- Bộ sưu tập
- Hành trình ẩm thực
- Đóng góp dữ liệu
- Quản trị đóng góp dữ liệu

### 4. Quy ước chung

- Base URL: `/api/v1`
- Dữ liệu request/response sử dụng JSON.
- Tên tài nguyên sử dụng dạng số nhiều hoặc cấu trúc tài nguyên nhất quán theo endpoint.
- API danh sách sử dụng phân trang phía máy chủ.
- Các dữ liệu đầu vào phải được kiểm tra hợp lệ trước khi xử lý.
- API yêu cầu xác thực phải kiểm tra quyền truy cập tương ứng với vai trò người dùng.

### 5. HTTP Status Code

| Status | Ý nghĩa |
|---|---|
| 200 | Yêu cầu thành công |
| 201 | Tạo tài nguyên thành công |
| 204 | Xử lý thành công, không có nội dung trả về |
| 401 | Chưa xác thực |
| 403 | Không có quyền thực hiện |
| 404 | Không tìm thấy tài nguyên |
| 422 | Dữ liệu đầu vào không hợp lệ |
| 500 | Lỗi máy chủ |
## 6. Danh sách endpoint

### 6.1. Tài khoản

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 1 | POST | `/api/v1/auth/register` | Đăng ký tài khoản | Public |
| 2 | POST | `/api/v1/auth/login` | Đăng nhập | Public |
| 3 | POST | `/api/v1/auth/logout` | Đăng xuất | User |

### 6.2. Vùng miền và tỉnh/thành

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 4 | GET | `/api/v1/vung-mien` | Lấy danh sách vùng miền | Public |
| 5 | GET | `/api/v1/vung-mien/{id}` | Xem thông tin vùng miền | Public |
| 6 | GET | `/api/v1/tinh-thanh` | Lấy danh sách tỉnh/thành | Public |
| 7 | GET | `/api/v1/tinh-thanh/{id}` | Xem thông tin tỉnh/thành | Public |

### 6.3. Món ăn

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 8 | GET | `/api/v1/mon-an` | Tìm kiếm, lọc và phân trang món ăn | Public |
| 9 | GET | `/api/v1/mon-an/{id}` | Xem chi tiết món ăn | Public |
| 10 | GET | `/api/v1/mon-an/{id}/nguyen-lieu` | Xem nguyên liệu của món ăn | Public |
| 11 | GET | `/api/v1/mon-an/{id}/mua-vu` | Xem mùa vụ liên quan | Public |
| 12 | GET | `/api/v1/mon-an/{id}/dip-le` | Xem dịp lễ liên quan | Public |
| 13 | GET | `/api/v1/mon-an/{id}/di-ung` | Xem thông tin dị ứng liên quan | Public |
| 14 | GET | `/api/v1/mon-an/{id}/cau-chuyen` | Xem câu chuyện văn hóa | Public |

### 6.4. Địa điểm và cơ sở ẩm thực

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 15 | GET | `/api/v1/dia-diem` | Tìm kiếm/lấy danh sách địa điểm | Public |
| 16 | GET | `/api/v1/dia-diem/{id}` | Xem chi tiết địa điểm | Public |
| 17 | GET | `/api/v1/co-so-am-thuc` | Lấy danh sách cơ sở ẩm thực | Public |
| 18 | GET | `/api/v1/co-so-am-thuc/{id}` | Xem chi tiết cơ sở ẩm thực | Public |

### 6.5. Đánh giá

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 19 | GET | `/api/v1/mon-an/{id}/danh-gia` | Xem đánh giá món ăn | Public |
| 20 | POST | `/api/v1/mon-an/{id}/danh-gia` | Gửi đánh giá món ăn | User |
| 21 | GET | `/api/v1/co-so-am-thuc/{id}/danh-gia` | Xem đánh giá cơ sở | Public |
| 22 | POST | `/api/v1/co-so-am-thuc/{id}/danh-gia` | Gửi đánh giá cơ sở | User |

### 6.6. Bộ sưu tập

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 23 | GET | `/api/v1/bo-suu-tap` | Lấy bộ sưu tập của người dùng | User |
| 24 | POST | `/api/v1/bo-suu-tap` | Tạo bộ sưu tập | User |
| 25 | GET | `/api/v1/bo-suu-tap/{id}` | Xem chi tiết bộ sưu tập | User |
| 26 | POST | `/api/v1/bo-suu-tap/{id}/mon-an` | Thêm món ăn vào bộ sưu tập | User |
| 27 | DELETE | `/api/v1/bo-suu-tap/{id}/mon-an/{mon_an_id}` | Xóa món ăn khỏi bộ sưu tập | User |

### 6.7. Hành trình ẩm thực

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 28 | GET | `/api/v1/hanh-trinh-am-thuc` | Lấy danh sách hành trình | Public |
| 29 | GET | `/api/v1/hanh-trinh-am-thuc/{id}` | Xem chi tiết hành trình | Public |

### 6.8. Đóng góp dữ liệu

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 30 | POST | `/api/v1/dong-gop` | Gửi đóng góp dữ liệu | User |
| 31 | GET | `/api/v1/dong-gop/me` | Xem các đóng góp của mình | User |

### 6.9. Quản trị

| STT | Method | Endpoint | Mục đích | Quyền |
|---|---|---|---|---|
| 32 | GET | `/api/v1/admin/dong-gop` | Xem danh sách đóng góp cần quản lý | Admin |
| 33 | PATCH | `/api/v1/admin/dong-gop/{id}` | Cập nhật trạng thái đóng góp | Admin |
## 7. Chi tiết API

### 7.1. Authentication

#### 7.1.1. Đăng ký tài khoản

**Endpoint**

```text
POST /api/v1/auth/register
### 7.2. Vùng miền và tỉnh/thành

#### 7.2.1. Lấy danh sách vùng miền

**Endpoint**

```text
GET /api/v1/vung-mien
### 7.3. Món ăn

#### 7.3.1. Tìm kiếm, lọc và phân trang món ăn

**Endpoint**

```text

GET /api/v1/mon-an
### 7.3.2. Xem chi tiết món ăn

**Endpoint**

```text
GET /api/v1/mon-an/{id}
### 7.3.3. Lấy nguyên liệu của món ăn

**Endpoint**

```text
GET /api/v1/mon-an/{id}/nguyen-lieu
#### 7.3.3. Lấy nguyên liệu của món ăn

**Endpoint**

GET /api/v1/mon-an/{id}/nguyen-lieu

**Mục đích**

Lấy danh sách nguyên liệu và thông tin số lượng, đơn vị của một món ăn.

**Quyền truy cập**

Public.

**Path parameters**

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `id` | integer | Có | ID của món ăn |

**Response 200**

```json
{
  "data": [
    {
      "nguyen_lieu_id": 1,
      "ten_nguyen_lieu": "Bánh phở",
      "mo_ta": "...",
      "so_luong": 200,
      "don_vi": "gram"
    }
  ]
}
### 7.4. Địa điểm và cơ sở ẩm thực

#### 7.4.1. Lấy danh sách địa điểm

**Endpoint**

GET /api/v1/dia-diem

**Mục đích**

Lấy danh sách địa điểm phục vụ hiển thị trên bản đồ và hỗ trợ tìm kiếm địa điểm.

**Quyền truy cập**

Public.

**Query parameters**

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `tinh_thanh_id` | integer | Không | Lọc theo tỉnh/thành |
| `keyword` | string | Không | Tìm theo tên địa điểm hoặc địa chỉ |
| `page` | integer | Không | Số trang, mặc định 1 |
| `per_page` | integer | Không | Số bản ghi/trang |

**Response 200**

```json
{
  "data": [
    {
      "dia_diem_id": 1,
      "ten_dia_diem": "Phố cổ Hà Nội",
      "dia_chi": "Hà Nội",
      "kinh_do": 105.8542,
      "vi_do": 21.0285,
      "tinh_thanh": {
        "tinh_thanh_id": 1,
        "ten_tinh": "Hà Nội"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 10,
    "total": 20,
    "last_page": 2
  }
}
### 7.5. Đánh giá

#### 7.5.1. Lấy danh sách đánh giá của món ăn

**Endpoint**

GET /api/v1/mon-an/{id}/danh-gia

**Mục đích**

Lấy danh sách đánh giá của người dùng đối với một món ăn.

**Quyền truy cập**

Public.

**Path parameters**

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `id` | integer | Có | ID món ăn |

**Query parameters**

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---|---|---|---|
| `page` | integer | Không | Số trang, mặc định 1 |
| `per_page` | integer | Không | Số bản ghi/trang |

**Response 200**

```json
{
  "data": [
    {
      "danh_gia_id": 1,
      "nguoi_dung": {
        "nguoi_dung_id": 1,
        "ho_ten": "Nguyễn Văn A"
      },
      "so_sao": 5,
      "noi_dung": "Món ăn ngon.",
      "ngay_danh_gia": "2026-09-22"
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 10,
    "total": 5,
    "last_page": 1
  }
}