# THÔNG TIN HỆ THỐNG VÀ HƯỚNG DẪN TRIỂN KHAI (00\_INFO.md)

### 1\. Tên đề tài, mã đề tài, tên nhóm, lớp học phần

* **Tên đề tài:** Bản đồ số du lịch ẩm thực vùng miền
* **Mã đề tài:** ĐT-11
* **Tên nhóm:** Nhóm 11
* **Lớp học phần / Mã học phần:** Lập trình ứng dụng web trong du lịch 2 (CSE703073)

### 2\. Danh sách thành viên

|STT|Họ và tên|Mã số sinh viên|Vai trò|Địa chỉ thư điện tử|Tài khoản Git|
|:-:|-|:-:|-|-|-|
|1|Nguyễn Thị Linh|24107983|V1/V6 – Trưởng nhóm, quản trị Git, triển khai và tài liệu|24107983@st.phenikaa-uni.edu.vn|24107983|
|2|Nguyễn Trần Diệu Linh|24108446|V2 – Quản lý Dữ liệu|24108446@st.phenikaa-uni.edu.vn|dieulinhne206|
|3|Nguyễn Linh Chi|24107973|V3 – Server / Backend|24107973@st.phenikaa-uni.edu.vn|linhchin653|
|4|Đào Thị Ngọc Linh|24103345|V4 – Frontend|24103345@st.phenikaa-uni.edu.vn|ngoclinhnc2006|
|5|Nguyễn Huy Hoàng|24101435|V5 – Kiểm thử \& Triển khai|24101435@st.phenikaa-uni.edu.vn|hn208514|

### 3\. Liên kết kho mã nguồn Git và tên thẻ phát hành

* **Kho mã nguồn Git (Repository):** https://github.com/24107983/CSE703073_AT11
* **Tên thẻ phát hành (Release Tag):** `v1.0.0`

### 4\. Địa chỉ website đã triển khai và ghi chú vận hành

