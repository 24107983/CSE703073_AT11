<<<<<<< Updated upstream
CREATE DATABASE IF NOT EXISTS am_thuc_vung_mien
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE am_thuc_vung_mien;

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
=======
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: am_thuc_vung_mien
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bo_suu_tap`
--

DROP TABLE IF EXISTS `bo_suu_tap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bo_suu_tap` (
  `bo_suu_tap_id` int NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int NOT NULL,
  `ten_bo_suu_tap` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  `ngay_tao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bo_suu_tap_id`),
  KEY `fk_bo_suu_tap_nguoi_dung` (`nguoi_dung_id`),
  CONSTRAINT `fk_bo_suu_tap_nguoi_dung` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bo_suu_tap_mon_an`
--

DROP TABLE IF EXISTS `bo_suu_tap_mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bo_suu_tap_mon_an` (
  `bo_suu_tap_id` int NOT NULL,
  `mon_an_id` int NOT NULL,
  `ngay_them` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bo_suu_tap_id`,`mon_an_id`),
  KEY `fk_bstma_mon_an` (`mon_an_id`),
  CONSTRAINT `fk_bstma_bo_suu_tap` FOREIGN KEY (`bo_suu_tap_id`) REFERENCES `bo_suu_tap` (`bo_suu_tap_id`),
  CONSTRAINT `fk_bstma_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cau_chuyen_van_hoa`
--

DROP TABLE IF EXISTS `cau_chuyen_van_hoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cau_chuyen_van_hoa` (
  `cau_chuyen_id` int NOT NULL AUTO_INCREMENT,
  `tieu_de` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `noi_dung` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `nguon_goc` text COLLATE utf8mb4_unicode_ci,
  `gia_tri_van_hoa` text COLLATE utf8mb4_unicode_ci,
  `mon_an_id` int NOT NULL,
  PRIMARY KEY (`cau_chuyen_id`),
  KEY `fk_cau_chuyen_mon_an` (`mon_an_id`),
  CONSTRAINT `fk_cau_chuyen_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `co_so_am_thuc`
--

DROP TABLE IF EXISTS `co_so_am_thuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `co_so_am_thuc` (
  `co_so_id` int NOT NULL AUTO_INCREMENT,
  `ten_co_so` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `loai_hinh` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dia_chi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `so_dien_thoai` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dia_diem_id` int NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  `hinh_anh` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`co_so_id`),
  KEY `fk_co_so_dia_diem` (`dia_diem_id`),
  CONSTRAINT `fk_co_so_dia_diem` FOREIGN KEY (`dia_diem_id`) REFERENCES `dia_diem` (`dia_diem_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `danh_gia`
--

DROP TABLE IF EXISTS `danh_gia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `danh_gia` (
  `danh_gia_id` int NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int NOT NULL,
  `mon_an_id` int DEFAULT NULL,
  `co_so_id` int DEFAULT NULL,
  `so_sao` int NOT NULL,
  `noi_dung` text COLLATE utf8mb4_unicode_ci,
  `ngay_danh_gia` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`danh_gia_id`),
  KEY `fk_danh_gia_nguoi_dung` (`nguoi_dung_id`),
  KEY `fk_danh_gia_mon_an` (`mon_an_id`),
  KEY `fk_danh_gia_co_so` (`co_so_id`),
  CONSTRAINT `fk_danh_gia_co_so` FOREIGN KEY (`co_so_id`) REFERENCES `co_so_am_thuc` (`co_so_id`),
  CONSTRAINT `fk_danh_gia_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `fk_danh_gia_nguoi_dung` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`),
  CONSTRAINT `chk_danh_gia_doi_tuong` CHECK (((`mon_an_id` is not null) or (`co_so_id` is not null))),
  CONSTRAINT `danh_gia_chk_1` CHECK ((`so_sao` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `di_ung_thuc_pham`
--

DROP TABLE IF EXISTS `di_ung_thuc_pham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `di_ung_thuc_pham` (
  `di_ung_id` int NOT NULL AUTO_INCREMENT,
  `ten_chat_di_ung` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`di_ung_id`),
  UNIQUE KEY `ten_chat_di_ung` (`ten_chat_di_ung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dia_diem`
--

DROP TABLE IF EXISTS `dia_diem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dia_diem` (
  `dia_diem_id` int NOT NULL AUTO_INCREMENT,
  `ten_dia_diem` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dia_chi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kinh_do` decimal(10,7) DEFAULT NULL,
  `vi_do` decimal(10,7) DEFAULT NULL,
  `tinh_thanh_id` int NOT NULL,
  PRIMARY KEY (`dia_diem_id`),
  KEY `fk_dia_diem_tinh_thanh` (`tinh_thanh_id`),
  CONSTRAINT `fk_dia_diem_tinh_thanh` FOREIGN KEY (`tinh_thanh_id`) REFERENCES `tinh_thanh` (`tinh_thanh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dip_le`
--

DROP TABLE IF EXISTS `dip_le`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dip_le` (
  `dip_le_id` int NOT NULL AUTO_INCREMENT,
  `ten_dip_le` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thoi_gian` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`dip_le_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dong_gop_du_lieu`
--

DROP TABLE IF EXISTS `dong_gop_du_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dong_gop_du_lieu` (
  `dong_gop_id` int NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int NOT NULL,
  `noi_dung` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `trang_thai` enum('cho_duyet','da_duyet','tu_choi') COLLATE utf8mb4_unicode_ci DEFAULT 'cho_duyet',
  `ngay_dong_gop` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`dong_gop_id`),
  KEY `fk_dong_gop_nguoi_dung` (`nguoi_dung_id`),
  CONSTRAINT `fk_dong_gop_nguoi_dung` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hanh_trinh_am_thuc`
--

DROP TABLE IF EXISTS `hanh_trinh_am_thuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hanh_trinh_am_thuc` (
  `hanh_trinh_id` int NOT NULL AUTO_INCREMENT,
  `ten_hanh_trinh` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  `thoi_luong` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`hanh_trinh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hanh_trinh_mon_an`
--

DROP TABLE IF EXISTS `hanh_trinh_mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hanh_trinh_mon_an` (
  `hanh_trinh_id` int NOT NULL,
  `mon_an_id` int NOT NULL,
  `thu_tu` int NOT NULL,
  `ghi_chu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`hanh_trinh_id`,`mon_an_id`),
  KEY `fk_htma_mon_an` (`mon_an_id`),
  CONSTRAINT `fk_htma_hanh_trinh` FOREIGN KEY (`hanh_trinh_id`) REFERENCES `hanh_trinh_am_thuc` (`hanh_trinh_id`),
  CONSTRAINT `fk_htma_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mon_an`
--

DROP TABLE IF EXISTS `mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_an` (
  `mon_an_id` int NOT NULL AUTO_INCREMENT,
  `ten_mon` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  `gia_tham_khao` decimal(12,2) DEFAULT NULL,
  `vung_mien_id` int NOT NULL,
  `tinh_thanh_id` int NOT NULL,
  `dia_diem_id` int DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`),
  KEY `fk_mon_an_vung_mien` (`vung_mien_id`),
  KEY `fk_mon_an_tinh_thanh` (`tinh_thanh_id`),
  KEY `fk_mon_an_dia_diem` (`dia_diem_id`),
  CONSTRAINT `fk_mon_an_dia_diem` FOREIGN KEY (`dia_diem_id`) REFERENCES `dia_diem` (`dia_diem_id`),
  CONSTRAINT `fk_mon_an_tinh_thanh` FOREIGN KEY (`tinh_thanh_id`) REFERENCES `tinh_thanh` (`tinh_thanh_id`),
  CONSTRAINT `fk_mon_an_vung_mien` FOREIGN KEY (`vung_mien_id`) REFERENCES `vung_mien` (`vung_mien_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mon_an_di_ung`
--

DROP TABLE IF EXISTS `mon_an_di_ung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_an_di_ung` (
  `mon_an_id` int NOT NULL,
  `di_ung_id` int NOT NULL,
  `ghi_chu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`di_ung_id`),
  KEY `fk_madiu_di_ung` (`di_ung_id`),
  CONSTRAINT `fk_madiu_di_ung` FOREIGN KEY (`di_ung_id`) REFERENCES `di_ung_thuc_pham` (`di_ung_id`),
  CONSTRAINT `fk_madiu_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mon_an_dip_le`
--

DROP TABLE IF EXISTS `mon_an_dip_le`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_an_dip_le` (
  `mon_an_id` int NOT NULL,
  `dip_le_id` int NOT NULL,
  `ghi_chu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`dip_le_id`),
  KEY `fk_madl_dip_le` (`dip_le_id`),
  CONSTRAINT `fk_madl_dip_le` FOREIGN KEY (`dip_le_id`) REFERENCES `dip_le` (`dip_le_id`),
  CONSTRAINT `fk_madl_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mon_an_mua_vu`
--

DROP TABLE IF EXISTS `mon_an_mua_vu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_an_mua_vu` (
  `mon_an_id` int NOT NULL,
  `mua_vu_id` int NOT NULL,
  `ghi_chu` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`mua_vu_id`),
  KEY `fk_mamv_mua_vu` (`mua_vu_id`),
  CONSTRAINT `fk_mamv_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `fk_mamv_mua_vu` FOREIGN KEY (`mua_vu_id`) REFERENCES `mua_vu` (`mua_vu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mon_an_nguyen_lieu`
--

DROP TABLE IF EXISTS `mon_an_nguyen_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mon_an_nguyen_lieu` (
  `mon_an_id` int NOT NULL,
  `nguyen_lieu_id` int NOT NULL,
  `so_luong` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `don_vi` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`nguyen_lieu_id`),
  KEY `fk_manl_nguyen_lieu` (`nguyen_lieu_id`),
  CONSTRAINT `fk_manl_mon_an` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `fk_manl_nguyen_lieu` FOREIGN KEY (`nguyen_lieu_id`) REFERENCES `nguyen_lieu` (`nguyen_lieu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mua_vu`
--

DROP TABLE IF EXISTS `mua_vu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mua_vu` (
  `mua_vu_id` int NOT NULL AUTO_INCREMENT,
  `ten_mua` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`mua_vu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nguoi_dung`
--

DROP TABLE IF EXISTS `nguoi_dung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguoi_dung` (
  `nguoi_dung_id` int NOT NULL AUTO_INCREMENT,
  `ho_ten` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mat_khau` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vai_tro` enum('khach_du_lich','cong_tac_vien','quan_tri_vien') COLLATE utf8mb4_unicode_ci DEFAULT 'khach_du_lich',
  PRIMARY KEY (`nguoi_dung_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nguyen_lieu`
--

DROP TABLE IF EXISTS `nguyen_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nguyen_lieu` (
  `nguyen_lieu_id` int NOT NULL AUTO_INCREMENT,
  `ten_nguyen_lieu` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`nguyen_lieu_id`),
  UNIQUE KEY `ten_nguyen_lieu` (`ten_nguyen_lieu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tinh_thanh`
--

DROP TABLE IF EXISTS `tinh_thanh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tinh_thanh` (
  `tinh_thanh_id` int NOT NULL AUTO_INCREMENT,
  `ten_tinh` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vung_mien_id` int NOT NULL,
  PRIMARY KEY (`tinh_thanh_id`),
  KEY `fk_tinh_thanh_vung_mien` (`vung_mien_id`),
  CONSTRAINT `fk_tinh_thanh_vung_mien` FOREIGN KEY (`vung_mien_id`) REFERENCES `vung_mien` (`vung_mien_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vung_mien`
--

DROP TABLE IF EXISTS `vung_mien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vung_mien` (
  `vung_mien_id` int NOT NULL AUTO_INCREMENT,
  `ten_vung` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`vung_mien_id`),
  UNIQUE KEY `ten_vung` (`ten_vung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-17 21:44:12
>>>>>>> Stashed changes
