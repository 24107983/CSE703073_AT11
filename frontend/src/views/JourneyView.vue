<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'

import hanoiJourneyImage from '../assets/images/journeys/hanoi.jpeg'
import hueJourneyImage from '../assets/images/journeys/hue.jpg'
import hoiAnJourneyImage from '../assets/images/journeys/hoi-an.jpg'
import journey4Image from '../assets/images/journeys/journey-4.jpg'
import journey5Image from '../assets/images/journeys/journey-5.jpg'
import journey6Image from '../assets/images/journeys/journey-6.jpg'
import journey7Image from '../assets/images/journeys/journey-7.jpg'
import journey8Image from '../assets/images/journeys/journey-8.jpg'
import journey9Image from '../assets/images/journeys/journey-9.jpg'
import journey10Image from '../assets/images/journeys/journey-10.jpg'

const journeys = ref([])

const loading = ref(false)

const errorMessage = ref('')

const currentPage = ref(1)

const lastPage = ref(1)

const totalJourneys = ref(0)

// Bộ lọc giao diện: API hiện chỉ xác nhận page/per_page,
// vì vậy tìm kiếm/lọc được áp dụng trên dữ liệu trang hiện tại.
const searchQuery = ref('')
const durationFilter = ref('all')

const filteredJourneys = computed(() => {
  const keyword = searchQuery.value.trim().toLocaleLowerCase('vi')

  return journeys.value.filter((journey) => {
    const searchableText = [
      journey.ten_hanh_trinh,
      journey.mo_ta,
      journey.thoi_luong
    ].filter(Boolean).join(' ').toLocaleLowerCase('vi')

    const matchesSearch = !keyword || searchableText.includes(keyword)
    const duration = String(journey.thoi_luong || '').toLocaleLowerCase('vi')
    const daysMatch = duration.match(/(\d+)\s*ngày/)
    const dayCount = daysMatch ? Number(daysMatch[1]) : null

    let matchesDuration = true
    if (durationFilter.value === 'short') matchesDuration = dayCount !== null && dayCount <= 3
    if (durationFilter.value === 'medium') matchesDuration = dayCount !== null && dayCount >= 4 && dayCount <= 5
    if (durationFilter.value === 'long') matchesDuration = dayCount !== null && dayCount >= 6

    return matchesSearch && matchesDuration
  })
})

const clearFilters = () => {
  searchQuery.value = ''
  durationFilter.value = 'all'
}


/* =========================================================
   IMAGE
========================================================= */

const getJourneyImage = (id) => {
  const imageMap = {
    1: hanoiJourneyImage,
    2: hueJourneyImage,
    3: hoiAnJourneyImage,
    4: journey4Image,
    5: journey5Image,
    6: journey6Image,
    7: journey7Image,
    8: journey8Image,
    9: journey9Image,
    10: journey10Image
  }

  return imageMap[id] || null
}


/* =========================================================
   FETCH JOURNEYS FROM V3
========================================================= */

