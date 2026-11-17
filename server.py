import http.server
import socketserver
import webbrowser
import os
import json
import urllib.parse

try:
    import pymysql
    import pymysql.cursors
    HAVE_PYMYSQL = True
except ImportError:
    HAVE_PYMYSQL = False

PORT = 8080
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

MYSQL_CONFIG = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': '',
    'database': 'EcommerceSmartWarehouse',
    'charset': 'utf8mb4',
}


def get_connection():
    if not HAVE_PYMYSQL:
        return None
    return pymysql.connect(
        host=MYSQL_CONFIG['host'],
        port=MYSQL_CONFIG['port'],
        user=MYSQL_CONFIG['user'],
        password=MYSQL_CONFIG['password'],
        database=MYSQL_CONFIG['database'],
        charset=MYSQL_CONFIG['charset'],
        cursorclass=pymysql.cursors.DictCursor,
        autocommit=False,
    )


def query_db(sql, params=None):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params or ())
            return cur.fetchall()
    finally:
        conn.close()


class ReusableTCPServer(socketserver.TCPServer):
    allow_reuse_address = True


class LiveAPIHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        super().end_headers()

    def send_json(self, status_code, data):
        body = json.dumps(data, ensure_ascii=False).encode('utf-8')
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()
        self.wfile.write(body)

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_GET(self):
        path = urllib.parse.urlparse(self.path).path

        if path == '/api/status':
            if not HAVE_PYMYSQL:
                self.send_json(200, {
                    'ok': False,
                    'connected': False,
                    'error': 'Chua cai thu vien pymysql',
                    'hint': 'Chay: python -m pip install pymysql',
                })
                return
            try:
                rows = query_db('SELECT DATABASE() AS db')
                self.send_json(200, {
                    'ok': True,
                    'connected': True,
                    'host': '127.0.0.1:3306',
                    'database': rows[0]['db'],
                    'message': 'Ket noi MySQL thanh cong',
                })
            except Exception as e:
                self.send_json(200, {
                    'ok': False,
                    'connected': False,
                    'error': str(e),
                    'hint': 'Kiem tra MySQL XAMPP da chay va database EcommerceSmartWarehouse da duoc tao.',
                })
            return

        if path == '/api/inventory':
            try:
                rows = query_db("""
                    SELECT
                        tk.MaKho,
                        kh.TenKho,
                        tk.MaBienThe,
                        bt.SKU,
                        sp.TenSanPham,
                        bt.MauSac,
                        bt.KichCo,
                        CAST(bt.GiaBan AS DOUBLE) AS GiaBan,
                        tk.SoLuongTonKho,
                        sp.MaDanhMuc
                    FROM TonKho tk
                    INNER JOIN KhoHang kh ON kh.MaKho = tk.MaKho
                    INNER JOIN BienTheSanPham bt ON bt.MaBienThe = tk.MaBienThe
                    INNER JOIN SanPham sp ON sp.MaSanPham = bt.MaSanPham
                    ORDER BY tk.MaKho, tk.MaBienThe;
                """)
                self.send_json(200, {'ok': True, 'data': rows})
            except Exception as e:
                self.send_json(500, {'ok': False, 'error': str(e)})
            return

        if path == '/api/kpis':
            try:
                rev = query_db("""
                    SELECT COALESCE(SUM(TongThanhToan), 0) AS Rev
                    FROM DonHang
                    WHERE TrangThai <> 'Cancelled'
                      AND NgayDatHang >= '2026-10-01'
                      AND NgayDatHang < '2026-11-01';
                """)[0]['Rev']
                stk = query_db("SELECT COALESCE(SUM(SoLuongTonKho), 0) AS Stk FROM TonKho;")[0]['Stk']
                self.send_json(200, {'ok': True, 'revenue': float(rev), 'stock': int(stk)})
            except Exception as e:
                self.send_json(500, {'ok': False, 'error': str(e)})
            return

        super().do_GET()

    def do_POST(self):
        path = urllib.parse.urlparse(self.path).path
        length = int(self.headers.get('Content-Length', 0))
        raw = self.rfile.read(length) if length else b'{}'
        try:
            payload = json.loads(raw.decode('utf-8'))
        except Exception:
            payload = {}

        if path == '/api/deduct':
            self.handle_deduct(payload)
            return
        if path == '/api/restock':
            self.handle_restock(payload)
            return
        if path == '/api/transfer':
            self.handle_transfer(payload)
            return

        self.send_json(404, {'ok': False, 'error': 'Endpoint not found'})

    def handle_deduct(self, payload):
        try:
            wh_id = int(payload.get('whId'))
            var_id = int(payload.get('varId'))
            qty = int(payload.get('qty'))
        except (TypeError, ValueError):
            self.send_json(400, {'ok': False, 'error': 'Tham so whId/varId/qty khong hop le'})
            return

        if qty <= 0:
            self.send_json(400, {'ok': False, 'error': 'So luong xuat phai lon hon 0'})
            return

        conn = get_connection()
        if not conn:
            self.send_json(500, {'ok': False, 'error': 'Chua ket noi duoc MySQL (thieu pymysql)'})
            return

        try:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT bt.GiaBan, sp.MaGianHang
                    FROM BienTheSanPham bt
                    INNER JOIN SanPham sp ON sp.MaSanPham = bt.MaSanPham
                    WHERE bt.MaBienThe = %s;
                """, (var_id,))
                variant = cur.fetchone()
                if not variant:
                    raise ValueError('Khong tim thay bien the san pham')

                price = float(variant['GiaBan'])
                shop_id = int(variant['MaGianHang'])
                total = price * qty

                cur.execute("""
                    INSERT INTO DonHang
                        (MaKhachHang, MaGianHang, MaKho, NgayDatHang,
                         TongTienHang, SoTienGiam, TongThanhToan, TrangThai)
                    VALUES (1, %s, %s, NOW(), %s, 0.00, %s, 'ChoXacNhan');
                """, (shop_id, wh_id, total, total))
                order_id = cur.lastrowid

                cur.execute("""
                    INSERT INTO ChiTietDonHang
                        (MaDonHang, MaBienThe, SoLuong, DonGia, ThanhTien)
                    VALUES (%s, %s, %s, %s, %s);
                """, (order_id, var_id, qty, price, total))

                cur.execute(
                    "UPDATE DonHang SET TrangThai = 'DaXacNhan' WHERE MaDonHang = %s;",
                    (order_id,),
                )
                conn.commit()

                cur.execute(
                    "SELECT SoLuongTonKho FROM TonKho WHERE MaKho = %s AND MaBienThe = %s;",
                    (wh_id, var_id),
                )
                stock_row = cur.fetchone()
                new_stock = stock_row['SoLuongTonKho'] if stock_row else 0

            self.send_json(200, {
                'ok': True,
                'orderId': order_id,
                'newStock': new_stock,
                'message': f'Da xac nhan don #{order_id}; trigger MySQL da tru {qty} san pham.',
            })
        except pymysql.MySQLError as e:
            conn.rollback()
            code = e.args[0] if e.args else 0
            msg = e.args[1] if len(e.args) > 1 else str(e)
            self.send_json(400, {
                'ok': False,
                'is_trigger_error': code == 1644,
                'error': f'[MySQL {code}] {msg}',
            })
        except Exception as e:
            conn.rollback()
            self.send_json(400, {'ok': False, 'error': str(e)})
        finally:
            conn.close()

    def handle_restock(self, payload):
        try:
            wh_id = int(payload.get('whId'))
            var_id = int(payload.get('varId'))
            qty = int(payload.get('qty'))
        except (TypeError, ValueError):
            self.send_json(400, {'ok': False, 'error': 'Tham so whId/varId/qty khong hop le'})
            return

        if qty <= 0:
            self.send_json(400, {'ok': False, 'error': 'So luong nhap phai lon hon 0'})
            return

        conn = get_connection()
        if not conn:
            self.send_json(500, {'ok': False, 'error': 'Chua ket noi duoc MySQL'})
            return

        try:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT SoLuongTonKho FROM TonKho WHERE MaKho = %s AND MaBienThe = %s FOR UPDATE;",
                    (wh_id, var_id),
                )
                row = cur.fetchone()
                if row:
                    cur.execute(
                        "UPDATE TonKho SET SoLuongTonKho = SoLuongTonKho + %s WHERE MaKho = %s AND MaBienThe = %s;",
                        (qty, wh_id, var_id),
                    )
                else:
                    cur.execute(
                        "INSERT INTO TonKho (MaKho, MaBienThe, SoLuongTonKho) VALUES (%s, %s, %s);",
                        (wh_id, var_id, qty),
                    )
                conn.commit()

                cur.execute(
                    "SELECT SoLuongTonKho FROM TonKho WHERE MaKho = %s AND MaBienThe = %s;",
                    (wh_id, var_id),
                )
                new_stock = cur.fetchone()['SoLuongTonKho']

            self.send_json(200, {
                'ok': True,
                'newStock': new_stock,
                'message': f'Da nhap +{qty} san pham vao kho #{wh_id}.',
            })
        except pymysql.MySQLError as e:
            conn.rollback()
            code = e.args[0] if e.args else 0
            msg = e.args[1] if len(e.args) > 1 else str(e)
            self.send_json(400, {'ok': False, 'error': f'[MySQL {code}] {msg}'})
        except Exception as e:
            conn.rollback()
            self.send_json(400, {'ok': False, 'error': str(e)})
        finally:
            conn.close()

    def handle_transfer(self, payload):
        try:
            from_wh = int(payload.get('fromWhId'))
            to_wh = int(payload.get('toWhId'))
            var_id = int(payload.get('varId'))
            qty = int(payload.get('qty'))
        except (TypeError, ValueError):
            self.send_json(400, {'ok': False, 'error': 'Tham so dieu chuyen khong hop le'})
            return

        if qty <= 0:
            self.send_json(400, {'ok': False, 'error': 'So luong dieu chuyen phai lon hon 0'})
            return
        if from_wh == to_wh:
            self.send_json(400, {'ok': False, 'error': 'Kho xuat va kho nhan phai khac nhau'})
            return

        conn = get_connection()
        if not conn:
            self.send_json(500, {'ok': False, 'error': 'Chua ket noi duoc MySQL'})
            return

        try:
            with conn.cursor() as cur:
                cur.execute(
                    "SELECT SoLuongTonKho FROM TonKho WHERE MaKho = %s AND MaBienThe = %s FOR UPDATE;",
                    (from_wh, var_id),
                )
                src = cur.fetchone()
                if not src or src['SoLuongTonKho'] < qty:
                    avail = src['SoLuongTonKho'] if src else 0
                    raise ValueError(f'Kho nguon khong du hang (kha dung {avail}, can {qty})')

                cur.execute(
                    "SELECT SoLuongTonKho FROM TonKho WHERE MaKho = %s AND MaBienThe = %s FOR UPDATE;",
                    (to_wh, var_id),
                )
                dest = cur.fetchone()

                cur.execute(
                    "UPDATE TonKho SET SoLuongTonKho = SoLuongTonKho - %s WHERE MaKho = %s AND MaBienThe = %s;",
                    (qty, from_wh, var_id),
                )
                if dest:
                    cur.execute(
                        "UPDATE TonKho SET SoLuongTonKho = SoLuongTonKho + %s WHERE MaKho = %s AND MaBienThe = %s;",
                        (qty, to_wh, var_id),
                    )
                else:
                    cur.execute(
                        "INSERT INTO TonKho (MaKho, MaBienThe, SoLuongTonKho) VALUES (%s, %s, %s);",
                        (to_wh, var_id, qty),
                    )
                conn.commit()

            self.send_json(200, {
                'ok': True,
                'message': f'Da chuyen {qty} san pham tu kho #{from_wh} sang kho #{to_wh}.',
            })
        except pymysql.MySQLError as e:
            conn.rollback()
            code = e.args[0] if e.args else 0
            msg = e.args[1] if len(e.args) > 1 else str(e)
            self.send_json(400, {'ok': False, 'error': f'[MySQL {code}] {msg}'})
        except Exception as e:
            conn.rollback()
            self.send_json(400, {'ok': False, 'error': str(e)})
        finally:
            conn.close()


def main():
    os.chdir(DIRECTORY)
    print('=' * 70)
    print(' SMART WAREHOUSE - LIVE MYSQL DASHBOARD')
    print('=' * 70)
    if not HAVE_PYMYSQL:
        print(' [CANH BAO] Chua cai pymysql: python -m pip install pymysql')
    else:
        try:
            rows = query_db('SELECT DATABASE() AS db')
            print(f" [OK] Ket noi MySQL: 127.0.0.1:3306 @ {rows[0]['db']}")
        except Exception as e:
            print(f' [CANH BAO] Chua ket noi duoc MySQL: {e}')
            print(' Hay bat MySQL trong XAMPP va nap 01_schema_triggers.sql + 02_seed_data.sql.')

    with ReusableTCPServer(('', PORT), LiveAPIHandler) as httpd:
        url = f'http://localhost:{PORT}/index.html'
        print(f' May chu dang chay tai: {url}')
        print(' Nhan Ctrl + C de dung may chu')
        print('=' * 70)
        if os.environ.get('NO_BROWSER') != '1':
            try:
                webbrowser.open(url)
            except Exception:
                pass
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print('\nDa dung may chu.')
            httpd.server_close()


if __name__ == '__main__':
    main()
