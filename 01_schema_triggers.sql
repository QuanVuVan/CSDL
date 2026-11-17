-- Active: 1794808148472@@127.0.0.1@3306@test

DROP DATABASE IF EXISTS EcommerceSmartWarehouse;
CREATE DATABASE EcommerceSmartWarehouse CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE EcommerceSmartWarehouse;

CREATE TABLE DanhMuc (
    MaDanhMuc INT AUTO_INCREMENT PRIMARY KEY,
    TenDanhMuc VARCHAR(100) NOT NULL,
    DanhMucChaID INT NULL,
    MoTa TEXT NULL,
    CONSTRAINT fk_danhmuc_cha FOREIGN KEY (DanhMucChaID) REFERENCES DanhMuc(MaDanhMuc) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE GianHang (
    MaGianHang INT AUTO_INCREMENT PRIMARY KEY,
    TenGianHang VARCHAR(150) NOT NULL,
    NguoiDaiDien VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    SoDienThoai VARCHAR(20) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL,
    NgayThamGia DATE NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NhaCungCap (
    MaNhaCungCap INT AUTO_INCREMENT PRIMARY KEY,
    TenNhaCungCap VARCHAR(150) NOT NULL,
    NguoiLienHe VARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KhoHang (
    MaKho INT AUTO_INCREMENT PRIMARY KEY,
    TenKho VARCHAR(150) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL,
    SucChua INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SanPham (
    MaSanPham INT AUTO_INCREMENT PRIMARY KEY,
    TenSanPham VARCHAR(200) NOT NULL,
    MoTa TEXT NULL,
    ThuongHieu VARCHAR(100) NOT NULL,
    MaDanhMuc INT NOT NULL,
    MaGianHang INT NOT NULL,
    MaNhaCungCap INT NOT NULL,
    NgayTao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sanpham_danhmuc FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc) ON UPDATE CASCADE,
    CONSTRAINT fk_sanpham_gianhang FOREIGN KEY (MaGianHang) REFERENCES GianHang(MaGianHang) ON UPDATE CASCADE,
    CONSTRAINT fk_sanpham_nhacungcap FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE BienTheSanPham (
    MaBienThe INT AUTO_INCREMENT PRIMARY KEY,
    MaSanPham INT NOT NULL,
    MauSac VARCHAR(50) NOT NULL,
    KichCo VARCHAR(50) NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    GiaNhap DECIMAL(15, 2) NOT NULL,
    GiaBan DECIMAL(15, 2) NOT NULL,
    CONSTRAINT fk_bienthe_sanpham FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_bienthe_giaban CHECK (GiaBan > GiaNhap)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE TonKho (
    MaKho INT NOT NULL,
    MaBienThe INT NOT NULL,
    SoLuongTonKho INT NOT NULL DEFAULT 0,
    PRIMARY KEY (MaKho, MaBienThe),
    CONSTRAINT fk_tonkho_kho FOREIGN KEY (MaKho) REFERENCES KhoHang(MaKho) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_tonkho_bienthe FOREIGN KEY (MaBienThe) REFERENCES BienTheSanPham(MaBienThe) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_tonkho_soluong CHECK (SoLuongTonKho >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KhachHang (
    MaKhachHang INT AUTO_INCREMENT PRIMARY KEY,
    HoTen VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    SoDienThoai VARCHAR(20) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL,
    NgayDangKy DATE NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Voucher (
    MaVoucher INT AUTO_INCREMENT PRIMARY KEY,
    CodeVoucher VARCHAR(50) NOT NULL UNIQUE,
    MoTa VARCHAR(255) NULL,
    PhanTramGiamGia INT NOT NULL,
    GiaTriGiamToiDa DECIMAL(15, 2) NOT NULL,
    GiaTriDonHangToiThieu DECIMAL(15, 2) NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    SoLuong INT NOT NULL DEFAULT 100,
    CONSTRAINT chk_voucher_phantram CHECK (PhanTramGiamGia BETWEEN 1 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DonHang (
    MaDonHang INT AUTO_INCREMENT PRIMARY KEY,
    MaKhachHang INT NOT NULL,
    MaGianHang INT NOT NULL,
    MaKho INT NOT NULL,
    MaVoucher INT NULL,
    NgayDatHang DATETIME NOT NULL,
    TongTienHang DECIMAL(15, 2) NOT NULL,
    SoTienGiam DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    TongThanhToan DECIMAL(15, 2) NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'ChoXacNhan',
    CONSTRAINT fk_donhang_khachhang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang) ON UPDATE CASCADE,
    CONSTRAINT fk_donhang_gianhang FOREIGN KEY (MaGianHang) REFERENCES GianHang(MaGianHang) ON UPDATE CASCADE,
    CONSTRAINT fk_donhang_kho FOREIGN KEY (MaKho) REFERENCES KhoHang(MaKho) ON UPDATE CASCADE,
    CONSTRAINT fk_donhang_voucher FOREIGN KEY (MaVoucher) REFERENCES Voucher(MaVoucher) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ChiTietDonHang (
    MaDonHang INT NOT NULL,
    MaBienThe INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(15, 2) NOT NULL,
    ThanhTien DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (MaDonHang, MaBienThe),
    CONSTRAINT fk_chitiet_donhang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_chitiet_bienthe FOREIGN KEY (MaBienThe) REFERENCES BienTheSanPham(MaBienThe) ON UPDATE CASCADE,
    CONSTRAINT chk_chitiet_soluong CHECK (SoLuong > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ThanhToan (
    MaThanhToan INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL UNIQUE,
    PhuongThuc VARCHAR(50) NOT NULL,
    SoTien DECIMAL(15, 2) NOT NULL,
    NgayThanhToan DATETIME NOT NULL,
    TrangThai VARCHAR(30) NOT NULL,
    CONSTRAINT fk_thanhtoan_donhang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE VanChuyen (
    MaVanChuyen INT AUTO_INCREMENT PRIMARY KEY,
    MaDonHang INT NOT NULL UNIQUE,
    DonViVanChuyen VARCHAR(100) NOT NULL,
    MaVanDon VARCHAR(100) NOT NULL UNIQUE,
    PhiVanChuyen DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    NgayGiaoDuKien DATE NOT NULL,
    NgayGiaoThucTe DATE NULL,
    TrangThai VARCHAR(30) NOT NULL,
    CONSTRAINT fk_vanchuyen_donhang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DanhGia (
    MaDanhGia INT AUTO_INCREMENT PRIMARY KEY,
    MaKhachHang INT NOT NULL,
    MaBienThe INT NOT NULL,
    MaDonHang INT NOT NULL,
    SoSao INT NOT NULL,
    BinhLuan TEXT NULL,
    NgayDanhGia DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_danhgia_khachhang FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang) ON UPDATE CASCADE,
    CONSTRAINT fk_danhgia_bienthe FOREIGN KEY (MaBienThe) REFERENCES BienTheSanPham(MaBienThe) ON UPDATE CASCADE,
    CONSTRAINT fk_danhgia_donhang FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang) ON UPDATE CASCADE,
    CONSTRAINT chk_danhgia_sosao CHECK (SoSao BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER //

CREATE TRIGGER trg_KiemTraVoucherDonHang_Insert
BEFORE INSERT ON DonHang
FOR EACH ROW
BEGIN
    DECLARE v_GiaTriToiThieu DECIMAL(15, 2);
    DECLARE v_NgayBatDau DATE;
    DECLARE v_NgayHetHan DATE;

    IF NEW.MaVoucher IS NOT NULL THEN
        SELECT GiaTriDonHangToiThieu, NgayBatDau, NgayHetHan
        INTO v_GiaTriToiThieu, v_NgayBatDau, v_NgayHetHan
        FROM Voucher
        WHERE MaVoucher = NEW.MaVoucher;

        IF NEW.TongTienHang < v_GiaTriToiThieu THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Gia tri don hang chua dat muc toi thieu de ap dung voucher';
        END IF;

        IF DATE(NEW.NgayDatHang) < v_NgayBatDau OR DATE(NEW.NgayDatHang) > v_NgayHetHan THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Voucher da het han hoac chua den dot ap dung';
        END IF;
    END IF;
END //

CREATE TRIGGER trg_KiemTraVoucherDonHang_Update
BEFORE UPDATE ON DonHang
FOR EACH ROW
BEGIN
    DECLARE v_GiaTriToiThieu DECIMAL(15, 2);
    DECLARE v_NgayBatDau DATE;
    DECLARE v_NgayHetHan DATE;

    IF NEW.MaVoucher IS NOT NULL THEN
        SELECT GiaTriDonHangToiThieu, NgayBatDau, NgayHetHan
        INTO v_GiaTriToiThieu, v_NgayBatDau, v_NgayHetHan
        FROM Voucher
        WHERE MaVoucher = NEW.MaVoucher;

        IF NEW.TongTienHang < v_GiaTriToiThieu THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Gia tri don hang chua dat muc toi thieu de ap dung voucher';
        END IF;

        IF DATE(NEW.NgayDatHang) < v_NgayBatDau OR DATE(NEW.NgayDatHang) > v_NgayHetHan THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Voucher da het han hoac chua den dot ap dung';
        END IF;
    END IF;
END //

CREATE TRIGGER trg_KiemTraDieuKienDanhGia
BEFORE INSERT ON DanhGia
FOR EACH ROW
BEGIN
    DECLARE v_HopLe INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_HopLe
    FROM DonHang dh
    INNER JOIN ChiTietDonHang ct ON dh.MaDonHang = ct.MaDonHang
    WHERE dh.MaDonHang = NEW.MaDonHang
      AND dh.MaKhachHang = NEW.MaKhachHang
      AND ct.MaBienThe = NEW.MaBienThe
      AND dh.TrangThai = 'DaGiao';

    IF v_HopLe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Chi duoc danh gia bien the san pham khi don hang da o trang thai DaGiao';
    END IF;
END //

CREATE TRIGGER trg_CapNhatTonKhoKhiXacNhan
AFTER UPDATE ON DonHang
FOR EACH ROW
BEGIN
    DECLARE v_ThieuHang INT DEFAULT 0;

    IF OLD.TrangThai <> 'DaXacNhan' AND NEW.TrangThai = 'DaXacNhan' THEN
        SELECT COUNT(*)
        INTO v_ThieuHang
        FROM ChiTietDonHang ct
        LEFT JOIN TonKho tk ON ct.MaBienThe = tk.MaBienThe AND tk.MaKho = NEW.MaKho
        WHERE ct.MaDonHang = NEW.MaDonHang
          AND (tk.SoLuongTonKho IS NULL OR tk.SoLuongTonKho < ct.SoLuong);

        IF v_ThieuHang > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'So luong ton kho khong du de xac nhan don hang';
        END IF;

        UPDATE TonKho tk
        INNER JOIN ChiTietDonHang ct ON tk.MaBienThe = ct.MaBienThe
        SET tk.SoLuongTonKho = tk.SoLuongTonKho - ct.SoLuong
        WHERE ct.MaDonHang = NEW.MaDonHang
          AND tk.MaKho = NEW.MaKho;
    END IF;
END //

DELIMITER ;
