<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'

// Import 10 ảnh món ăn từ thư mục assets
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

const route = useRoute()

const dish = ref(null)
const loading = ref(false)
const errorMessage = ref('')
const recommendations = ref([])
const recommendationLoading = ref(false)
const recommendationError = ref('')

// Trạng thái tương tác (Bookmark & Share)
const isBookmarked = ref(false)
const showShareToast = ref(false)

// Trạng thái phần Đánh giá (Reviews)
const reviews = ref([])
const newReviewName = ref('')
const newReviewRating = ref(5)
const newReviewComment = ref('')

let requestVersion = 0

async function fetchDish() {
  const version = ++requestVersion
  loading.value = true
  errorMessage.value = ''
  dish.value = null

  try {
    const response = await fetch(`/api/mon-an/${encodeURIComponent(route.params.id)}`, {
      headers: { Accept: 'application/json' },
    })

    if (!response.ok) {
      if (response.status === 404) throw new Error('Không tìm thấy món ăn này.')
      throw new Error(`Không thể tải món ăn (HTTP ${response.status}).`)
    }

    const result = await response.json()
    if (version !== requestVersion) return

    if (!result?.data || typeof result.data !== 'object') {
      throw new Error('Dữ liệu món ăn trả về chưa đúng định dạng.')
    }

    dish.value = result.data

    // Khởi tạo trạng thái bookmark và load đánh giá theo ID món
    loadInteractiveData(route.params.id)
  } catch (error) {
    if (version !== requestVersion) return
    console.error('Lỗi tải chi tiết món ăn:', error)
    errorMessage.value = error.message || 'Không thể tải thông tin món ăn.'
  } finally {
    if (version === requestVersion) loading.value = false
  }
}

async function fetchRecommendations() {
  const productId = route.params.id
  if (!productId) {
    recommendations.value = []
    return
  }

  recommendationLoading.value = true
  recommendationError.value = ''
  recommendations.value = []

  try {
    const response = await fetch(
      `/api/python/recommend/${encodeURIComponent(productId)}?k=5`,
      { headers: { Accept: 'application/json' } },
    )

    if (!response.ok) throw new Error(`HTTP ${response.status}`)

    const result = await response.json()
    const rows = result?.recommendations
      ?? result?.data?.recommendations
      ?? result?.data
      ?? []

    recommendations.value = Array.isArray(rows) ? rows : []
  } catch (error) {
    console.error('Lỗi tải gợi ý món ăn:', error)
    recommendationError.value = 'Chưa thể tải gợi ý món ăn. Vui lòng thử lại sau.'
  } finally {
    recommendationLoading.value = false
  }
}

// Xử lý lưu và tải dữ liệu tương tác từ localStorage
function loadInteractiveData(id) {
  const bookmarks = JSON.parse(localStorage.getItem('bookmarked_dishes') || '{}')
  isBookmarked.value = !!bookmarks[id]

  const allReviews = JSON.parse(localStorage.getItem('dish_reviews') || '{}')
  reviews.value = allReviews[id] || [
    { id: 1, name: 'Nguyễn Minh Anh', rating: 5, comment: 'Món ăn chuẩn vị truyền thống, trình bày rất đẹp mắt và hấp dẫn.', date: '15/05/2026' },
    { id: 2, name: 'Trần Hoàng Long', rating: 4, comment: 'Hương vị đậm đà, nước dùng rất vừa miệng. Sẽ quay lại ủng hộ!', date: '18/05/2026' }
  ]
}

function toggleBookmark() {
  isBookmarked.value = !isBookmarked.value
  const bookmarks = JSON.parse(localStorage.getItem('bookmarked_dishes') || '{}')
  bookmarks[route.params.id] = isBookmarked.value
  localStorage.setItem('bookmarked_dishes', JSON.stringify(bookmarks))
}

function shareDish() {
  navigator.clipboard?.writeText(window.location.href)
  showShareToast.value = true
  setTimeout(() => {
    showShareToast.value = false
  }, 2000)
}

function submitReview() {
  if (!newReviewName.value.trim() || !newReviewComment.value.trim()) {
    alert('Vui lòng nhập đầy đủ họ tên và nội dung đánh giá!')
    return
  }

  const reviewItem = {
    id: Date.now(),
    name: newReviewName.value.trim(),
    rating: Number(newReviewRating.value),
    comment: newReviewComment.value.trim(),
    date: new Date().toLocaleDateString('vi-VN')
  }

  reviews.value.unshift(reviewItem)

  const allReviews = JSON.parse(localStorage.getItem('dish_reviews') || '{}')
  allReviews[route.params.id] = reviews.value
  localStorage.setItem('dish_reviews', JSON.stringify(allReviews))

  // Reset form
  newReviewName.value = ''
  newReviewComment.value = ''
  newReviewRating.value = 5
}

