<script setup>
import { computed, ref, onMounted, watch } from 'vue'

// Sử dụng đường dẫn tương đối ../ thay vì @/
import phoHaNoiImage from '../assets/images/dishes/pho-ha-noi.webp'
import bunChaImage from '../assets/images/dishes/bun-cha.jpg'
import banhDaCuaImage from '../assets/images/dishes/banh-da-cua-hai-phong.jpg'
import banhCuonImage from '../assets/images/dishes/banh-cuon-dong-van.jpg'
import bunBoHueImage from '../assets/images/dishes/bun-bo-hue.jpeg'
import miQuangImage from '../assets/images/dishes/mi-quang.jpg'
import comTamImage from '../assets/images/dishes/com-tam.webp'
import banhXeoImage from '../assets/images/dishes/banh-xeo.jpg'
import bunCaImage from '../assets/images/dishes/bun-ca-chau-doc.jpg'
import caoLauImage from '../assets/images/dishes/cao-lau-hoi-an.jpg'
const API_BASE_URL = (import.meta.env.VITE_API_BASE_URL || '').replace(/\/+$/, '')
const searchKeyword = ref('')
const selectedRegion = ref('')
const selectedProvince = ref('')

const loading = ref(false)
const errorMessage = ref('')
const dishes = ref([])

const currentPage = ref(1)
const pageSize = ref(10) // Giới hạn đúng 10 món mỗi trang

const getRegionId = (dish) =>
  dish.vung_mien_id ?? dish.vungMien?.vung_mien_id ?? dish.vung_mien?.vung_mien_id

const getRegionName = (dish) =>
  dish.vungMien?.ten_vung ??
  dish.vung_mien?.ten_vung ??
  ''

const getProvinceId = (dish) =>
  dish.tinh_thanh_id ?? dish.tinhThanh?.tinh_thanh_id ?? dish.tinh_thanh?.tinh_thanh_id

const getProvinceName = (dish) =>
  dish.tinhThanh?.ten_tinh ??
  dish.tinhThanh?.ten_tinh_thanh ??
  dish.tinh_thanh?.ten_tinh ??
  dish.tinh_thanh?.ten_tinh_thanh ??
  ''

const regions = computed(() => {
  const map = new Map()

  for (const dish of dishes.value) {
    const id = getRegionId(dish)
    const name = getRegionName(dish)

    if (id != null && name) map.set(String(id), name)
  }

  return [...map.entries()].map(([id, name]) => ({ id, name }))
})

const provinces = computed(() => {
  const map = new Map()

  for (const dish of dishes.value) {
    const id = getProvinceId(dish)
    const name = getProvinceName(dish)

    if (id != null && name) {
      map.set(String(id), { id: String(id), name, regionId: String(getRegionId(dish) ?? '') })
    }
  }

  return [...map.values()].filter(
    (province) => !selectedRegion.value || province.regionId === selectedRegion.value
  )
})

const fetchDishes = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const firstResponse = await fetch(`${API_BASE_URL}/api/mon-an?page=1&per_page=100`, {
      headers: { Accept: 'application/json' }
    })

    if (!firstResponse.ok) throw new Error(`HTTP ${firstResponse.status}`)

    const firstResult = await firstResponse.json()
    const firstPage = firstResult.data

    let allDishes = firstPage.data ?? []

    const pages = Number(firstPage.last_page ?? 1)

    if (pages > 1) {
      const responses = await Promise.all(
        Array.from({ length: pages - 1 }, (_, index) =>
          fetch(`${API_BASE_URL}/api/mon-an?page=${index + 2}&per_page=100`, {
            headers: { Accept: 'application/json' }
          })
        )
      )

      for (const response of responses) {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        const result = await response.json()
        allDishes = allDishes.concat(result.data?.data ?? [])
      }
    }

    dishes.value = allDishes
  } catch (error) {
    console.error('Lỗi tải danh sách món ăn:', error)
    errorMessage.value = 'Không thể tải danh sách món ăn.'
  } finally {
    loading.value = false
  }
}

