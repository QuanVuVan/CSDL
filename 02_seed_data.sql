-- Active: 1794827011207@@127.0.0.1@3306@mysql
USE EcommerceSmartWarehouse;

INSERT INTO DanhMuc (MaDanhMuc, TenDanhMuc, DanhMucChaID, MoTa) VALUES
(1, 'Thiết bị điện tử', NULL, 'Các sản phẩm công nghệ, linh kiện điện tử cao cấp'),
(2, 'Điện thoại', 1, 'Điện thoại thông minh, smartphone các thương hiệu hàng đầu'),
(3, 'Laptop & Máy tính', 1, 'Máy tính xách tay, máy tính để bàn và phụ kiện máy tính'),
(4, 'Thời trang & Phụ kiện', NULL, 'Trang phục thời trang nam nữ, túi xách và phụ kiện cao cấp'),
(5, 'Thời trang Nam', 4, 'Áo sơ mi, áo polo, quần âu nam phong cách công sở hiện đại'),
(6, 'Gia dụng thông minh', NULL, 'Thiết bị nhà bếp, thiết bị gia đình tiện ích thông minh'),
(7, 'Sách & Văn phòng phẩm', NULL, 'Sách giáo trình, tác phẩm văn học và dụng cụ học tập'),
(8, 'Ô tô & Xe máy', NULL, 'Phụ tùng ô tô xe máy, xe máy điện và đồ chơi xe cộ');

INSERT INTO GianHang (MaGianHang, TenGianHang, NguoiDaiDien, Email, SoDienThoai, DiaChi, NgayThamGia, TrangThai) VALUES
(1, 'TechZone Official', 'Nguyễn Thanh Tùng', 'contact@techzone.vn', '0901234567', 'Tòa nhà Landmark 72, Nam Từ Liêm, Hà Nội', '2023-01-10', 'Active'),
(2, 'Apple Authorized Store', 'Trần Bảo Long', 'sales@applestore.vn', '0902345678', 'Số 29 Liễu Giai, Ba Đình, Hà Nội', '2023-03-15', 'Active'),
(3, 'SamCenter Vietnam', 'Lê Quỳnh Nga', 'support@samcenter.vn', '0903456789', 'Số 98 Nguyễn Huệ, Quận 1, TP Hồ Chí Minh', '2023-05-20', 'Active'),
(4, 'Thời Trang Aristino', 'Phạm Hoàng Yến', 'info@aristino.vn', '0904567890', 'Số 169 Thái Hà, Đống Đa, Hà Nội', '2023-08-12', 'Active'),
(5, 'Gia Dụng Sunhouse', 'Đặng Quốc Huy', 'cskh@sunhouse.vn', '0905678901', 'Số 38 Đại lộ Thăng Long, Cầu Giấy, Hà Nội', '2024-01-05', 'Active'),
(6, 'Phụ Kiện Anker Mall', 'Võ Hoài Nam', 'contact@anker.vn', '0906789012', 'Số 246 Cống Quỳnh, Quận 1, TP Hồ Chí Minh', '2024-04-18', 'Active');

INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, NguoiLienHe, SoDienThoai, Email, DiaChi) VALUES
(1, 'Công ty Cổ phần Phân phối Digiworld', 'Bùi Văn Hưng', '0243768999', 'info@digiworld.com.vn', 'Số 195 Cô Bắc, Quận 1, TP Hồ Chí Minh'),
(2, 'Công ty TNHH Phân phối FPT', 'Ngô Quang Minh', '0247300666', 'contact@synnexfpt.com.vn', 'Tòa nhà FPT Cầu Giấy, 17 Duy Tân, Hà Nội'),
(3, 'Công ty TNHH Apple Vietnam', 'Claire Dupont', '0283827888', 'vietnam_support@apple.com', 'Tầng 33 Vietcombank Tower, Quận 1, TP Hồ Chí Minh'),
(4, 'Công ty TNHH Điện tử Samsung Vina', 'Kim Dong Won', '0283915777', 'samsungvina@samsung.com', 'Số 2 Hải Triều, Bến Nghé, Quận 1, TP Hồ Chí Minh'),
(5, 'Công ty Cổ phần Tập đoàn Sunhouse', 'Nguyễn Xuân Thắng', '0243736666', 'sunhouse@sunhouse.com.vn', 'KCN Ngọc Hồi, Thanh Trì, Hà Nội'),
(6, 'Công ty TNHH Dệt may Quốc tế D&N', 'Hoàng Minh Tuấn', '0243852111', 'dntextile@fashioncorp.vn', 'KCN Tiên Sơn, Tiên Du, Bắc Ninh');

