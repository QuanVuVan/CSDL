-- Active: 1794827011207@@127.0.0.1@3306@ecommercesmartwarehouse

USE EcommerceSmartWarehouse;

SELECT 
    sp.MaSanPham,
    sp.TenSanPham,
    sp.ThuongHieu,
    dm.TenDanhMuc,
    ROUND(AVG(dg.SoSao), 2) AS DiemDanhGiaTrungBinh,
    COUNT(dg.MaDanhGia) AS SoLuotDanhGia
FROM DanhMuc dm
INNER JOIN SanPham sp ON dm.MaDanhMuc = sp.MaDanhMuc
INNER JOIN BienTheSanPham bt ON sp.MaSanPham = bt.MaSanPham
INNER JOIN DanhGia dg ON bt.MaBienThe = dg.MaBienThe
WHERE dm.TenDanhMuc = 'Điện thoại'
GROUP BY sp.MaSanPham, sp.TenSanPham, sp.ThuongHieu, dm.TenDanhMuc
HAVING AVG(dg.SoSao) >= 4.5;

SELECT 
    kh.HoTen AS TenKhachHang,
    dh.MaDonHang,
    dh.NgayDatHang,
    sp.TenSanPham,
    bt.MauSac,
    bt.KichCo,
    ct.SoLuong,
    ct.DonGia,
    ct.ThanhTien
FROM KhachHang kh
INNER JOIN DonHang dh ON kh.MaKhachHang = dh.MaKhachHang
INNER JOIN ChiTietDonHang ct ON dh.MaDonHang = ct.MaDonHang
INNER JOIN BienTheSanPham bt ON ct.MaBienThe = bt.MaBienThe
INNER JOIN SanPham sp ON bt.MaSanPham = sp.MaSanPham
WHERE kh.HoTen = 'Nguyễn Văn A';

SELECT 
    gh.MaGianHang,
    gh.TenGianHang,
    COUNT(dh.MaDonHang) AS SoDonThanhCong,
    SUM(dh.TongTienHang) AS TongTienHangGoc,
    SUM(dh.SoTienGiam) AS TongTienGiamVoucher,
    SUM(dh.TongTienHang - dh.SoTienGiam) AS DoanhThuThuan
FROM GianHang gh
INNER JOIN DonHang dh ON gh.MaGianHang = dh.MaGianHang
WHERE dh.TrangThai <> 'Cancelled'
  AND YEAR(dh.NgayDatHang) = 2026
  AND MONTH(dh.NgayDatHang) = 10
GROUP BY gh.MaGianHang, gh.TenGianHang
ORDER BY DoanhThuThuan DESC;

SELECT 
    gh.MaGianHang,
    gh.TenGianHang,
    COUNT(dh.MaDonHang) AS TongSoDonHang,
    SUM(CASE WHEN dh.TrangThai = 'Cancelled' THEN 1 ELSE 0 END) AS SoDonBiHuy,
    ROUND((SUM(CASE WHEN dh.TrangThai = 'Cancelled' THEN 1.0 ELSE 0.0 END) / COUNT(dh.MaDonHang)) * 100, 2) AS TyLeHuyPercent
FROM GianHang gh
INNER JOIN DonHang dh ON gh.MaGianHang = dh.MaGianHang
WHERE YEAR(dh.NgayDatHang) = 2026
  AND MONTH(dh.NgayDatHang) = 10
GROUP BY gh.MaGianHang, gh.TenGianHang
HAVING (SUM(CASE WHEN dh.TrangThai = 'Cancelled' THEN 1.0 ELSE 0.0 END) / COUNT(dh.MaDonHang)) > 0.10;

SELECT 
    dm1.MaDanhMuc,
    dm1.TenDanhMuc,
    COALESCE(SUM(tk.SoLuongTonKho), 0) AS TongSoLuongTonKho
FROM DanhMuc dm1
LEFT OUTER JOIN DanhMuc dm2 ON dm2.DanhMucChaID = dm1.MaDanhMuc
LEFT OUTER JOIN SanPham sp ON (sp.MaDanhMuc = dm1.MaDanhMuc OR sp.MaDanhMuc = dm2.MaDanhMuc)
LEFT OUTER JOIN BienTheSanPham bt ON sp.MaSanPham = bt.MaSanPham
LEFT OUTER JOIN TonKho tk ON bt.MaBienThe = tk.MaBienThe
WHERE dm1.DanhMucChaID IS NULL
GROUP BY dm1.MaDanhMuc, dm1.TenDanhMuc
ORDER BY TongSoLuongTonKho DESC;

