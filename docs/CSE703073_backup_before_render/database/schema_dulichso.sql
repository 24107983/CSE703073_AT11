

-- 1. Vùng miền
CREATE TABLE vung_mien (
    vung_mien_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_vung VARCHAR(100) NOT NULL UNIQUE,
    mo_ta TEXT
);

-- 2. Tỉnh/thành phố
CREATE TABLE tinh_thanh (
    tinh_thanh_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_tinh VARCHAR(100) NOT NULL,
    vung_mien_id INT NOT NULL,
    FOREIGN KEY (vung_mien_id) REFERENCES vung_mien(vung_mien_id)
);

-- 3. Địa điểm
CREATE TABLE dia_diem (
    dia_diem_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_dia_diem VARCHAR(255) NOT NULL,
    dia_chi VARCHAR(255),
    kinh_do DECIMAL(10,7),
    vi_do DECIMAL(10,7),
    tinh_thanh_id INT NOT NULL,
    FOREIGN KEY (tinh_thanh_id) REFERENCES tinh_thanh(tinh_thanh_id)
);

-- 4. Món ăn
CREATE TABLE mon_an (
    mon_an_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_mon VARCHAR(150) NOT NULL,
    mo_ta TEXT,
    gia_tham_khao DECIMAL(12,2),
    vung_mien_id INT NOT NULL,
    tinh_thanh_id INT NOT NULL,
    dia_diem_id INT,
    FOREIGN KEY (vung_mien_id) REFERENCES vung_mien(vung_mien_id),
    FOREIGN KEY (tinh_thanh_id) REFERENCES tinh_thanh(tinh_thanh_id),
    FOREIGN KEY (dia_diem_id) REFERENCES dia_diem(dia_diem_id)
);

-- 5. Nguyên liệu
CREATE TABLE nguyen_lieu (
    nguyen_lieu_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_nguyen_lieu VARCHAR(150) NOT NULL UNIQUE
);

-- 6. Mùa vụ
CREATE TABLE mua_vu (
    mua_vu_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_mua VARCHAR(100) NOT NULL,
    mo_ta TEXT
);

-- 7. Dịp lễ
CREATE TABLE dip_le (
    dip_le_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_dip_le VARCHAR(150) NOT NULL,
    thoi_gian VARCHAR(100),
    mo_ta TEXT
);

-- 8. Cơ sở ẩm thực
CREATE TABLE co_so_am_thuc (
    co_so_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_co_so VARCHAR(200) NOT NULL,
    dia_chi VARCHAR(255),
    so_dien_thoai VARCHAR(20),
    dia_diem_id INT NOT NULL,
    FOREIGN KEY (dia_diem_id) REFERENCES dia_diem(dia_diem_id)
);

-- 9. Câu chuyện văn hóa
CREATE TABLE cau_chuyen_van_hoa (
    cau_chuyen_id INT AUTO_INCREMENT PRIMARY KEY,
    tieu_de VARCHAR(255) NOT NULL,
    noi_dung TEXT NOT NULL,
    mon_an_id INT NOT NULL,
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id)
);

-- 10. Người dùng
CREATE TABLE nguoi_dung (
    nguoi_dung_id INT AUTO_INCREMENT PRIMARY KEY,
    ho_ten VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    mat_khau VARCHAR(255),
    vai_tro ENUM('khach_du_lich', 'cong_tac_vien', 'quan_tri_vien')
        DEFAULT 'khach_du_lich'
);

-- 11. Đánh giá
CREATE TABLE danh_gia (
    danh_gia_id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    mon_an_id INT,
    co_so_id INT,
    so_sao INT NOT NULL CHECK (so_sao BETWEEN 1 AND 5),
    noi_dung TEXT,
    ngay_danh_gia DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(nguoi_dung_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id),
    FOREIGN KEY (co_so_id) REFERENCES co_so_am_thuc(co_so_id),
    CHECK (mon_an_id IS NOT NULL OR co_so_id IS NOT NULL)
);

-- 12. Bộ sưu tập
CREATE TABLE bo_suu_tap (
    bo_suu_tap_id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    ten_bo_suu_tap VARCHAR(150) NOT NULL,
    mo_ta TEXT,
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(nguoi_dung_id)
);