INSERT INTO KhoHang (MaKho, TenKho, DiaChi, SucChua) VALUES
(1, 'Kho Tổng Hà Nội - KCN Đài Tư', 'KCN Đài Tư, 386 Nguyễn Văn Linh, Long Biên, Hà Nội', 50000),
(2, 'Kho Phía Nam - KCN Tân Bình', 'Lô B14 KCN Tân Bình, Tây Thạnh, Tân Phú, TP Hồ Chí Minh', 60000),
(3, 'Kho Trung Chuyển Đà Nẵng', 'Đường số 3, KCN Hòa Cầm, Cẩm Lệ, Đà Nẵng', 20000),
(4, 'Kho Vệ Tinh Hải Phòng', 'Km 9 Đường 5 Mới, Nam Sơn, An Dương, Hải Phòng', 15000),
(5, 'Kho Vận Cần Thơ', 'Lô 2A KCN Trà Nóc 1, Bình Thủy, Cần Thơ', 15000),
(6, 'Kho Thông Minh Bắc Ninh', 'KCN VSIP Bắc Ninh, Phù Chẩn, Từ Sơn, Bắc Ninh', 80000);

INSERT INTO SanPham (MaSanPham, TenSanPham, MoTa, ThuongHieu, MaDanhMuc, MaGianHang, MaNhaCungCap, NgayTao) VALUES
(1, 'iPhone 15 Pro Max', 'Điện thoại flagship cao cấp khung viền Titan và chip A17 Pro mạnh mẽ', 'Apple', 2, 2, 3, '2024-01-15 08:00:00'),
(2, 'Samsung Galaxy S24 Ultra', 'Smartphone tích hợp trí tuệ nhân tạo Galaxy AI cùng camera 200MP zoom ấn tượng', 'Samsung', 2, 3, 4, '2024-02-01 09:30:00'),
(3, 'Xiaomi Redmi Note 13', 'Điện thoại quốc dân phân khúc tầm trung với màn hình AMOLED 120Hz mượt mà', 'Xiaomi', 2, 1, 2, '2024-03-10 10:15:00'),
(4, 'Laptop Dell XPS 15', 'Dòng máy tính xách tay cao cấp dành cho doanh nhân và đồ họa chuyên nghiệp', 'Dell', 3, 1, 1, '2024-02-20 14:00:00'),
(5, 'Laptop Asus Vivobook 15', 'Laptop văn phòng mỏng nhẹ cấu hình ổn định đáp ứng tốt tác vụ học tập làm việc', 'Asus', 3, 1, 2, '2024-03-01 11:20:00'),
(6, 'Áo Sơ Mi Nam Công Sở', 'Áo sơ mi nam sợi tre Bamboo kháng khuẩn chống nhăn dáng vừa vặn lịch lãm', 'Aristino', 5, 4, 6, '2024-04-05 16:45:00'),
(7, 'Nồi Chiên Không Dầu Sunhouse 6L', 'Nồi chiên công nghệ Rapid Air giảm đến 80 phần trăm lượng mỡ thừa', 'Sunhouse', 6, 5, 5, '2024-04-12 13:10:00'),
(8, 'Củ Sạc Nhanh Anker 65W GaN', 'Củ sạc công nghệ GaN nhỏ gọn sạc nhanh đa thiết bị an toàn bảo vệ mạch', 'Anker', 1, 6, 1, '2024-05-18 15:30:00');