SELECT 
    kh.MaKhachHang,
    kh.HoTen,
    kh.Email,
    kh.SoDienThoai,
    kh.NgayDangKy,
    DATEDIFF(CURDATE(), kh.NgayDangKy) AS SoNgayDangKy
FROM KhachHang kh
WHERE DATEDIFF(CURDATE(), kh.NgayDangKy) > 365
  AND NOT EXISTS (
      SELECT 1
      FROM DonHang dh
      WHERE dh.MaKhachHang = kh.MaKhachHang
  );

SELECT 
    sp.TenSanPham,
    bt.MaBienThe,
    bt.SKU,
    bt.MauSac,
    bt.KichCo,
    bt.GiaBan
FROM BienTheSanPham bt
INNER JOIN SanPham sp ON bt.MaSanPham = sp.MaSanPham
WHERE bt.GiaBan > ALL (
    SELECT bt_sub.GiaBan
    FROM BienTheSanPham bt_sub
    INNER JOIN SanPham sp_sub ON bt_sub.MaSanPham = sp_sub.MaSanPham
    INNER JOIN NhaCungCap ncc ON sp_sub.MaNhaCungCap = ncc.MaNhaCungCap
    WHERE ncc.TenNhaCungCap = 'Công ty TNHH Phân phối FPT'
)
ORDER BY bt.GiaBan DESC;

WITH CTE_DoanhThuNgay AS (
    SELECT 
        DATE(dh.NgayDatHang) AS Ngay,
        SUM(dh.TongThanhToan) AS DoanhThuNgay
    FROM DonHang dh
    WHERE dh.TrangThai <> 'Cancelled'
      AND YEAR(dh.NgayDatHang) = 2026
      AND MONTH(dh.NgayDatHang) = 10
    GROUP BY DATE(dh.NgayDatHang)
),
CTE_LuyKe AS (
    SELECT 
        Ngay,
        DoanhThuNgay,
        SUM(DoanhThuNgay) OVER (
            PARTITION BY YEAR(Ngay), MONTH(Ngay)
            ORDER BY Ngay ASC
            ROWS UNBOUNDED PRECEDING
        ) AS DoanhThuLuyKe
    FROM CTE_DoanhThuNgay
)
SELECT 
    Ngay,
    DoanhThuNgay,
    DoanhThuLuyKe,
    CASE 
        WHEN DoanhThuLuyKe >= 1000000000.00 
             AND COALESCE(LAG(DoanhThuLuyKe, 1) OVER (ORDER BY Ngay ASC), 0) < 1000000000.00 
        THEN 'Mốc đầu tiên đạt ngưỡng 1 tỷ VNĐ'
        WHEN DoanhThuLuyKe >= 1000000000.00 THEN 'Trên ngưỡng 1 tỷ VNĐ'
        ELSE 'Chưa đạt 1 tỷ VNĐ'
    END AS TrangThaiCotMoc
FROM CTE_LuyKe
ORDER BY Ngay ASC;
-- Xem danh mục phân cấp cha - con
SELECT 
    dm.MaDanhMuc,
    dm.TenDanhMuc,
    dm.DanhMucChaID,
    cha.TenDanhMuc AS TenDanhMucCha,
    CASE 
        WHEN dm.DanhMucChaID IS NULL THEN 'Cấp 1 (Gốc)'
        ELSE 'Cấp 2 (Con)'
    END AS CapBac
FROM DanhMuc dm
LEFT JOIN DanhMuc cha ON dm.DanhMucChaID = cha.MaDanhMuc;

-- Xem toàn bộ dữ liệu trong các bảng
SELECT * FROM DanhMuc;
SELECT * FROM SanPham;
SELECT * FROM BienTheSanPham;
SELECT * FROM TonKho;
SELECT * FROM DonHang;
SELECT * FROM ChiTietDonHang;
SELECT * FROM KhachHang;
SELECT * FROM DanhGia;
SELECT * FROM GianHang;
SELECT * FROM NhaCungCap;
SELECT * FROM Voucher;
SELECT * FROM VanChuyen;
SELECT * FROM ThanhToan;
SELECT * FROM KhoHang;
