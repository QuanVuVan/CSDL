---
name: db-schema-architect
description: Phân tích nghiệp vụ, mô hình hóa thực thể kết hợp (E/R), vẽ sơ đồ Mermaid và chuẩn hóa lược đồ cơ sở dữ liệu đạt chuẩn 3NF cho hệ thống E-commerce & Kho thông minh.
---

# Quy trình Thiết kế Kiến trúc Cơ sở dữ liệu (E/R & 3NF)

Khi được yêu cầu phân tích nghiệp vụ hoặc thiết kế cấu trúc bảng cho hệ thống Thương mại điện tử và Kho hàng, thực hiện tuần tự các bước sau:

## 1. Phân rã Thực thể & Mối quan hệ
- **Danh mục phân cấp (Self-referencing):** Thiết kế bảng `DanhMuc` có khóa ngoại tự tham chiếu `DanhMucChaID` trỏ về `MaDanhMuc` (cho phép `NULL` đối với danh mục cấp 1).
- **Tách biệt Sản phẩm & Biến thể:** Tách riêng thông tin chung (`SanPham`: Tên, Mô tả, Thương hiệu, Danh mục, Gian hàng, Nhà cung cấp) và thuộc tính biến thiên (`BienTheSanPham`: Màu sắc, Kích cỡ, Mã `SKU`, Giá nhập, Giá bán) để tránh dư thừa dữ liệu.
- **Quản lý Kho đa điểm:** Tách bảng `KhoHang` và bảng trung gian `TonKho` (`MaKho`, `MaBienThe`, `SoLuongTonKho`) nhằm hỗ trợ lưu trữ nhiều kho.
- **Quy trình Đơn hàng khép kín:** Thiết lập đầy đủ các thực thể `KhachHang`, `GianHang` (Seller), `NhaCungCap`, `Voucher`, `DonHang`, `ChiTietDonHang`, `ThanhToan`, `VanChuyen`, và `DanhGia`.

## 2. Kiểm tra Chuẩn hóa 3NF
- **1NF:** Đảm bảo mọi thuộc tính đều nguyên tử, không chứa nhóm lặp hay mảng giá trị trong một cột.
- **2NF:** Mọi thuộc tính không khóa phải phụ thuộc hàm đầy đủ vào toàn bộ khóa chính (đặc biệt kiểm tra kỹ bảng có khóa chính tổ hợp như `ChiTietDonHang` và `TonKho`).
- **3NF:** Loại bỏ hoàn toàn phụ thuộc bắc cầu (ví dụ: không lưu `TenDanhMuc` hay `TenGianHang` trong bảng `BienTheSanPham`; không lưu `GiaTriGiam` của Voucher lặp lại nếu không cần chốt lịch sử tách biệt).
- Trình bày rõ ràng lý do tách bảng để chứng minh lược đồ đạt 3NF.

## 3. Trực quan hóa Sơ đồ E/R
- Xuất toàn bộ sơ đồ thực thể kết hợp bằng cú pháp chuẩn **Mermaid** (`erDiagram`), ghi rõ kiểu dữ liệu, `PK`, `FK`, `UK` và ký hiệu bản số (`||--o{`, `}|--||`).