const fetchJourneys = async () => {
  loading.value = true

  errorMessage.value = ''

  try {
    const response = await fetch(
      `/api/hanh-trinh-am-thuc?page=${currentPage.value}`,
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

    const pagination = result.data

    journeys.value = pagination.data.map((journey) => ({
      ...journey,
      image: getJourneyImage(journey.hanh_trinh_id)
    }))

    currentPage.value = pagination.current_page

    lastPage.value = pagination.last_page

    totalJourneys.value = pagination.total

  } catch (error) {
    console.error(error)

    errorMessage.value =
      'Không thể tải danh sách hành trình.'

  } finally {
    loading.value = false
  }
}


/* =========================================================
   PAGINATION
========================================================= */

const goToPage = (page) => {

  if (
    page < 1 ||
    page > lastPage.value ||
    page === currentPage.value
  ) {
    return
  }

  currentPage.value = page

  fetchJourneys()

  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}


/* =========================================================
   INITIAL LOAD
========================================================= */

onMounted(() => {
  fetchJourneys()
})
</script>


<template>

  <main class="page">

    <div class="container">


      <!-- =========================
           PAGE HEADING
      ========================== -->

      <section class="page-heading">

        <div>

          <span class="eyebrow">
            KHÁM PHÁ ẨM THỰC
          </span>

          <h1>
            Hành trình ẩm thực
          </h1>

          <p>
            Khám phá những hành trình ẩm thực đặc sắc
            theo từng vùng miền Việt Nam.
          </p>

        </div>

      </section>


      <!-- =========================
           SEARCH & FILTER
      ========================== -->

      <section class="journey-filters" aria-label="Tìm kiếm và lọc hành trình">
        <label class="search-field">
          <span class="field-label">Tìm kiếm hành trình</span>
          <span class="search-input-wrap">
            <span class="search-icon" aria-hidden="true">⌕</span>
            <input
              v-model="searchQuery"
              type="search"
              placeholder="Nhập tên hành trình hoặc từ khóa..."
              aria-label="Tìm theo tên, mô tả hoặc thời lượng"
            />
          </span>
        </label>

        <label class="filter-field">
          <span class="field-label">Thời lượng</span>
          <select v-model="durationFilter" aria-label="Lọc theo thời lượng">
            <option value="all">Tất cả thời lượng</option>
            <option value="short">Tối đa 3 ngày</option>
            <option value="medium">4–5 ngày</option>
            <option value="long">Từ 6 ngày trở lên</option>
          </select>
        </label>

        <button
          type="button"
          class="clear-filter-button"
          :disabled="!searchQuery && durationFilter === 'all'"
          @click="clearFilters"
        >
          Xóa bộ lọc
        </button>
      </section>

      <!-- =========================
           LOADING
      ========================== -->

      <section
        v-if="loading"
        class="state-card"
      >

        <div class="loading-spinner"></div>

        <p>
          Đang tải danh sách hành trình...
        </p>

      </section>


      <!-- =========================
           ERROR
      ========================== -->

      <section
        v-else-if="errorMessage"
        class="state-card"
      >

        <div class="state-icon">
          !
        </div>

        <h2>
          Không thể tải dữ liệu
        </h2>

        <p>
          {{ errorMessage }}
        </p>

        <button
          type="button"
          class="primary-button"
          @click="fetchJourneys"
        >
          Thử lại
        </button>

      </section>


      <!-- =========================
           CONTENT
      ========================== -->

      <template v-else>

        <section class="list-header">

          <div>

            <h2>
              Các hành trình nổi bật
            </h2>

            <p>
              {{ searchQuery || durationFilter !== 'all' ? filteredJourneys.length : totalJourneys }}
              {{ searchQuery || durationFilter !== 'all' ? 'kết quả phù hợp' : 'hành trình đang có sẵn' }}
            </p>

          </div>

        </section>


        <!-- =========================
             JOURNEY CARDS
        ========================== -->

        <section class="journey-grid">

          <article
            v-for="journey in filteredJourneys"
            :key="journey.hanh_trinh_id"
            class="journey-card"
          >


            <!-- IMAGE -->

            <div class="card-visual">

              <span class="region-badge">
                Ẩm thực Việt Nam
              </span>


              <img
                v-if="journey.image"
                :src="journey.image"
                :alt="journey.ten_hanh_trinh"
                class="journey-image"
              />


              <div
                v-else
                class="visual-placeholder"
              >
                <span>
                  🍜
                </span>

                <small>
                  ẨM THỰC VIỆT NAM
                </small>
              </div>

            </div>


            <!-- BODY -->

            <div class="card-body">

              <h3>
                {{ journey.ten_hanh_trinh }}
              </h3>


              <p class="description">

                {{
                  journey.mo_ta ||
                  'Khám phá hành trình ẩm thực đặc sắc.'
                }}

              </p>


              <div class="card-meta">

                <div class="meta-item">

                  <span class="meta-icon">
                    ⏱
                  </span>

                  <span>
                    {{ journey.thoi_luong || 'Chưa cập nhật' }}
                  </span>

                </div>


                <div class="meta-item">

                  <span class="meta-icon">
                    🍽
                  </span>

                  <span>
                    Hành trình ẩm thực
                  </span>

                </div>

              </div>


              <!-- DETAIL -->

              <RouterLink
                :to="`/hanh-trinh/${journey.hanh_trinh_id}`"
                class="detail-button"
              >

                <span>
                  Xem hành trình
                </span>

                <span>
                  →
                </span>

              </RouterLink>

            </div>

          </article>

        </section>


        <!-- =========================
             EMPTY
        ========================== -->

        <section
          v-if="filteredJourneys.length === 0"
          class="state-card"
        >

          <h2>
            Chưa có hành trình
          </h2>

          <p>
            Hiện chưa có dữ liệu hành trình để hiển thị.
          </p>

        </section>


        <!-- =========================
             PAGINATION
        ========================== -->

        <nav
          v-if="lastPage > 1 && !searchQuery && durationFilter === 'all'"
          class="pagination"
          aria-label="Phân trang hành trình"
        >

          <button
            type="button"
            class="page-button"
            :disabled="currentPage === 1"
            @click="goToPage(currentPage - 1)"
          >
            ←
          </button>


          <button
            v-for="page in lastPage"
            :key="page"
            type="button"
            class="page-button"
            :class="{
              active: page === currentPage
            }"
            @click="goToPage(page)"
          >
            {{ page }}
          </button>


          <button
            type="button"
            class="page-button"
            :disabled="currentPage === lastPage"
            @click="goToPage(currentPage + 1)"
          >
            →
          </button>

        </nav>

      </template>

    </div>

  </main>

