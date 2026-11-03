USE am_thuc_vung_mien;

INSERT INTO vung_mien (vung_mien_id, ten_vung, mo_ta) VALUES
(1, 'Miền Bắc', 'Khu vực phía Bắc Việt Nam'),
(2, 'Miền Trung', 'Khu vực miền Trung Việt Nam'),
(3, 'Miền Nam', 'Khu vực phía Nam Việt Nam');

INSERT INTO tinh_thanh (tinh_thanh_id, ten_tinh, vung_mien_id) VALUES
(1, 'Hà Nội', 1),
(2, 'Hải Phòng', 1),
(3, 'Hà Giang', 1),
(4, 'Huế', 2),
(5, 'Đà Nẵng', 2),
(6, 'Quảng Nam', 2),
(7, 'TP. Hồ Chí Minh', 3),
(8, 'Cần Thơ', 3),
(9, 'An Giang', 3);

INSERT INTO dia_diem
(dia_diem_id, ten_dia_diem, dia_chi, kinh_do, vi_do, tinh_thanh_id)
VALUES
(1, 'Phố cổ Hà Nội', 'Hoàn Kiếm, Hà Nội', 105.8542, 21.0285, 1),
(2, 'Chợ Đồng Xuân', 'Hoàn Kiếm, Hà Nội', 105.8470, 21.0380, 1),
(3, 'Chợ Cát Bi', 'Hải An, Hải Phòng', 106.6780, 20.8449, 2),
(4, 'Chợ trung tâm Đồng Văn', 'Đồng Văn, Hà Giang', 105.3580, 23.2780, 3),
(5, 'Đại Nội Huế', 'Thành phố Huế', 107.5780, 16.4698, 4),
(6, 'Chợ Hàn', 'Hải Châu, Đà Nẵng', 108.2181, 16.0678, 5),
(7, 'Phố cổ Hội An', 'Hội An, Quảng Nam', 108.3270, 15.8801, 6),
(8, 'Chợ Bến Thành', 'Quận 1, TP. Hồ Chí Minh', 106.6980, 10.7720, 7),
(9, 'Chợ nổi Cái Răng', 'Cái Răng, Cần Thơ', 105.7840, 10.0070, 8),
(10, 'Chợ Châu Đốc', 'Châu Đốc, An Giang', 105.1167, 10.7000, 9);

INSERT INTO mon_an
(mon_an_id, ten_mon, mo_ta, gia_tham_khao, vung_mien_id, tinh_thanh_id, dia_diem_id)
VALUES
(1, 'Phở Hà Nội', 'Món ăn truyền thống nổi tiếng của Hà Nội', 50000, 1, 1, 1),
(2, 'Bún chả Hà Nội', 'Bún ăn kèm thịt nướng và nước chấm', 60000, 1, 1, 2),
(3, 'Bánh đa cua Hải Phòng', 'Món ăn đặc trưng của Hải Phòng', 45000, 1, 2, 3),
(4, 'Bánh cuốn Đồng Văn', 'Bánh cuốn nóng đặc sản vùng cao Hà Giang', 40000, 1, 3, 4),
(5, 'Bún bò Huế', 'Món bún cay đặc trưng của cố đô Huế', 55000, 2, 4, 5),
(6, 'Mì Quảng', 'Món mì đặc sản của Quảng Nam', 55000, 2, 6, 7),
(7, 'Cơm tấm Sài Gòn', 'Cơm tấm ăn kèm sườn nướng', 60000, 3, 7, 8),
(8, 'Bánh xèo miền Tây', 'Bánh xèo giòn với nhân tôm thịt', 50000, 3, 8, 9),
(9, 'Bún cá Châu Đốc', 'Món bún cá nổi tiếng của An Giang', 55000, 3, 9, 10),
(10, 'Cao lầu Hội An', 'Món mì đặc trưng của phố cổ Hội An', 65000, 2, 6, 7);

COMMIT;