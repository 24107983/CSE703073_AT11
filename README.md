# Bản Đồ Số Du Lịch Ẩm Thực Vùng Miền (CSE703073)

Hệ thống web bản đồ số tương tác hỗ trợ tra cứu, khám phá và trải nghiệm du lịch ẩm thực vùng miền Việt Nam. Dự án được phát triển trong khuôn khổ môn học **CSE703073: Lập trình ứng dụng web trong du lịch 2**.

---

## 📌 Tính năng chính

- **Bản đồ tương tác (Interactive Map):** Trực quan hóa địa điểm ẩm thực, món ăn đặc sản theo vùng miền/tỉnh thành.
- **Quản lý & Tra cứu Món ăn:** Tìm kiếm, lọc món ăn theo danh mục, địa phương và trải nghiệm văn hóa.
- **Đánh giá & Lưu bài viết:** Cho phép người dùng lưu địa điểm yêu thích (profile bookmarks) và nhận thông tin khuyến mãi.
- **Tích hợp dịch vụ API:** Kết nối mượt mà giữa Frontend Vue.js và Backend API service trên Render.

---

## 🏗 Kiến trúc Hệ thống & Công nghệ

Dự án được tổ chức theo kiến trúc tách biệt Frontend & Backend (Decoupled Architecture):

### Công nghệ sử dụng
- **Frontend:** Vue.js 3, Vite, Pinia, Vue Router, Tailwind CSS / Leaflet Map.
- **Backend:** Laravel / Python Web Service (RESTful API), MySQL Database (Chuẩn hóa 3NF).
- **Deployment:** Render Platform & GitHub Actions.

### Cấu trúc thư mục dự án
```text
CSE703073/
├── backend/          # Mã nguồn Laravel API & Cấu hình Database
├── frontend/         # Mã nguồn Vue.js Single Page Application
├── docs/             # Tài liệu báo cáo, kiểm thử & nhật ký các buổi học (buoi01 - buoi08)
├── data/             # Dữ liệu mẫu (data.xlsx) & SQL scripts
└── README.md         # Tài liệu hướng dẫn dự án

```

---

## 🛠 Hướng dẫn Cài đặt & Chạy Local

### Yêu cầu tiên quyết

* **Node.js:** v18.x trở lên
* **PHP:** >= 8.1 & **Composer**
* **MySQL / MariaDB**

### 1. Cài đặt Backend

```powershell
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve

```

*Backend API sẽ chạy tại:* `http://127.0.0.1:8000`

### 2. Cài đặt Frontend

```powershell
cd ../frontend
npm install
npm run dev

```

*Frontend ứng dụng sẽ chạy tại:* `http://localhost:5173`

---

## 👥 Thành viên Thực hiện (Nhóm 11)

| STT | Họ và tên | Vai trò | Lớp / Khóa |
| --- | --- | --- | --- |
| 1 | **Nguyễn Thị Linh** | Trưởng nhóm, quản trị Git, triển khai và tài liệu | Kinh doanh du lịch số - K18 |
| 2 | **Nguyễn Trần Diệu Linh** | V2 – Quản lý Dữ liệu | Kinh doanh du lịch số - K18 |
| 3 | **Nguyễn Linh Chi** | Backend | Kinh doanh du lịch số - K18 |
| 4 | **Đào Thị Ngọc Linh** | Frontend Developer | Kinh doanh du lịch số - K18 |
| 5 | **Nguyễn Huy Hoàng** | Kiểm thử \& Triển khai | Kinh doanh du lịch số - K18 |

---

## 📄 Tài liệu liên quan

Tất cả báo cáo kiểm thử, API Contract và nhật ký tiến độ các buổi học được lưu trữ đầy đủ tại thư mục [`/docs`](https://www.google.com/search?q=./docs).

```

---

### **Các bước thực hiện trên PowerShell để đẩy README mới lên GitHub:**

1. Mở file `README.md` trong VS Code, dán nội dung trên vào và lưu lại (`Ctrl + S`).
2. Mở PowerShell và chạy 3 lệnh đơn giản sau:

```powershell
git add README.md
git commit -m "docs: cap nhat noi dung README.md chuan cho du an"
git push origin main

```
