<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('giao_dich_thanh_toan', function (Blueprint $table) {
            $table->engine = 'InnoDB';
            $table->charset = 'utf8mb4';
            $table->collation = 'utf8mb4_unicode_ci';

            $table->increments('giao_dich_id');

            // Khớp kiểu INT với dat_cho.dat_cho_id
            $table->integer('dat_cho_id');

            // Mã giao dịch UUID
            $table->string('ma_giao_dich', 36)->unique();

            // Số tiền thanh toán
            $table->decimal('so_tien', 14, 2);

            // Kết quả thanh toán
            $table->enum('ket_qua', [
                'success',
                'failed',
            ]);

            // Phương thức thanh toán
            $table->string('phuong_thuc', 50);

            // Thời điểm tạo giao dịch
            $table->dateTime('ngay_tao')->useCurrent();

            $table->index(
                'dat_cho_id',
                'idx_giao_dich_dat_cho'
            );

            // Liên kết với đơn đặt chỗ
            $table->foreign('dat_cho_id', 'fk_giao_dich_dat_cho')
                ->references('dat_cho_id')
                ->on('dat_cho')
                ->onUpdate('cascade')
                ->onDelete('restrict');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('giao_dich_thanh_toan');
    }
};