</template>


<style scoped>

/* =========================================================
   PAGE
========================================================= */

.page {
  padding:
    var(--space-10)
    0
    var(--space-16);
}


/* =========================================================
   HEADING
========================================================= */

.page-heading {
  margin-bottom: var(--space-10);
}


.eyebrow {
  display: inline-block;

  margin-bottom: var(--space-3);

  color: var(--color-primary);

  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-bold);

  letter-spacing: 0.08em;
}


.page-heading h1 {
  margin:
    0
    0
    var(--space-3);

  color: var(--color-text);

  font-size:
    clamp(
      2rem,
      4vw,
      2.75rem
    );

  line-height: 1.15;
}


.page-heading p {
  max-width: 680px;

  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-md);

  line-height: 1.7;
}


/* =========================================================
   SEARCH & FILTER
========================================================= */

.journey-filters {
  display: grid;
  grid-template-columns: minmax(240px, 1fr) minmax(190px, 260px) auto;
  align-items: end;
  gap: var(--space-4);
  margin: calc(var(--space-5) * -1) 0 var(--space-8);
  padding: var(--space-5);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);
  background: var(--color-surface);
}

.search-field,
.filter-field {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: var(--space-2);
}

.field-label {
  color: var(--color-text);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
}

.search-input-wrap {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  min-height: 46px;
  padding: 0 var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
}

.search-input-wrap:focus-within,
.filter-field select:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

.search-icon {
  color: var(--color-text-muted);
  font-size: 1.5rem;
  line-height: 1;
}

.search-input-wrap input {
  width: 100%;
  min-width: 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: var(--color-text);
  font: inherit;
  font-size: var(--font-size-sm);
}

.filter-field select {
  width: 100%;
  min-height: 46px;
  padding: 0 var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
  font-size: var(--font-size-sm);
}

.clear-filter-button {
  min-height: 46px;
  padding: 0 var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-primary);
  font: inherit;
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  cursor: pointer;
  white-space: nowrap;
}

.clear-filter-button:hover:not(:disabled) {
  border-color: var(--color-primary);
}