INSERT INTO BienTheSanPham (MaBienThe, MaSanPham, MauSac, KichCo, SKU, GiaNhap, GiaBan) VALUES
(1, 1, 'Titan Tự Nhiên', '256GB', 'IP15PM-NAT-256', 25000000.00, 29990000.00),
(2, 1, 'Titan Xanh', '512GB', 'IP15PM-BLU-512', 29000000.00, 34990000.00),
(3, 2, 'Xám Titan', '256GB', 'S24U-GRY-256', 24000000.00, 28990000.00),
(4, 3, 'Đen Bán Dạ', '128GB', 'XIAOMI-RN13-BLK-128', 3800000.00, 4890000.00),
(5, 3, 'Xanh Băng Tuyết', '256GB', 'XIAOMI-RN13-BLU-256', 4500000.00, 5990000.00),
(6, 4, 'Bạc Platinum', '32GB-1TB', 'DELL-XPS15-SLV-1TB', 42000000.00, 49990000.00),
(7, 5, 'Bạc Ánh Trăng', '16GB-512GB', 'ASUS-VIVO15-SLV-512', 13000000.00, 16500000.00),
(8, 6, 'Trắng', 'L', 'ARI-SOMI-WHT-L', 350000.00, 650000.00),
(9, 7, 'Đen Bóng', '6L', 'SUN-AF60-BLK-6L', 1100000.00, 1850000.00),
(10, 8, 'Đen Nhám', '65W', 'ANK-65W-BLK', 550000.00, 890000.00);

INSERT INTO TonKho (MaKho, MaBienThe, SoLuongTonKho) VALUES
(1, 1, 120),
(2, 1, 85),
(1, 2, 60),
(2, 3, 95),
(1, 4, 200),
(3, 5, 150),
(1, 6, 40),
(2, 7, 75),
(1, 8, 300),
(2, 9, 180);

INSERT INTO KhachHang (MaKhachHang, HoTen, Email, SoDienThoai, DiaChi, NgayDangKy, TrangThai) VALUES
(1, 'Nguyễn Văn A', 'nguyenvana@gmail.com', '0981112233', 'Số 12 Chùa Bộc, Đống Đa, Hà Nội', '2023-02-15', 'Active'),
(2, 'Trần Thị Bích', 'tranthibich@gmail.com', '0982223344', 'Số 45 Lê Lợi, Quận 1, TP Hồ Chí Minh', '2023-05-20', 'Active'),
(3, 'Lê Hoàng Nam', 'lehoangnam@gmail.com', '0983334455', 'Số 88 Nguyễn Văn Linh, Hải Châu, Đà Nẵng', '2023-09-10', 'Active'),
(4, 'Phạm Minh Đức', 'phamminhduc@gmail.com', '0984445566', 'Số 102 Trần Phú, Hà Đông, Hà Nội', '2024-01-12', 'Active'),
(5, 'Vũ Hải Yến', 'vuhaiyen@gmail.com', '0985556677', 'Số 36 Cầu Giấy, Cầu Giấy, Hà Nội', '2024-03-25', 'Active'),
(6, 'Hoàng Văn Tuấn', 'hoangvantuan@gmail.com', '0986667788', 'Số 79 Hùng Vương, Hồng Bàng, Hải Phòng', '2024-05-10', 'Active'),
(7, 'Đỗ Thị Mai', 'dothimai@gmail.com', '0987778899', 'Số 15 3 Tháng 2, Ninh Kiều, Cần Thơ', '2024-08-15', 'Active'),
(8, 'Nguyễn Thu Hà', 'nguyenthuha@gmail.com', '0988889900', 'Số 22 Hai Bà Trưng, Hoàn Kiếm, Hà Nội', '2026-09-01', 'Active');

