<script setup>
import { computed, ref } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { mockJourneys } from '../data/mockJourneys'

import phoHaNoi from '../assets/images/dishes/pho-ha-noi.webp'
import bunBoHue from '../assets/images/dishes/bun-bo-hue.jpeg'
import miQuang from '../assets/images/dishes/mi-quang.jpg'

import mienBacImage from '../assets/images/regions/mien-bac.jpeg'
import mienTrungImage from '../assets/images/regions/mien-trung.jpeg'
import mienNamImage from '../assets/images/regions/mien-nam.jpeg'
import heroImage from '../assets/images/hero/hero-vietnam.jpeg'
const router = useRouter()

const keyword = ref('')

/*
 * Dữ liệu món ăn mẫu.
 * Các trường được giữ theo cấu trúc dữ liệu mon_an
 * mà V4 đã sử dụng ở trang danh sách / chi tiết.
 */
const featuredDishes = [
  {
    mon_an_id: 1,
    ten_mon: 'Phở Hà Nội',
    mo_ta: 'Món ăn truyền thống nổi tiếng của Hà Nội.',
    gia_tham_khao: 50000,
    vung_mien: 'Miền Bắc',
    image: phoHaNoi
  },
  {
    mon_an_id: 5,
    ten_mon: 'Bún bò Huế',
    mo_ta: 'Món bún đặc trưng gắn với ẩm thực cố đô Huế.',
    gia_tham_khao: 55000,
    vung_mien: 'Miền Trung',
    image: bunBoHue
  },
  {
    mon_an_id: 6,
    ten_mon: 'Mì Quảng',
    mo_ta: 'Món mì đặc sản mang đậm hương vị Quảng Nam.',
    gia_tham_khao: 55000,
    vung_mien: 'Miền Trung',
    image: miQuang
  }
]

const featuredJourneys = computed(() => {
  return mockJourneys.slice(0, 3)
})

const formatPrice = (price) => {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }

  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}

const handleSearch = () => {
  /*
   * Hiện tại API tìm kiếm theo keyword của V3
   * chưa được tích hợp vào Home.
   *
   * Vì vậy Home chỉ chuyển người dùng tới
   * trang danh sách món ăn.
   */
  router.push('/mon-an')
}
</script>

<template>
  <main class="home">

<!-- =====================================================
     HERO
====================================================== -->

<section class="hero-section">

  <div class="container">

    <div class="hero-layout">

      <!-- =========================
           LEFT CONTENT
      ========================== -->

      <div class="hero-content">

        <span class="hero-eyebrow">
          AT-11 · BẢN ĐỒ DU LỊCH ẨM THỰC
        </span>


        <h1 class="hero-title">
          Khám phá
          <span>hương vị Việt</span>
          từ Bắc vào Nam
        </h1>


        <p class="hero-description">
          Khám phá món ăn đặc trưng, điểm đến ẩm thực
          và những hành trình trải nghiệm từ Bắc vào Nam.
        </p>


        <!-- CTA -->

        <div class="hero-actions">

          <RouterLink
            to="/mon-an"
            class="hero-primary-button"
          >
            Khám phá món ăn
            <span>→</span>
          </RouterLink>

          <RouterLink
            to="/hanh-trinh"
            class="hero-secondary-button"
          >
            Hành trình ẩm thực
          </RouterLink>

        </div>


        <!-- SEARCH -->

        <form
          class="hero-search"
          @submit.prevent="handleSearch"
        >

          <div class="hero-search-input">

            <span class="hero-search-icon">
              ⌕
            </span>

            <input
              v-model="keyword"
              type="text"
              placeholder="Tìm món ăn, vùng miền hoặc địa điểm..."
              aria-label="Tìm kiếm ẩm thực"
            />

          </div>

          <button
            type="submit"
            class="hero-search-button"
          >
            Tìm kiếm
          </button>

        </form>


        <div class="hero-suggestions">
          <span>Gợi ý:</span>

          <RouterLink to="/mon-an">
            Phở Hà Nội
          </RouterLink>

          <RouterLink to="/mon-an">
            Bún bò Huế
          </RouterLink>

          <RouterLink to="/mon-an">
            Mì Quảng
          </RouterLink>
        </div>

      </div>

      <!-- =========================
           RIGHT VISUAL
      ========================== -->

      <div class="hero-visual">

        <div class="hero-image-card">

          <img
            :src="heroImage"
            alt="Ẩm thực Việt Nam"
            class="hero-image"
          />

          <div class="hero-image-label">

            <span class="hero-live-dot"></span>

            <span>
              ẨM THỰC VIỆT NAM
            </span>

          </div>


          <div class="hero-image-bottom">

            <div>

              <span class="hero-bottom-label">
                HÀNH TRÌNH ẨM THỰC
              </span>

              <strong>
                Từ Bắc vào Nam
              </strong>

            </div>

            <span class="hero-bottom-arrow">
              ↗
            </span>

          </div>

        </div>

      </div>

    </div>

  </div>

</section>
<!-- =====================================================
     REGION
====================================================== -->
<section class="section region-section">
  <div class="container">

    <div class="section-heading section-heading-row">
      <div>
        <span class="section-eyebrow">KHÁM PHÁ THEO VÙNG</span>
        <h2>Hương vị từ Bắc vào Nam</h2>
        <p>
          Mỗi vùng miền mang một bản sắc và câu chuyện ẩm thực riêng.
        </p>
      </div>

      <RouterLink to="/mon-an" class="section-link">
        Khám phá món ăn
        <span>→</span>
      </RouterLink>
    </div>

    <div class="region-grid">

      <!-- MIỀN BẮC -->
      <RouterLink to="/mon-an" class="region-card">

        <div class="region-image">
          <img
            :src="mienBacImage"
            alt="Ẩm thực miền Bắc"
          />
        </div>

        <div class="region-body">
          <span class="region-label">PHÍA BẮC</span>

          <div class="region-title-row">
            <h3>Miền Bắc</h3>
            <span class="region-arrow">↗</span>
          </div>

          <p>
            Hương vị thanh nhẹ, tinh tế và giàu nét truyền thống.
          </p>
        </div>

      </RouterLink>


      <!-- MIỀN TRUNG -->
      <RouterLink to="/mon-an" class="region-card">

        <div class="region-image">
          <img
            :src="mienTrungImage"
            alt="Ẩm thực miền Trung"
          />
        </div>

        <div class="region-body">
          <span class="region-label">MIỀN TRUNG</span>

          <div class="region-title-row">
            <h3>Miền Trung</h3>
            <span class="region-arrow">↗</span>
          </div>

          <p>
            Đậm đà, tinh tế và gắn liền với văn hóa địa phương.
          </p>
        </div>

      </RouterLink>


      <!-- MIỀN NAM -->
      <RouterLink to="/mon-an" class="region-card">

        <div class="region-image">
          <img
            :src="mienNamImage"
            alt="Ẩm thực miền Nam"
          />
        </div>

        <div class="region-body">
          <span class="region-label">PHÍA NAM</span>

          <div class="region-title-row">
            <h3>Miền Nam</h3>
            <span class="region-arrow">↗</span>
          </div>

          <p>
            Phong phú, cởi mở và mang nhiều sắc thái sông nước.
          </p>
        </div>

      </RouterLink>

    </div>
  </div>
