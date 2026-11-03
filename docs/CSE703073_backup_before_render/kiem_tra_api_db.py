# Kich ban doi chieu Hop dong API v0.1 (V3) va CSDL (V2) - Buoi 4 
import sys 
print("=" * 65) 
print(" PHAE KIEM THU 1: KIEM TRA TINH NHAT QUAN HOP DONG API v0.1 vs CSDL") 
print(" Hoc phan: CSE703073 - De tai DT-11 Ban do so du lich am thuc") 
print("=" * 65) 
# Các trường trong JSON Response của API (V3) 
api_response_fields = [ 
	"mon_an_id", "ten_mon", "mieu_ta", "gia_tham_khao", 
	"vung_mien_id", "tinh_thanh_id", "anh_da_dien" 
] 

# Các cột tương ứng trong Bảng CSDL (V2 - schema.sql) 
db_table_columns = [ 
	"mon_an_id", "ten_mon", "mieu_ta", "gia_tham_khao", 
	"vung_mien_id", "tinh_thanh_id", "anh_da_dien", "created_at", "updated_at" 
] 
missing_fields = [field for field in api_response_fields if field not in db_table_columns] 
if not missing_fields: 
	print("[*] Ket qua doi chieu: 100% truong du lieu trong API deu co cot luu trutrong CSDL.")
	print("=> KIEM THU DAT (PASS): Khong co truong API nao bi 'mo coi' cot CSDL!") 
else: 
	print(f"[!] PHAT HIEN LOI: Cac truong API sau chua co cot trong CSDL: {missing_fields}") 
	print("=> KIEM THU KHONG DAT (FAIL): Yeu cau V2 bo sung vao schema.sql!") 
print("=" * 65)