INSERT INTO Voucher (MaVoucher, CodeVoucher, MoTa, PhanTramGiamGia, GiaTriGiamToiDa, GiaTriDonHangToiThieu, NgayBatDau, NgayHetHan, SoLuong) VALUES
(1, 'SIEUSALE10', 'Đại tiệc siêu sale tháng 10 giảm 10 phần trăm tối đa 20 triệu', 10, 20000000.00, 50000000.00, '2026-10-01', '2026-10-31', 100),
(2, 'VIPOCTOBER', 'Tri ân khách hàng VIP tháng 10 giảm 15 phần trăm tối đa 30 triệu', 15, 30000000.00, 100000000.00, '2026-10-01', '2026-10-31', 50),
(3, 'TECHSALE05', 'Giảm giá đồ công nghệ 5 phần trăm tối đa 5 triệu', 5, 5000000.00, 10000000.00, '2026-10-01', '2026-10-31', 200),
(4, 'WELCOME2026', 'Chào mừng thành viên mới giảm 10 phần trăm tối đa 500 nghìn', 10, 500000.00, 1000000.00, '2026-01-01', '2026-12-31', 500),
(5, 'FREESHIPMAX', 'Hỗ trợ chiết khấu vận chuyển tối đa 50 nghìn', 100, 50000.00, 200000.00, '2026-10-01', '2026-10-31', 1000),
(6, 'MEGAEXP', 'Mã khuyến mãi đã hết hạn lưu trữ lịch sử', 20, 1000000.00, 2000000.00, '2025-01-01', '2025-06-30', 50);

INSERT INTO DonHang (MaDonHang, MaKhachHang, MaGianHang, MaKho, MaVoucher, NgayDatHang, TongTienHang, SoTienGiam, TongThanhToan, TrangThai) VALUES
(1, 1, 2, 1, 1, '2026-10-05 09:30:00', 299900000.00, 20000000.00, 279900000.00, 'DaGiao'),
(2, 1, 3, 2, 1, '2026-10-10 14:15:00', 319900000.00, 20000000.00, 299900000.00, 'DaGiao'),
(3, 2, 1, 1, 2, '2026-10-15 10:45:00', 299940000.00, 30000000.00, 269940000.00, 'DaGiao'),
(4, 3, 4, 1, NULL, '2026-10-18 19:00:00', 6500000.00, 0.00, 6500000.00, 'DaGiao'),
(5, 3, 2, 1, 1, '2026-10-20 16:20:00', 209930000.00, 20000000.00, 189930000.00, 'DaGiao'),
(6, 4, 5, 2, NULL, '2026-10-22 13:45:00', 9250000.00, 0.00, 9250000.00, 'DaGiao'),
(7, 4, 1, 2, NULL, '2026-10-25 11:00:00', 165000000.00, 0.00, 165000000.00, 'DaGiao'),
(8, 5, 1, 1, NULL, '2026-10-28 15:30:00', 59900000.00, 0.00, 59900000.00, 'Cancelled'),
(9, 2, 1, 1, NULL, '2026-10-29 08:30:00', 24450000.00, 0.00, 24450000.00, 'DaGiao');

INSERT INTO ChiTietDonHang (MaDonHang, MaBienThe, SoLuong, DonGia, ThanhTien) VALUES
(1, 1, 10, 29990000.00, 299900000.00),
(2, 2, 5, 34990000.00, 174950000.00),
(2, 3, 5, 28990000.00, 144950000.00),
(3, 6, 6, 49990000.00, 299940000.00),
(4, 8, 10, 650000.00, 6500000.00),
(5, 1, 7, 29990000.00, 209930000.00),
(6, 9, 5, 1850000.00, 9250000.00),
(7, 7, 10, 16500000.00, 165000000.00),
(8, 5, 10, 5990000.00, 59900000.00),
(9, 4, 5, 4890000.00, 24450000.00);