.clear-filter-button:disabled {
  opacity: 0.45;
  cursor: not-allowed;
}

/* =========================================================
   LIST HEADER
========================================================= */

.list-header {
  display: flex;

  align-items: flex-end;

  justify-content: space-between;

  margin-bottom: var(--space-5);
}


.list-header h2 {
  margin:
    0
    0
    var(--space-2);

  font-size: var(--font-size-xl);
}


.list-header p {
  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}


/* =========================================================
   GRID
========================================================= */

.journey-grid {
  display: grid;

  grid-template-columns:
    repeat(
      3,
      minmax(0, 1fr)
    );

  gap: var(--space-5);
}


/* =========================================================
   CARD
========================================================= */

.journey-card {
  overflow: hidden;

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-xl);

  background:
    var(--color-background);

  box-shadow:
    var(--shadow-sm);

  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease,
    border-color 0.2s ease;
}


.journey-card:hover {
  transform:
    translateY(-3px);

  border-color:
    var(--color-primary);

  box-shadow:
    var(--shadow-md);
}


/* =========================================================
   VISUAL
========================================================= */

.card-visual {
  position: relative;

  display: flex;

  align-items: center;

  justify-content: center;

  height: 210px;

  overflow: hidden;

  background:
    var(--color-surface);
}


.journey-image {
  width: 100%;

  height: 100%;

  display: block;

  object-fit: cover;

  transition:
    transform 0.4s ease;
}


.journey-card:hover
.journey-image {
  transform:
    scale(1.04);
}


.region-badge {
  position: absolute;

  top: var(--space-4);

  left: var(--space-4);

  z-index: 2;

  padding:
    var(--space-2)
    var(--space-3);

  border:
    1px solid
    rgba(255,255,255,0.4);

  border-radius:
    var(--radius-full);

  background:
    rgba(17,24,39,0.72);

  color: white;

  font-size:
    var(--font-size-xs);

  font-weight:
    var(--font-weight-medium);

  backdrop-filter:
    blur(8px);
}


/* =========================================================
   PLACEHOLDER
========================================================= */

.visual-placeholder {
  display: flex;

  flex-direction: column;

  align-items: center;

  justify-content: center;

  gap: 8px;

  width: 100%;

  height: 100%;

  color: var(--color-text-muted);
}


.visual-placeholder span {
  font-size: 3.5rem;
}


.visual-placeholder small {
  font-size: 10px;

  font-weight: 700;

  letter-spacing: 0.08em;
}


/* =========================================================
   BODY
========================================================= */

.card-body {
  display: flex;

  flex-direction: column;

  min-height: 270px;

  padding:
    var(--space-5);
}


.card-body h3 {
  margin:
    0
    0
    var(--space-3);

  color: var(--color-text);

  font-size: var(--font-size-lg);

  line-height: 1.4;
}


.description {
  display: -webkit-box;

  overflow: hidden;

  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);

  line-height: 1.65;

  -webkit-box-orient: vertical;

  -webkit-line-clamp: 3;
}


/* =========================================================
   META
========================================================= */

.card-meta {
  display: flex;

  flex-wrap: wrap;

  gap: var(--space-4);

  margin-top: auto;

  padding-top: var(--space-5);
}


.meta-item {
  display: inline-flex;

  align-items: center;

  gap: var(--space-2);

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}


.meta-icon {
  font-size: 1rem;
}


/* =========================================================
   BUTTON
========================================================= */

.detail-button {
  display: flex;

  align-items: center;

  justify-content: space-between;

  width: 100%;

  margin-top: var(--space-5);

  padding:
    var(--space-3)
    var(--space-4);

  border:
    1px solid
    var(--color-primary);

  border-radius:
    var(--radius-md);

  background:
    var(--color-primary);

  color: white;

  font-size:
    var(--font-size-sm);

  font-weight:
    var(--font-weight-medium);

  text-decoration: none;

  transition:
    background 0.2s ease,
    transform 0.2s ease;
}


