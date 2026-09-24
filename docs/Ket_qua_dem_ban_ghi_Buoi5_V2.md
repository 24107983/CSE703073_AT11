# KẾT QUẢ ĐẾM BẢN GHI – BUỔI 5

## 1. Thông tin

- Đề tài: ĐT-11 – Bản đồ số du lịch ẩm thực vùng miền
- Vai trò: V2 – Kiến trúc sư dữ liệu
- Buổi: 5
- Cơ sở dữ liệu: `am_thuc_vung_mien`

---

## 2. Mục đích

Kiểm tra dữ liệu mẫu đã được nạp vào cơ sở dữ liệu và xác nhận số lượng bản ghi hiện có.

Kết quả được sử dụng để đối chiếu với yêu cầu dữ liệu tối thiểu của Buổi 5.

---

## 3. Kết quả kiểm tra

### 3.1. Tổng số bản ghi

Kết quả truy vấn trực tiếp trên cơ sở dữ liệu:

**Tổng số bản ghi: 1.024**

Mức yêu cầu tối thiểu: **100 bản ghi**

Kết luận: **ĐẠT**

---

### 3.2. Kiểm tra hiển thị tiếng Việt

Đã kiểm tra dữ liệu trong bảng `mon_an` bằng MySQL với bộ mã `utf8mb4`.

Một số dữ liệu hiển thị đúng tiếng Việt:

- Phở bò
- Bún chả
- Bánh cuốn
- Chả cá
- Bún cá
- Cơm cháy
- Thắng cố
- Bánh mì cay
- Bún bò Huế
- Cơm hến

Kết luận: **Dữ liệu tiếng Việt hiển thị đúng sau khi sử dụng kết nối UTF-8.**

---

## 4. Cơ sở thực hiện kiểm tra

Database được kiểm tra:

`am_thuc_vung_mien`

Database hiện có các bảng dữ liệu của hệ thống và đã có dữ liệu mẫu.

Kết quả đếm được trực tiếp bằng câu lệnh SQL:

```sql
SELECT SUM(so_ban_ghi) AS tong_so_ban_ghi
FROM (
    SELECT COUNT(*) AS so_ban_ghi
    FROM am_thuc_vung_mien.vung_mien

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.tinh_thanh

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.dia_diem

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mon_an

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.nguyen_lieu

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mua_vu

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.dip_le

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.co_so_am_thuc

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.cau_chuyen_van_hoa

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.nguoi_dung

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.danh_gia

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.bo_suu_tap

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.bo_suu_tap_mon_an

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.hanh_trinh_am_thuc

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.hanh_trinh_mon_an

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.di_ung_thuc_pham

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mon_an_di_ung

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mon_an_nguyen_lieu

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mon_an_mua_vu

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.mon_an_dip_le

    UNION ALL
    SELECT COUNT(*)
    FROM am_thuc_vung_mien.dong_gop_du_lieu
) AS tong;
```

### Kết quả thực tế

```text
+-----------------+
| tong_so_ban_ghi |
+-----------------+
|            1024 |
+-----------------+
```

---

## 5. Kết luận

Cơ sở dữ liệu `am_thuc_vung_mien` hiện có **1.024 bản ghi**, vượt mức tối thiểu **100 bản ghi**.

Dữ liệu tiếng Việt đã được kiểm tra và hiển thị đúng khi sử dụng kết nối `utf8mb4`.

Kết quả kiểm tra đáp ứng đầu ra cá nhân của V2 trong Buổi 5:

**Kết quả đếm bản ghi.**