INSERT INTO ThanhToan (MaThanhToan, MaDonHang, PhuongThuc, SoTien, NgayThanhToan, TrangThai) VALUES
(1, 1, 'TheTinDung', 279900000.00, '2026-10-05 09:35:00', 'ThanhCong'),
(2, 2, 'ViDienTu', 299900000.00, '2026-10-10 14:20:00', 'ThanhCong'),
(3, 3, 'ChuyenKhoan', 269940000.00, '2026-10-15 10:50:00', 'ThanhCong'),
(4, 4, 'COD', 6500000.00, '2026-10-18 19:05:00', 'ThanhCong'),
(5, 5, 'TheTinDung', 189930000.00, '2026-10-20 16:25:00', 'ThanhCong'),
(6, 6, 'ViDienTu', 9250000.00, '2026-10-22 13:50:00', 'ThanhCong'),
(7, 7, 'ChuyenKhoan', 165000000.00, '2026-10-25 11:05:00', 'ThanhCong'),
(8, 8, 'COD', 59900000.00, '2026-10-28 15:35:00', 'HoanTien'),
(9, 9, 'ViDienTu', 24450000.00, '2026-10-29 08:35:00', 'ThanhCong');

INSERT INTO VanChuyen (MaVanChuyen, MaDonHang, DonViVanChuyen, MaVanDon, PhiVanChuyen, NgayGiaoDuKien, NgayGiaoThucTe, TrangThai) VALUES
(1, 1, 'SPX Express', 'VN_SPX_1001', 0.00, '2026-10-08', '2026-10-07', 'DaGiaoHang'),
(2, 2, 'GHTK', 'VN_GHTK_1002', 0.00, '2026-10-13', '2026-10-12', 'DaGiaoHang'),
(3, 3, 'Viettel Post', 'VN_VTP_1003', 0.00, '2026-10-18', '2026-10-17', 'DaGiaoHang'),
(4, 4, 'GHN', 'VN_GHN_1004', 30000.00, '2026-10-21', '2026-10-20', 'DaGiaoHang'),
(5, 5, 'SPX Express', 'VN_SPX_1005', 0.00, '2026-10-23', '2026-10-22', 'DaGiaoHang'),
(6, 6, 'GHN', 'VN_GHN_1006', 45000.00, '2026-10-25', '2026-10-24', 'DaGiaoHang'),
(7, 7, 'Viettel Post', 'VN_VTP_1007', 0.00, '2026-10-28', '2026-10-27', 'DaGiaoHang'),
(8, 8, 'GHTK', 'VN_GHTK_1008', 50000.00, '2026-10-31', NULL, 'GiaoThatBai'),
(9, 9, 'SPX Express', 'VN_SPX_1009', 25000.00, '2026-11-01', '2026-10-31', 'DaGiaoHang');

INSERT INTO DanhGia (MaDanhGia, MaKhachHang, MaBienThe, MaDonHang, SoSao, BinhLuan, NgayDanhGia) VALUES
(1, 1, 1, 1, 5, 'iPhone 15 Pro Max dùng rất mượt mà, màn hình đẹp tuyệt vời.', '2026-10-08 10:00:00'),
(2, 3, 1, 5, 5, 'Máy cầm nhẹ tay, camera chụp đêm xuất sắc, giao hàng siêu nhanh.', '2026-10-23 09:15:00'),
(3, 1, 3, 2, 5, 'Galaxy S24 Ultra màn hình phẳng hiển thị ngoài trời cực rõ, bút Spen tiện.', '2026-10-13 16:30:00'),
(4, 2, 4, 9, 3, 'Máy Xiaomi cấu hình khá nhưng chụp hình buổi tối bị nhiễu hạt nhiều.', '2026-11-01 11:20:00'),
(5, 2, 6, 3, 5, 'Dell XPS 15 thiết kế sang trọng, bàn phím gõ êm, màn hình sắc nét.', '2026-10-18 14:00:00'),
(6, 3, 8, 4, 4, 'Chất vải áo sơ mi mát mẻ, form áo vừa vặn với người, đóng gói kỹ.', '2026-10-21 20:30:00'),
(7, 4, 9, 6, 5, 'Nồi chiên không dầu dung tích lớn, chiên gà vịt nguyên con rất tiện lợi.', '2026-10-25 08:45:00'),
(8, 4, 7, 7, 4, 'Laptop Asus khởi động nhanh, pin ổn định, giá thành rất hợp lý.', '2026-10-28 17:15:00');