</section>
    <!-- =====================================================
         FEATURED DISHES
    ====================================================== -->

    <section class="section dishes-section">

      <div class="container">

        <div class="section-heading section-heading-row">

          <div>

            <span class="section-eyebrow">
              HƯƠNG VỊ NỔI BẬT
            </span>

            <h2>
              Những món ăn không nên bỏ lỡ
            </h2>

            <p>
              Khám phá một số món ăn tiêu biểu đang có trên hệ thống.
            </p>

          </div>

          <RouterLink
            to="/mon-an"
            class="section-link"
          >
            Xem tất cả
            <span>→</span>
          </RouterLink>

        </div>


        <div class="dish-grid">

          <article
            v-for="dish in featuredDishes"
            :key="dish.mon_an_id"
            class="dish-card"
          >

            <div class="dish-visual">

              <span class="dish-region">
                {{ dish.vung_mien }}
              </span>

              <img
                :src="dish.image"
                :alt="dish.ten_mon"
                class="dish-image"
              />

            </div>

            <div class="dish-body">

              <h3>
                {{ dish.ten_mon }}
              </h3>

              <p>
                {{ dish.mo_ta }}
              </p>

              <div class="dish-footer">

                <strong>
                  {{ formatPrice(dish.gia_tham_khao) }}
                </strong>

                <RouterLink
                  :to="`/mon-an/${dish.mon_an_id}`"
                  class="dish-link"
                >
                  Chi tiết →
                </RouterLink>

              </div>

            </div>

          </article>

        </div>

      </div>

    </section>


    <!-- =====================================================
         MAP FEATURE
    ====================================================== -->

    <section class="section map-section">

      <div class="container">

        <div class="map-feature">

          <div class="map-feature-content">

            <span class="section-eyebrow">
              ĐIỂM NHẤN CỦA AT-11
            </span>

            <h2>
              Khám phá ẩm thực
              trên bản đồ
            </h2>

            <p>
              Tìm hiểu các địa điểm và không gian ẩm thực
              theo vùng miền, tỉnh thành và điểm đến.
            </p>

            <RouterLink
              to="/ban-do"
              class="primary-button"
            >
              Khám phá bản đồ
              <span>→</span>
            </RouterLink>

          </div>


          <div class="map-preview">

            <div class="preview-grid"></div>

            <div class="preview-country">
              <div class="country-line line-a"></div>
              <div class="country-line line-b"></div>
              <div class="country-line line-c"></div>
            </div>

            <div class="preview-marker preview-marker-one">
              <span>🍜</span>
              <small>Hà Nội</small>
            </div>

            <div class="preview-marker preview-marker-two">
              <span>🍲</span>
              <small>Huế</small>
            </div>

            <div class="preview-marker preview-marker-three">
              <span>🍚</span>
              <small>Đà Nẵng</small>
            </div>

          </div>

        </div>

      </div>

    </section>


    <!-- =====================================================
         JOURNEYS
    ====================================================== -->

    <section class="section journey-section">

      <div class="container">

        <div class="section-heading section-heading-row">

          <div>

            <span class="section-eyebrow">
              TRẢI NGHIỆM
            </span>

            <h2>
              Hành trình ẩm thực
            </h2>

            <p>
              Không chỉ tìm món ăn — hãy trải nghiệm câu chuyện
              ẩm thực của từng điểm đến.
            </p>

          </div>

          <RouterLink
            to="/hanh-trinh"
            class="section-link"
          >
            Xem tất cả
            <span>→</span>
          </RouterLink>

        </div>


<div class="journey-grid">

  <article
    v-for="journey in featuredJourneys"
    :key="journey.hanh_trinh_id"
    class="home-journey-card"
  >

    <div class="journey-visual">

      <img
        :src="journey.image"
        :alt="journey.ten_hanh_trinh"
        class="journey-image"
      />

      <span class="journey-badge">
        Ẩm thực Việt Nam
      </span>

    </div>

    <div class="journey-body">

      <h3>
        {{ journey.ten_hanh_trinh }}
      </h3>

      <p>
        {{ journey.mo_ta }}
      </p>

      <div class="journey-meta">

        <span>
          ⏱ {{ journey.thoi_luong }}
        </span>

        <span>
          🍽 {{ journey.mon_an?.length || 0 }} món
        </span>

      </div>

      <RouterLink
        :to="`/hanh-trinh/${journey.hanh_trinh_id}`"
        class="journey-link"
      >
        Xem hành trình
        <span>→</span>
      </RouterLink>

    </div>

  </article>

</div>

      </div>

    </section>


    <!-- =====================================================
         CTA
    ====================================================== -->

    <section class="cta-section">

      <div class="container">

        <div class="cta-card">

          <div>

            <span>
              SẴN SÀNG KHÁM PHÁ?
            </span>

            <h2>
              Bắt đầu hành trình
              khám phá ẩm thực Việt Nam.
            </h2>

            <p>
              Từ một món ăn, một địa điểm đến cả một hành trình
              trải nghiệm.
            </p>

          </div>

          <div class="cta-actions">

            <RouterLink
              to="/mon-an"
              class="cta-primary"
            >
              Khám phá món ăn
              <span>→</span>
            </RouterLink>

            <RouterLink
              to="/hanh-trinh"
              class="cta-secondary"
            >
              Xem hành trình
            </RouterLink>

          </div>

        </div>

      </div>

    </section>

  </main>