// Ánh xạ ảnh từ assets cho 10 món đầu tiên
const getDishImage = (dish) => {
  const name = (dish?.ten_mon || '')
    .normalize('NFC')
    .trim()
    .toLocaleLowerCase('vi')

  const imageMap = [
    { keywords: ['phở bò', 'phở hà nội'], image: phoHaNoiImage },
    { keywords: ['bún chả'], image: bunChaImage },
    { keywords: ['bánh đa cua'], image: banhDaCuaImage },
    { keywords: ['bánh cuốn'], image: banhCuonImage },
    { keywords: ['bún bò huế'], image: bunBoHueImage },
    { keywords: ['mì quảng'], image: miQuangImage },
    { keywords: ['cơm tấm'], image: comTamImage },
    { keywords: ['bánh xèo'], image: banhXeoImage },
    { keywords: ['cao lầu'], image: caoLauImage },
    { keywords: ['bún cá châu đốc'], image: bunCaImage }
  ]

  return imageMap.find(item =>
    item.keywords.some(keyword => name.includes(keyword))
  )?.image || null
}

// Lọc danh sách theo từ khóa và vùng miền/tỉnh thành
const filteredDishes = computed(() => {
  const keyword = searchKeyword.value.trim().toLocaleLowerCase('vi')

  return dishes.value.filter((dish) => {
    const matchesKeyword = (dish.ten_mon ?? '')
      .toLocaleLowerCase('vi')
      .includes(keyword)

    const matchesRegion =
      !selectedRegion.value ||
      String(getRegionId(dish) ?? '') === selectedRegion.value

    const matchesProvince =
      !selectedProvince.value ||
      String(getProvinceId(dish) ?? '') === selectedProvince.value

    return matchesKeyword && matchesRegion && matchesProvince
  })
})

// Tính tổng số trang dựa trên kết quả đã lọc (mỗi trang 10 món)
const lastPage = computed(() => {
  return Math.ceil(filteredDishes.value.length / pageSize.value) || 1
})

// Cắt danh sách chỉ hiển thị 10 món cho trang hiện tại
const paginatedDishes = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return filteredDishes.value.slice(start, end)
})

// Tự động đưa về trang 1 khi người dùng tìm kiếm hoặc đổi bộ lọc
watch([searchKeyword, selectedRegion, selectedProvince], () => {
  currentPage.value = 1
})

