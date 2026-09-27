<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const dish = ref(null)
const loading = ref(false)
const errorMessage = ref('')

const fetchDish = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const response = await fetch(
      `http://10.240.223.32:8000/api/mon-an/${route.params.id}`,
      {
        headers: {
          Accept: 'application/json'
        }
      }
    )

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`)
    }

    const result = await response.json()

    dish.value = result.data
  } catch (error) {
    console.error(error)
    errorMessage.value = 'Không thể tải thông tin món ăn.'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchDish()
})

function formatPrice(price) {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }

  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}
</script>
<template>
  <main class="page">
    <div class="container">

      <!-- Đang tải -->
      <div
        v-if="loading"
        class="status-message"
      >
        Đang tải thông tin món ăn...
      </div>

      <!-- Có lỗi khi gọi API -->
      <div
        v-else-if="errorMessage"
        class="status-message error"
      >
        {{ errorMessage }}
      </div>

      <!-- Không tìm thấy món -->
      <div
        v-else-if="!dish"
        class="empty-state"
      >
        Không tìm thấy món ăn.
      </div>

      <!-- Chi tiết món ăn -->
      <template v-else>

        <!-- Breadcrumb -->
        <nav class="breadcrumb">
          <RouterLink to="/">
            Trang chủ
          </RouterLink>

          <span>/</span>

          <RouterLink to="/mon-an">
            Món ăn
          </RouterLink>

          <span>/</span>

          <span>{{ dish.ten_mon }}</span>
        </nav>

        <!-- Thông tin chính -->
        <section class="dish-detail">

          <div class="visual-placeholder">
            <span>Visual món ăn</span>
          </div>

          <div class="dish-info">

            <span class="region-tag">
              Mã vùng: {{ dish.vung_mien_id }}
            </span>

            <h1>
              {{ dish.ten_mon }}
            </h1>

            <p class="description">
              {{ dish.mo_ta }}
            </p>

            <div class="price">
              {{ formatPrice(dish.gia_tham_khao) }}
            </div>

          </div>

        </section>

        <!-- Thông tin địa điểm -->
        <section class="detail-section">

          <h2>Địa điểm</h2>

          <div class="info-grid">

            <div class="info-item">
              <span>Vùng miền</span>
              <strong>
                Mã vùng miền: {{ dish.vung_mien_id }}
              </strong>
            </div>

            <div class="info-item">
              <span>Tỉnh / thành phố</span>
              <strong>
                Mã tỉnh / thành: {{ dish.tinh_thanh_id }}
              </strong>
            </div>

            <div class="info-item">
              <span>Địa điểm</span>
              <strong>
                Mã địa điểm: {{ dish.dia_diem_id }}
              </strong>
            </div>

          </div>

        </section>

        <!-- Các khu vực nội dung -->

        <section class="detail-section">
          <h2>Nguyên liệu</h2>

          <p class="placeholder-text">
            Thông tin nguyên liệu sẽ được hiển thị từ dữ liệu hệ thống.
          </p>
        </section>

        <section class="detail-section">
          <h2>Mùa vụ</h2>

          <p class="placeholder-text">
            Thông tin mùa vụ sẽ được hiển thị từ dữ liệu hệ thống.
          </p>
        </section>

        <section class="detail-section">
          <h2>Dịp lễ</h2>

          <p class="placeholder-text">
            Thông tin dịp lễ sẽ được hiển thị từ dữ liệu hệ thống.
          </p>
        </section>

        <section class="detail-section">
          <h2>Dị ứng thực phẩm</h2>

          <p class="placeholder-text">
            Thông tin dị ứng sẽ được hiển thị từ dữ liệu hệ thống.
          </p>
        </section>

        <section class="detail-section">
          <h2>Câu chuyện văn hóa</h2>

          <p class="placeholder-text">
            Nội dung văn hóa của món ăn sẽ được hiển thị từ dữ liệu hệ thống.
          </p>
        </section>

        <section class="detail-section">
          <h2>Đánh giá</h2>

          <p class="placeholder-text">
            Đánh giá của người dùng sẽ được hiển thị tại đây.
          </p>
        </section>

      </template>

    </div>
  </main>
</template>
<style scoped>
.page {
  padding: var(--space-10) 0 var(--space-12);
}


/* =========================
   BREADCRUMB
   ========================= */

.breadcrumb {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--space-2);

  margin-bottom: var(--space-8);

  color: var(--color-text-muted);

  font-size: var(--font-size-base);
}

.breadcrumb a {
  color: var(--color-primary);
}

.breadcrumb a:hover {
  text-decoration: underline;
}


/* =========================
   MAIN DETAIL
   ========================= */

.dish-detail {
  display: grid;

  grid-template-columns: 1fr 1fr;

  gap: var(--space-8);

  margin-bottom: var(--space-12);
}


/* =========================
   VISUAL
   ========================= */

.visual-placeholder {
  min-height: 360px;

  display: flex;

  align-items: center;
  justify-content: center;

  border: 1px solid var(--color-border);

  border-radius: var(--radius-lg);

  background: var(--color-surface);

  color: var(--color-text-muted);
}


/* =========================
   INFO
   ========================= */

.dish-info {
  padding: var(--space-4) 0;
}

.region-tag {
  display: inline-block;

  margin-bottom: var(--space-3);

  padding:
    var(--space-1)
    var(--space-3);

  border-radius: var(--radius-full);

  background: var(--color-surface);

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}

.dish-info h1 {
  margin: 0 0 var(--space-4);

  font-size: var(--font-size-2xl);

  line-height: 1.2;

  font-weight: var(--font-weight-bold);
}

.description {
  margin: 0 0 var(--space-6);

  color: var(--color-text-muted);

  line-height: 1.7;
}

.price {
  font-size: var(--font-size-xl);

  font-weight: var(--font-weight-bold);

  color: var(--color-primary);
}


/* =========================
   DETAIL SECTIONS
   ========================= */

.detail-section {
  padding: var(--space-8) 0;

  border-top: 1px solid var(--color-border);
}

.detail-section h2 {
  margin: 0 0 var(--space-4);

  font-size: var(--font-size-xl);

  font-weight: var(--font-weight-bold);
}


/* =========================
   INFO GRID
   ========================= */

.info-grid {
  display: grid;

  grid-template-columns:
    repeat(3, minmax(0, 1fr));

  gap: var(--space-4);
}

.info-item {
  padding: var(--space-4);

  border: 1px solid var(--color-border);

  border-radius: var(--radius-md);

  background: var(--color-surface);
}

.info-item span {
  display: block;

  margin-bottom: var(--space-2);

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}

.info-item strong {
  font-weight: var(--font-weight-medium);
}


/* =========================
   PLACEHOLDER
   ========================= */

.placeholder-text {
  margin: 0;

  color: var(--color-text-muted);

  line-height: 1.6;
}


/* =========================
   EMPTY
   ========================= */

.empty-state {
  padding: var(--space-12);

  text-align: center;

  border: 1px dashed var(--color-border);

  border-radius: var(--radius-lg);

  color: var(--color-text-muted);
}


/* =========================
   RESPONSIVE
   ========================= */

@media (max-width: 1023px) {
  .dish-detail {
    grid-template-columns: 1fr;
  }

  .info-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}


@media (max-width: 639px) {
  .page {
    padding: var(--space-8) 0 var(--space-10);
  }

  .visual-placeholder {
    min-height: 240px;
  }

  .dish-info h1 {
    font-size: var(--font-size-xl);
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>