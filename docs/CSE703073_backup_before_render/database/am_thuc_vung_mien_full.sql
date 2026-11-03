-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: am_thuc_vung_mien
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bo_suu_tap` (
  `bo_suu_tap_id` int(11) NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int(11) NOT NULL,
  `ten_bo_suu_tap` varchar(150) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  PRIMARY KEY (`bo_suu_tap_id`),
  KEY `nguoi_dung_id` (`nguoi_dung_id`),
  CONSTRAINT `bo_suu_tap_ibfk_1` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bo_suu_tap`
--

LOCK TABLES `bo_suu_tap` WRITE;
/*!40000 ALTER TABLE `bo_suu_tap` DISABLE KEYS */;
/*!40000 ALTER TABLE `bo_suu_tap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bo_suu_tap_mon_an`
--

DROP TABLE IF EXISTS `bo_suu_tap_mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bo_suu_tap_mon_an` (
  `bo_suu_tap_id` int(11) NOT NULL,
  `mon_an_id` int(11) NOT NULL,
  `ngay_them` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`bo_suu_tap_id`,`mon_an_id`),
  KEY `mon_an_id` (`mon_an_id`),
  CONSTRAINT `bo_suu_tap_mon_an_ibfk_1` FOREIGN KEY (`bo_suu_tap_id`) REFERENCES `bo_suu_tap` (`bo_suu_tap_id`),
  CONSTRAINT `bo_suu_tap_mon_an_ibfk_2` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bo_suu_tap_mon_an`
--

LOCK TABLES `bo_suu_tap_mon_an` WRITE;
/*!40000 ALTER TABLE `bo_suu_tap_mon_an` DISABLE KEYS */;
/*!40000 ALTER TABLE `bo_suu_tap_mon_an` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cau_chuyen_van_hoa`
--

DROP TABLE IF EXISTS `cau_chuyen_van_hoa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cau_chuyen_van_hoa` (
  `cau_chuyen_id` int(11) NOT NULL AUTO_INCREMENT,
  `tieu_de` varchar(255) NOT NULL,
  `noi_dung` text NOT NULL,
  `mon_an_id` int(11) NOT NULL,
  PRIMARY KEY (`cau_chuyen_id`),
  KEY `mon_an_id` (`mon_an_id`),
  CONSTRAINT `cau_chuyen_van_hoa_ibfk_1` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cau_chuyen_van_hoa`
--

LOCK TABLES `cau_chuyen_van_hoa` WRITE;
/*!40000 ALTER TABLE `cau_chuyen_van_hoa` DISABLE KEYS */;
/*!40000 ALTER TABLE `cau_chuyen_van_hoa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `co_so_am_thuc`
--

DROP TABLE IF EXISTS `co_so_am_thuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `co_so_am_thuc` (
  `co_so_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_co_so` varchar(200) NOT NULL,
  `dia_chi` varchar(255) DEFAULT NULL,
  `so_dien_thoai` varchar(20) DEFAULT NULL,
  `dia_diem_id` int(11) NOT NULL,
  PRIMARY KEY (`co_so_id`),
  KEY `idx_co_so_dia_diem` (`dia_diem_id`),
  CONSTRAINT `co_so_am_thuc_ibfk_1` FOREIGN KEY (`dia_diem_id`) REFERENCES `dia_diem` (`dia_diem_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `co_so_am_thuc`
--

LOCK TABLES `co_so_am_thuc` WRITE;
/*!40000 ALTER TABLE `co_so_am_thuc` DISABLE KEYS */;
INSERT INTO `co_so_am_thuc` VALUES (1,'NhĂ  hĂ ng ?m th?c M?n 1','1 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 1',NULL,1),(2,'NhĂ  hĂ ng ?m th?c M?n 11','11 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 11',NULL,1),(3,'NhĂ  hĂ ng ?m th?c M?n 21','21 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 21',NULL,1),(4,'NhĂ  hĂ ng ?m th?c M?n 31','31 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 31',NULL,1),(5,'NhĂ  hĂ ng ?m th?c M?n 41','41 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 41',NULL,1),(6,'NhĂ  hĂ ng ?m th?c M?n 2','2 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 2',NULL,1),(7,'NhĂ  hĂ ng ?m th?c M?n 12','12 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 12',NULL,1),(8,'NhĂ  hĂ ng ?m th?c M?n 22','22 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 22',NULL,1),(9,'NhĂ  hĂ ng ?m th?c M?n 32','32 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 32',NULL,1),(10,'NhĂ  hĂ ng ?m th?c M?n 42','42 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 42',NULL,1),(11,'NhĂ  hĂ ng ?m th?c M?n 3','3 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 3',NULL,1),(12,'NhĂ  hĂ ng ?m th?c M?n 13','13 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 13',NULL,1),(13,'NhĂ  hĂ ng ?m th?c M?n 23','23 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 23',NULL,1),(14,'NhĂ  hĂ ng ?m th?c M?n 33','33 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 33',NULL,1),(15,'NhĂ  hĂ ng ?m th?c M?n 43','43 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 43',NULL,1),(16,'NhĂ  hĂ ng ?m th?c M?n 4','4 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 4',NULL,1),(17,'NhĂ  hĂ ng ?m th?c M?n 14','14 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 14',NULL,1),(18,'NhĂ  hĂ ng ?m th?c M?n 24','24 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 24',NULL,1),(19,'NhĂ  hĂ ng ?m th?c M?n 34','34 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 34',NULL,1),(20,'NhĂ  hĂ ng ?m th?c M?n 44','44 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 44',NULL,1),(21,'NhĂ  hĂ ng ?m th?c M?n 5','5 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 5',NULL,1),(22,'NhĂ  hĂ ng ?m th?c M?n 15','15 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 15',NULL,1),(23,'NhĂ  hĂ ng ?m th?c M?n 25','25 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 25',NULL,1),(24,'NhĂ  hĂ ng ?m th?c M?n 35','35 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 35',NULL,1),(25,'NhĂ  hĂ ng ?m th?c M?n 45','45 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 45',NULL,1),(26,'NhĂ  hĂ ng ?m th?c M?n 6','6 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 6',NULL,1),(27,'NhĂ  hĂ ng ?m th?c M?n 16','16 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 16',NULL,1),(28,'NhĂ  hĂ ng ?m th?c M?n 26','26 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 26',NULL,1),(29,'NhĂ  hĂ ng ?m th?c M?n 36','36 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 36',NULL,1),(30,'NhĂ  hĂ ng ?m th?c M?n 46','46 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 46',NULL,1),(31,'NhĂ  hĂ ng ?m th?c M?n 7','7 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 7',NULL,1),(32,'NhĂ  hĂ ng ?m th?c M?n 17','17 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 17',NULL,1),(33,'NhĂ  hĂ ng ?m th?c M?n 27','27 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 27',NULL,1),(34,'NhĂ  hĂ ng ?m th?c M?n 37','37 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 37',NULL,1),(35,'NhĂ  hĂ ng ?m th?c M?n 47','47 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 47',NULL,1),(36,'NhĂ  hĂ ng ?m th?c M?n 8','8 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 8',NULL,1),(37,'NhĂ  hĂ ng ?m th?c M?n 18','18 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 18',NULL,1),(38,'NhĂ  hĂ ng ?m th?c M?n 28','28 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 28',NULL,1),(39,'NhĂ  hĂ ng ?m th?c M?n 38','38 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 38',NULL,1),(40,'NhĂ  hĂ ng ?m th?c M?n 48','48 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 48',NULL,1),(41,'NhĂ  hĂ ng ?m th?c M?n 9','9 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 9',NULL,1),(42,'NhĂ  hĂ ng ?m th?c M?n 19','19 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 19',NULL,1),(43,'NhĂ  hĂ ng ?m th?c M?n 29','29 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 29',NULL,1),(44,'NhĂ  hĂ ng ?m th?c M?n 39','39 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 39',NULL,1),(45,'NhĂ  hĂ ng ?m th?c M?n 49','49 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 49',NULL,1),(46,'NhĂ  hĂ ng ?m th?c M?n 10','10 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 10',NULL,1),(47,'NhĂ  hĂ ng ?m th?c M?n 20','20 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 20',NULL,1),(48,'NhĂ  hĂ ng ?m th?c M?n 30','30 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 30',NULL,1),(49,'NhĂ  hĂ ng ?m th?c M?n 40','40 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 40',NULL,1),(50,'NhĂ  hĂ ng ?m th?c M?n 50','50 ĂĂ½?ng Ă?a Danh, PhĂ½?ng 50',NULL,1);
/*!40000 ALTER TABLE `co_so_am_thuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `danh_gia`
--

DROP TABLE IF EXISTS `danh_gia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `danh_gia` (
  `danh_gia_id` int(11) NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int(11) NOT NULL,
  `mon_an_id` int(11) DEFAULT NULL,
  `co_so_id` int(11) DEFAULT NULL,
  `so_sao` int(11) NOT NULL CHECK (`so_sao` between 1 and 5),
  `noi_dung` text DEFAULT NULL,
  `ngay_danh_gia` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`danh_gia_id`),
  KEY `nguoi_dung_id` (`nguoi_dung_id`),
  KEY `mon_an_id` (`mon_an_id`),
  KEY `co_so_id` (`co_so_id`),
  CONSTRAINT `danh_gia_ibfk_1` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`),
  CONSTRAINT `danh_gia_ibfk_2` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `danh_gia_ibfk_3` FOREIGN KEY (`co_so_id`) REFERENCES `co_so_am_thuc` (`co_so_id`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`mon_an_id` is not null or `co_so_id` is not null)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `danh_gia`
--

LOCK TABLES `danh_gia` WRITE;
/*!40000 ALTER TABLE `danh_gia` DISABLE KEYS */;
/*!40000 ALTER TABLE `danh_gia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `di_ung_thuc_pham`
--

DROP TABLE IF EXISTS `di_ung_thuc_pham`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `di_ung_thuc_pham` (
  `di_ung_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_chat_di_ung` varchar(150) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  PRIMARY KEY (`di_ung_id`),
  UNIQUE KEY `ten_chat_di_ung` (`ten_chat_di_ung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `di_ung_thuc_pham`
--

LOCK TABLES `di_ung_thuc_pham` WRITE;
/*!40000 ALTER TABLE `di_ung_thuc_pham` DISABLE KEYS */;
/*!40000 ALTER TABLE `di_ung_thuc_pham` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dia_diem`
--

DROP TABLE IF EXISTS `dia_diem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dia_diem` (
  `dia_diem_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_dia_diem` varchar(255) NOT NULL,
  `dia_chi` varchar(255) DEFAULT NULL,
  `kinh_do` decimal(10,7) DEFAULT NULL,
  `vi_do` decimal(10,7) DEFAULT NULL,
  `tinh_thanh_id` int(11) NOT NULL,
  PRIMARY KEY (`dia_diem_id`),
  KEY `idx_dia_diem_tinh_thanh` (`tinh_thanh_id`),
  CONSTRAINT `dia_diem_ibfk_1` FOREIGN KEY (`tinh_thanh_id`) REFERENCES `tinh_thanh` (`tinh_thanh_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dia_diem`
--

LOCK TABLES `dia_diem` WRITE;
/*!40000 ALTER TABLE `dia_diem` DISABLE KEYS */;
INSERT INTO `dia_diem` VALUES (1,'PhĂ¡Â»â€˜ cĂ¡Â»â€¢ HĂƒÂ  NĂ¡Â»â„¢i','HoĂƒÂ n KiĂ¡ÂºÂ¿m, HĂƒÂ  NĂ¡Â»â„¢i',105.8542000,21.0285000,1),(2,'ChĂ¡Â»Â£ Ă„ÂĂ¡Â»â€œng XuĂƒÂ¢n','HoĂƒÂ n KiĂ¡ÂºÂ¿m, HĂƒÂ  NĂ¡Â»â„¢i',105.8470000,21.0380000,1),(3,'ChĂ¡Â»Â£ CĂƒÂ¡t Bi','HĂ¡ÂºÂ£i An, HĂ¡ÂºÂ£i PhĂƒÂ²ng',106.6780000,20.8449000,2),(4,'ChĂ¡Â»Â£ trung tĂƒÂ¢m Ă„ÂĂ¡Â»â€œng VĂ„Æ’n','Ă„ÂĂ¡Â»â€œng VĂ„Æ’n, HĂƒÂ  Giang',105.3580000,23.2780000,3),(5,'Ă„ÂĂ¡ÂºÂ¡i NĂ¡Â»â„¢i HuĂ¡ÂºÂ¿','ThĂƒÂ nh phĂ¡Â»â€˜ HuĂ¡ÂºÂ¿',107.5780000,16.4698000,4),(6,'ChĂ¡Â»Â£ HĂƒÂ n','HĂ¡ÂºÂ£i ChĂƒÂ¢u, Ă„ÂĂƒÂ  NĂ¡ÂºÂµng',108.2181000,16.0678000,5),(7,'PhĂ¡Â»â€˜ cĂ¡Â»â€¢ HĂ¡Â»â„¢i An','HĂ¡Â»â„¢i An, QuĂ¡ÂºÂ£ng Nam',108.3270000,15.8801000,6),(8,'ChĂ¡Â»Â£ BĂ¡ÂºÂ¿n ThĂƒÂ nh','QuĂ¡ÂºÂ­n 1, TP. HĂ¡Â»â€œ ChĂƒÂ­ Minh',106.6980000,10.7720000,7),(9,'ChĂ¡Â»Â£ nĂ¡Â»â€¢i CĂƒÂ¡i RĂ„Æ’ng','CĂƒÂ¡i RĂ„Æ’ng, CĂ¡ÂºÂ§n ThĂ†Â¡',105.7840000,10.0070000,8),(10,'ChĂ¡Â»Â£ ChĂƒÂ¢u Ă„ÂĂ¡Â»â€˜c','ChĂƒÂ¢u Ă„ÂĂ¡Â»â€˜c, An Giang',105.1167000,10.7000000,9);
/*!40000 ALTER TABLE `dia_diem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dip_le`
--

DROP TABLE IF EXISTS `dip_le`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dip_le` (
  `dip_le_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_dip_le` varchar(150) NOT NULL,
  `thoi_gian` varchar(100) DEFAULT NULL,
  `mo_ta` text DEFAULT NULL,
  PRIMARY KEY (`dip_le_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dip_le`
--

LOCK TABLES `dip_le` WRITE;
/*!40000 ALTER TABLE `dip_le` DISABLE KEYS */;
/*!40000 ALTER TABLE `dip_le` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dong_gop_du_lieu`
--

DROP TABLE IF EXISTS `dong_gop_du_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dong_gop_du_lieu` (
  `dong_gop_id` int(11) NOT NULL AUTO_INCREMENT,
  `nguoi_dung_id` int(11) NOT NULL,
  `noi_dung` text NOT NULL,
  `trang_thai` enum('cho_duyet','da_duyet','tu_choi') DEFAULT 'cho_duyet',
  `ngay_dong_gop` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`dong_gop_id`),
  KEY `nguoi_dung_id` (`nguoi_dung_id`),
  CONSTRAINT `dong_gop_du_lieu_ibfk_1` FOREIGN KEY (`nguoi_dung_id`) REFERENCES `nguoi_dung` (`nguoi_dung_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dong_gop_du_lieu`
--

LOCK TABLES `dong_gop_du_lieu` WRITE;
/*!40000 ALTER TABLE `dong_gop_du_lieu` DISABLE KEYS */;
/*!40000 ALTER TABLE `dong_gop_du_lieu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hanh_trinh_am_thuc`
--

DROP TABLE IF EXISTS `hanh_trinh_am_thuc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hanh_trinh_am_thuc` (
  `hanh_trinh_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_hanh_trinh` varchar(200) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  `thoi_luong` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`hanh_trinh_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hanh_trinh_am_thuc`
--

LOCK TABLES `hanh_trinh_am_thuc` WRITE;
/*!40000 ALTER TABLE `hanh_trinh_am_thuc` DISABLE KEYS */;
/*!40000 ALTER TABLE `hanh_trinh_am_thuc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hanh_trinh_mon_an`
--

DROP TABLE IF EXISTS `hanh_trinh_mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hanh_trinh_mon_an` (
  `hanh_trinh_id` int(11) NOT NULL,
  `mon_an_id` int(11) NOT NULL,
  `thu_tu` int(11) NOT NULL,
  `ghi_chu` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`hanh_trinh_id`,`mon_an_id`),
  KEY `mon_an_id` (`mon_an_id`),
  CONSTRAINT `hanh_trinh_mon_an_ibfk_1` FOREIGN KEY (`hanh_trinh_id`) REFERENCES `hanh_trinh_am_thuc` (`hanh_trinh_id`),
  CONSTRAINT `hanh_trinh_mon_an_ibfk_2` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hanh_trinh_mon_an`
--

LOCK TABLES `hanh_trinh_mon_an` WRITE;
/*!40000 ALTER TABLE `hanh_trinh_mon_an` DISABLE KEYS */;
/*!40000 ALTER TABLE `hanh_trinh_mon_an` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_an`
--

DROP TABLE IF EXISTS `mon_an`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mon_an` (
  `mon_an_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_mon` varchar(150) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  `gia_tham_khao` decimal(12,2) DEFAULT NULL,
  `vung_mien_id` int(11) NOT NULL,
  `tinh_thanh_id` int(11) NOT NULL,
  `dia_diem_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`),
  KEY `vung_mien_id` (`vung_mien_id`),
  KEY `dia_diem_id` (`dia_diem_id`),
  KEY `idx_mon_an_tinh_thanh` (`tinh_thanh_id`),
  KEY `idx_mon_an_gia` (`gia_tham_khao`),
  CONSTRAINT `mon_an_ibfk_1` FOREIGN KEY (`vung_mien_id`) REFERENCES `vung_mien` (`vung_mien_id`),
  CONSTRAINT `mon_an_ibfk_2` FOREIGN KEY (`tinh_thanh_id`) REFERENCES `tinh_thanh` (`tinh_thanh_id`),
  CONSTRAINT `mon_an_ibfk_3` FOREIGN KEY (`dia_diem_id`) REFERENCES `dia_diem` (`dia_diem_id`)
) ENGINE=InnoDB AUTO_INCREMENT=523 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_an`
--

LOCK TABLES `mon_an` WRITE;
/*!40000 ALTER TABLE `mon_an` DISABLE KEYS */;
INSERT INTO `mon_an` VALUES (1,'PhĂ¡Â»Å¸ HĂƒÂ  NĂ¡Â»â„¢i','MĂƒÂ³n Ă„Æ’n truyĂ¡Â»Ân thĂ¡Â»â€˜ng nĂ¡Â»â€¢i tiĂ¡ÂºÂ¿ng cĂ¡Â»Â§a HĂƒÂ  NĂ¡Â»â„¢i',50000.00,1,1,1),(2,'BĂƒÂºn chĂ¡ÂºÂ£ HĂƒÂ  NĂ¡Â»â„¢i','BĂƒÂºn Ă„Æ’n kĂƒÂ¨m thĂ¡Â»â€¹t nĂ†Â°Ă¡Â»â€ºng vĂƒÂ  nĂ†Â°Ă¡Â»â€ºc chĂ¡ÂºÂ¥m',60000.00,1,1,2),(3,'BĂƒÂ¡nh Ă„â€˜a cua HĂ¡ÂºÂ£i PhĂƒÂ²ng','MĂƒÂ³n Ă„Æ’n Ă„â€˜Ă¡ÂºÂ·c trĂ†Â°ng cĂ¡Â»Â§a HĂ¡ÂºÂ£i PhĂƒÂ²ng',45000.00,1,2,3),(4,'BĂƒÂ¡nh cuĂ¡Â»â€˜n Ă„ÂĂ¡Â»â€œng VĂ„Æ’n','BĂƒÂ¡nh cuĂ¡Â»â€˜n nĂƒÂ³ng Ă„â€˜Ă¡ÂºÂ·c sĂ¡ÂºÂ£n vĂƒÂ¹ng cao HĂƒÂ  Giang',40000.00,1,3,4),(5,'BĂƒÂºn bĂƒÂ² HuĂ¡ÂºÂ¿','MĂƒÂ³n bĂƒÂºn cay Ă„â€˜Ă¡ÂºÂ·c trĂ†Â°ng cĂ¡Â»Â§a cĂ¡Â»â€˜ Ă„â€˜ĂƒÂ´ HuĂ¡ÂºÂ¿',55000.00,2,4,5),(6,'MĂƒÂ¬ QuĂ¡ÂºÂ£ng','MĂƒÂ³n mĂƒÂ¬ Ă„â€˜Ă¡ÂºÂ·c sĂ¡ÂºÂ£n cĂ¡Â»Â§a QuĂ¡ÂºÂ£ng Nam',55000.00,2,6,7),(7,'CĂ†Â¡m tĂ¡ÂºÂ¥m SĂƒÂ i GĂƒÂ²n','CĂ†Â¡m tĂ¡ÂºÂ¥m Ă„Æ’n kĂƒÂ¨m sĂ†Â°Ă¡Â»Ân nĂ†Â°Ă¡Â»â€ºng',60000.00,3,7,8),(8,'BĂƒÂ¡nh xĂƒÂ¨o miĂ¡Â»Ân TĂƒÂ¢y','BĂƒÂ¡nh xĂƒÂ¨o giĂƒÂ²n vĂ¡Â»â€ºi nhĂƒÂ¢n tĂƒÂ´m thĂ¡Â»â€¹t',50000.00,3,8,9),(9,'BĂƒÂºn cĂƒÂ¡ ChĂƒÂ¢u Ă„ÂĂ¡Â»â€˜c','MĂƒÂ³n bĂƒÂºn cĂƒÂ¡ nĂ¡Â»â€¢i tiĂ¡ÂºÂ¿ng cĂ¡Â»Â§a An Giang',55000.00,3,9,10),(10,'Cao lĂ¡ÂºÂ§u HĂ¡Â»â„¢i An','MĂƒÂ³n mĂƒÂ¬ Ă„â€˜Ă¡ÂºÂ·c trĂ†Â°ng cĂ¡Â»Â§a phĂ¡Â»â€˜ cĂ¡Â»â€¢ HĂ¡Â»â„¢i An',65000.00,2,6,7),(11,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 1','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 1',36000.00,1,1,NULL),(12,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 101','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 101',136000.00,1,1,NULL),(13,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 201','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 201',236000.00,1,1,NULL),(14,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 2','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 2',37000.00,1,1,NULL),(15,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 102','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 102',137000.00,1,1,NULL),(16,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 202','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 202',237000.00,1,1,NULL),(17,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 3','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 3',38000.00,1,1,NULL),(18,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 103','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 103',138000.00,1,1,NULL),(19,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 203','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 203',238000.00,1,1,NULL),(20,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 4','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 4',39000.00,1,1,NULL),(21,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 104','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 104',139000.00,1,1,NULL),(22,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 204','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 204',239000.00,1,1,NULL),(23,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 5','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 5',40000.00,1,1,NULL),(24,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 105','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 105',140000.00,1,1,NULL),(25,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 205','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 205',240000.00,1,1,NULL),(26,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 6','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 6',41000.00,1,1,NULL),(27,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 106','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 106',141000.00,1,1,NULL),(28,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 206','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 206',241000.00,1,1,NULL),(29,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 7','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 7',42000.00,1,1,NULL),(30,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 107','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 107',142000.00,1,1,NULL),(31,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 207','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 207',242000.00,1,1,NULL),(32,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 8','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 8',43000.00,1,1,NULL),(33,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 108','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 108',143000.00,1,1,NULL),(34,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 208','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 208',243000.00,1,1,NULL),(35,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 9','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 9',44000.00,1,1,NULL),(36,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 109','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 109',144000.00,1,1,NULL),(37,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 209','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 209',244000.00,1,1,NULL),(38,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 10','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 10',45000.00,1,1,NULL),(39,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 110','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 110',145000.00,1,1,NULL),(40,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 210','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 210',245000.00,1,1,NULL),(41,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 11','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 11',46000.00,1,1,NULL),(42,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 111','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 111',146000.00,1,1,NULL),(43,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 211','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 211',246000.00,1,1,NULL),(44,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 12','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 12',47000.00,1,1,NULL),(45,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 112','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 112',147000.00,1,1,NULL),(46,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 212','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 212',247000.00,1,1,NULL),(47,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 13','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 13',48000.00,1,1,NULL),(48,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 113','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 113',148000.00,1,1,NULL),(49,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 213','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 213',248000.00,1,1,NULL),(50,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 14','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 14',49000.00,1,1,NULL),(51,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 114','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 114',149000.00,1,1,NULL),(52,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 214','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 214',249000.00,1,1,NULL),(53,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 15','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 15',50000.00,1,1,NULL),(54,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 115','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 115',150000.00,1,1,NULL),(55,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 215','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 215',250000.00,1,1,NULL),(56,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 16','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 16',51000.00,1,1,NULL),(57,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 116','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 116',151000.00,1,1,NULL),(58,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 216','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 216',251000.00,1,1,NULL),(59,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 17','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 17',52000.00,1,1,NULL),(60,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 117','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 117',152000.00,1,1,NULL),(61,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 217','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 217',252000.00,1,1,NULL),(62,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 18','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 18',53000.00,1,1,NULL),(63,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 118','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 118',153000.00,1,1,NULL),(64,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 218','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 218',253000.00,1,1,NULL),(65,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 19','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 19',54000.00,1,1,NULL),(66,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 119','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 119',154000.00,1,1,NULL),(67,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 219','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 219',254000.00,1,1,NULL),(68,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 20','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 20',55000.00,1,1,NULL),(69,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 120','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 120',155000.00,1,1,NULL),(70,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 220','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 220',255000.00,1,1,NULL),(71,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 21','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 21',56000.00,1,1,NULL),(72,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 121','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 121',156000.00,1,1,NULL),(73,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 221','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 221',256000.00,1,1,NULL),(74,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 22','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 22',57000.00,1,1,NULL),(75,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 122','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 122',157000.00,1,1,NULL),(76,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 222','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 222',257000.00,1,1,NULL),(77,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 23','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 23',58000.00,1,1,NULL),(78,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 123','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 123',158000.00,1,1,NULL),(79,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 223','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 223',258000.00,1,1,NULL),(80,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 24','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 24',59000.00,1,1,NULL),(81,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 124','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 124',159000.00,1,1,NULL),(82,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 224','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 224',259000.00,1,1,NULL),(83,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 25','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 25',60000.00,1,1,NULL),(84,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 125','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 125',160000.00,1,1,NULL),(85,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 225','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 225',260000.00,1,1,NULL),(86,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 26','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 26',61000.00,1,1,NULL),(87,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 126','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 126',161000.00,1,1,NULL),(88,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 226','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 226',261000.00,1,1,NULL),(89,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 27','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 27',62000.00,1,1,NULL),(90,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 127','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 127',162000.00,1,1,NULL),(91,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 227','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 227',262000.00,1,1,NULL),(92,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 28','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 28',63000.00,1,1,NULL),(93,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 128','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 128',163000.00,1,1,NULL),(94,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 228','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 228',263000.00,1,1,NULL),(95,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 29','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 29',64000.00,1,1,NULL),(96,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 129','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 129',164000.00,1,1,NULL),(97,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 229','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 229',264000.00,1,1,NULL),(98,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 30','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 30',65000.00,1,1,NULL),(99,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 130','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 130',165000.00,1,1,NULL),(100,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 230','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 230',265000.00,1,1,NULL),(101,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 31','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 31',66000.00,1,1,NULL),(102,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 131','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 131',166000.00,1,1,NULL),(103,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 231','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 231',266000.00,1,1,NULL),(104,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 32','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 32',67000.00,1,1,NULL),(105,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 132','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 132',167000.00,1,1,NULL),(106,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 232','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 232',267000.00,1,1,NULL),(107,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 33','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 33',68000.00,1,1,NULL),(108,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 133','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 133',168000.00,1,1,NULL),(109,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 233','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 233',268000.00,1,1,NULL),(110,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 34','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 34',69000.00,1,1,NULL),(111,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 134','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 134',169000.00,1,1,NULL),(112,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 234','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 234',269000.00,1,1,NULL),(113,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 35','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 35',70000.00,1,1,NULL),(114,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 135','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 135',170000.00,1,1,NULL),(115,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 235','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 235',270000.00,1,1,NULL),(116,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 36','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 36',71000.00,1,1,NULL),(117,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 136','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 136',171000.00,1,1,NULL),(118,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 236','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 236',271000.00,1,1,NULL),(119,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 37','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 37',72000.00,1,1,NULL),(120,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 137','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 137',172000.00,1,1,NULL),(121,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 237','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 237',272000.00,1,1,NULL),(122,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 38','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 38',73000.00,1,1,NULL),(123,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 138','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 138',173000.00,1,1,NULL),(124,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 238','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 238',273000.00,1,1,NULL),(125,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 39','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 39',74000.00,1,1,NULL),(126,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 139','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 139',174000.00,1,1,NULL),(127,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 239','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 239',274000.00,1,1,NULL),(128,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 40','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 40',75000.00,1,1,NULL),(129,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 140','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 140',175000.00,1,1,NULL),(130,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 240','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 240',275000.00,1,1,NULL),(131,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 41','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 41',76000.00,1,1,NULL),(132,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 141','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 141',176000.00,1,1,NULL),(133,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 241','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 241',276000.00,1,1,NULL),(134,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 42','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 42',77000.00,1,1,NULL),(135,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 142','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 142',177000.00,1,1,NULL),(136,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 242','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 242',277000.00,1,1,NULL),(137,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 43','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 43',78000.00,1,1,NULL),(138,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 143','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 143',178000.00,1,1,NULL),(139,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 243','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 243',278000.00,1,1,NULL),(140,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 44','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 44',79000.00,1,1,NULL),(141,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 144','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 144',179000.00,1,1,NULL),(142,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 244','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 244',279000.00,1,1,NULL),(143,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 45','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 45',80000.00,1,1,NULL),(144,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 145','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 145',180000.00,1,1,NULL),(145,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 245','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 245',280000.00,1,1,NULL),(146,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 46','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 46',81000.00,1,1,NULL),(147,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 146','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 146',181000.00,1,1,NULL),(148,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 246','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 246',281000.00,1,1,NULL),(149,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 47','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 47',82000.00,1,1,NULL),(150,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 147','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 147',182000.00,1,1,NULL),(151,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 247','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 247',282000.00,1,1,NULL),(152,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 48','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 48',83000.00,1,1,NULL),(153,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 148','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 148',183000.00,1,1,NULL),(154,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 248','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 248',283000.00,1,1,NULL),(155,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 49','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 49',84000.00,1,1,NULL),(156,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 149','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 149',184000.00,1,1,NULL),(157,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 249','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 249',284000.00,1,1,NULL),(158,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 50','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 50',85000.00,1,1,NULL),(159,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 150','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 150',185000.00,1,1,NULL),(160,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 250','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 250',285000.00,1,1,NULL),(161,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 51','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 51',86000.00,1,1,NULL),(162,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 151','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 151',186000.00,1,1,NULL),(163,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 251','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 251',286000.00,1,1,NULL),(164,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 52','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 52',87000.00,1,1,NULL),(165,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 152','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 152',187000.00,1,1,NULL),(166,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 252','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 252',287000.00,1,1,NULL),(167,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 53','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 53',88000.00,1,1,NULL),(168,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 153','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 153',188000.00,1,1,NULL),(169,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 253','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 253',288000.00,1,1,NULL),(170,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 54','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 54',89000.00,1,1,NULL),(171,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 154','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 154',189000.00,1,1,NULL),(172,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 254','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 254',289000.00,1,1,NULL),(173,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 55','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 55',90000.00,1,1,NULL),(174,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 155','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 155',190000.00,1,1,NULL),(175,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 255','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 255',290000.00,1,1,NULL),(176,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 56','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 56',91000.00,1,1,NULL),(177,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 156','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 156',191000.00,1,1,NULL),(178,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 256','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 256',291000.00,1,1,NULL),(179,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 57','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 57',92000.00,1,1,NULL),(180,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 157','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 157',192000.00,1,1,NULL),(181,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 257','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 257',292000.00,1,1,NULL),(182,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 58','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 58',93000.00,1,1,NULL),(183,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 158','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 158',193000.00,1,1,NULL),(184,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 258','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 258',293000.00,1,1,NULL),(185,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 59','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 59',94000.00,1,1,NULL),(186,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 159','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 159',194000.00,1,1,NULL),(187,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 259','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 259',294000.00,1,1,NULL),(188,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 60','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 60',95000.00,1,1,NULL),(189,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 160','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 160',195000.00,1,1,NULL),(190,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 260','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 260',295000.00,1,1,NULL),(191,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 61','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 61',96000.00,1,1,NULL),(192,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 161','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 161',196000.00,1,1,NULL),(193,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 261','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 261',296000.00,1,1,NULL),(194,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 62','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 62',97000.00,1,1,NULL),(195,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 162','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 162',197000.00,1,1,NULL),(196,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 262','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 262',297000.00,1,1,NULL),(197,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 63','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 63',98000.00,1,1,NULL),(198,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 163','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 163',198000.00,1,1,NULL),(199,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 263','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 263',298000.00,1,1,NULL),(200,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 64','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 64',99000.00,1,1,NULL),(201,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 164','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 164',199000.00,1,1,NULL),(202,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 264','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 264',299000.00,1,1,NULL),(203,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 65','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 65',100000.00,1,1,NULL),(204,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 165','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 165',200000.00,1,1,NULL),(205,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 265','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 265',300000.00,1,1,NULL),(206,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 66','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 66',101000.00,1,1,NULL),(207,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 166','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 166',201000.00,1,1,NULL),(208,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 266','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 266',301000.00,1,1,NULL),(209,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 67','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 67',102000.00,1,1,NULL),(210,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 167','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 167',202000.00,1,1,NULL),(211,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 267','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 267',302000.00,1,1,NULL),(212,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 68','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 68',103000.00,1,1,NULL),(213,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 168','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 168',203000.00,1,1,NULL),(214,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 268','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 268',303000.00,1,1,NULL),(215,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 69','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 69',104000.00,1,1,NULL),(216,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 169','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 169',204000.00,1,1,NULL),(217,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 269','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 269',304000.00,1,1,NULL),(218,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 70','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 70',105000.00,1,1,NULL),(219,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 170','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 170',205000.00,1,1,NULL),(220,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 270','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 270',305000.00,1,1,NULL),(221,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 71','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 71',106000.00,1,1,NULL),(222,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 171','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 171',206000.00,1,1,NULL),(223,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 271','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 271',306000.00,1,1,NULL),(224,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 72','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 72',107000.00,1,1,NULL),(225,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 172','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 172',207000.00,1,1,NULL),(226,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 272','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 272',307000.00,1,1,NULL),(227,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 73','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 73',108000.00,1,1,NULL),(228,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 173','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 173',208000.00,1,1,NULL),(229,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 273','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 273',308000.00,1,1,NULL),(230,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 74','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 74',109000.00,1,1,NULL),(231,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 174','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 174',209000.00,1,1,NULL),(232,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 274','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 274',309000.00,1,1,NULL),(233,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 75','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 75',110000.00,1,1,NULL),(234,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 175','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 175',210000.00,1,1,NULL),(235,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 275','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 275',310000.00,1,1,NULL),(236,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 76','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 76',111000.00,1,1,NULL),(237,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 176','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 176',211000.00,1,1,NULL),(238,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 276','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 276',311000.00,1,1,NULL),(239,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 77','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 77',112000.00,1,1,NULL),(240,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 177','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 177',212000.00,1,1,NULL),(241,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 277','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 277',312000.00,1,1,NULL),(242,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 78','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 78',113000.00,1,1,NULL),(243,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 178','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 178',213000.00,1,1,NULL),(244,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 278','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 278',313000.00,1,1,NULL),(245,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 79','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 79',114000.00,1,1,NULL),(246,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 179','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 179',214000.00,1,1,NULL),(247,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 279','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 279',314000.00,1,1,NULL),(248,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 80','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 80',115000.00,1,1,NULL),(249,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 180','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 180',215000.00,1,1,NULL),(250,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 280','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 280',315000.00,1,1,NULL),(251,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 81','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 81',116000.00,1,1,NULL),(252,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 181','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 181',216000.00,1,1,NULL),(253,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 281','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 281',316000.00,1,1,NULL),(254,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 82','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 82',117000.00,1,1,NULL),(255,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 182','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 182',217000.00,1,1,NULL),(256,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 282','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 282',317000.00,1,1,NULL),(257,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 83','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 83',118000.00,1,1,NULL),(258,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 183','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 183',218000.00,1,1,NULL),(259,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 283','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 283',318000.00,1,1,NULL),(260,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 84','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 84',119000.00,1,1,NULL),(261,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 184','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 184',219000.00,1,1,NULL),(262,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 284','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 284',319000.00,1,1,NULL),(263,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 85','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 85',120000.00,1,1,NULL),(264,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 185','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 185',220000.00,1,1,NULL),(265,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 285','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 285',320000.00,1,1,NULL),(266,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 86','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 86',121000.00,1,1,NULL),(267,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 186','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 186',221000.00,1,1,NULL),(268,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 286','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 286',321000.00,1,1,NULL),(269,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 87','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 87',122000.00,1,1,NULL),(270,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 187','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 187',222000.00,1,1,NULL),(271,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 287','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 287',322000.00,1,1,NULL),(272,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 88','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 88',123000.00,1,1,NULL),(273,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 188','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 188',223000.00,1,1,NULL),(274,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 288','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 288',323000.00,1,1,NULL),(275,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 89','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 89',124000.00,1,1,NULL),(276,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 189','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 189',224000.00,1,1,NULL),(277,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 289','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 289',324000.00,1,1,NULL),(278,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 90','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 90',125000.00,1,1,NULL),(279,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 190','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 190',225000.00,1,1,NULL),(280,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 290','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 290',325000.00,1,1,NULL),(281,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 91','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 91',126000.00,1,1,NULL),(282,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 191','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 191',226000.00,1,1,NULL),(283,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 291','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 291',326000.00,1,1,NULL),(284,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 92','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 92',127000.00,1,1,NULL),(285,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 192','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 192',227000.00,1,1,NULL),(286,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 292','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 292',327000.00,1,1,NULL),(287,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 93','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 93',128000.00,1,1,NULL),(288,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 193','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 193',228000.00,1,1,NULL),(289,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 293','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 293',328000.00,1,1,NULL),(290,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 94','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 94',129000.00,1,1,NULL),(291,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 194','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 194',229000.00,1,1,NULL),(292,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 294','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 294',329000.00,1,1,NULL),(293,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 95','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 95',130000.00,1,1,NULL),(294,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 195','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 195',230000.00,1,1,NULL),(295,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 295','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 295',330000.00,1,1,NULL),(296,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 96','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 96',131000.00,1,1,NULL),(297,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 196','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 196',231000.00,1,1,NULL),(298,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 296','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 296',331000.00,1,1,NULL),(299,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 97','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 97',132000.00,1,1,NULL),(300,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 197','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 197',232000.00,1,1,NULL),(301,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 297','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 297',332000.00,1,1,NULL),(302,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 98','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 98',133000.00,1,1,NULL),(303,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 198','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 198',233000.00,1,1,NULL),(304,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 298','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 298',333000.00,1,1,NULL),(305,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 99','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 99',134000.00,1,1,NULL),(306,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 199','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 199',234000.00,1,1,NULL),(307,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 299','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 299',334000.00,1,1,NULL),(308,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 100','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 100',135000.00,1,1,NULL),(309,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 200','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 200',235000.00,1,1,NULL),(310,'Ă?c s?n ?m th?c vĂ¹ng mi?n th? 300','MĂ´ t? hĂ½Ăµng v? vĂ  vĂ£n hĂ³a c?a mĂ³n Ă£n Ă°?c s?n th? 300',335000.00,1,1,NULL);
/*!40000 ALTER TABLE `mon_an` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_an_di_ung`
--

DROP TABLE IF EXISTS `mon_an_di_ung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mon_an_di_ung` (
  `mon_an_id` int(11) NOT NULL,
  `di_ung_id` int(11) NOT NULL,
  `ghi_chu` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`di_ung_id`),
  KEY `di_ung_id` (`di_ung_id`),
  CONSTRAINT `mon_an_di_ung_ibfk_1` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `mon_an_di_ung_ibfk_2` FOREIGN KEY (`di_ung_id`) REFERENCES `di_ung_thuc_pham` (`di_ung_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_an_di_ung`
--

LOCK TABLES `mon_an_di_ung` WRITE;
/*!40000 ALTER TABLE `mon_an_di_ung` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_an_di_ung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_an_dip_le`
--

DROP TABLE IF EXISTS `mon_an_dip_le`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mon_an_dip_le` (
  `mon_an_id` int(11) NOT NULL,
  `dip_le_id` int(11) NOT NULL,
  `ghi_chu` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`dip_le_id`),
  KEY `dip_le_id` (`dip_le_id`),
  CONSTRAINT `mon_an_dip_le_ibfk_1` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `mon_an_dip_le_ibfk_2` FOREIGN KEY (`dip_le_id`) REFERENCES `dip_le` (`dip_le_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_an_dip_le`
--

LOCK TABLES `mon_an_dip_le` WRITE;
/*!40000 ALTER TABLE `mon_an_dip_le` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_an_dip_le` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_an_mua_vu`
--

DROP TABLE IF EXISTS `mon_an_mua_vu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mon_an_mua_vu` (
  `mon_an_id` int(11) NOT NULL,
  `mua_vu_id` int(11) NOT NULL,
  `ghi_chu` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`mua_vu_id`),
  KEY `mua_vu_id` (`mua_vu_id`),
  CONSTRAINT `mon_an_mua_vu_ibfk_1` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `mon_an_mua_vu_ibfk_2` FOREIGN KEY (`mua_vu_id`) REFERENCES `mua_vu` (`mua_vu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_an_mua_vu`
--

LOCK TABLES `mon_an_mua_vu` WRITE;
/*!40000 ALTER TABLE `mon_an_mua_vu` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_an_mua_vu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mon_an_nguyen_lieu`
--

DROP TABLE IF EXISTS `mon_an_nguyen_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mon_an_nguyen_lieu` (
  `mon_an_id` int(11) NOT NULL,
  `nguyen_lieu_id` int(11) NOT NULL,
  `so_luong` varchar(100) DEFAULT NULL,
  `don_vi` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`mon_an_id`,`nguyen_lieu_id`),
  KEY `nguyen_lieu_id` (`nguyen_lieu_id`),
  CONSTRAINT `mon_an_nguyen_lieu_ibfk_1` FOREIGN KEY (`mon_an_id`) REFERENCES `mon_an` (`mon_an_id`),
  CONSTRAINT `mon_an_nguyen_lieu_ibfk_2` FOREIGN KEY (`nguyen_lieu_id`) REFERENCES `nguyen_lieu` (`nguyen_lieu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mon_an_nguyen_lieu`
--

LOCK TABLES `mon_an_nguyen_lieu` WRITE;
/*!40000 ALTER TABLE `mon_an_nguyen_lieu` DISABLE KEYS */;
/*!40000 ALTER TABLE `mon_an_nguyen_lieu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mua_vu`
--

DROP TABLE IF EXISTS `mua_vu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mua_vu` (
  `mua_vu_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_mua` varchar(100) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  PRIMARY KEY (`mua_vu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mua_vu`
--

LOCK TABLES `mua_vu` WRITE;
/*!40000 ALTER TABLE `mua_vu` DISABLE KEYS */;
/*!40000 ALTER TABLE `mua_vu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguoi_dung`
--

DROP TABLE IF EXISTS `nguoi_dung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nguoi_dung` (
  `nguoi_dung_id` int(11) NOT NULL AUTO_INCREMENT,
  `ho_ten` varchar(150) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `mat_khau` varchar(255) DEFAULT NULL,
  `vai_tro` enum('khach_du_lich','cong_tac_vien','quan_tri_vien') DEFAULT 'khach_du_lich',
  PRIMARY KEY (`nguoi_dung_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguoi_dung`
--

LOCK TABLES `nguoi_dung` WRITE;
/*!40000 ALTER TABLE `nguoi_dung` DISABLE KEYS */;
/*!40000 ALTER TABLE `nguoi_dung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nguyen_lieu`
--

DROP TABLE IF EXISTS `nguyen_lieu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nguyen_lieu` (
  `nguyen_lieu_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_nguyen_lieu` varchar(150) NOT NULL,
  PRIMARY KEY (`nguyen_lieu_id`),
  UNIQUE KEY `ten_nguyen_lieu` (`ten_nguyen_lieu`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nguyen_lieu`
--

LOCK TABLES `nguyen_lieu` WRITE;
/*!40000 ALTER TABLE `nguyen_lieu` DISABLE KEYS */;
/*!40000 ALTER TABLE `nguyen_lieu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tinh_thanh`
--

DROP TABLE IF EXISTS `tinh_thanh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tinh_thanh` (
  `tinh_thanh_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_tinh` varchar(100) NOT NULL,
  `vung_mien_id` int(11) NOT NULL,
  PRIMARY KEY (`tinh_thanh_id`),
  KEY `vung_mien_id` (`vung_mien_id`),
  CONSTRAINT `tinh_thanh_ibfk_1` FOREIGN KEY (`vung_mien_id`) REFERENCES `vung_mien` (`vung_mien_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tinh_thanh`
--

LOCK TABLES `tinh_thanh` WRITE;
/*!40000 ALTER TABLE `tinh_thanh` DISABLE KEYS */;
INSERT INTO `tinh_thanh` VALUES (1,'HĂƒÂ  NĂ¡Â»â„¢i',1),(2,'HĂ¡ÂºÂ£i PhĂƒÂ²ng',1),(3,'HĂƒÂ  Giang',1),(4,'HuĂ¡ÂºÂ¿',2),(5,'Ă„ÂĂƒÂ  NĂ¡ÂºÂµng',2),(6,'QuĂ¡ÂºÂ£ng Nam',2),(7,'TP. HĂ¡Â»â€œ ChĂƒÂ­ Minh',3),(8,'CĂ¡ÂºÂ§n ThĂ†Â¡',3),(9,'An Giang',3);
/*!40000 ALTER TABLE `tinh_thanh` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vung_mien`
--

DROP TABLE IF EXISTS `vung_mien`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vung_mien` (
  `vung_mien_id` int(11) NOT NULL AUTO_INCREMENT,
  `ten_vung` varchar(100) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  PRIMARY KEY (`vung_mien_id`),
  UNIQUE KEY `ten_vung` (`ten_vung`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vung_mien`
--

LOCK TABLES `vung_mien` WRITE;
/*!40000 ALTER TABLE `vung_mien` DISABLE KEYS */;
INSERT INTO `vung_mien` VALUES (1,'MiĂ¡Â»Ân BĂ¡ÂºÂ¯c','Khu vĂ¡Â»Â±c phĂƒÂ­a BĂ¡ÂºÂ¯c ViĂ¡Â»â€¡t Nam'),(2,'MiĂ¡Â»Ân Trung','Khu vĂ¡Â»Â±c miĂ¡Â»Ân Trung ViĂ¡Â»â€¡t Nam'),(3,'MiĂ¡Â»Ân Nam','Khu vĂ¡Â»Â±c phĂƒÂ­a Nam ViĂ¡Â»â€¡t Nam');
/*!40000 ALTER TABLE `vung_mien` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-17 21:24:23