</template>


<style scoped>

/* =========================================================
   HOME
========================================================= */

.home {
  overflow: hidden;

  background:
    var(--color-background);
}


/* =========================================================
   HERO
========================================================= */

.hero-section {
  position: relative;

  overflow: hidden;

  padding:
    80px 0
    72px;

  border-bottom: 1px solid var(--color-border);

  background:
    linear-gradient(
      135deg,
      #f8fafc 0%,
      #ffffff 55%,
      #eff6ff 100%
    );
}

.hero-container {
  display: grid;

  grid-template-columns:
    minmax(0, 1.05fr)
    minmax(380px, 0.95fr);

  align-items: center;

  gap: var(--space-12);
}

.hero-content {
  position: relative;

  z-index: 2;
}

.hero-eyebrow {
  display: inline-flex;

  align-items: center;

  margin-bottom: var(--space-5);

  color: var(--color-primary);

  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-bold);

  letter-spacing: 0.1em;
}

.hero-content h1 {
  max-width: 700px;

  margin: 0;

  color: var(--color-text);

  font-size: clamp(
    2.75rem,
    5vw,
    4.5rem
  );

  line-height: 1.04;

  letter-spacing: -0.045em;
}

.hero-content h1 span {
  display: block;

  color: var(--color-primary);
}

.hero-description {
  max-width: 650px;

  margin:
    var(--space-6)
    0
    0;

  color: var(--color-text-muted);

  font-size: var(--font-size-lg);

  line-height: 1.7;
}

.hero-actions {
  display: flex;

  flex-wrap: wrap;

  gap: var(--space-3);

  margin-top: var(--space-7);
}


/* =========================================================
   BUTTONS
========================================================= */

.primary-button,
.secondary-button {
  display: inline-flex;

  align-items: center;
  justify-content: center;

  gap: var(--space-4);

  min-height: 48px;

  padding:
    0
    var(--space-5);

  border-radius: var(--radius-md);

  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-bold);

  text-decoration: none;

  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease,
    background 0.2s ease;
}

.primary-button {
  border: 1px solid var(--color-primary);

  background: var(--color-primary);

  color: white;
}

.primary-button:hover {
  transform: translateY(-2px);

  box-shadow: var(--shadow-md);

  opacity: 0.94;
}

.secondary-button {
  border: 1px solid var(--color-border);

  background: var(--color-background);

  color: var(--color-text);
}

.secondary-button:hover {
  border-color: var(--color-primary);

  color: var(--color-primary);
}


/* =========================================================
   HERO SEARCH
========================================================= */

.hero-search {
  display: flex;

  align-items: center;

  max-width: 650px;

  margin-top: var(--space-7);

  padding: 6px;

  border: 1px solid var(--color-border);

  border-radius: var(--radius-lg);

  background: var(--color-background);

  box-shadow: var(--shadow-sm);
}

.search-icon {
  display: flex;

  align-items: center;
  justify-content: center;

  width: 44px;

  color: var(--color-text-muted);

  font-size: 1.5rem;
}

.hero-search input {
  flex: 1;

  min-width: 0;

  border: 0;

  outline: 0;

  background: transparent;

  color: var(--color-text);

  font: inherit;

  font-size: var(--font-size-sm);
}

.hero-search input::placeholder {
  color: var(--color-text-muted);
}

.hero-search button {
  min-height: 42px;

  padding:
    0
    var(--space-4);

  border: 0;

  border-radius: var(--radius-md);

  background: var(--color-primary);

  color: white;

  font: inherit;

  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-medium);

  cursor: pointer;
}


/* =====================================================
   HERO
====================================================== */

.hero-section {
  position: relative;

  padding-top: 72px;
  padding-bottom: 88px;

  overflow: hidden;

  background:
    radial-gradient(
      circle at 78% 30%,
      rgba(37, 99, 235, 0.07),
      transparent 30%
    ),
    var(--color-background);
}


/* subtle background decoration */

.hero-section::before {
  content: '';

  position: absolute;

  width: 420px;
  height: 420px;

  top: -180px;
  right: -120px;

  border-radius: 50%;

  background: rgba(37, 99, 235, 0.035);

  pointer-events: none;
}


/* =====================================================
   LAYOUT
====================================================== */

.hero-layout {
  display: grid;

  grid-template-columns:
    minmax(0, 1.02fr)
    minmax(440px, 0.98fr);

  align-items: center;

  gap: 64px;

  min-height: 610px;
}


/* =====================================================
   LEFT
====================================================== */

.hero-content {
  position: relative;

  z-index: 2;

  max-width: 680px;
}

.hero-eyebrow {
  display: inline-flex;
  align-items: center;

  margin-bottom: 20px;

  color: var(--color-primary);

  font-size: 15px;
  line-height: 1;
  font-weight: 800;

  letter-spacing: 0.08em;
}


.hero-title {
  max-width: 650px;

  margin: 0;

  color: var(--color-text);

  font-size: clamp(48px, 5vw, 76px);
  line-height: 1.02;

  font-weight: 800;

  letter-spacing: -0.045em;
}


.hero-title span {
  display: inline;

  color: var(--color-primary);
}


.hero-description {
  max-width: 620px;

  margin: 28px 0 26px;

  color: var(--color-text-muted);

  font-size: 18px;
  line-height: 1.65;
}


/* =====================================================
   CTA
====================================================== */

.hero-actions {
  display: flex;
  align-items: center;

  gap: 12px;

  margin-bottom: 22px;
}


.hero-primary-button,
.hero-secondary-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;

  min-height: 52px;

  padding: 0 20px;

  border-radius: 11px;

  font-size: 15px;
  font-weight: 700;

  text-decoration: none;

  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease,
    background 0.2s ease;
}


.hero-primary-button {
  gap: 12px;

  background: var(--color-primary);

  color: #ffffff;

  box-shadow:
    0 8px 18px rgba(37, 99, 235, 0.2);
}