const averageRating = computed(() => {
  if (!reviews.value.length) return '5.0'
  const sum = reviews.value.reduce((acc, r) => acc + r.rating, 0)
  return (sum / reviews.value.length).toFixed(1)
})

// Ánh xạ ảnh cho 10 món đầu tiên
const getDishImage = (dishData) => {
  const id = dishData?.mon_an_id
  const imageMap = {
    1: phoHaNoiImage,
    2: bunChaImage,
    3: banhDaCuaImage,
    4: banhCuonImage,
    5: bunBoHueImage,
    6: miQuangImage,
    7: comTamImage,
    8: banhXeoImage,
    9: bunCaImage,
    10: caoLauImage
  }
  return imageMap[id] || null
}

function formatPrice(price) {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }
  const number = Number(price)
  if (!Number.isFinite(number)) return 'Chưa cập nhật'
  return new Intl.NumberFormat('vi-VN').format(number) + 'đ'
}

function recommendationId(item, index) {
  return item?.mon_an_id ?? item?.id ?? item?.id_mon_an ?? `${item?.ten_mon ?? item?.name ?? 'recommendation'}-${index}`
}

function recommendationName(item) {
  return item?.ten_mon ?? item?.name ?? item?.mon_an?.ten_mon ?? 'Món ăn được đề xuất'
}

function recommendationScore(item) {
  const score = item?.score ?? item?.diem_goi_y ?? item?.similarity
  if (score === null || score === undefined || score === '') return null
  const number = Number(score)
  return Number.isFinite(number) ? number.toFixed(2) : null
}

function locationText(value, fallback = 'Chưa có thông tin') {
  return value === null || value === undefined || value === '' ? fallback : value
}

function formatIngredientPivot(pivot) {
  if (!pivot) return ''
  const parts = []
  if (pivot.so_luong !== null && pivot.so_luong !== undefined && pivot.so_luong !== '') {
    parts.push(pivot.so_luong)
  }
  if (pivot.don_vi !== null && pivot.don_vi !== undefined && pivot.don_vi !== '') {
    parts.push(pivot.don_vi)
  }
  return parts.join(' ')
}

onMounted(() => {
  fetchDish()
  fetchRecommendations()
})

watch(() => route.params.id, () => {
  fetchDish()
  fetchRecommendations()
})
</script>

