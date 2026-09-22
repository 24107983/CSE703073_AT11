# API CONTRACT v0.1

## ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền

### 1. Mục đích

Thống nhất hợp đồng API giữa V3 (máy chủ), V4 (giao diện) và V5 (kiểm thử).

### 2. Công nghệ

- Backend: PHP 8.3 + Laravel 11
- Database: MySQL 8
- API: REST
- Phân trang: server-side
- Xác thực và phân quyền theo vai trò

### 3. Quy ước chung

- Base URL: /api
- Request/Response sử dụng JSON.
- ID sử dụng kiểu số nguyên.
- API danh sách sử dụng page và per_page.
- per_page mặc định là 10.
- per_page tối đa là 100.
- Lỗi validation: HTTP 422.
- Chưa đăng nhập: HTTP 401.
- Không đủ quyền: HTTP 403.

### 4. Vai trò

- khach_du_lich
- cong_tac_vien
- quan_tri_vien

### 5. Danh sách endpoint

1. POST /auth/register
2. POST /auth/login
3. POST /auth/logout
4. GET /vung-mien
5. GET /vung-mien/{id}
6. GET /tinh-thanh
7. GET /tinh-thanh/{id}
8. GET /mon-an
9. GET /mon-an/{id}
10. GET /mon-an/{id}/nguyen-lieu
11. GET /mon-an/{id}/mua-vu
12. GET /mon-an/{id}/dip-le
13. GET /mon-an/{id}/di-ung
14. GET /mon-an/{id}/cau-chuyen
15. GET /dia-diem
16. GET /dia-diem/{id}
17. GET /co-so-am-thuc
18. GET /co-so-am-thuc/{id}
19. GET /mon-an/{id}/danh-gia
20. POST /mon-an/{id}/danh-gia
21. GET /co-so-am-thuc/{id}/danh-gia
22. POST /co-so-am-thuc/{id}/danh-gia
23. GET /bo-suu-tap
24. POST /bo-suu-tap
25. GET /bo-suu-tap/{id}
26. POST /bo-suu-tap/{id}/mon-an
27. DELETE /bo-suu-tap/{id}/mon-an/{mon_an_id}
28. GET /hanh-trinh-am-thuc
29. GET /hanh-trinh-am-thuc/{id}
30. POST /dong-gop
31. GET /dong-gop/me
32. GET /admin/dong-gop
33. PATCH /admin/dong-gop/{id}


## 7.1. Xác thực

### 7.1.1 POST /auth/register

Auth: Public

Request:
- ho_ten
- email
- mat_khau

Response 201:
- nguoi_dung_id
- ho_ten
- email
- vai_tro

Vai trò mặc định: khach_du_lich.

Status: 201, 422, 500.


### 7.1.2 POST /auth/login

Auth: Public

Request:
- email
- mat_khau

Response 200:
- token
- thông tin người dùng

Status: 200, 401, 422, 500.


### 7.1.3 POST /auth/logout

Auth: User

Response: HTTP 204.

Status: 204, 401, 500.


## 7.2. Vùng miền và tỉnh thành

### 7.2.1 GET /vung-mien

Auth: Public

Query:
- page
- per_page

Response:
- vung_mien_id
- ten_vung
- mo_ta

Status: 200, 500.


### 7.2.2 GET /vung-mien/{id}

Auth: Public

Path parameter:
- id: vung_mien_id

Response:
- vung_mien_id
- ten_vung
- mo_ta

Status: 200, 404, 500.


### 7.2.3 GET /tinh-thanh

Auth: Public

Query:
- vung_mien_id
- page
- per_page

Response:
- tinh_thanh_id
- ten_tinh
- vung_mien_id

Status: 200, 500.


### 7.2.4 GET /tinh-thanh/{id}

Auth: Public

Path parameter:
- id: tinh_thanh_id

Response:
- tinh_thanh_id
- ten_tinh
- vung_mien_id

Status: 200, 404, 500.


## 7.3. Món ăn

### 7.3.1 GET /mon-an

Auth: Public

Query:
- keyword
- vung_mien_id
- tinh_thanh_id
- loai_mon
- page
- per_page

Response:
- mon_an_id
- ten_mon
- mo_ta
- gia_tham_khao
- vung_mien_id
- tinh_thanh_id
- dia_diem_id

