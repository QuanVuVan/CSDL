---
name: sql-constraint-trigger
description: Viết mã nguồn DDL tạo bảng, thiết lập ràng buộc CHECK, UNIQUE, khóa chính tổ hợp và lập trình TRIGGER xử lý quy tắc nghiệp vụ phức tạp trong SQL.
---

# Quy chuẩn Lập trình DDL, Ràng buộc & Trigger

Khi chuyển đổi lược đồ quan hệ thành mã SQL thực thi (mặc định T-SQL cho SQL Server trừ khi có chỉ định khác), tuân thủ nghiêm ngặt các nguyên tắc sau:

## 1. Quy chuẩn Mã nguồn SQL
- Viết câu lệnh chuẩn xác, định dạng thụt lề rõ ràng, đặt tên bảng và cột nhất quán (PascalCase).
- **Tuyệt đối không chèn chú thích nội dòng (inline comments `--` hoặc `/* */`)** bên trong mã SQL.
- Sắp xếp thứ tự `CREATE TABLE` từ bảng cha (không có khóa ngoại) đến bảng con để chạy một lần không gặp lỗi tham chiếu.

## 2. Ràng buộc Tĩnh (Static Constraints)
- **CHECK Constraints:**
  - Giá bán phải lớn hơn giá nhập: `CHECK (GiaBan > GiaNhap)`
  - Phần trăm giảm giá hợp lệ: `CHECK (PhanTramGiamGia BETWEEN 1 AND 100)`
  - Số lượng tồn kho không âm: `CHECK (SoLuongTonKho >= 0)`
- **UNIQUE & Composite Keys:**
  - Mã `SKU` trên bảng biến thể sản phẩm bắt buộc khai báo `UNIQUE`.
  - Bảng `ChiTietDonHang` bắt buộc sử dụng khóa chính tổ hợp `PRIMARY KEY (MaDonHang, MaBienThe)`.

## 3. Lập trình Trigger Nghiệp vụ (Dynamic Business Rules)
Sử dụng `TRIGGER` kết hợp quản lý giao dịch (`ROLLBACK TRANSACTION` và `RAISERROR` / `THROW`) để bảo vệ 3 quy tắc cốt lõi:
1. **Trigger Kiểm tra Voucher (`trg_KiemTraVoucherDonHang`):** Kích hoạt khi `INSERT` hoặc `UPDATE` cột `MaVoucher` trên `DonHang`. Kiểm tra `TongTienDonHang >= GiaTriToiThieu` và `NgayDatHang <= NgayHetHan`. Vi phạm thì hủy giao dịch.
2. **Trigger Kiểm tra Đánh giá (`trg_KiemTraDieuKienDanhGia`):** Kích hoạt khi `INSERT` vào `DanhGia`. Truy vấn kiểm tra khách hàng có tồn tại đơn hàng chứa biến thể sản phẩm đó với trạng thái `TrangThai = 'DaGiao'` hay không. Nếu chưa giao thành công thì từ chối ghi nhận.
3. **Trigger Trừ Tồn kho Tự động (`trg_CapNhatTonKhoKhiXacNhan`):** Kích hoạt khi `UPDATE` cột `TrangThai` trên `DonHang` chuyển từ trạng thái khác sang `'DaXacNhan'`. Kiểm tra khả dụng tồn kho của toàn bộ sản phẩm trong đơn; nếu thiếu hàng thì báo lỗi và `ROLLBACK`, nếu đủ thì trừ tương ứng `SoLuongTonKho`.