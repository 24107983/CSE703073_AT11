\# V3 – BÀN GIAO API CHO V4



\## 1. Thông tin chung



- Dự án: ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền

- Vai trò: V3 – Phát triển máy chủ

- Tài liệu nguồn: API Contract v0.1

- Mục đích: Bàn giao mapping giữa giao diện V4 và API để V4 phát triển giao diện song song với máy chủ.



\## 2. Quy ước



- Base URL: `/api`

- Dữ liệu trao đổi: JSON

- API danh sách sử dụng phân trang `page`, `per_page`.

- `per_page` mặc định: 10.

- `per_page` tối đa: 100.

- Public: không yêu cầu đăng nhập.

- User: yêu cầu người dùng đăng nhập.

- Admin: yêu cầu vai trò `quan_tri_vien`.



\## 3. Mapping UI – API



| Trang UI | API | Method | Auth | Dữ liệu cần hiển thị |

|---|---|---|---|---|
| Đăng ký | `/auth/register` | POST | Public | Họ tên, email, mật khẩu |
| Đăng nhập | `/auth/login` | POST | Public | Email, mật khẩu; token sau khi đăng nhập |
| Đăng xuất | `/auth/logout` | POST | User | Trạng thái đăng xuất |
| Danh sách vùng miền | `/vung-mien` | GET | Public | Tên vùng, mô tả; phân trang |
| Chi tiết vùng miền | `/vung-mien/{id}` | GET | Public | Tên vùng, mô tả |
| Danh sách tỉnh thành | `/tinh-thanh` | GET | Public | Tên tỉnh, vùng miền; phân trang |
| Chi tiết tỉnh thành | `/tinh-thanh/{id}` | GET | Public | Tên tỉnh, vùng miền |
| Danh sách món ăn / tìm kiếm / lọc | `/mon-an` | GET | Public | Tên món, mô tả, giá tham khảo, vùng miền, tỉnh thành, địa điểm; hỗ trợ keyword, vùng miền, tỉnh thành, loại món và phân trang |
| Chi tiết món ăn | `/mon-an/{id}` | GET | Public | Tên món, mô tả, giá tham khảo, vùng miền, tỉnh thành, địa điểm |
| Nguyên liệu món ăn | `/mon-an/{id}/nguyen-lieu` | GET | Public | Tên nguyên liệu, mô tả, số lượng, đơn vị |
| Mùa vụ món ăn | `/mon-an/{id}/mua-vu` | GET | Public | Tên mùa, mô tả, ghi chú |
| Dịp lễ của món ăn | `/mon-an/{id}/dip-le` | GET | Public | Tên dịp lễ, thời gian, mô tả, ghi chú |
| Thông tin dị ứng | `/mon-an/{id}/di-ung` | GET | Public | Tên chất dị ứng, mô tả, ghi chú |
| Câu chuyện văn hóa | `/mon-an/{id}/cau-chuyen` | GET | Public | Tiêu đề, nội dung, nguồn gốc, giá trị văn hóa |

| Bản đồ / danh sách địa điểm | `/dia-diem` | GET | Public | Tên địa điểm, địa chỉ, kinh độ, vĩ độ, tỉnh thành; hỗ trợ lọc tỉnh thành và phân trang |
| Chi tiết địa điểm | `/dia-diem/{id}` | GET | Public | Tên địa điểm, địa chỉ, kinh độ, vĩ độ, tỉnh thành |
| Danh sách cơ sở ẩm thực | `/co-so-am-thuc` | GET | Public | Tên cơ sở, loại hình, địa chỉ, số điện thoại, địa điểm, mô tả, hình ảnh; phân trang |
| Chi tiết cơ sở ẩm thực | `/co-so-am-thuc/{id}` | GET | Public | Tên cơ sở, loại hình, địa chỉ, số điện thoại, địa điểm, mô tả, hình ảnh |

| Danh sách đánh giá món ăn | `/mon-an/{id}/danh-gia` | GET | Public | Người đánh giá, số sao, nội dung, ngày đánh giá; phân trang |
| Gửi đánh giá món ăn | `/mon-an/{id}/danh-gia` | POST | User | Số sao, nội dung đánh giá |
| Danh sách đánh giá cơ sở | `/co-so-am-thuc/{id}/danh-gia` | GET | Public | Người đánh giá, số sao, nội dung, ngày đánh giá; phân trang |
| Gửi đánh giá cơ sở | `/co-so-am-thuc/{id}/danh-gia` | POST | User | Số sao, nội dung đánh giá |

| Danh sách bộ sưu tập | `/bo-suu-tap` | GET | User | Tên bộ sưu tập, mô tả, ngày tạo; phân trang |
| Tạo bộ sưu tập | `/bo-suu-tap` | POST | User | Tên bộ sưu tập, mô tả |
| Chi tiết bộ sưu tập | `/bo-suu-tap/{id}` | GET | User | Tên bộ sưu tập, mô tả, ngày tạo, danh sách món ăn |
| Thêm món vào bộ sưu tập | `/bo-suu-tap/{id}/mon-an` | POST | User | Mã món ăn cần thêm |
| Xóa món khỏi bộ sưu tập | `/bo-suu-tap/{id}/mon-an/{mon_an_id}` | DELETE | User | Mã bộ sưu tập, mã món ăn |

| Danh sách hành trình ẩm thực | `/hanh-trinh-am-thuc` | GET | Public | Tên hành trình, mô tả, thời lượng; phân trang |
| Chi tiết hành trình ẩm thực | `/hanh-trinh-am-thuc/{id}` | GET | Public | Tên hành trình, mô tả, thời lượng, danh sách món ăn theo thứ tự |
| Gửi đóng góp dữ liệu | `/dong-gop` | POST | User | Nội dung đóng góp |
| Đóng góp của tôi | `/dong-gop/me` | GET | User | Nội dung, trạng thái, ngày đóng góp; phân trang |
| Danh sách đóng góp quản trị | `/admin/dong-gop` | GET | Admin | Người đóng góp, nội dung, trạng thái, ngày đóng góp; lọc trạng thái và phân trang |
| Duyệt / từ chối đóng góp | `/admin/dong-gop/{id}` | PATCH | Admin | Trạng thái: `cho_duyet`, `da_duyet`, `tu_choi` |
## 4. Quy tắc phối hợp V3 – V4

1. V4 sử dụng đúng endpoint, method và trường dữ liệu trong API Contract v0.1.
2. API danh sách phải truyền `page` và `per_page` khi cần phân trang.
3. Không tự đặt tên endpoint hoặc field khác với API Contract.
4. Với API có Auth `User`, V4 cần gửi thông tin xác thực theo cơ chế đăng nhập của hệ thống.
5. Với API có Auth `Admin`, chỉ hiển thị chức năng quản trị cho người dùng có vai trò `quan_tri_vien`.
6. V4 không tự giả định các field chưa có trong API Contract.
7. Hai vấn đề schema cần lưu ý:
   - `mon_an.loai_mon` chưa có trong schema hiện tại nhưng RQ-F-03 yêu cầu lọc loại món.
   - `mon_an.hinh_anh` chưa có trong schema hiện tại nhưng RQ-F-05 yêu cầu hình ảnh món ăn.
8. Hai vấn đề trên cần V2 xác nhận trước khi triển khai chính thức.

## 5. Tài liệu tham chiếu

- `docs/API_CONTRACT_V0.1.md`
- Schema dữ liệu 3.0
- Danh mục yêu cầu chức năng và phi chức năng
