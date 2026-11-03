\# V3 – HƯỚNG DẪN BÀN GIAO MỐC M2



\## 1. Thông tin phiên bản



Branch:



`feature/v3-server`



Commit:



`1ede2b4`



\## 2. Các thành phần V3



Backend:



\- `app/Http/Controllers/DatChoController.php`

\- `app/Services/DatChoService.php`

\- `app/Models/DatCho.php`

\- `app/Models/DatChoLichSu.php`

\- `app/Models/LichKhaDungHanhTrinh.php`



Route:



\- `routes/api.php`

\- `routes/console.php`



\## 3. API giữ chỗ



Endpoint:



`POST /api/dat-cho/hold`



Request:



```json

{

&#x20;   "lich\_kha\_dung\_id": 1,

&#x20;   "so\_khach": 1

}