<template>
  <main class="page">
    <div class="container">
      <div v-if="loading" class="status-message" role="status">
        Đang tải thông tin món ăn...
      </div>

      <div v-else-if="errorMessage" class="status-message error" role="alert">
        {{ errorMessage }}
      </div>

      <div v-else-if="!dish" class="empty-state">
        Không tìm thấy món ăn.
      </div>

      <template v-else>
        <nav class="breadcrumb" aria-label="Đường dẫn">
          <RouterLink to="/">Trang chủ</RouterLink>
          <span>/</span>
          <RouterLink to="/mon-an">Món ăn</RouterLink>
          <span>/</span>
          <span aria-current="page">{{ dish.ten_mon }}</span>
        </nav>

        <section class="dish-detail">
          <div class="visual-container" role="img" :aria-label="`Ảnh ${dish.ten_mon}`">
            <img
              v-if="getDishImage(dish)"
              :src="getDishImage(dish)"
              :alt="dish.ten_mon"
              class="dish-detail-img"
            />
            <div v-else class="visual-placeholder">
              <span>Chưa có hình ảnh món ăn</span>
            </div>
          </div>

          <div class="dish-info">
            <div class="header-top-row">
              <span class="region-tag">
                {{ locationText(dish.vung_mien?.ten_vung, 'Chưa cập nhật vùng miền') }}
              </span>

              <!-- Nút tương tác Bookmark & Share -->
              <div class="action-buttons">
                <button
                  type="button"
                  class="action-btn"
                  :class="{ active: isBookmarked }"
                  @click="toggleBookmark"
                  :title="isBookmarked ? 'Đã lưu vào yêu thích' : 'Lưu món ăn'"
                >
                  <span class="icon">{{ isBookmarked ? '♥' : '♡' }}</span>
                  <span>{{ isBookmarked ? 'Đã lưu' : 'Lưu' }}</span>
                </button>

                <button type="button" class="action-btn" @click="shareDish" title="Chia sẻ món ăn">
                  <span class="icon">🔗</span>
                  <span>Chia sẻ</span>
                </button>
              </div>
            </div>

            <h1>{{ dish.ten_mon }}</h1>

            <p class="description">
              {{ locationText(dish.mo_ta, 'Chưa có mô tả cho món ăn này.') }}
            </p>

            <div class="price-rating-row">
              <div class="price">{{ formatPrice(dish.gia_tham_khao) }}</div>
              <div class="quick-rating">
                <span class="star">⭐</span>
                <strong>{{ averageRating }}</strong>
                <span class="count">({{ reviews.size || reviews.length }} đánh giá)</span>
              </div>
            </div>
          </div>
        </section>

        <!-- Toast thông báo khi sao chép link -->
        <transition name="fade">
          <div v-if="showShareToast" class="share-toast">
            ✨ Đã sao chép liên kết món ăn vào bộ nhớ tạm!
          </div>
        </transition>

        <!-- Địa điểm -->
        <section class="detail-section">
          <h2>Địa điểm</h2>

          <div class="info-grid">
            <div class="info-item">
              <span>Vùng miền</span>
              <strong>{{ locationText(dish.vung_mien?.ten_vung) }}</strong>
            </div>

            <div class="info-item">
              <span>Tỉnh / thành phố</span>
              <strong>{{ locationText(dish.tinh_thanh?.ten_tinh) }}</strong>
            </div>

            <div class="info-item">
              <span>Địa điểm</span>
              <strong>{{ locationText(dish.dia_diem?.ten_dia_diem) }}</strong>
              <small v-if="dish.dia_diem?.dia_chi" class="address">
                {{ dish.dia_diem.dia_chi }}
              </small>
            </div>
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

        <!-- Nguyên liệu -->
        <section class="detail-section">
          <h2>Nguyên liệu</h2>
          <template v-if="Array.isArray(dish.nguyen_lieu) && dish.nguyen_lieu.length > 0">
            <div class="ingredient-chips">
              <div v-for="(item, index) in dish.nguyen_lieu" :key="item.nguyen_lieu_id ?? index" class="ingredient-chip">
                <span class="bullet">•</span>
                <strong>{{ item.ten_nguyen_lieu || 'Nguyên liệu' }}</strong>
                <span v-if="formatIngredientPivot(item.pivot)" class="sub-info">
                  ({{ formatIngredientPivot(item.pivot) }})
                </span>
              </div>
            </div>
          </template>
          <p v-else class="placeholder-text">
            Chưa có dữ liệu nguyên liệu cho món ăn này.
          </p>
        </section>

        <!-- Câu chuyện văn hóa -->
        <section class="detail-section" v-if="Array.isArray(dish.cau_chuyen_van_hoa) && dish.cau_chuyen_van_hoa.length > 0">
          <h2>Câu chuyện văn hóa</h2>
          <div class="story-list">
            <article v-for="(story, index) in dish.cau_chuyen_van_hoa" :key="index" class="story-item">
              <h3 v-if="story.tieu_de">{{ story.tieu_de }}</h3>
              <p>{{ story.noi_dung }}</p>
            </article>
          </div>
        </section>

        <!-- Đánh giá & Bình luận (Interactive Reviews) -->
        <section class="detail-section review-section">
          <div class="review-header-flex">
            <h2>Đánh giá & Cảm nhận</h2>
            <div class="rating-badge">
              <span>⭐</span>
              <strong>{{ averageRating }}</strong> / 5.0
            </div>
          </div>

          <!-- Form viết đánh giá mới -->
          <div class="review-form-card">
            <h3>Chia sẻ cảm nhận của bạn</h3>
            <form @submit.prevent="submitReview" class="review-form">
              <div class="form-row">
                <div class="form-group">
                  <label for="reviewer-name">Họ và tên</label>
                  <input
                    id="reviewer-name"
                    v-model="newReviewName"
                    type="text"
                    placeholder="Nhập tên của bạn..."
                    required
                  />
                </div>
                <div class="form-group">
                  <label for="reviewer-rating">Đánh giá sao</label>
                  <select id="reviewer-rating" v-model="newReviewRating">
                    <option :value="5">⭐⭐⭐⭐⭐ (5/5 - Tuyệt vời)</option>
                    <option :value="4">⭐⭐⭐⭐ (4/5 - Rất ngon)</option>
                    <option :value="3">⭐⭐⭐ (3/5 - Bình thường)</option>
                    <option :value="2">⭐⭐ (2/5 - Tạm được)</option>
                    <option :value="1">⭐ (1/5 - Không hợp khẩu vị)</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label for="reviewer-comment">Nội dung bình luận</label>
                <textarea
                  id="reviewer-comment"
                  v-model="newReviewComment"
                  rows="3"
                  placeholder="Hãy chia sẻ trải nghiệm thưởng thức món ăn này..."
                  required
                ></textarea>
              </div>
              <button type="submit" class="submit-review-btn">Gửi đánh giá</button>
            </form>
          </div>

          <!-- Danh sách đánh giá -->
          <div class="reviews-list" v-if="reviews.length > 0">
            <div v-for="review in reviews" :key="review.id" class="review-card">
              <div class="review-card-top">
                <div class="reviewer-info">
                  <div class="avatar-circle">{{ review.name.charAt(0).toUpperCase() }}</div>
                  <div>
                    <strong>{{ review.name }}</strong>
                    <span class="review-date">{{ review.date }}</span>
                  </div>
                </div>
                <div class="review-stars">
                  {{ '⭐'.repeat(review.rating) }}
                </div>
              </div>
              <p class="review-comment">{{ review.comment }}</p>
            </div>
          </div>
        </section>

        <!-- Món ăn gợi ý -->
        <section class="detail-section recommendation-section">
          <h2>Món ăn có thể bạn sẽ thích</h2>
          <p class="placeholder-text recommendation-note">
            Các gợi ý được cung cấp bởi hệ thống đề xuất món ăn.
          </p>

          <p v-if="recommendationLoading" class="placeholder-text" role="status">
            Đang tải gợi ý món ăn...
          </p>

          <p v-else-if="recommendationError" class="recommendation-error" role="alert">
            {{ recommendationError }}
          </p>

          <p v-else-if="recommendations.length === 0" class="placeholder-text">
            Hiện chưa có gợi ý cho món ăn này.
          </p>

          <div v-else class="recommendation-grid">
            <article
              v-for="(item, index) in recommendations"
              :key="recommendationId(item, index)"
              class="recommendation-card"
            >
              <div class="recommendation-icon" aria-hidden="true">🍜</div>
              <div class="recommendation-content">
                <h3>{{ recommendationName(item) }}</h3>
                <p v-if="recommendationScore(item) !== null" class="recommendation-score">
                  Điểm gợi ý:
                  <strong>{{ recommendationScore(item) }}</strong>
                </p>
              </div>
            </article>
          </div>
        </section>
      </template>
    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-10) 0 var(--space-12);
}

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
  text-decoration: none;
}