-- 13. Hành trình ẩm thực
CREATE TABLE hanh_trinh_am_thuc (
    hanh_trinh_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_hanh_trinh VARCHAR(200) NOT NULL,
    mo_ta TEXT,
    thoi_luong VARCHAR(100)
);

-- 14. Dị ứng thực phẩm
CREATE TABLE di_ung_thuc_pham (
    di_ung_id INT AUTO_INCREMENT PRIMARY KEY,
    ten_chat_di_ung VARCHAR(150) NOT NULL UNIQUE,
    mo_ta TEXT
);

-- 15. Đóng góp dữ liệu
CREATE TABLE dong_gop_du_lieu (
    dong_gop_id INT AUTO_INCREMENT PRIMARY KEY,
    nguoi_dung_id INT NOT NULL,
    noi_dung TEXT NOT NULL,
    trang_thai ENUM('cho_duyet', 'da_duyet', 'tu_choi')
        DEFAULT 'cho_duyet',
    ngay_dong_gop DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(nguoi_dung_id)
);

-- 16. Món ăn – Nguyên liệu
CREATE TABLE mon_an_nguyen_lieu (
    mon_an_id INT NOT NULL,
    nguyen_lieu_id INT NOT NULL,
    so_luong VARCHAR(100),
    don_vi VARCHAR(50),
    PRIMARY KEY (mon_an_id, nguyen_lieu_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id),
    FOREIGN KEY (nguyen_lieu_id) REFERENCES nguyen_lieu(nguyen_lieu_id)
);

-- 17. Món ăn – Mùa vụ
CREATE TABLE mon_an_mua_vu (
    mon_an_id INT NOT NULL,
    mua_vu_id INT NOT NULL,
    ghi_chu VARCHAR(255),
    PRIMARY KEY (mon_an_id, mua_vu_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id),
    FOREIGN KEY (mua_vu_id) REFERENCES mua_vu(mua_vu_id)
);

-- 18. Món ăn – Dịp lễ
CREATE TABLE mon_an_dip_le (
    mon_an_id INT NOT NULL,
    dip_le_id INT NOT NULL,
    ghi_chu VARCHAR(255),
    PRIMARY KEY (mon_an_id, dip_le_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id),
    FOREIGN KEY (dip_le_id) REFERENCES dip_le(dip_le_id)
);

-- 19. Bộ sưu tập – Món ăn
CREATE TABLE bo_suu_tap_mon_an (
    bo_suu_tap_id INT NOT NULL,
    mon_an_id INT NOT NULL,
    ngay_them DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (bo_suu_tap_id, mon_an_id),
    FOREIGN KEY (bo_suu_tap_id) REFERENCES bo_suu_tap(bo_suu_tap_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id)
);

-- 20. Hành trình – Món ăn
CREATE TABLE hanh_trinh_mon_an (
    hanh_trinh_id INT NOT NULL,
    mon_an_id INT NOT NULL,
    thu_tu INT NOT NULL,
    ghi_chu VARCHAR(255),
    PRIMARY KEY (hanh_trinh_id, mon_an_id),
    FOREIGN KEY (hanh_trinh_id) REFERENCES hanh_trinh_am_thuc(hanh_trinh_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id)
);

-- 21. Món ăn – Dị ứng
CREATE TABLE mon_an_di_ung (
    mon_an_id INT NOT NULL,
    di_ung_id INT NOT NULL,
    ghi_chu VARCHAR(255),
    PRIMARY KEY (mon_an_id, di_ung_id),
    FOREIGN KEY (mon_an_id) REFERENCES mon_an(mon_an_id),
    FOREIGN KEY (di_ung_id) REFERENCES di_ung_thuc_pham(di_ung_id)
);

-- Chỉ mục hỗ trợ tìm kiếm
CREATE INDEX idx_mon_an_tinh_thanh
ON mon_an(tinh_thanh_id);

CREATE INDEX idx_mon_an_gia
ON mon_an(gia_tham_khao);

CREATE INDEX idx_dia_diem_tinh_thanh
ON dia_diem(tinh_thanh_id);

CREATE INDEX idx_co_so_dia_diem
ON co_so_am_thuc(dia_diem_id);