.hero-primary-button:hover {
  transform: translateY(-2px);

  box-shadow:
    0 12px 24px rgba(37, 99, 235, 0.25);
}


.hero-primary-button span {
  font-size: 19px;

  transition: transform 0.2s ease;
}


.hero-primary-button:hover span {
  transform: translateX(4px);
}


.hero-secondary-button {
  border: 1px solid var(--color-border);

  background: var(--color-background);

  color: var(--color-text);
}


.hero-secondary-button:hover {
  border-color: var(--color-primary);

  color: var(--color-primary);

  transform: translateY(-2px);
}


/* =====================================================
   SEARCH
====================================================== */

.hero-search {
  display: flex;
  align-items: stretch;

  width: 100%;
  max-width: 650px;

  min-height: 58px;

  padding: 5px;

  border: 1px solid var(--color-border);

  border-radius: 13px;

  background: var(--color-background);

  box-shadow:
    0 8px 24px rgba(15, 23, 42, 0.06);
}


.hero-search-input {
  flex: 1;

  display: flex;
  align-items: center;

  min-width: 0;
}


.hero-search-icon {
  flex-shrink: 0;

  margin-left: 14px;
  margin-right: 10px;

  color: var(--color-text-muted);

  font-size: 24px;
}


.hero-search-input input {
  width: 100%;

  min-width: 0;

  border: none;
  outline: none;

  background: transparent;

  color: var(--color-text);

  font-family: inherit;

  font-size: 14px;
}


.hero-search-input input::placeholder {
  color: var(--color-text-muted);
}


.hero-search-button {
  flex-shrink: 0;

  min-width: 100px;

  border: none;
  border-radius: 9px;

  background: var(--color-text);

  color: #ffffff;

  font-family: inherit;

  font-size: 14px;
  font-weight: 700;

  cursor: pointer;

  transition:
    background 0.2s ease,
    transform 0.2s ease;
}


.hero-search-button:hover {
  background: var(--color-primary);

  transform: translateY(-1px);
}


/* =====================================================
   SUGGESTIONS
====================================================== */

.hero-suggestions {
  display: flex;
  align-items: center;
  flex-wrap: wrap;

  gap: 8px;

  margin-top: 12px;

  color: var(--color-text-muted);

  font-size: 12px;
}


.hero-suggestions a {
  color: var(--color-text-muted);

  text-decoration: none;

  transition: color 0.2s ease;
}


.hero-suggestions a:hover {
  color: var(--color-primary);
}


/* =========================================================
   HERO VISUAL — PREMIUM
========================================================= */

.hero-visual {
  position: relative;

  display: flex;
  align-items: center;
  justify-content: center;

  min-height: 520px;
}


/* =========================================================
   IMAGE CARD
========================================================= */

.hero-image-card {
  position: relative;

  width: 100%;
  max-width: 540px;

  height: 540px;

  overflow: hidden;

  border-radius: 28px;

  background: #111827;

  box-shadow:
    0 30px 70px rgba(15, 23, 42, 0.16);

  transform: translateY(0);

  transition:
    transform 0.35s ease,
    box-shadow 0.35s ease;
}

.hero-image-card:hover {
  transform: translateY(-4px);

  box-shadow:
    0 36px 80px rgba(15, 23, 42, 0.2);
}


/* =========================================================
   IMAGE
========================================================= */

.hero-image {
  width: 100%;
  height: 100%;

  display: block;

  object-fit: cover;

  transition:
    transform 0.7s ease;
}

.hero-image-card:hover .hero-image {
  transform: scale(1.035);
}


/* =========================================================
   DARK OVERLAY
========================================================= */

.hero-image-overlay {
  position: absolute;

  inset: 0;

  background:
    linear-gradient(
      to bottom,
      rgba(15, 23, 42, 0.08) 0%,
      rgba(15, 23, 42, 0.02) 42%,
      rgba(15, 23, 42, 0.78) 100%
    );
}


/* =========================================================
   TOP LABEL
========================================================= */

.hero-image-label {
  position: absolute;

  top: 22px;
  left: 22px;

  display: inline-flex;

  align-items: center;

  gap: 8px;

  padding:
    9px
    13px;

  border:
    1px solid
    rgba(255, 255, 255, 0.2);

  border-radius: 999px;

  background:
    rgba(15, 23, 42, 0.58);

  color: white;

  font-size: 11px;

  font-weight: 700;

  letter-spacing: 0.08em;

  backdrop-filter: blur(12px);
}

.hero-live-dot {
  width: 7px;
  height: 7px;

  flex-shrink: 0;

  border-radius: 50%;

  background: #60a5fa;

  box-shadow:
    0 0 0 4px
    rgba(96, 165, 250, 0.18);
}


/* =========================================================
   REGION PATH
========================================================= */

.hero-region-path {
  position: absolute;

  top: 50%;

  left: 50%;

  display: flex;

  align-items: center;

  gap: 10px;

  width: max-content;

  transform:
    translate(-50%, -50%);
}

.hero-region-item {
  display: flex;

  align-items: center;

  gap: 7px;

  padding:
    7px
    10px;

  border:
    1px solid
    rgba(255, 255, 255, 0.24);

  border-radius: 999px;

  background:
    rgba(15, 23, 42, 0.45);

  color: white;

  font-size: 11px;

  font-weight: 600;

  white-space: nowrap;

  backdrop-filter: blur(10px);
}

.hero-region-dot {
  width: 6px;
  height: 6px;

  border-radius: 50%;

  background: #60a5fa;
}

.hero-region-line {
  width: 22px;
  height: 1px;

  background:
    rgba(255, 255, 255, 0.55);
}


/* =========================================================
   BOTTOM INFO
========================================================= */

.hero-image-bottom {
  position: absolute;

  right: 22px;
  bottom: 22px;
  left: 22px;

  display: flex;

  align-items: flex-end;
  justify-content: space-between;

  gap: 20px;
}

.hero-image-bottom > div {
  display: flex;

  flex-direction: column;

  gap: 5px;
}

.hero-bottom-label {
  color:
    rgba(255, 255, 255, 0.7);

  font-size: 10px;

  font-weight: 700;

  letter-spacing: 0.12em;
}

