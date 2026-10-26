-- 22. Lich kha dung hanh trinh
CREATE TABLE lich_kha_dung_hanh_trinh (
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
