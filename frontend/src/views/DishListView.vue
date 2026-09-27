<script setup>
import { computed, ref, onMounted } from 'vue'

const searchKeyword = ref('')
const selectedRegion = ref('')
const selectedProvince = ref('')

const loading = ref(false)
const errorMessage = ref('')

const dishes = ref([])
const currentPage = ref(1)
const lastPage = ref(1)
const totalDishes = ref(0)
const fetchDishes = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const response = await fetch(
      `http://10.240.223.32:8000/api/mon-an?page=${currentPage.value}`,
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

    dishes.value = result.data.data
    currentPage.value = result.data.current_page
    lastPage.value = result.data.last_page
    totalDishes.value = result.data.total
  } catch (error) {
    console.error(error)
    errorMessage.value = 'Không thể tải danh sách món ăn.'
  } finally {
    loading.value = false
  }
}
const goToPage = (page) => {
  if (page < 1 || page > lastPage.value || page === currentPage.value) {
    return
  }

  currentPage.value = page
  fetchDishes()
}
onMounted(() => {
  fetchDishes()
})

const filteredDishes = computed(() => {
  return dishes.value.filter((dish) => {
    const matchesKeyword =
      dish.ten_mon
        .toLowerCase()
        .includes(searchKeyword.value.toLowerCase())

    const matchesRegion =
      !selectedRegion.value ||
      dish.vung_mien?.includes(selectedRegion.value)

    const matchesProvince =
      !selectedProvince.value ||
      dish.tinh_thanh === selectedProvince.value

    return (
      matchesKeyword &&
      matchesRegion &&
      matchesProvince
    )
  })
})

const formatPrice = (price) => {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }

  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}
</script>
<template>
  <main class="page">
    <div class="container">

      <!-- Tiêu đề -->
      <section class="page-heading">
        <h1>Danh sách món ăn</h1>

        <p>
          Khám phá các món ăn đặc trưng theo vùng miền.
        </p>
      </section>

      <!-- Bộ lọc -->
      <section class="filter-bar">

        <div class="search-box">
          <label for="search">
            Tìm kiếm
          </label>

          <input
            id="search"
            v-model="searchKeyword"
            type="text"
            placeholder="Tìm tên món ăn..."
          />
        </div>

        <div class="filter-group">
          <label for="region">
            Vùng miền
          </label>

          <select id="region" v-model="selectedRegion">
            <option value="">
              Tất cả vùng miền
            </option>

            <option value="Bắc">
              Miền Bắc
            </option>

            <option value="Trung">
              Miền Trung
            </option>

            <option value="Nam">
              Miền Nam
            </option>
          </select>
        </div>

        <div class="filter-group">
          <label for="province">
            Tỉnh / thành phố
          </label>

          <select id="province" v-model="selectedProvince">
            <option value="">
              Tất cả tỉnh / thành
            </option>

            <option value="Hà Nội">
              Hà Nội
            </option>

            <option value="Huế">
              Huế
            </option>

            <option value="Đà Nẵng">
              Đà Nẵng
            </option>
          </select>
        </div>

      </section>

      <!-- Loading -->
      <div
        v-if="loading"
        class="status-message"
      >
        Đang tải dữ liệu món ăn...
      </div>

      <!-- Error -->
      <div
        v-else-if="errorMessage"
        class="status-message error"
      >
        {{ errorMessage }}
      </div>

      <!-- Danh sách -->
      <section
        v-else
        class="dish-section"
      >

        <div class="section-header">
          <h2>Món ăn</h2>

          <span>
            {{ filteredDishes.length }} món
          </span>
        </div>

        <!-- Có dữ liệu -->
        <div
          v-if="filteredDishes.length"
          class="dish-grid"
        >

          <RouterLink
            v-for="dish in filteredDishes"
            :key="dish.mon_an_id"
            :to="`/mon-an/${dish.mon_an_id}`"
            class="dish-card"
          >

            <div class="dish-card-body">

              <h3>
                {{ dish.ten_mon }}
              </h3>

              <p class="dish-description">
                {{ dish.mo_ta }}
              </p>

              <div class="dish-meta">

                <span class="dish-price">
                  {{ formatPrice(dish.gia_tham_khao) }}
                </span>

                <span class="dish-region">
                  Mã vùng: {{ dish.vung_mien_id }}
                </span>

              </div>

            </div>

          </RouterLink>

        </div>

        <!-- Không có dữ liệu -->
        <div
          v-else
          class="empty-state"
        >
          Không tìm thấy món ăn phù hợp.
        </div>
<div
  v-if="lastPage > 1 && filteredDishes.length"
  class="pagination"
>
  <button
    type="button"
    :disabled="currentPage === 1"
    @click="goToPage(currentPage - 1)"
  >
    ← Trang trước
  </button>

  <span>
    Trang {{ currentPage }} / {{ lastPage }}
  </span>

  <button
    type="button"
    :disabled="currentPage === lastPage"
    @click="goToPage(currentPage + 1)"
  >
    Trang sau →
  </button>