.detail-button:hover {
  opacity: 0.92;

  transform:
    translateY(-1px);
}


/* =========================================================
   PAGINATION
========================================================= */

.pagination {
  display: flex;

  align-items: center;

  justify-content: center;

  gap: var(--space-2);

  margin-top:
    var(--space-10);
}


.page-button {
  display: flex;

  align-items: center;

  justify-content: center;

  min-width: 40px;

  height: 40px;

  padding:
    0
    var(--space-3);

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-md);

  background:
    var(--color-background);

  color:
    var(--color-text);

  font: inherit;

  cursor: pointer;

  transition:
    border-color 0.2s ease,
    background 0.2s ease;
}


.page-button:hover:not(:disabled) {
  border-color:
    var(--color-primary);
}


.page-button.active {
  border-color:
    var(--color-primary);

  background:
    var(--color-primary);

  color: white;
}


.page-button:disabled {
  opacity: 0.45;

  cursor: not-allowed;
}


/* =========================================================
   STATES
========================================================= */

.state-card {
  display: flex;

  flex-direction: column;

  align-items: center;

  justify-content: center;

  min-height: 320px;

  padding:
    var(--space-8);

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-xl);

  background:
    var(--color-surface);

  text-align: center;
}


.state-card h2 {
  margin:
    var(--space-4)
    0
    var(--space-2);
}


.state-card p {
  margin: 0;

  color:
    var(--color-text-muted);
}


/* =========================================================
   LOADING
========================================================= */

.loading-spinner {
  width: 34px;

  height: 34px;

  border:
    3px solid
    var(--color-border);

  border-top-color:
    var(--color-primary);

  border-radius: 50%;

  animation:
    spin 0.8s linear infinite;
}


@keyframes spin {

  to {
    transform:
      rotate(360deg);
  }

}


/* =========================================================
   ERROR
========================================================= */

.state-icon {
  display: flex;

  align-items: center;

  justify-content: center;

  width: 48px;

  height: 48px;

  border-radius: 50%;

  background:
    var(--color-danger);

  color: white;

  font-size:
    var(--font-size-lg);

  font-weight:
    var(--font-weight-bold);
}


.primary-button {
  margin-top:
    var(--space-5);

  padding:
    var(--space-3)
    var(--space-5);

  border: 0;

  border-radius:
    var(--radius-md);

  background:
    var(--color-primary);

  color: white;

  font: inherit;

  font-weight:
    var(--font-weight-medium);

  cursor: pointer;
}


/* =========================================================
   TABLET
========================================================= */

@media (max-width: 1024px) {

  .journey-filters {
    grid-template-columns: minmax(0, 1fr) minmax(180px, 0.7fr);
  }

  .clear-filter-button {
    grid-column: 1 / -1;
    justify-self: start;
  }

  .journey-grid {
    grid-template-columns:
      repeat(
        2,
        minmax(0, 1fr)
      );
  }

}


/* =========================================================
   MOBILE
========================================================= */

@media (max-width: 640px) {

  .journey-filters {
    grid-template-columns: 1fr;
    gap: var(--space-3);
    margin-top: calc(var(--space-3) * -1);
    margin-bottom: var(--space-7);
    padding: var(--space-4);
  }

  .clear-filter-button {
    width: 100%;
    grid-column: auto;
  }

  .page {
    padding:
      var(--space-7)
      0
      var(--space-10);
  }


  .page-heading {
    margin-bottom:
      var(--space-7);
  }


  .page-heading h1 {
    font-size: 2rem;
  }


  .page-heading p {
    font-size:
      var(--font-size-sm);
  }


  .journey-grid {
    grid-template-columns: 1fr;

    gap: var(--space-4);
  }


  .card-visual {
    height: 190px;
  }


  .card-body {
    min-height: auto;
  }


  .pagination {
    margin-top:
      var(--space-7);
  }


  .page-button {
    min-width: 38px;

    height: 38px;
  }

}

</style>