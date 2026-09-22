# DANH MỤC YÊU CẦU PHI CHỨC NĂNG — BUỔI 2

## 1. Hiệu năng

### NFR-01 — Thời gian phản hồi
- **Yêu cầu:** Các thao tác tra cứu dữ liệu du lịch phổ biến phải có thời gian phản hồi không quá **2 giây** trong điều kiện kiểm thử thông thường.
- **Phạm vi:** API tra cứu danh sách món ăn/địa điểm và tìm kiếm dữ liệu.
- **Cách kiểm chứng:** Gửi tối thiểu 30 request liên tiếp đến API và ghi nhận thời gian phản hồi; yêu cầu đạt nếu thời gian phản hồi của ít nhất 95% request không vượt quá 2 giây.
## 2. An toàn và bảo mật

### NFR-02 — Kiểm soát truy cập
- **Yêu cầu:** Các chức năng quản trị dữ liệu phải yêu cầu người dùng đăng nhập và được phân quyền đúng vai trò; người dùng không có quyền không được truy cập chức năng quản trị.
- **Phạm vi:** Các API/chức năng quản trị dữ liệu du lịch.
- **Cách kiểm chứng:** Dùng tài khoản không có quyền quản trị để gọi trực tiếp API quản trị; yêu cầu hệ thống từ chối truy cập với mã HTTP **403** và không trả về dữ liệu quản trị.
## 3. Khả năng mở rộng

### NFR-03 — Khả năng đáp ứng khi dữ liệu tăng
- **Yêu cầu:** Hệ thống phải duy trì khả năng tra cứu dữ liệu khi số lượng bản ghi du lịch tăng lên, không phụ thuộc vào việc dữ liệu chỉ ở quy mô nhỏ.
- **Phạm vi:** API danh sách, tìm kiếm và lọc dữ liệu du lịch.
- **Cách kiểm chứng:** Thực hiện kiểm thử với bộ dữ liệu tối thiểu **300 bản ghi du lịch**; kiểm tra các API danh sách, tìm kiếm và lọc vẫn trả về kết quả chính xác và không phát sinh lỗi.