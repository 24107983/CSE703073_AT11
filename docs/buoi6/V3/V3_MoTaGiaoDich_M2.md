# V3 – MÔ TẢ GIAO DỊCH VÀ XỬ LÝ TRANH CHẤP – MỐC M2

## 1. Phạm vi thực hiện

V3 – Phát triển máy chủ thực hiện các chức năng phía máy chủ trong Mốc M2:

- Tìm kiếm món ăn.
- Lọc theo nhiều tiêu chí.
- Phân trang và sắp xếp.
- Kiểm tra số chỗ còn khả dụng.
- Giữ chỗ có thời hạn.
- Xử lý tranh chấp khi nhiều phiên cùng đặt chỗ.
- Ghi nhận lịch sử trạng thái đặt chỗ.

## 2. Luồng tìm kiếm và lọc

API danh sách món ăn xử lý các tham số:

- `q`: tìm kiếm theo tên món.
- `vung_mien_id`: lọc theo vùng miền.
- `tinh_thanh_id`: lọc theo tỉnh thành.
- `dia_diem_id`: lọc theo địa điểm.
- `gia_min`: giá tối thiểu.
- `gia_max`: giá tối đa.
- `sort_by`: trường sắp xếp.
- `sort_order`: tăng hoặc giảm.
- `per_page`: số bản ghi trên mỗi trang.

Dữ liệu được lọc và phân trang tại phía máy chủ bằng Laravel Query Builder/Eloquent.

## 3. Luồng giữ chỗ

Khi người dùng yêu cầu giữ chỗ:

1. Kiểm tra người dùng đã đăng nhập.
2. Kiểm tra `lich_kha_dung_id` tồn tại.
3. Kiểm tra số khách hợp lệ.
4. Bắt đầu transaction.
5. Khóa bản ghi lịch khả dụng bằng `lockForUpdate()`.
6. Tính số chỗ còn lại:

   `so_cho_con_lai = so_cho_total - so_cho_held - so_cho_sold`

7. Nếu số chỗ còn lại không đủ:
   - Từ chối yêu cầu.
   - Transaction không tạo đặt chỗ.

8. Nếu đủ chỗ:
   - Tạo bản ghi `dat_cho`.
   - Trạng thái ban đầu: `pending_payment`.
   - Thời gian giữ chỗ: 15 phút.
   - Tăng `so_cho_held`.
   - Ghi lịch sử chuyển trạng thái.
9. Commit transaction.

## 4. Xử lý tranh chấp tồn kho

Bản ghi lịch khả dụng được khóa trong transaction bằng:

`lockForUpdate()`

Do đó, các yêu cầu cập nhật cùng một lịch khả dụng được xử lý tuần tự.

Sau khi phiên thứ nhất giữ chỗ cuối cùng, phiên tiếp theo kiểm tra lại số chỗ sau khi nhận khóa.

Nếu không còn chỗ:

`so_cho_con_lai <= 0`

hệ thống trả về:

`Không đủ chỗ trống.`

và không tạo thêm đặt chỗ.

## 5. Cơ chế giữ chỗ có thời hạn

Mỗi đặt chỗ ở trạng thái `pending_payment` được gán:

`het_han_giu = thời điểm hiện tại + 15 phút`

Khi quá thời hạn, đặt chỗ được chuyển sang:

`expired`

Đồng thời:

- Giảm `so_cho_held`.
- Trả chỗ về số chỗ khả dụng.
- Ghi lịch sử `pending_payment → expired`.

Command xử lý hết hạn:

`php artisan dat-cho:expire`

## 6. Các bảng sử dụng

### lich_kha_dung_hanh_trinh

Lưu số chỗ của từng lịch phục vụ:

- `so_cho_total`
- `so_cho_held`
- `so_cho_sold`

### dat_cho

Lưu thông tin đặt chỗ:

- mã đặt chỗ
- người dùng
- lịch khả dụng
- số khách
- đơn giá
- tổng tiền
- trạng thái
- thời gian hết hạn giữ chỗ

### dat_cho_lich_su

Lưu lịch sử thay đổi trạng thái của đặt chỗ.

## 7. Kết quả kiểm thử

### 7.1. Giữ chỗ

Đã kiểm tra giữ chỗ thành công.

Kết quả:

- Tạo được đặt chỗ.
- Trạng thái `pending_payment`.
- `so_cho_held` tăng đúng số khách.
- Có bản ghi lịch sử.

### 7.2. Hết hạn giữ chỗ

Đã kiểm tra command:

`php artisan dat-cho:expire`

Kết quả:

- Đặt chỗ chuyển sang `expired`.
- `so_cho_held` được giảm.
- Chỗ được trả lại.
- Lịch sử `pending_payment → expired` được ghi nhận.

### 7.3. Tranh chấp chỗ cuối

Thiết lập lịch chỉ còn 1 chỗ.

- Phiên 1 giữ 1 chỗ → thành công.
- Phiên 2 tiếp tục yêu cầu 1 chỗ → bị từ chối.
- Không phát sinh đặt chỗ thứ hai.
- Số chỗ còn lại bằng 0.

## 8. Mã nguồn bàn giao

Branch:

`feature/v3-server`

Commit:

`1ede2b4`

Các thành phần chính:

- `app/Http/Controllers/DatChoController.php`
- `app/Services/DatChoService.php`
- `app/Models/DatCho.php`
- `app/Models/DatChoLichSu.php`
- `app/Models/LichKhaDungHanhTrinh.php`
- `routes/api.php`
- `routes/console.php`

## 9. Kết luận

V3 đã hoàn thành phần phát triển máy chủ cho Mốc M2 gồm tìm kiếm, lọc, phân trang, sắp xếp, đặt chỗ, giữ chỗ có thời hạn và xử lý tranh chấp tồn kho bằng transaction và khóa hàng.
