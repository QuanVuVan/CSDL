---
name: clean-dashboard-ui
description: Thiết kế giao diện Dashboard quản trị dữ liệu tối giản, sắc nét theo chuẩn Linear/Stripe, loại bỏ hoàn toàn các chi tiết thừa và icon trang trí kiểu AI.
---

# Quy chuẩn Thiết kế Dashboard Tối giản & Chuyên nghiệp

Khi xây dựng giao diện Dashboard hiển thị dữ liệu (React, Next.js, Tailwind CSS hoặc HTML/CSS), tuân thủ nghiêm ngặt các nguyên tắc thẩm mỹ sau:

## 1. Quy tắc "Không Icon Thừa" (Anti-AI Cliché)
- **Cấm tuyệt đối Emoji** trong toàn bộ giao diện, tiêu đề, bảng dữ liệu và thông báo.
- **Không đặt các khối icon tròn/vuông màu mè** bên cạnh tiêu đề các thẻ KPI (ví dụ: không vẽ icon túi tiền hay giỏ hàng bên cạnh mục "Tổng doanh thu"). Để con số và tiêu đề tự lên tiếng.
- Chỉ sử dụng icon SVG nét mảnh (`stroke-width: 1.5`, kích thước `16px`) cho các thành phần điều hướng bắt buộc: menu sidebar, nút tìm kiếm, mũi tên sắp xếp bảng, hoặc dấu chấm trạng thái (`6px` dot).

## 2. Hệ thống Màu sắc Kiềm chế (Restrained Palette)
- **Nền chủ đạo:** Sử dụng tông trung tính sạch sẽ: nền tổng thể `#FAFAFA` (`zinc-50`), nền thẻ dữ liệu `#FFFFFF` (`white`).
- **Đường viền thay cho đổ bóng:** Hạn chế tối đa `box-shadow`. Phân tách các khối bằng đường viền mảnh `1px solid #E4E4E7` (`border-zinc-200`) và bo góc vừa phải (`6px` hoặc `8px`).
- **Màu nhấn (Accent):** Chỉ chọn **1 màu nhấn duy nhất** (ví dụ: Đen than `#18181B` hoặc Xanh dương đậm `#0F172A`) cho nút hành động chính và đường biểu đồ chính. Màu trạng thái chỉ dùng ở mức độ nhẹ nhàng (xanh lá nhạt cho hoàn tất, đỏ nhạt cho hủy đơn).

## 3. Typography & Hiển thị Số liệu
- Sử dụng font chữ hiện đại, sắc nét (`Inter`, `Geist Sans`, hoặc `Plus Jakarta Sans`).
- **Bắt buộc dùng `font-variant-numeric: tabular-nums`** cho mọi con số doanh thu, số lượng tồn kho, tỷ lệ phần trăm và ngày tháng để các cột số thẳng hàng tuyệt đối theo chiều dọc.
- Phân cấp rõ ràng: Nhãn KPI viết chữ nhỏ (`12px`–`13px`, màu `#71717A`), giá trị chính viết đậm (`24px`–`28px`, `font-weight: 600`, màu `#09090B`, `tracking-tight`).

## 4. Bố cục & Trực quan hóa Dữ liệu
- **Cấu trúc lưới (Grid):** Sử dụng bố cục lưới 12 cột chuẩn xác với khoảng cách đều (`gap-4` hoặc `gap-6`), nhiều khoảng trắng thở, không nhồi nhét quá 4 thẻ KPI trên một hàng ngang.
- **Biểu đồ sạch (Clean Charts):** Tắt các đường lưới ngang dọc rườm rà trên biểu đồ (chỉ giữ lưới ngang nét đứt siêu mờ), không tô màu nền gradient dưới đường line chart quá đậm, tooltip khi di chuột phải có nền trắng viền mảnh `1px`.
- **Bảng dữ liệu (Data Tables):** Tiêu đề cột căn lề khớp với nội dung (chữ căn trái, số tiền/số lượng căn phải), chiều cao mỗi hàng thoáng (`44px`–`48px`), hiệu ứng hover nhẹ nhàng (`hover:bg-zinc-50`).

## 5. Quy chuẩn Mã nguồn Frontend
- Toàn bộ mã nguồn (HTML, CSS, JS/TSX) phải viết sạch, **tuyệt đối không chèn chú thích nội dòng (inline comments)**.
- Dữ liệu hiển thị trên Dashboard phải ánh xạ trực tiếp từ kết quả của các truy vấn phân tích CSDL (doanh thu lũy kế, tỷ lệ hủy đơn, danh mục tồn kho, sản phẩm đánh giá cao).