.breadcrumb a:hover {
  text-decoration: underline;
}

.dish-detail {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
  gap: var(--space-8);
  margin-bottom: var(--space-12);
}

.visual-container {
  min-height: 360px;
  width: 100%;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
  background: var(--color-surface);
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

.dish-detail-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  min-height: 360px;
}

.visual-placeholder {
  min-height: 360px;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-6);
  color: var(--color-text-muted);
  text-align: center;
}

.dish-info {
  min-width: 0;
  padding: var(--space-4) 0;
}

.header-top-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-3);
}

.region-tag {
  display: inline-block;
  padding: 4px 12px;
  border-radius: var(--radius-full);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
  font-weight: 500;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.action-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  color: var(--color-text);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-btn:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.action-btn.active {
  background: #fef2f2;
  border-color: #f87171;
  color: #ef4444;
}

.action-btn .icon {
  font-size: 15px;
}

.dish-info h1 {
  margin: 0 0 var(--space-4);
  font-size: clamp(28px, 3.5vw, 36px);
  line-height: 1.2;
  font-weight: var(--font-weight-bold);
  color: var(--color-text);
}

.description {
  margin: 0 0 var(--space-6);
  color: var(--color-text-muted);
  line-height: 1.8;
  font-size: 15px;
}

.price-rating-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.price {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-bold);
  color: var(--color-primary);
}

.quick-rating {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: var(--color-text);
}

.quick-rating .count {
  color: var(--color-text-muted);
}

.share-toast {
  position: fixed;
  bottom: 30px;
  right: 30px;
  background: #0f172a;
  color: #ffffff;
  padding: 12px 20px;
  border-radius: var(--radius-md);
  font-size: 14px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.2);
  z-index: 1000;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.detail-section {
  padding: var(--space-8) 0;
  border-top: 1px solid var(--color-border);
}

.detail-section h2 {
  margin: 0 0 var(--space-5);
  font-size: 20px;
  font-weight: var(--font-weight-bold);
  color: var(--color-text);
  letter-spacing: -0.01em;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: var(--space-4);
}

.info-item {
  min-width: 0;
  padding: var(--space-5);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-surface);
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}

.info-item span {
  display: block;
  margin-bottom: var(--space-2);
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
  font-weight: 500;
}

