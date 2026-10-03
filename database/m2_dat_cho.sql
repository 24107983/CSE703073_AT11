CREATE TABLE dat_cho (
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
