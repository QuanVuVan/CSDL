# Hệ thống Cơ sở Dữ liệu Sàn Thương mại Điện tử Đa kênh & Kho Thông minh (EcommerceSmartWarehouse)

Dự án thiết kế, cài đặt và tối ưu hóa hệ thống cơ sở dữ liệu quan hệ cho sàn thương mại điện tử đa kênh kết hợp quản lý kho bãi thông minh, chuẩn 3NF trên nền tảng **MySQL 8.0+ InnoDB**.

---

## 📌 1. Danh sách 14 Thực thể chuẩn hóa

Hệ thống được thiết kế đầy đủ 14 thực thể theo đúng chuẩn nghiệp vụ thương mại điện tử và kho vận:

1. **`DanhMuc`**: Quản lý cây danh mục sản phẩm đa cấp (tự tham chiếu `DanhMucChaID`).
2. **`GianHang`**: Quản lý các đối tác bán hàng (Seller) trên sàn.
3. **`NhaCungCap`**: Nhà sản xuất, phân phối nguồn hàng chính hãng.
4. **`KhoHang`**: Hệ thống các trung tâm kho vận đa điểm.
5. **`SanPham`**: Mặt hàng thương mại dùng chung.
6. **`BienTheSanPham`**: Biến thể chi tiết theo SKU, màu sắc, kích cỡ, giá nhập, giá bán.
7. **`TonKho`**: Bảng liên kết nhiều - nhiều giữa Kho và Biến thể, khóa chính ghép `(MaKho, MaBienThe)`.
8. **`KhachHang`**: Người tiêu dùng đăng ký tài khoản trên nền tảng.
9. **`Voucher`**: Mã giảm giá, khuyến mãi sàn và điều kiện áp dụng.
10. **`DonHang`**: Hóa đơn đặt hàng trung tâm của hệ thống.
11. **`ChiTietDonHang`**: Bảng liên kết nhiều - nhiều giữa Đơn hàng và Biến thể, khóa chính ghép `(MaDonHang, MaBienThe)`.
12. **`ThanhToan`**: Giao dịch chứng từ thanh toán (Quan hệ 1 - 1 với `DonHang`).
13. **`VanChuyen`**: Thông tin vận đơn logistics giao nhận (Quan hệ 1 - 1 với `DonHang`).
14. **`DanhGia`**: Đánh giá, chấm điểm chất lượng (1-5 sao) sau khi đơn giao thành công.

---

## 📂 2. Cấu trúc Thư mục Dự án

```text
├── 01_schema_triggers.sql       # Khởi tạo CSDL, 14 bảng, ràng buộc FK/CHECK và 4 Triggers tự động
├── 02_seed_data.sql             # Dữ liệu mẫu chuẩn hóa đầy đủ 14 bảng
├── 03_queries.sql               # 8 câu truy vấn phân tích nghiệp vụ từ cơ bản đến nâng cao (OLAP, CTE, Window Functions)
├── so_do_erd.html               # Sơ đồ ERD tương tác (Interactive Canvas) khổ lớn với ký pháp Crow's Foot
├── xem_erd.bat                  # Script khởi chạy nhanh sơ đồ ERD trên trình duyệt
├── index.html                   # Dashboard demo (Live MySQL qua API, fallback mô phỏng)
├── server.py                    # API server Python + pymysql kết nối MySQL
├── chay_demo.bat                # Cài pymysql và khởi động server demo
├── BaoCao_ThietKe_CSDL.md       # Báo cáo thuyết minh kỹ thuật chi tiết
└── README.md                    # Tài liệu hướng dẫn dự án
```

---

## 🚀 3. Hướng dẫn Cài đặt & Chạy Thực tế

### Bước 1: Khởi động MySQL trong XAMPP
* Mở **XAMPP Control Panel**.
* Bấm **Start** dịch vụ **MySQL** (cổng mặc định `3306`).

### Bước 2: Nạp CSDL và Dữ liệu mẫu
Mở Terminal / PowerShell tại thư mục dự án và thực thi:

```bash
# Nạp Schema và Triggers
mysql -u root < 01_schema_triggers.sql

# Nạp Dữ liệu mẫu
mysql -u root < 02_seed_data.sql
```

### Bước 3: Chạy các Truy vấn Nghiệp vụ
* Mở file `03_queries.sql` trong VS Code hoặc MySQL Workbench / phpMyAdmin.
* Thực thi từng câu truy vấn từ 1 đến 8 để xem báo cáo thống kê và phân tích.

### Bước 4: Mở Sơ đồ ERD Trực quan
* Nhấp đúp vào file `xem_erd.bat` hoặc mở trực tiếp `so_do_erd.html` bằng trình duyệt (Chrome, Edge, Firefox).
* Sử dụng chuột để kéo thả, cuộn chuột để phóng to/thu nhỏ, hoặc chuyển đổi giữa 5 chế độ phân hệ chuyên biệt.

### Bước 5: Chạy Dashboard kết nối MySQL
* Nhấp đúp `chay_demo.bat` (tự cài `pymysql` nếu cần) hoặc chạy:

```bash
python server.py
```

* Mở `http://localhost:8080/index.html`.
* Nếu API kết nối được MySQL, góc phải header hiện **“Live MySQL: ecommercesmartwarehouse”**; các thao tác xuất/nhập/điều chuyển sẽ ghi trực tiếp vào database.
* Nếu chưa chạy server, dashboard tự chuyển sang **chế độ mô phỏng client** (không ghi DB).

---

## ⚡ 4. 4 Triggers Nghiệp vụ Tự động Hóa

1. **`trg_check_voucher_before_insert`**: Tự động kiểm tra tính hợp lệ của mã giảm giá (thời hạn, số lượt còn lại, giá trị đơn tối thiểu) trước khi tạo đơn.
2. **`trg_deduct_voucher_after_order`**: Tự động trừ 1 vào số lượng voucher sau khi đơn hàng được ghi nhận.
3. **`trg_update_stock_on_order_status`**: Tự động trừ tồn kho khi đơn hàng chuyển sang `DaXacNhan` và tự động hoàn trả tồn kho nếu đơn bị `Cancelled`.
4. **`trg_check_review_eligibility`**: Kiểm soát chặt chẽ đánh giá: Khách hàng chỉ được phép đánh giá sản phẩm sau khi đơn hàng chứa sản phẩm đó đã chuyển sang trạng thái `DaGiao`.

---

## 📊 5. Danh sách 8 Truy vấn Nghiệp vụ Cốt lõi

1. **Query 1:** `INNER JOIN` 4 bảng + `GROUP BY` + `HAVING` $\rightarrow$ Top sản phẩm điện thoại có đánh giá $\ge 4.5$ sao.
2. **Query 2:** Nối 5 bảng liên tiếp $\rightarrow$ Tra cứu chi tiết lịch sử mua sắm của một khách hàng.
3. **Query 3:** `SUM` + `COUNT` $\rightarrow$ Thống kê doanh thu thuần từng gian hàng sau khi trừ voucher.
4. **Query 4:** `Conditional Aggregation` (`CASE WHEN` lồng trong `SUM`) $\rightarrow$ Cảnh báo gian hàng có tỷ lệ hủy đơn $> 10\%$.
5. **Query 5:** `LEFT OUTER JOIN` đa tầng + `COALESCE` $\rightarrow$ Thống kê tồn kho danh mục cấp 1 (giữ cả danh mục chưa có hàng).
6. **Query 6:** Correlated Subquery `NOT EXISTS` + `DATEDIFF` $\rightarrow$ Tìm khách hàng ngủ đông đăng ký $> 1$ năm chưa phát sinh đơn.
7. **Query 7:** Toán tử so sánh tập hợp `> ALL` $\rightarrow$ Tìm sản phẩm cao cấp đắt hơn tất cả các mặt hàng của đối tác FPT.
8. **Query 8:** `CTE` + `WINDOW FUNCTION (SUM OVER)` + `LAG()` $\rightarrow$ Phân tích doanh thu lũy kế theo ngày và bắt chính xác ngày đầu tiên cán mốc 1 tỷ VNĐ.
