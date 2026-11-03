# Từ điển dữ liệu Buổi 6 – V2

## 1. Thông tin chung

- Dự án: **Bản đồ số du lịch ẩm thực vùng miền**
- Buổi: **Buổi 6 – M2: Tìm kiếm, lọc, đặt chỗ và giữ chỗ có thời hạn**
- Vai trò: **V2 – Kiến trúc sư dữ liệu**
- Mục đích: cập nhật từ điển dữ liệu và mô tả các thực thể chính phục vụ dữ liệu du lịch.

Từ điển được xây dựng dựa trên schema của project và đối chiếu với cấu trúc cơ sở dữ liệu hiện tại.

## 2. Các bảng dữ liệu chính

### 2.1. `vung_mien`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `vung_mien_id` | INT | Khóa chính của vùng miền |
| `ten_vung` | VARCHAR(100) | Tên vùng miền |
| `mo_ta` | TEXT | Mô tả vùng miền |

### 2.2. `tinh_thanh`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `tinh_thanh_id` | INT | Khóa chính của tỉnh/thành |
| `ten_tinh` | VARCHAR(100) | Tên tỉnh/thành phố |
| `vung_mien_id` | INT | Khóa ngoại đến `vung_mien` |

### 2.3. `dia_diem`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `dia_diem_id` | INT | Khóa chính của địa điểm |
| `ten_dia_diem` | VARCHAR(255) | Tên địa điểm |
| `dia_chi` | VARCHAR(255) | Địa chỉ |
| `kinh_do` | DECIMAL(10,7) | Kinh độ |
| `vi_do` | DECIMAL(10,7) | Vĩ độ |
| `tinh_thanh_id` | INT | Khóa ngoại đến `tinh_thanh` |

### 2.4. `mon_an`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `mon_an_id` | INT | Khóa chính của món ăn |
| `ten_mon` | VARCHAR(150) | Tên món ăn |
| `mo_ta` | TEXT | Mô tả món ăn |
| `gia_tham_khao` | DECIMAL(12,2) | Giá tham khảo |
| `vung_mien_id` | INT | Khóa ngoại đến `vung_mien` |
| `tinh_thanh_id` | INT | Khóa ngoại đến `tinh_thanh` |
| `dia_diem_id` | INT | Khóa ngoại đến `dia_diem` |

### 2.5. `nguyen_lieu`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `nguyen_lieu_id` | INT | Khóa chính của nguyên liệu |
| `ten_nguyen_lieu` | VARCHAR(150) | Tên nguyên liệu |

### 2.6. `mua_vu`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `mua_vu_id` | INT | Khóa chính của mùa vụ |
| `ten_mua` | VARCHAR(100) | Tên mùa |
| `mo_ta` | TEXT | Mô tả mùa vụ |

### 2.7. `dip_le`

| Trường | Kiểu dữ liệu | Ý nghĩa |
|---|---|---|
| `dip_le_id` | INT | Khóa chính của dịp lễ |
| `ten_dip_le` | VARCHAR(150) | Tên dịp lễ |
| `thoi_gian` | VARCHAR(100) | Thời gian diễn ra |
| `mo_ta` | TEXT | Mô tả dịp lễ |

### 2.8. `co_so_am_thuc`

Cấu trúc dưới đây là cấu trúc đang được sử dụng trong cơ sở dữ liệu hiện tại của project.

| Trường | Ý nghĩa |
|---|---|
| `co_so_id` | Khóa chính của cơ sở ẩm thực |
| `ten_co_so` | Tên cơ sở |
| `loai_hinh` | Loại hình cơ sở, ví dụ quán ăn/nhà hàng/cửa hàng đặc sản |
| `dia_chi` | Địa chỉ cơ sở |
| `so_dien_thoai` | Số điện thoại |
| `dia_diem_id` | Khóa ngoại đến `dia_diem` |
| `mo_ta` | Mô tả cơ sở |
| `hinh_anh` | Hình ảnh của cơ sở |

## 3. Quan hệ dữ liệu chính

- `vung_mien` 1 – N `tinh_thanh`
- `tinh_thanh` 1 – N `dia_diem`
- `vung_mien` 1 – N `mon_an`
- `tinh_thanh` 1 – N `mon_an`
- `dia_diem` 1 – N `mon_an`
- `dia_diem` 1 – N `co_so_am_thuc`
- `mon_an` 1 – N `cau_chuyen_van_hoa`
- `mon_an` N – N `nguyen_lieu` thông qua `mon_an_nguyen_lieu`
- `mon_an` N – N `mua_vu` thông qua `mon_an_mua_vu`
- `mon_an` N – N `dip_le` thông qua `mon_an_dip_le`
- `mon_an` N – N `di_ung_thuc_pham` thông qua `mon_an_di_ung`

## 4. Kết quả khối lượng dữ liệu Buổi 6

| Bảng | Số bản ghi |
|---|---:|
| `mon_an` | 100 |
| `dia_diem` | 100 |
| `co_so_am_thuc` | 100 |
| **Tổng** | **300** |

Kết quả được kiểm tra trực tiếp bằng `COUNT(*)` trên cơ sở dữ liệu.

## 5. Ghi chú

- Từ điển trên tập trung vào các thực thể chính phục vụ dữ liệu du lịch và chức năng tìm kiếm/lọc.
- Kiểu dữ liệu của các bảng nền được đối chiếu từ schema của project.
- `co_so_am_thuc` được mô tả theo cấu trúc đang có trong database hiện tại, gồm thêm các trường `loai_hinh`, `mo_ta`, `hinh_anh`.
- Không tính các bảng quan hệ, tài khoản người dùng, đánh giá hoặc các bảng hệ thống vào tổng 300 trong phạm vi kiểm tra này.