</div>
      </section>

    </div>
  </main>
</template>
<style scoped>
.page {
  padding: var(--space-12) 0;
}


/* =========================
   PAGE HEADING
   ========================= */

.page-heading {
  margin-bottom: var(--space-8);
}

.page-heading h1 {
  margin: 0 0 var(--space-3);

  font-size: var(--font-size-2xl);
  line-height: 1.2;

  font-weight: var(--font-weight-bold);
}

.page-heading p {
  margin: 0;

  color: var(--color-text-muted);
  font-size: var(--font-size-lg);
}


/* =========================
   FILTER
   ========================= */

.filter-bar {
  display: grid;

  grid-template-columns:
    minmax(0, 2fr)
    minmax(180px, 1fr)
    minmax(180px, 1fr);

  gap: var(--space-4);

  margin-bottom: var(--space-10);

  padding: var(--space-6);

  background: var(--color-surface);

  border: 1px solid var(--color-border);

  border-radius: var(--radius-lg);
}


.search-box,
.filter-group {
  display: flex;
  flex-direction: column;

  gap: var(--space-2);
}


.search-box label,
.filter-group label {
  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-medium);

  color: var(--color-text);
}


.search-box input,
.filter-group select {
  width: 100%;

  min-height: 44px;

  padding:
    var(--space-2)
    var(--space-3);

  border: 1px solid var(--color-border);

  border-radius: var(--radius-md);

  background: var(--color-background);

  color: var(--color-text);

  outline: none;
}


.search-box input:focus,
.filter-group select:focus {
  border-color: var(--color-primary);
}


/* =========================
   SECTION HEADER
   ========================= */

.section-header {
  display: flex;

  align-items: center;

  justify-content: space-between;

  margin-bottom: var(--space-4);
}


.section-header h2 {
  margin: 0;

  font-size: var(--font-size-xl);

  font-weight: var(--font-weight-bold);
}


.section-header span {
  color: var(--color-text-muted);

  font-size: var(--font-size-base);
}


/* =========================
   DISH GRID
   ========================= */

.dish-grid {
  display: grid;

  grid-template-columns: repeat(3, minmax(0, 1fr));

  gap: var(--space-6);
}


/* =========================
   DISH CARD
   ========================= */

.dish-card {
  display: block;

  min-height: 190px;

  color: inherit;
  text-decoration: none;

  background: var(--color-background);

  border: 1px solid var(--color-border);

  border-radius: var(--radius-lg);

  box-shadow: var(--shadow-sm);

  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease;
}


.dish-card:hover {
  transform: translateY(-2px);

  box-shadow: var(--shadow-md);
}


.dish-card-body {
  padding: var(--space-6);
}


.dish-card h3 {
  margin: 0 0 var(--space-3);

  font-size: var(--font-size-lg);

  font-weight: var(--font-weight-bold);
}


.dish-description {
  min-height: 48px;

  margin: 0 0 var(--space-6);

  color: var(--color-text-muted);

  line-height: 1.6;
}


.dish-meta {
  display: flex;

  align-items: center;

  justify-content: space-between;

  gap: var(--space-3);
}


.dish-price {
  font-weight: var(--font-weight-bold);

  color: var(--color-primary);
}


.dish-region {
  padding:
    var(--space-1)
    var(--space-2);

  border-radius: var(--radius-full);

  background: var(--color-surface);

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}


/* =========================
   EMPTY STATE
   ========================= */

.empty-state {
  padding: var(--space-12);

  text-align: center;

  color: var(--color-text-muted);

  border: 1px dashed var(--color-border);

  border-radius: var(--radius-lg);
}
/* =========================
   STATUS MESSAGE
   ========================= */

.status-message {
  margin-bottom: var(--space-8);

  padding: var(--space-8);

  text-align: center;

  border: 1px solid var(--color-border);

  border-radius: var(--radius-lg);

  background: var(--color-surface);

  color: var(--color-text-muted);
}

.status-message.error {
  border-color: var(--color-danger);

  color: var(--color-danger);

  background: var(--color-background);
}

/* =========================
   RESPONSIVE
   ========================= */

@media (max-width: 1023px) {
  .dish-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .filter-bar {
    grid-template-columns: 1fr 1fr;
  }

  .search-box {
    grid-column: 1 / -1;
  }
}


@media (max-width: 639px) {
  .page {
    padding: var(--space-10) 0;
  }

  .page-heading h1 {
    font-size: var(--font-size-xl);
  }

  .page-heading p {
    font-size: var(--font-size-md);
  }

  .filter-bar {
    grid-template-columns: 1fr;

    padding: var(--space-4);
  }

  .search-box {
    grid-column: auto;
  }

  .dish-grid {
    grid-template-columns: 1fr;
  }
}
</style>