.hero-image-bottom strong {
  color: white;

  font-size: 26px;

  line-height: 1.2;

  font-weight: 700;
}

.hero-bottom-arrow {
  display: flex;

  align-items: center;
  justify-content: center;

  width: 44px;
  height: 44px;

  flex-shrink: 0;

  border:
    1px solid
    rgba(255, 255, 255, 0.25);

  border-radius: 50%;

  background:
    rgba(255, 255, 255, 0.12);

  color: white;

  font-size: 20px;

  backdrop-filter: blur(10px);
}


/* =========================================================
   REMOVE OLD FLOATING CARD
========================================================= */

.hero-floating-card {
  display: none;
}


/* =========================================================
   HERO RESPONSIVE
========================================================= */

@media (max-width: 1023px) {

  .hero-container {
    grid-template-columns: 1fr;

    gap: 48px;
  }

  .hero-content {
    max-width: 760px;
  }

  .hero-visual {
    min-height: auto;
  }

  .hero-image-card {
    max-width: 680px;

    height: 500px;
  }

}


@media (max-width: 639px) {

  .hero-section {
    padding:
      56px 0
      56px;
  }

  .hero-container {
    gap: 36px;
  }

  .hero-content h1 {
    font-size: 42px;

    line-height: 1.08;

    letter-spacing: -0.035em;
  }

  .hero-description {
    font-size: 16px;

    line-height: 1.65;
  }

  .hero-actions {
    flex-direction: column;

    align-items: stretch;
  }

  .primary-button,
  .secondary-button {
    width: 100%;
  }

  .hero-search {
    margin-top: 20px;
  }

  .hero-search button {
    padding:
      0
      14px;
  }

  .hero-visual {
    width: 100%;
  }

  .hero-image-card {
    height: 430px;

    border-radius: 22px;
  }

  .hero-image-label {
    top: 16px;
    left: 16px;
  }

  .hero-region-path {
    top: 48%;

    gap: 5px;
  }

  .hero-region-item {
    padding:
      6px
      8px;

    font-size: 9px;
  }

  .hero-region-line {
    width: 10px;
  }

  .hero-image-bottom {
    right: 16px;
    bottom: 16px;
    left: 16px;
  }

  .hero-image-bottom strong {
    font-size: 21px;
  }

  .hero-bottom-arrow {
    width: 38px;
    height: 38px;
  }

}
.hero-content h1 {
  max-width: 680px;

  margin: 0;

  color: var(--color-text);

  font-size: clamp(
    3rem,
    5vw,
    4rem
  );

  line-height: 1.06;

  letter-spacing: -0.04em;
}

/* =====================================================
   IMAGE LABEL
====================================================== */

.hero-image-label {
  position: absolute;

  top: 22px;
  left: 22px;

  display: inline-flex;
  align-items: center;

  gap: 8px;

  padding: 9px 13px;

  border: 1px solid rgba(255, 255, 255, 0.25);

  border-radius: 999px;

  background: rgba(15, 23, 42, 0.58);

  color: #ffffff;

  font-size: 11px;
  font-weight: 800;

  letter-spacing: 0.08em;

  backdrop-filter: blur(10px);
}


.hero-live-dot {
  width: 7px;
  height: 7px;

  border-radius: 50%;

  background: #ffffff;
}


/* =====================================================
   MAP PATH
====================================================== */

.hero-map-path {
  position: absolute;

  inset: 0;

  pointer-events: none;
}


.hero-map-line {
  position: absolute;

  width: 2px;

  background: rgba(255, 255, 255, 0.72);

  transform-origin: top center;

  border-radius: 999px;
}


.line-one {
  height: 110px;

  top: 190px;
  left: 51%;

  transform:
    rotate(16deg);
}


.line-two {
  height: 105px;

  top: 292px;
  left: 54%;

  transform:
    rotate(-18deg);
}


.hero-map-pin {
  position: absolute;

  display: flex;
  align-items: center;
  justify-content: center;

  width: 48px;
  height: 48px;

  border: 3px solid rgba(255, 255, 255, 0.9);

  border-radius: 50%;

  background: var(--color-primary);

  color: #ffffff;

  font-size: 12px;
  font-weight: 800;

  box-shadow:
    0 8px 20px rgba(15, 23, 42, 0.2);
}


.pin-north {
  top: 165px;
  left: 47%;
}


.pin-central {
  top: 270px;
  left: 53%;
}


.pin-south {
  top: 375px;
  left: 47%;
}


/* =====================================================
   BOTTOM INFO
====================================================== */

.hero-image-bottom {
  position: absolute;

  left: 24px;
  right: 24px;
  bottom: 22px;

  display: flex;
  align-items: flex-end;
  justify-content: space-between;

  color: #ffffff;
}


.hero-image-bottom div {
  display: flex;
  flex-direction: column;

  gap: 4px;
}


.hero-image-bottom strong {
  font-size: 18px;
  line-height: 1.2;
}


.hero-image-bottom span {
  font-size: 13px;

  opacity: 0.82;
}


.hero-bottom-arrow {
  display: flex;
  align-items: center;
  justify-content: center;

  width: 42px;
  height: 42px;

  border: 1px solid rgba(255, 255, 255, 0.35);

  border-radius: 50%;

  background: rgba(15, 23, 42, 0.35);

  color: #ffffff !important;

  font-size: 20px !important;

  backdrop-filter: blur(8px);
}


/* =====================================================
   FLOATING CARD
====================================================== */

.hero-floating-card {
  position: absolute;

  right: -4px;
  bottom: 48px;

  display: flex;
  align-items: center;

  gap: 11px;

  padding: 12px 15px;

  border: 1px solid rgba(255, 255, 255, 0.8);

  border-radius: 14px;

  background: rgba(255, 255, 255, 0.94);

  box-shadow:
    0 14px 30px rgba(15, 23, 42, 0.14);

  backdrop-filter: blur(10px);
}


.hero-floating-icon {
  display: flex;
  align-items: center;
  justify-content: center;

  width: 36px;
  height: 36px;

  border-radius: 10px;

  background: #eff6ff;

  font-size: 18px;
}


.hero-floating-card div {
  display: flex;
  flex-direction: column;

  gap: 3px;
}