Status: 200, 500.

Lưu ý: RQ-F-03 yêu cầu lọc loai_mon nhưng bảng mon_an hiện chưa có trường loai_mon. Cần V2 xác nhận/bổ sung schema.


### 7.3.2 GET /mon-an/{id}

Auth: Public

Response:
- mon_an_id
- ten_mon
- mo_ta
- gia_tham_khao
- vung_mien_id
- tinh_thanh_id
- dia_diem_id

Status: 200, 404, 500.

Lưu ý: RQ-F-05 yêu cầu hình ảnh món ăn nhưng bảng mon_an hiện chưa có hinh_anh. Cần V2 xác nhận/bổ sung schema.


### 7.3.3 GET /mon-an/{id}/nguyen-lieu

Auth: Public

Response:
- nguyen_lieu_id
- ten_nguyen_lieu
- mo_ta
- so_luong
- don_vi

Status: 200, 404, 500.


### 7.3.4 GET /mon-an/{id}/mua-vu

Auth: Public

Response:
- mua_vu_id
- ten_mua
- mo_ta
- ghi_chu

Status: 200, 404, 500.


### 7.3.5 GET /mon-an/{id}/dip-le

Auth: Public

Response:
- dip_le_id
- ten_dip_le
- thoi_gian
- mo_ta
- ghi_chu

Status: 200, 404, 500.


### 7.3.6 GET /mon-an/{id}/di-ung

Auth: Public

Response:
- di_ung_id
- ten_chat_di_ung
- mo_ta
- ghi_chu

Status: 200, 404, 500.


### 7.3.7 GET /mon-an/{id}/cau-chuyen

Auth: Public

Response:
- cau_chuyen_id
- tieu_de
- noi_dung
- nguon_goc
- gia_tri_van_hoa

Status: 200, 404, 500.


## 7.4. Địa điểm và cơ sở ẩm thực

### 7.4.1 GET /dia-diem

Auth: Public

Query:
- tinh_thanh_id
- page
- per_page

Response:
- dia_diem_id
- ten_dia_diem
- dia_chi
- kinh_do
- vi_do
- tinh_thanh_id

Status: 200, 500.


### 7.4.2 GET /dia-diem/{id}

Auth: Public

Response:
- dia_diem_id
- ten_dia_diem
- dia_chi
- kinh_do
- vi_do
- tinh_thanh_id

Status: 200, 404, 500.


### 7.4.3 GET /co-so-am-thuc

Auth: Public

Query:
- dia_diem_id
- page
- per_page

Response:
- co_so_id
- ten_co_so
- loai_hinh
- dia_chi
- so_dien_thoai
- dia_diem_id
- mo_ta
- hinh_anh

Status: 200, 500.


### 7.4.4 GET /co-so-am-thuc/{id}

Auth: Public

Response:
- co_so_id
- ten_co_so
- loai_hinh
- dia_chi
- so_dien_thoai
- dia_diem_id
- mo_ta
- hinh_anh

Status: 200, 404, 500.


## 7.5. Đánh giá

### 7.5.1 GET /mon-an/{id}/danh-gia

Auth: Public

Query:
- page
- per_page

Response:
- danh_gia_id
- nguoi_dung_id
- mon_an_id
- so_sao
- noi_dung
- ngay_danh_gia

Status: 200, 404, 500.


### 7.5.2 POST /mon-an/{id}/danh-gia

Auth: User

Request:
- so_sao
- noi_dung

nguoi_dung_id lấy từ thông tin xác thực, không nhận từ request body.

Status: 201, 401, 404, 422, 500.


### 7.5.3 GET /co-so-am-thuc/{id}/danh-gia

Auth: Public

Query:
- page
- per_page

Response:
- danh_gia_id
- nguoi_dung_id
- co_so_id
- so_sao
- noi_dung
- ngay_danh_gia

Status: 200, 404, 500.


### 7.5.4 POST /co-so-am-thuc/{id}/danh-gia

Auth: User

Request:
- so_sao
- noi_dung

nguoi_dung_id lấy từ thông tin xác thực.

Status: 201, 401, 404, 422, 500.


## 7.6. Bộ sưu tập

### 7.6.1 GET /bo-suu-tap

Auth: User