* **Địa chỉ Website (Production):** [https://cse703073-at11.onrender.com/]
* **Ghi chú vận hành:**

  * Hệ thống được triển khai trên nền tảng Render (Free Tier).
  * *Chế độ ngủ đông (Sleep Mode):* Dịch vụ sẽ tự động chuyển sang trạng thái ngủ đông sau 15 phút không có lượt truy cập. Khi truy cập lại lần đầu, thời gian phản hồi có thể mất từ **30 đến 50 giây** để máy chủ khởi động lại.

### 5\. Liên kết video minh chứng

* **Video Demo sản phẩm:** https://drive.google.com/drive/folders/1j3QBsKx-rXIq\_ASSbxvPSRb9L0NLatj2?usp=sharing ( trong file gg drive; Thời lượng: 10 phút, bao gồm tổng quan, demo tính năng và kiểm thử).

### 6\. Bảng tài khoản kiểm thử theo từng vai trò

|Vai trò|Tên đăng nhập (Email)|Mật khẩu|Quyền hạn / Mô tả|
|-|-|-|-|
|**Quản trị viên (Admin)**|admin@dulichso.vn<br />|admin@12345678ad|Sử dụng các chức năng dành cho<br />khách đã đăng nhập như quản lý<br />hồ sơ, lưu món ăn yêu thích, lưu<br />hành trình, đặt chỗ và thanh toán.|
|**Cộng tác viên**|ctv@test.com|123456|Sử dụng các chức năng dành cho<br />khách đã đăng nhập như quản lý<br />hồ sơ, lưu món ăn yêu thích, lưu<br />hành trình, đặt chỗ và thanh toán|
|**Khách du lịch (Customer)**|guest@test.com|Ctv@123456|Xem thông tin món ăn, bản<br />đồ và hành trình du lịch ẩm thực;<br />chưa có quyền sử dụng các chức<br />năng cá nhân cần đăng nhập.|

### 7\. Ngăn xếp công nghệ và yêu cầu môi trường chạy

* **Ngăn xếp công nghệ (Tech Stack):**

  * *Frontend:* Vue 3, Vite, Tailwind CSS, Bootstrap 5, Leaflet.js
  * *Backend:* PHP 8.3, Laravel 11 (RESTful API)
  * *AI \& Data Service:* Python 3.11, FastAPI, pandas, scikit-learn
  * *Database:* MySQL 8.0 (Hỗ trợ truy vấn không gian / Haversine)
  * *Container:* Docker \& Docker Compose
* **Yêu cầu môi trường chạy:** PHP >= 8.3, Node.js >= 18.x, Python >= 3.11, MySQL Server >= 8.0.

### 8\. Hướng dẫn cài đặt cục bộ (Dưới 10 bước)

1. **Bước 1:** Clone mã nguồn từ GitHub về máy cục bộ: `git clone https://github.com/24107983/CSE703073\\\\\\\_AT11` và `cd AT-11`
2. **Bước 2:** Cài đặt thư viện Backend (Laravel): di chuyển vào thư mục `backend` và chạy `composer install`
3. **Bước 3:** Cấu hình tệp môi trường: sao chép `.env.example` thành `.env` và chạy `php artisan key:generate`
4. **Bước 4:** Tạo cơ sở dữ liệu MySQL mới (tên `culinary\\\\\\\_map\\\\\\\_db`) và cấu hình thông tin kết nối trong tệp `.env`.
5. **Bước 5:** Thực thi Migration và Seed dữ liệu mẫu: chạy lệnh `php artisan migrate --seed`
6. **Bước 6:** Khởi động máy chủ Backend: chạy lệnh `php artisan serve`
7. **Bước 7:** Cài đặt và khởi động Python FastAPI service: chuyển sang thư mục `python-service`, cài gói `pip install -r requirements.txt`, sau đó chạy `uvicorn main:app --reload --port 8001`
8. **Bước 8:** Cài đặt và khởi động Frontend: chuyển sang thư mục `frontend`, chạy `npm install` và `npm run dev`
9. **Bước 9:** Truy cập trình duyệt tại `http://localhost:5173` và sử dụng tài khoản kiểm thử tại Mục 6.

### 9\. Danh mục chức năng đã hoàn thành và chưa hoàn thành

* **Chức năng đã hoàn thành:**

  1. Xây dựng bản thể luận dữ liệu ẩm thực vùng miền với 10 thực thể chuẩn hóa 3NF.
  2. Tích hợp bản đồ số tương tác (Leaflet.js) và tính toán khoảng cách không gian Haversine.
  3. Xây dựng hệ thống gợi ý ẩm thực thông minh kết hợp Python/FastAPI.
  4. Quản lý quy trình đặt bàn trực tuyến và xử lý giữ chỗ đồng thời (Booking Hold) bằng Laravel Transaction.
  5. Phân quyền người dùng (Admin, Vendor, Customer) và bảo mật theo chuẩn OWASP Top 10.
* **Chức năng chưa hoàn thành (Khai báo trung thực):**

  1. *Thanh toán trực tuyến tự động qua cổng VNPay/Momo:* Mới xây dựng giao diện giả lập (Mock Payment) và ghi nhận trạng thái thủ công xác nhận bởi Admin/Vendor do giới hạn tích hợp API Sandbox ngân hàng.
  2. *Hệ thống thông báo thời gian thực (Real-time Notification) qua WebSockets (Laravel Reverb):* Hiện tại hệ thống sử dụng cơ chế thông báo lưu database và tải lại trang (Polling).

### 10\. Danh mục thư viện và mã nguồn bên thứ ba kèm giấy phép

|Tên thư viện / Công cụ|Phiên bản|Mục đích sử dụng|Giấy phép (License)|
|-|:-:|-|-|
|**Laravel Framework**|v11.x|Khung phát triển Backend \& RESTful API|MIT License|
|**Vue.js**|v3.x|Phát triển giao diện người dùng SPA|MIT License|
|**Tailwind CSS / Bootstrap**|v3.4 / 5.x|Thiết kế giao diện và hệ thống bố cục|MIT License|
|**Leaflet.js**|v1.9|Hiển thị và tương tác bản đồ số|BSD 2-Clause|
|**FastAPI**|v0.110|Dịch vụ AI và xử lý làm sạch dữ liệu|MIT License|
|**MySQL Database**|v8.0|Lưu trữ cơ sở dữ liệu quan hệ|GPLv2 / Commercial|