.hero-floating-card strong {
  color: var(--color-text);

  font-size: 13px;
}


.hero-floating-card span {
  color: var(--color-text-muted);

  font-size: 11px;
}
/* =========================================================
   SECTIONS
========================================================= */

.section {
    padding: 88px 0;
}

.section-heading {
  margin-bottom: 40px;

}

.section-heading-row {
  display: flex;

  align-items: flex-end;

  justify-content: space-between;

  gap: var(--space-6);
}

.section-eyebrow {
  display: inline-block;

  margin-bottom: var(--space-3);

  color: var(--color-primary);

  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-bold);

  letter-spacing: 0.09em;
}

.section-heading h2 {
  margin: 0;

  color: var(--color-text);

  font-size: clamp(
    1.75rem,
    3vw,
    2.5rem
  );

  line-height: 1.2;

  letter-spacing: -0.025em;
}

.section-heading p {
  max-width: 650px;

  margin:
    var(--space-3)
    0
    0;

  color: var(--color-text-muted);

  font-size: var(--font-size-md);

  line-height: 1.7;
}

.section-link {
  display: inline-flex;

  align-items: center;

  gap: var(--space-2);

  flex-shrink: 0;

  color: var(--color-primary);

  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-bold);

  text-decoration: none;
}

.section-link:hover {
  text-decoration: underline;
}


/* =====================================================
   REGION
====================================================== */

.region-section {
  padding-top: 72px;
  padding-bottom: 88px;
}

.region-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 24px;
  margin-top: 32px;
}

.region-card {
  display: block;
  overflow: hidden;

  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: 18px;

  text-decoration: none;

  transition:
    transform 0.25s ease,
    box-shadow 0.25s ease,
    border-color 0.25s ease;
}

.region-card:hover {
  transform: translateY(-5px);

  border-color: rgba(37, 99, 235, 0.22);

  box-shadow:
    0 14px 30px rgba(15, 23, 42, 0.09);
}


/* IMAGE */

.region-image {
  width: 100%;
  height: 210px;

  overflow: hidden;

  background: var(--color-surface);
}

.region-image img {
  width: 100%;
  height: 100%;

  display: block;

  object-fit: cover;

  transition: transform 0.45s ease;
}

.region-card:hover .region-image img {
  transform: scale(1.04);
}


/* BODY */

.region-body {
  padding: 22px 22px 24px;
}

.region-label {
  display: block;

  margin-bottom: 8px;

  color: var(--color-text-muted);

  font-size: 12px;
  line-height: 1;
  font-weight: 700;

  letter-spacing: 0.12em;
}


/* TITLE */

.region-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;

  gap: 16px;
}

.region-title-row h3 {
  margin: 0;

  color: var(--color-text);

  font-size: 25px;
  line-height: 1.2;
  font-weight: 700;
}

.region-arrow {
  flex-shrink: 0;

  display: flex;
  align-items: center;
  justify-content: center;

  width: 34px;
  height: 34px;

  border: 1px solid var(--color-border);
  border-radius: 50%;

  color: var(--color-primary);

  font-size: 18px;
  line-height: 1;

  transition:
    background 0.2s ease,
    color 0.2s ease,
    transform 0.2s ease;
}

.region-card:hover .region-arrow {
  background: var(--color-primary);
  color: #ffffff;

  transform: translate(2px, -2px);
}


/* DESCRIPTION */

.region-body p {
  max-width: 330px;

  margin: 10px 0 0;

  color: var(--color-text-muted);

  font-size: 14px;
  line-height: 1.6;
}
/* =========================================================
   DISHES
========================================================= */

.dishes-section {
  background: var(--color-surface);
}

.dish-grid {
  display: grid;

  grid-template-columns:
    repeat(3, minmax(0, 1fr));

  gap: var(--space-5);
}

.dish-card {
  overflow: hidden;

  border: 1px solid var(--color-border);

  border-radius: var(--radius-xl);

  background: var(--color-background);

  box-shadow: var(--shadow-sm);

  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease;
}

.dish-card:hover {
  transform: translateY(-4px);

  box-shadow: var(--shadow-md);
}

.dish-visual {
  position: relative;

  height: 230px;

  overflow: hidden;

  background: var(--color-surface);
}

.dish-image {
  width: 100%;
  height: 100%;

  display: block;

  object-fit: cover;
}

.dish-region {
  position: absolute;

  z-index: 2;

  top: var(--space-4);

  left: var(--space-4);

  padding:
    var(--space-2)
    var(--space-3);

  border: 1px solid var(--color-border);

  border-radius: var(--radius-full);

  background:
    rgba(255,255,255,0.9);

  color: var(--color-text-muted);

  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-medium);
}


.dish-body {
  padding: var(--space-5);
}

.dish-body h3 {
  margin: 0 0 var(--space-2);

  font-size: 23px;
}

.dish-body p {
  min-height: 48px;

  margin: 0;

  color: var(--color-text-muted);

  font-size: 18px;

  line-height: 1.6;
}

.dish-footer {
  display: flex;

  align-items: center;

  justify-content: space-between;

  gap: var(--space-4);

  margin-top: var(--space-5);

  padding-top: var(--space-4);

  border-top: 1px solid var(--color-border);
}

.dish-footer strong {
  color: var(--color-primary);
  font-weight: 700;
  font-size: var(--font-size-sm);
    font-size: 19px; 

}
.dish-footer span[data-v-b4e148ca] {
  font-size: 19px; 
}
.dish-link {
  color: var(--color-text);

  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-medium);

  text-decoration: none;
}

.dish-link:hover {
  color: var(--color-primary);
}


/* =========================================================
   MAP FEATURE
========================================================= */

.map-section {
  background: var(--color-background);
}

.map-feature {
  display: grid;

  grid-template-columns:
    minmax(0, 0.8fr)
    minmax(0, 1.2fr);

  align-items: center;

  gap: var(--space-10);

  padding: var(--space-8);

  border-radius: 24px;

  background:
    #111827;

  color: white;

  overflow: hidden;
}

.map-feature-content {
  position: relative;

  z-index: 2;
}

.map-feature-content .section-eyebrow {
  color: #93c5fd;
}

