---
name: sql-seed-generator
description: Sinh dữ liệu mẫu DML (INSERT INTO) có tính toán chủ đích để kiểm thử toàn diện các ràng buộc, Trigger và 8 kịch bản truy vấn phức tạp.
---

# Quy trình Sinh Dữ liệu Mẫu Kiểm thử (Deterministic Seeding)

Khi được yêu cầu tạo dữ liệu mẫu (`INSERT INTO`), không sinh dữ liệu ngẫu nhiên vô nghĩa mà phải thiết kế bộ dữ liệu bao phủ toàn bộ kịch bản kiểm thử:

## 1. Quy tắc Định dạng & Thứ tự Nạp
- **Tuyệt đối không chèn chú thích nội dòng (inline comments)** trong khối mã SQL.
- Nạp dữ liệu theo đúng thứ tự phụ thuộc khóa ngoại (Danh mục -> Người dùng/Khách hàng -> Gian hàng -> Nhà cung cấp -> Kho -> Sản phẩm -> Biến thể -> Tồn kho -> Voucher -> Đơn hàng -> Chi tiết đơn hàng -> Thanh toán -> Vận chuyển -> Đánh giá).
- Sử dụng dữ liệu tiếng Việt có dấu tự nhiên, thực tế (tiền tố `N'...'` nếu dùng SQL Server).

## 2. Ma trận Dữ liệu Bắt buộc (Test Coverage)
Dữ liệu sinh ra phải đảm bảo **tất cả** các truy vấn phân tích đều trả về kết quả có ý nghĩa:
1. **Danh mục & Đánh giá:** Có danh mục `"Điện thoại"` chứa các sản phẩm có điểm đánh giá trung bình `>= 4.5` sao, kèm ít nhất 1 sản phẩm dưới `4.5` sao để kiểm chứng bộ lọc.
2. **Khách hàng mục tiêu:** Có khách hàng tên `"Nguyễn Văn A"` sở hữu ít nhất 2 đơn hàng với nhiều biến thể (màu sắc, kích cỡ khác nhau).
3. **Doanh thu theo thời gian:** Có các đơn hàng hoàn tất trong **tháng 10/2026** (có áp dụng Voucher) và tổng doanh thu toàn sàn trong một tháng được tính toán vượt mốc **1.000.000.000 VNĐ** (1 tỷ đồng) để kiểm thử hàm lũy kế.
4. **Tỷ lệ hủy đơn:** Có ít nhất 1 gian hàng có số đơn `TrangThai = 'Cancelled'` chiếm trên **10%** tổng số đơn nhận được trong tháng, và 1 gian hàng dưới 10%.
5. **Dữ liệu biên (Edge Cases):**
   - Có ít nhất 1 danh mục cấp 1 (`DanhMucChaID IS NULL`) chưa có bất kỳ sản phẩm nào (kiểm thử `LEFT OUTER JOIN`).
   - Có ít nhất 1 khách hàng đăng ký tài khoản trên **1 năm** nhưng chưa từng phát sinh đơn hàng nào (kiểm thử `NOT EXISTS`).
   - Có các biến thể sản phẩm thuộc cùng một nhà cung cấp với mức giá phân tầng rõ rệt để kiểm thử truy vấn so sánh `ALL`.