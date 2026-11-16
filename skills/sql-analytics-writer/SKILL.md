---
name: sql-analytics-writer
description: Viết hệ thống truy vấn phân tích dữ liệu SQL nâng cao sử dụng CTE, Window Functions, Subqueries, Outer Joins và các hàm tổng hợp.
---

# Quy chuẩn Viết Truy vấn Phân tích Dữ liệu (SQL Analytics)

Khi xây dựng các câu truy vấn khai thác dữ liệu theo yêu cầu nghiệp vụ, tuân thủ các tiêu chuẩn kỹ thuật sau:

## 1. Quy chuẩn Code Sạch & Hiệu năng
- **Tuyệt đối không chèn chú thích nội dòng (inline comments)** trong mã SQL.
- Không sử dụng `SELECT *`; luôn chỉ định rõ danh sách cột cần lấy và đặt bí danh (Alias) tường minh cho từng bảng.
- Xử lý giá trị `NULL` an toàn bằng `COALESCE` hoặc `ISNULL` trong các phép tính tổng (`SUM`) và đếm (`COUNT`) khi dùng `OUTER JOIN`.

## 2. Chuẩn Kỹ thuật cho 8 Dạng Truy vấn Trọng tâm
1. **Cơ bản & Lọc nhóm:** Kết nối `DanhMuc` -> `SanPham` -> `BienTheSanPham` -> `DanhGia`, lọc danh mục `"Điện thoại"`, nhóm theo sản phẩm và lọc `HAVING AVG(CAST(SoSao AS FLOAT)) >= 4.5`.
2. **Inner Join đa bảng:** Kết nối `KhachHang` -> `DonHang` -> `ChiTietDonHang` -> `BienTheSanPham` -> `SanPham` với điều kiện `HoTen = N'Nguyễn Văn A'`.
3. **Group By & Aggregate:** Tính doanh thu thuần của từng gian hàng trong tháng 10/2026 bằng công thức tổng tiền hàng trừ đi giá trị giảm giá từ `Voucher` (chỉ tính các đơn hợp lệ/không bị hủy).
4. **Having nâng cao:** Tính tỷ lệ phần trăm đơn hủy theo từng gian hàng trong tháng bằng biểu thức điều kiện `SUM(CASE WHEN TrangThai = 'Cancelled' THEN 1.0 ELSE 0 END) / COUNT(*) > 0.10`.
5. **Outer Join:** Xuất phát từ bảng `DanhMuc` với điều kiện `DanhMucChaID IS NULL`, dùng `LEFT JOIN` sang danh mục con (nếu có), `SanPham`, `BienTheSanPham` và `TonKho` để hiển thị cả danh mục có tổng tồn kho bằng `0`.
6. **Subquery với NOT EXISTS:** Lọc khách hàng có khoảng cách từ `NgayDangKy` đến ngày hiện tại lớn hơn 1 năm (`DATEDIFF(DAY, NgayDangKy, GETDATE()) > 365`) kết hợp `WHERE NOT EXISTS (SELECT 1 FROM DonHang ...)`.
7. **Complex Subquery:** Sử dụng toán tử so sánh tập hợp `> ALL (SELECT ...)` để tìm các biến thể có `GiaBan` lớn hơn toàn bộ biến thể thuộc nhà cung cấp X.
8. **Window Functions & CTE:**
   - Tạo `CTE_DoanhThuNgay` tổng hợp doanh thu từng ngày trong tháng.
   - Sử dụng `SUM(DoanhThuNgay) OVER (PARTITION BY YEAR(Ngay), MONTH(Ngay) ORDER BY Ngay ASC ROWS UNBOUNDED PRECEDING)` để tính doanh thu lũy kế.
   - Dùng `CTE` kế tiếp hoặc `MIN(Ngay)` lọc điều kiện `DoanhThuLuyKe >= 1000000000` để xác định chính xác mốc ngày đầu tiên chạm ngưỡng 1 tỷ VNĐ.