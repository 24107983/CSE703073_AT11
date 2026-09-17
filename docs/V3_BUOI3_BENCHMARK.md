\# V3 – Buổi 3: Index và đo hiệu năng truy vấn



\## 1. Mục tiêu



Kiểm tra hiệu quả của index đối với các truy vấn tìm kiếm dữ liệu món ăn theo tỉnh/thành phố và theo khoảng giá.



Dữ liệu benchmark gồm 1.000 bản ghi trong bảng `mon\_an`. Trong đó, 990 bản ghi bổ sung là dữ liệu mô phỏng phục vụ kiểm thử hiệu năng, không đại diện cho dữ liệu khảo sát thực tế.



\## 2. Index kiểm thử



| Index | Bảng | Cột |

|---|---|---|

| `idx\_mon\_an\_tinh\_thanh` | `mon\_an` | `tinh\_thanh\_id` |

| `idx\_mon\_an\_gia` | `mon\_an` | `gia\_tham\_khao` |



\## 3. Kết quả EXPLAIN



\### 3.1. Query 1 – Tìm món ăn theo tỉnh



```sql

SELECT \*

FROM mon\_an

WHERE tinh\_thanh\_id = 1;

