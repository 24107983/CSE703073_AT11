CREATE TABLE IF NOT EXISTS lich_kha_dung_hanh_trinh (
    lich_kha_dung_id INT AUTO_INCREMENT PRIMARY KEY,
    hanh_trinh_id INT NOT NULL,
    ngay_phuc_vu DATE NOT NULL,
    so_cho_total INT NOT NULL DEFAULT 0 CHECK (so_cho_total >= 0),
    so_cho_held INT NOT NULL DEFAULT 0 CHECK (so_cho_held >= 0),
    so_cho_sold INT NOT NULL DEFAULT 0 CHECK (so_cho_sold >= 0),
    gia_tham_khao DECIMAL(12,2),
    UNIQUE KEY uq_hanh_trinh_ngay (hanh_trinh_id, ngay_phuc_vu),
    FOREIGN KEY (hanh_trinh_id) REFERENCES hanh_trinh_am_thuc(hanh_trinh_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dat_cho (
    dat_cho_id INT AUTO_INCREMENT PRIMARY KEY,
    ma_dat_cho VARCHAR(50) NOT NULL UNIQUE,
    nguoi_dung_id INT NOT NULL,
    lich_kha_dung_id INT NOT NULL,
    so_khach INT NOT NULL CHECK (so_khach >= 1),
    don_gia DECIMAL(12,2) NOT NULL,
    tong_tien DECIMAL(14,2) NOT NULL,
    trang_thai ENUM('draft','pending_payment','confirmed','cancelled','expired','refunded','completed') NOT NULL DEFAULT 'draft',
    het_han_giu DATETIME NULL,
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (nguoi_dung_id) REFERENCES nguoi_dung(nguoi_dung_id),
    FOREIGN KEY (lich_kha_dung_id) REFERENCES lich_kha_dung_hanh_trinh(lich_kha_dung_id),
    INDEX idx_dat_cho_nguoi_dung (nguoi_dung_id),
    INDEX idx_dat_cho_lich_kha_dung (lich_kha_dung_id),
    INDEX idx_dat_cho_trang_thai (trang_thai),
    INDEX idx_dat_cho_het_han (het_han_giu)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS dat_cho_lich_su (
    dat_cho_lich_su_id INT AUTO_INCREMENT PRIMARY KEY,
    dat_cho_id INT NOT NULL,
    tu_trang_thai ENUM('draft','pending_payment','confirmed','cancelled','expired','refunded','completed') NULL,
    den_trang_thai ENUM('draft','pending_payment','confirmed','cancelled','expired','refunded','completed') NOT NULL,
    nguoi_thuc_hien_id INT NULL,
    ly_do VARCHAR(255),
    ngay_tao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dat_cho_id) REFERENCES dat_cho(dat_cho_id) ON DELETE CASCADE,
    FOREIGN KEY (nguoi_thuc_hien_id) REFERENCES nguoi_dung(nguoi_dung_id),
    INDEX idx_lich_su_dat_cho (dat_cho_id),
    INDEX idx_lich_su_nguoi_thuc_hien (nguoi_thuc_hien_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