.map-feature-content h2 {
  max-width: 500px;

  margin: 0;

  font-size: clamp(
    2rem,
    4vw,
    3rem
  );

  line-height: 1.15;
}

.map-feature-content p {
  max-width: 500px;

  margin:
    var(--space-4)
    0
    var(--space-6);

  color: #cbd5e1;

  line-height: 1.7;
}

.map-feature-content .primary-button {
  background: white;

  color: #111827;
}

.map-preview {
  position: relative;

  min-height: 360px;

  overflow: hidden;

  border-radius: 18px;

  background:
    linear-gradient(
      135deg,
      #172554,
      #1e3a8a
    );
}

.preview-grid {
  background-image:
    linear-gradient(
      rgba(147,197,253,0.12) 1px,
      transparent 1px
    ),
    linear-gradient(
      90deg,
      rgba(147,197,253,0.12) 1px,
      transparent 1px
    );

  background-size: 32px 32px;
}

.preview-country {
  position: absolute;

  top: 12%;

  left: 35%;

  width: 30%;

  height: 76%;

  border:
    2px solid
    rgba(255,255,255,0.35);

  border-radius: 48% 40% 55% 35%;

  transform: rotate(12deg);

  opacity: 0.7;
}

.country-line {
  position: absolute;

  left: 45%;

  width: 2px;

  height: 90%;

  background:
    rgba(255,255,255,0.2);

  transform: rotate(18deg);
}

.line-a {
  top: 5%;
}

.line-b {
  top: 0;

  transform:
    rotate(-15deg);
}

.line-c {
  top: 10%;

  transform:
    rotate(42deg);
}

.preview-marker {
  position: absolute;

  display: flex;

  flex-direction: column;

  align-items: center;

  gap: 4px;
}

.preview-marker span {
  display: flex;

  align-items: center;
  justify-content: center;

  width: 54px;

  height: 54px;

  border: 3px solid white;

  border-radius: 50%;

  background: var(--color-primary);

  box-shadow: var(--shadow-md);

  font-size: 1.35rem;
}

.preview-marker small {
  color: white;

  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-bold);
}

.preview-marker-one {
  top: 18%;

  left: 49%;
}

.preview-marker-two {
  top: 48%;

  left: 54%;
}

.preview-marker-three {
  bottom: 13%;

  left: 47%;
}


/* =====================================================
   JOURNEY SECTION
====================================================== */

.journey-section {
  padding-top: 88px;
  padding-bottom: 88px;
}


/* GRID */

.journey-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));

  gap: 24px;

  margin-top: 32px;
}


/* CARD */

.home-journey-card {
  overflow: hidden;

  background: var(--color-background);

  border: 1px solid var(--color-border);
  border-radius: 18px;

  transition:
    transform 0.25s ease,
    box-shadow 0.25s ease,
    border-color 0.25s ease;
}

.home-journey-card:hover {
  transform: translateY(-5px);

  border-color: rgba(37, 99, 235, 0.2);

  box-shadow:
    0 14px 30px rgba(15, 23, 42, 0.09);
}


/* IMAGE */

.journey-visual {
  position: relative;

  width: 100%;
  height: 220px;

  overflow: hidden;

  background: var(--color-surface);
}

.journey-image {
  width: 100%;
  height: 100%;

  display: block;

  object-fit: cover;

  transition: transform 0.45s ease;
}

.home-journey-card:hover .journey-image {
  transform: scale(1.04);
}


/* BADGE */

.journey-badge {
  position: absolute;

  top: 16px;
  left: 16px;

  padding: 7px 11px;

  border-radius: 999px;

  background: rgba(17, 24, 39, 0.78);

  color: #ffffff;

  font-size: 11px;
  font-weight: 700;

  letter-spacing: 0.03em;

  backdrop-filter: blur(8px);
}


/* BODY */

.journey-body {
  padding: 22px;
}

.journey-body h3 {
  margin: 0;

  color: var(--color-text);

  font-size: 19px;
  line-height: 1.35;
  font-weight: 700;
}

.journey-body > p {
  margin: 10px 0 16px;

  color: var(--color-text-muted);

  font-size: 14px;
  line-height: 1.6;
}


/* META */

.journey-meta {
  display: flex;
  align-items: center;
  gap: 16px;

  margin-bottom: 18px;

  color: var(--color-text-muted);

  font-size: 13px;
}


/* LINK */

.journey-link {
  display: inline-flex;
  align-items: center;
  gap: 7px;

  color: var(--color-primary);

  font-size: 14px;
  font-weight: 700;

  text-decoration: none;
}

.journey-link span {
  transition: transform 0.2s ease;
}

.journey-link:hover span {
  transform: translateX(4px);
}

/* =========================================================
   CTA
========================================================= */

.cta-section {
  padding:
    0
    0
    var(--space-16);

  background: var(--color-surface);
}

.cta-card {
  display: flex;

  align-items: center;

  justify-content: space-between;

  gap: var(--space-8);

  padding:
    var(--space-8)
    var(--space-10);

  border-radius: 24px;

  background:
    linear-gradient(
      135deg,
      #2563eb,
      #1d4ed8
    );

  color: white;

  box-shadow:
    0 20px 50px
    rgba(37,99,235,0.2);
}

.cta-card > div:first-child {
  max-width: 650px;
}

.cta-card span {
  font-size: var(--font-size-xs);

  font-weight: var(--font-weight-bold);

  letter-spacing: 0.1em;
}

.cta-card h2 {
  margin:
    var(--space-3)
    0
    var(--space-3);

  font-size: clamp(
    1.75rem,
    3vw,
    2.5rem
  );

  line-height: 1.2;
}

.cta-card p {
  margin: 0;

  color: #dbeafe;

  line-height: 1.6;
}

.cta-actions {
  display: flex;

  flex-wrap: wrap;

  gap: var(--space-3);

  flex-shrink: 0;
}

.cta-primary,
.cta-secondary {
  display: inline-flex;

  align-items: center;

  justify-content: center;

  gap: var(--space-3);

  min-height: 46px;

  padding:
    0
    var(--space-5);

  border-radius: var(--radius-md);

  font-size: var(--font-size-sm);

  font-weight: var(--font-weight-bold);

  text-decoration: none;
}

.cta-primary {
  background: white;

  color: var(--color-primary);
}