.info-item strong {
  display: block;
  font-weight: var(--font-weight-bold);
  color: var(--color-text);
  overflow-wrap: anywhere;
}

.address {
  display: block;
  margin-top: var(--space-2);
  color: var(--color-text-muted);
  font-size: 13px;
  line-height: 1.5;
}

/* Journey Promo Card */
.journey-promo-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin: var(--space-8) 0;
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

/* Ingredients */
.ingredient-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.ingredient-chip {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  font-size: 14px;
  color: var(--color-text);
  box-shadow: 0 2px 6px rgba(0,0,0,0.02);
}

.ingredient-chip .bullet {
  color: var(--color-primary);
  font-weight: bold;
}

/* Story */
.story-list {
  display: grid;
  gap: var(--space-6);
}

.story-item {
  padding: var(--space-6);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-surface);
  box-shadow: 0 2px 10px rgba(0,0,0,0.02);
}

.story-item h3 {
  margin: 0 0 var(--space-3);
  font-size: 18px;
  font-weight: var(--font-weight-bold);
  color: var(--color-text);
}

.story-item p {
  margin: 0;
  color: var(--color-text-muted);
  line-height: 1.8;
  font-size: 15px;
}

/* Review Section */
.review-header-flex {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-5);
}

.rating-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-full);
  font-size: 14px;
}

.rating-badge strong {
  color: var(--color-primary);
  font-weight: 700;
}

.review-form-card {
  padding: var(--space-6);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  margin-bottom: var(--space-6);
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}

.review-form-card h3 {
  margin: 0 0 var(--space-4);
  font-size: 16px;
  font-weight: var(--font-weight-bold);
  color: var(--color-text);
}

.review-form {
  display: grid;
  gap: var(--space-4);
}

.form-row {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--space-4);
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group label {
  font-size: 13px;
  font-weight: 500;
  color: var(--color-text);
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px 12px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font-size: 14px;
  outline: none;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--color-primary);
}

.submit-review-btn {
  padding: 10px 20px;
  background: var(--color-primary);
  color: #ffffff;
  border: none;
  border-radius: var(--radius-md);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s ease;
  justify-self: flex-start;
}

.submit-review-btn:hover {
  opacity: 0.9;
}

.reviews-list {
  display: grid;
  gap: var(--space-4);
}

.review-card {
  padding: var(--space-5);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: 0 2px 6px rgba(0,0,0,0.02);
}

.review-card-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-3);
}

.reviewer-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.avatar-circle {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: var(--color-primary);
  color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 14px;
}

.reviewer-info strong {
  display: block;
  font-size: 14px;
  color: var(--color-text);
}

.review-date {
  font-size: 12px;
  color: var(--color-text-muted);
}

.review-stars {
  font-size: 12px;
  letter-spacing: 2px;
}

.review-comment {
  margin: 0;
  color: var(--color-text-muted);
  font-size: 14px;
  line-height: 1.6;
}

/* Recommendations */
.recommendation-note {
  margin-bottom: var(--space-6);
}

.recommendation-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: var(--space-4);
}

.recommendation-card {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  min-width: 0;
  padding: var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-surface);
  transition: border-color 0.2s ease, transform 0.2s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}

.recommendation-card:hover {
  border-color: var(--color-primary);
  transform: translateY(-2px);
}

.recommendation-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  border-radius: var(--radius-md);
  background: var(--color-background, #f5f1eb);
  font-size: 24px;
}

.recommendation-content {
  min-width: 0;
}

.recommendation-content h3 {
  margin: 0 0 var(--space-2);
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-bold);
  overflow-wrap: anywhere;
  color: var(--color-text);
}

.recommendation-score {
  margin: 0;
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
}

.recommendation-score strong {
  color: var(--color-primary);
}

.recommendation-error {
  color: #b42318;
  line-height: 1.6;
}

.placeholder-text {
  margin: 0;
  color: var(--color-text-muted);
  line-height: 1.6;
}

.empty-state {
  padding: var(--space-12);
  text-align: center;
  border: 1px dashed var(--color-border);
  border-radius: var(--radius-lg);
  color: var(--color-text-muted);
}

.status-message {
  padding: var(--space-6);
  color: var(--color-text-muted);
  text-align: center;
}

.status-message.error {
  color: #b42318;
}

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

  .visual-container {
    min-height: 240px;
  }

  .dish-detail-img {
    min-height: 240px;
  }

  .dish-info h1 {
    font-size: var(--font-size-xl);
  }

  .info-grid,
  .recommendation-grid,
  .form-row {
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