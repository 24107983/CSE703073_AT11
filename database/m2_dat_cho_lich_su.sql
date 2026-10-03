CREATE TABLE dat_cho_lich_su (
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