Query:
- page
- per_page

Response:
- bo_suu_tap_id
- nguoi_dung_id
- ten_bo_suu_tap
- mo_ta
- ngay_tao

Status: 200, 401, 500.


### 7.6.2 POST /bo-suu-tap

Auth: User

Request:
- ten_bo_suu_tap
- mo_ta

nguoi_dung_id lấy từ thông tin xác thực.

Status: 201, 401, 422, 500.


### 7.6.3 GET /bo-suu-tap/{id}

Auth: User

Chỉ chủ sở hữu được truy cập bộ sưu tập.

Response:
- thông tin bộ sưu tập
- danh sách món ăn

Status: 200, 401, 403, 404, 500.


### 7.6.4 POST /bo-suu-tap/{id}/mon-an

Auth: User

Request:
- mon_an_id

Status: 201, 401, 403, 404, 422, 500.


### 7.6.5 DELETE /bo-suu-tap/{id}/mon-an/{mon_an_id}

Auth: User

Chỉ chủ sở hữu được xóa món khỏi bộ sưu tập.

Status: 204, 401, 403, 404, 500.


## 7.7. Hành trình ẩm thực

### 7.7.1 GET /hanh-trinh-am-thuc

Auth: Public

Query:
- page
- per_page

Response:
- hanh_trinh_id
- ten_hanh_trinh
- mo_ta
- thoi_luong

Status: 200, 500.


### 7.7.2 GET /hanh-trinh-am-thuc/{id}

Auth: Public

Response:
- hanh_trinh_id
- ten_hanh_trinh
- mo_ta
- thoi_luong
- danh sách món ăn

Các món ăn được sắp xếp theo hanh_trinh_mon_an.thu_tu.

Status: 200, 404, 500.


## 7.8. Đóng góp dữ liệu

### 7.8.1 POST /dong-gop

Auth: User

Request:
- noi_dung

nguoi_dung_id lấy từ thông tin xác thực.

trang_thai khởi tạo là cho_duyet.

Status: 201, 401, 422, 500.


### 7.8.2 GET /dong-gop/me

Auth: User

Query:
- page
- per_page

Response:
- dong_gop_id
- nguoi_dung_id
- noi_dung
- trang_thai
- ngay_dong_gop

Status: 200, 401, 500.


## 7.9. Quản trị đóng góp

### 7.9.1 GET /admin/dong-gop

Auth: quan_tri_vien

Query:
- trang_thai
- page
- per_page

trang_thai:
- cho_duyet
- da_duyet
- tu_choi

Response:
- dong_gop_id
- nguoi_dung_id
- noi_dung
- trang_thai
- ngay_dong_gop

Status: 200, 401, 403, 500.


### 7.9.2 PATCH /admin/dong-gop/{id}

Auth: quan_tri_vien

Request:
- trang_thai

Giá trị hợp lệ:
- cho_duyet
- da_duyet
- tu_choi

Status: 200, 401, 403, 404, 422, 500.


## 8. Quy tắc kiểm thử API

Mỗi endpoint phải được đối chiếu với trường dữ liệu thực tế trong schema 3.0.

Không được khai báo API field không tồn tại trong DB nếu chưa có xác nhận thay đổi schema.

API danh sách phải hỗ trợ phân trang phía máy chủ.

UI phải xác định được endpoint tương ứng cho từng trang danh sách.


## 9. Vấn đề cần V2 xác nhận

### 9.1. Trường loai_mon

RQ-F-03 yêu cầu lọc theo loại món/ẩm thực.

Tuy nhiên bảng mon_an hiện chưa có trường loai_mon.

Cần V2 xác nhận hoặc bổ sung schema trước khi triển khai bộ lọc này.


### 9.2. Trường hinh_anh của món ăn

RQ-F-05 yêu cầu hiển thị hình ảnh món ăn.

Tuy nhiên bảng mon_an hiện chưa có trường hinh_anh.

Cần V2 xác nhận hoặc bổ sung schema.


## 10. Phạm vi chưa đưa vào API v0.1

Persona/User Journey có đề cập booking, payment, e-voucher và check-in.

Tuy nhiên schema hiện tại chưa có bảng dữ liệu tương ứng.

Do đó các chức năng này chưa được thiết kế endpoint trong API Contract v0.1.