const goToPage = (page) => {
  if (page >= 1 && page <= lastPage.value) {
    currentPage.value = page
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

const formatPrice = (price) => {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }

  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}

const resetProvinceWhenRegionChanges = () => {
  selectedProvince.value = ''
}

onMounted(fetchDishes)
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

          <select
            id="region"
            v-model="selectedRegion"
            @change="resetProvinceWhenRegionChanges"
          >
            <option value="">Tất cả vùng miền</option>
            <option
              v-for="region in regions"
              :key="region.id"
              :value="region.id"
            >
              {{ region.name }}
            </option>
          </select>
        </div>

        <div class="filter-group">
          <label for="province">
            Tỉnh / thành phố
          </label>

          <select id="province" v-model="selectedProvince">
            <option value="">Tất cả tỉnh / thành</option>
            <option
              v-for="province in provinces"
              :key="province.id"
              :value="province.id"
            >
              {{ province.name }}
            </option>
          </select>
        </div>

      </section>

      <!-- Ô dẫn sang trang Hành trình ẩm thực -->
      <RouterLink to="/hanh-trinh" class="journey-promo-card">
        <div class="journey-promo-content">
          <span class="promo-eyebrow">CUNG ĐƯỜNG ẨM THỰC</span>
          <h3>Khám phá các Hành trình ẩm thực ba miền</h3>
          <p>Trải nghiệm những chuyến đi thực tế, khám phá văn hóa và hương vị đặc trưng qua từng vùng đất.</p>
        </div>
        <div class="journey-promo-action">
          <span>Xem hành trình</span>
          <span class="arrow">→</span>
        </div>
      </RouterLink>

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

        <!-- Có dữ liệu (Hiển thị danh sách phân trang 10 món) -->
        <div
          v-if="paginatedDishes.length"
          class="dish-grid"
        >
          <RouterLink
            v-for="dish in paginatedDishes"
            :key="dish.mon_an_id"
            :to="`/mon-an/${dish.mon_an_id}`"
            class="dish-card"
            :class="{ 'featured-card': currentPage === 1 }"
          >
              <!-- Khung hình ảnh hiển thị ở tất cả các trang -->
              <div class="dish-card-image-wrap">
              <img
                v-if="getDishImage(dish)"
                :src="getDishImage(dish)"
                :alt="dish.ten_mon"
                class="dish-card-img"
              />
              <div v-else class="dish-card-img-placeholder">
                <span>Chưa có hình ảnh</span>
              </div>
            </div>

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

        <!-- Thanh phân trang -->
        <div
          v-if="lastPage > 1 && filteredDishes.length"
          class="pagination"
        >
          <button
            type="button"
            class="pagination-btn"
            :disabled="currentPage === 1"
            @click="goToPage(currentPage - 1)"
          >
            ← Trang trước
          </button>

          <span class="pagination-info">
            Trang <strong>{{ currentPage }}</strong> / {{ lastPage }}
          </span>

          <button
            type="button"
            class="pagination-btn"
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

  margin-bottom: var(--space-8);

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
   JOURNEY PROMO CARD
   ========================= */

.journey-promo-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: var(--space-10);
  padding: 24px 32px;
  background: linear-gradient(135deg, var(--color-surface, #f8fafc) 0%, var(--color-background, #ffffff) 100%);
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: var(--radius-lg, 16px);
  color: inherit;
  text-decoration: none;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
  transition: transform 0.25s ease, border-color 0.25s ease, box-shadow 0.25s ease;
}

.journey-promo-card:hover {
  transform: translateY(-2px);
  border-color: var(--color-primary, #2563eb);
  box-shadow: 0 8px 30px rgba(37, 99, 235, 0.08);
}

.journey-promo-content {
  display: grid;
  gap: 6px;
  min-width: 0;
}

.promo-eyebrow {
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: var(--color-primary, #2563eb);
}

.journey-promo-content h3 {
  margin: 0;
  font-size: 18px;
  font-weight: var(--font-weight-bold);
  color: var(--color-text, #0f172a);
}

.journey-promo-content p {
  margin: 0;
  color: var(--color-text-muted, #64748b);
  font-size: 14px;
  line-height: 1.5;
}

.journey-promo-action {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
  padding: 10px 18px;
  background: var(--color-primary, #2563eb);
  color: #ffffff;
  border-radius: var(--radius-md, 8px);
  font-size: 14px;
  font-weight: 600;
  transition: opacity 0.2s ease;
}

.journey-promo-card:hover .journey-promo-action {
  opacity: 0.9;
}

.journey-promo-action .arrow {
  transition: transform 0.2s ease;
}

.journey-promo-card:hover .journey-promo-action .arrow {
  transform: translateX(4px);
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

  overflow: hidden;
}


.dish-card:hover {
  transform: translateY(-2px);

  box-shadow: var(--shadow-md);
}

.dish-card-image-wrap {
  width: 100%;
  height: 180px;
  background: var(--color-surface);
  border-bottom: 1px solid var(--color-border);
  overflow: hidden;
}

.dish-card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.dish-card-img-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--color-text-muted);
  font-size: 13px;
  background: var(--color-surface);
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
   PAGINATION
   ========================= */

.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid var(--color-border);
}

.pagination-btn {
  padding: 8px 16px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-surface);
  color: var(--color-text);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.pagination-btn:hover:not(:disabled) {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.pagination-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination-info {
  font-size: 14px;
  color: var(--color-text-muted);
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

  .journey-promo-card {
    flex-direction: column;
    align-items: flex-start;
    padding: 20px;
    gap: 16px;
  }

  .journey-promo-action {
    width: 100%;
    justify-content: center;
  }
}
</style>