.cta-secondary {
  border: 1px solid rgba(255,255,255,0.5);

  color: white;
}


/* =========================================================
   TABLET
========================================================= */

@media (max-width: 1024px) {

  .hero-container {
    grid-template-columns: 1fr;

    gap: var(--space-8);
  }

  .hero-content {
    max-width: 850px;
  }

  .hero-visual {
    min-height: 420px;
  }

  .region-grid,
  .dish-grid,
  .journey-grid {
    grid-template-columns:
      repeat(2, minmax(0, 1fr));
  }

  .region-card:last-child,
  .dish-card:last-child,
  .home-journey-card:last-child {
    grid-column: span 2;
  }
 .region-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .region-grid .region-card:last-child {
    grid-column: 1 / -1;
  }
  .journey-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .map-feature {
    grid-template-columns: 1fr;
  }

  .map-preview {
    min-height: 320px;
  }

  .cta-card {
    align-items: flex-start;

    flex-direction: column;
  }
    .hero-layout {
    grid-template-columns: 1fr;

    gap: 48px;

    min-height: auto;
  }


  .hero-content {
    max-width: 760px;
  }


  .hero-title {
    max-width: 720px;
  }


  .hero-visual {
    width: min(100%, 700px);

    margin: 0 auto;
  }


  .hero-image-card {
    height: 500px;
  }

}


/* =========================================================
   MOBILE
========================================================= */

@media (max-width: 640px) {

  .hero-section {
    padding:
      var(--space-10)
      0
      var(--space-8);
  }

  .hero-content h1 {
    font-size: 2.65rem;

    letter-spacing: -0.04em;
  }

  .hero-description {
    font-size: var(--font-size-md);
  }

  .hero-actions {
    flex-direction: column;
  }

  .primary-button,
  .secondary-button {
    width: 100%;
  }

  .hero-search {
    align-items: stretch;

    flex-wrap: wrap;
  }

  .search-icon {
    width: 38px;
  }

  .hero-search input {
    width: calc(100% - 38px);
  }

  .hero-search button {
    width: 100%;

    margin-top: 6px;
  }

  .hero-visual {
    min-height: 330px;
  }

  .hero-map-card {
    width: 100%;

    transform: none;
  }

  .map-shape {
    height: 270px;
  }

  .section {
    padding:
      var(--space-10)
      0;
  }

  .section-heading-row {
    align-items: flex-start;

    flex-direction: column;
  }

  .region-grid,
  .dish-grid,
  .journey-grid {
    grid-template-columns: 1fr;
  }

  .region-card:last-child,
  .dish-card:last-child,
  .home-journey-card:last-child {
    grid-column: auto;
  }

  .region-card {
    min-height: 260px;
  }
.region-section {
    padding-top: 56px;
    padding-bottom: 64px;
  }

  .region-grid {
    grid-template-columns: 1fr;
    gap: 18px;
    margin-top: 24px;
  }

  .region-grid .region-card:last-child {
    grid-column: auto;
  }

  .region-image {
    height: 190px;
  }

  .region-body {
    padding: 20px;
  }

  .region-title-row h3 {
    font-size: 22px;
  }

  .dish-visual {
    height: 180px;
  }
  .journey-section {
    padding-top: 64px;
    padding-bottom: 64px;
  }

  .journey-grid {
    grid-template-columns: 1fr;
    gap: 18px;
  }

  .journey-visual {
    height: 210px;
  }

  .journey-body {
    padding: 20px;
  }

  .journey-body h3 {
    font-size: 20px;
  }

  .journey-meta {
    flex-wrap: wrap;
    gap: 10px 16px;
  }

  .map-feature {
    padding: var(--space-5);

    border-radius: var(--radius-xl);
  }

  .map-preview {
    min-height: 280px;
  }

  .cta-card {
    padding: var(--space-6);

    border-radius: var(--radius-xl);
  }

  .cta-actions {
    width: 100%;

    flex-direction: column;
  }

  .cta-primary,
  .cta-secondary {
    width: 100%;
  }
    .hero-section {
    padding-top: 42px;
    padding-bottom: 60px;
  }


  .hero-layout {
    gap: 34px;
  }


  .hero-eyebrow {
    margin-bottom: 14px;

    font-size: 12px;

    letter-spacing: 0.07em;
  }


  .hero-title {
    font-size: 43px;

    line-height: 1.04;

    letter-spacing: -0.04em;
  }


  .hero-description {
    margin-top: 20px;

    font-size: 15px;

    line-height: 1.6;
  }


  .hero-actions {
    flex-direction: column;

    align-items: stretch;

    margin-bottom: 18px;
  }


  .hero-primary-button,
  .hero-secondary-button {
    width: 100%;
  }


  .hero-search {
    min-height: 54px;
  }


  .hero-search-button {
    min-width: 84px;

    padding: 0 12px;
  }


  .hero-suggestions {
    line-height: 1.5;
  }


  .hero-visual {
    padding: 8px 0 18px;
  }


  .hero-image-card {
    height: 420px;

    border-radius: 22px;
  }


  .hero-image-label {
    top: 16px;
    left: 16px;

    padding: 8px 11px;

    font-size: 10px;
  }


  .hero-map-pin {
    width: 40px;
    height: 40px;

    font-size: 10px;
  }


  .pin-north {
    top: 120px;
  }


  .pin-central {
    top: 205px;
  }


  .pin-south {
    top: 290px;
  }


  .line-one {
    top: 145px;
    height: 80px;
  }


  .line-two {
    top: 225px;
    height: 80px;
  }


  .hero-image-bottom {
    left: 16px;
    right: 16px;
    bottom: 16px;
  }


  .hero-image-bottom strong {
    font-size: 16px;
  }


  .hero-image-bottom span {
    font-size: 11px;
  }


  .hero-bottom-arrow {
    width: 38px;
    height: 38px;
  }


  .hero-floating-card {
    right: 10px;
    bottom: 0;

    padding: 10px 12px;
  }


  .hero-floating-icon {
    width: 32px;
    height: 32px;

    font-size: 16px;
  }


  .hero-floating-card strong {
    font-size: 12px;
  }


  .hero-floating-card span {
    font-size: 10px;
  }

}
</style>