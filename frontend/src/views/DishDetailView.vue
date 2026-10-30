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

    const validRows = Array.isArray(rows) ? rows : []

    recommendations.value = validRows.filter(item => {
      if (!item) return false
      const name = typeof item === 'string' ? item : (item.name || item.ten_mon || '')
      const score = item?.score ?? item?.diem_goi_y ?? item?.similarity ?? 0

      if (
        name.toLowerCase().includes('gợi ý mặc định') ||
        name.toLowerCase().includes('default') ||
        Number(score) === 0
      ) {
        return false
      }
      return true
    })
  } catch (error) {
    console.error('Lỗi tải gợi ý món ăn:', error)
    recommendationError.value = 'Chưa thể tải gợi ý món ăn. Vui lòng thử lại sau.'
  } finally {
    recommendationLoading.value = false
  }
}

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

  newReviewName.value = ''
  newReviewComment.value = ''
  newReviewRating.value = 5
}

const averageRating = computed(() => {
  if (!reviews.value.length) return '5.0'
  const sum = reviews.value.reduce((acc, r) => acc + r.rating, 0)
  return (sum / reviews.value.length).toFixed(1)
})

const getDishImage = (input) => {
  // Trường hợp input là đối tượng món ăn hoặc ID (dùng cho trang chi tiết chính)
  if (typeof input === 'object' && input !== null) {
    const id = input.mon_an_id ?? input.id
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
    if (imageMap[id]) return imageMap[id]
    
    // Nếu có slug đi kèm trong object
    if (input.slug) {
      return getSlugImage(input.slug)
    }
    return null
  }

  // Trường hợp input là chuỗi slug trực tiếp (dùng cho danh sách gợi ý từ Python API)
  if (typeof input === 'string') {
    return getSlugImage(input)
  }

  return null
}

// Hàm phụ trợ load động ảnh từ thư mục assets theo slug
function getSlugImage(slug) {
  if (!slug) return ''
  try {
    return new URL(`../assets/images/dishes/${slug}.jpg`, import.meta.url).href
  } catch (e) {
    try {
      return new URL(`../assets/images/dishes/${slug}.webp`, import.meta.url).href
    } catch (err) {
      return ''
    }
  }
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
  if (typeof item === 'string') return item
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

// Hàm hỗ trợ chọn icon nguyên liệu sống động
function getIngredientIcon(name) {
  const lower = (name || '').toLowerCase()
  if (lower.includes('cua')) return '🦀'
  if (lower.includes('bánh đa') || lower.includes('bún') || lower.includes('mì')) return '🍜'
  if (lower.includes('cà chua')) return '🍅'
  if (lower.includes('tôm')) return '🦐'
  if (lower.includes('chả') || lower.includes('thịt')) return '🥩'
  if (lower.includes('rau') || lower.includes('lá')) return '🌿'
  if (lower.includes('hành')) return '🧅'
  return '🥗'
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
                📍 {{ locationText(dish.vung_mien?.ten_vung, 'Chưa cập nhật vùng miền') }}
              </span>

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
                <span class="count">({{ reviews.length }} đánh giá)</span>
              </div>
            </div>
          </div>
        </section>

        <!-- Toast thông báo -->
        <transition name="fade">
          <div v-if="showShareToast" class="share-toast">
            ✨ Đã sao chép liên kết món ăn vào bộ nhớ tạm!
          </div>
        </transition>

        <!-- Địa điểm -->
        <section class="detail-section">
          <h2>Địa điểm thưởng thức</h2>

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

        <!-- NGUYÊN LIỆU TẠO NÊN HƯƠNG VỊ -->
        <section class="detail-section ingredients-section">
          <div class="section-header-modern">
            <span class="section-tag">Thành phần</span>
            <h2>Nguyên liệu đặc trưng</h2>
          </div>

          <template v-if="Array.isArray(dish.nguyen_lieu) && dish.nguyen_lieu.length > 0">
            <div class="ingredient-grid-modern">
              <div
                v-for="(item, index) in dish.nguyen_lieu"
                :key="item.nguyen_lieu_id ?? index"
                class="ingredient-card-modern"
              >
                <div class="ingredient-icon-box">
                  {{ getIngredientIcon(item.ten_nguyen_lieu) }}
                </div>
                <div class="ingredient-details">
                  <span class="ingredient-name">{{ item.ten_nguyen_lieu || 'Nguyên liệu' }}</span>
                  <span v-if="formatIngredientPivot(item.pivot)" class="ingredient-quantity">
                    {{ formatIngredientPivot(item.pivot) }}
                  </span>
                  <span v-else class="ingredient-quantity">Tươi sạch chuẩn vị</span>
                </div>
              </div>
            </div>
          </template>
          <p v-else class="placeholder-text">
            Chưa có dữ liệu nguyên liệu cho món ăn này.
          </p>
        </section>

        <!-- CÂU CHUYỆN VĂN HÓA -->
        <section class="detail-section culture-section" v-if="Array.isArray(dish.cau_chuyen_van_hoa) && dish.cau_chuyen_van_hoa.length > 0">
          <div class="story-container">
            <div class="story-badge">
              <span class="badge-icon">🏛️</span>
              <span>Giai thoại & Hồn đất Việt</span>
            </div>
            
            <div v-for="(story, index) in dish.cau_chuyen_van_hoa" :key="index" class="story-card-modern">
              <h2 v-if="story.tieu_de" class="story-title">{{ story.tieu_de }}</h2>
              <p class="story-content">{{ story.noi_dung }}</p>
            </div>
          </div>
        </section>

        <!-- ĐÁNH GIÁ & CẢM NHẬN -->
        <section class="detail-section review-section-modern">
          <div class="section-header-flex">
            <div>
              <span class="section-tag">Cộng đồng</span>
              <h2>Đánh giá & Cảm nhận</h2>
            </div>
          </div>

          <!-- Rating Overview Bar -->
          <div class="rating-overview-card">
            <div class="rating-big-score">
              <span class="score-number">{{ averageRating }}</span>
              <div class="score-stars">⭐⭐⭐⭐⭐</div>
              <span class="score-count">{{ reviews.length }} nhận xét từ thực khách</span>
            </div>
            <div class="rating-divider"></div>
            <div class="rating-highlights">
              <div class="highlight-item">
                <span class="hl-icon">🍜</span>
                <span class="hl-text">Hương vị chuẩn bản địa</span>
              </div>
              <div class="highlight-item">
                <span class="hl-icon">❤️</span>
                <span class="hl-text">Được 98% thực khách yêu thích</span>
              </div>
            </div>
          </div>

          <!-- Form viết đánh giá mới -->
          <div class="review-form-modern">
            <h3>Chia sẻ trải nghiệm của bạn</h3>
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
                  <label for="reviewer-rating">Mức độ hài lòng</label>
                  <select id="reviewer-rating" v-model="newReviewRating">
                    <option :value="5">⭐⭐⭐⭐⭐ 5/5 - Rất tuyệt vời</option>
                    <option :value="4">⭐⭐⭐⭐ 4/5 - Rất ngon miệng</option>
                    <option :value="3">⭐⭐⭐ 3/5 - Chuẩn vị vừa miệng</option>
                    <option :value="2">⭐⭐ 2/5 - Tạm ổn</option>
                    <option :value="1">⭐ 1/5 - Chưa hợp khẩu vị</option>
                  </select>
                </div>
              </div>
              <div class="form-group">
                <label for="reviewer-comment">Lời nhận xét</label>
                <textarea
                  id="reviewer-comment"
                  v-model="newReviewComment"
                  rows="3"
                  placeholder="Viết cảm nhận của bạn về hương vị, màu sắc hay không gian thưởng thức món ăn này..."
                  required
                ></textarea>
              </div>
              <button type="submit" class="submit-review-btn-modern">
                <span>Gửi đánh giá</span>
                <span class="btn-icon">✈️</span>
              </button>
            </form>
          </div>

          <!-- Danh sách đánh giá -->
          <div class="reviews-list-modern" v-if="reviews.length > 0">
            <div v-for="review in reviews" :key="review.id" class="review-card-modern">
              <div class="review-card-header">
                <div class="reviewer-profile">
                  <div class="avatar-gradient">{{ review.name.charAt(0).toUpperCase() }}</div>
                  <div>
                    <strong class="reviewer-name">{{ review.name }}</strong>
                    <span class="review-date">Đã trải nghiệm • {{ review.date }}</span>
                  </div>
                </div>
                <div class="stars-badge">
                  {{ '⭐'.repeat(review.rating) }}
                </div>
              </div>
              <p class="review-comment-text">{{ review.comment }}</p>
            </div>
          </div>
        </section>

        <!-- Món ăn gợi ý -->
        <section class="detail-section recommendation-section">
          <h2>Món ăn có thể bạn sẽ thích</h2>
          <p class="placeholder-text recommendation-note">
            Các gợi ý được cung cấp bởi hệ thống đề xuất món ăn thông minh.
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
            <RouterLink
              v-for="(item, index) in recommendations"
              :key="recommendationId(item, index)"
              :to="`/mon-an/${recommendationId(item, index)}`"
              class="recommendation-card"
            >
              <!-- 👇 THAY THẺ DIV ICON BÁT MÌ BẰNG THẺ ẢNH NÀY -->
                <img 
  :src="getDishImage(item)" 
  :alt="recommendationName(item)" 
  class="recommendation-thumb"
  style="width: 64px; height: 64px; object-fit: cover; border-radius: 8px;"
/>
              
              <div class="recommendation-content">
                <h3>{{ recommendationName(item) }}</h3>
                <p v-if="recommendationScore(item) !== null" class="recommendation-score">
                  Điểm tương đồng:
                  <strong>{{ recommendationScore(item) }}</strong>
                </p>
              </div>
            </RouterLink>
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

.section-tag {
  display: inline-block;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-primary, #2563eb);
  margin-bottom: 4px;
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

/* --- DESIGN CẢI TIẾN: NGUYÊN LIỆU --- */
.section-header-modern {
  margin-bottom: var(--space-6);
}

.section-header-modern h2 {
  margin: 0;
}

.ingredient-grid-modern {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
}

.ingredient-card-modern {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 18px;
  background: var(--color-surface, #ffffff);
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: var(--radius-lg, 12px);
  transition: all 0.2s ease;
  box-shadow: 0 2px 6px rgba(0,0,0,0.02);
}

.ingredient-card-modern:hover {
  border-color: var(--color-primary, #2563eb);
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0,0,0,0.05);
}

.ingredient-icon-box {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 10px;
  background: #f1f5f9;
  font-size: 22px;
  flex-shrink: 0;
}

.ingredient-details {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.ingredient-name {
  font-weight: 600;
  font-size: 15px;
  color: var(--color-text, #0f172a);
}

.ingredient-quantity {
  font-size: 13px;
  color: var(--color-text-muted, #64748b);
}

/* --- DESIGN CẢI TIẾN: CÂU CHUYỆN VĂN HÓA --- */
.culture-section {
  background: linear-gradient(180deg, rgba(248, 250, 252, 0.6) 0%, rgba(255, 255, 255, 1) 100%);
  border-radius: var(--radius-lg, 16px);
  padding: var(--space-8);
  margin-top: var(--space-6);
}

.story-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.story-badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 14px;
  background: #fef3c7;
  color: #92400e;
  border-radius: var(--radius-full, 9999px);
  font-size: 13px;
  font-weight: 600;
  width: fit-content;
}

.story-card-modern {
  position: relative;
  padding: 24px 28px;
  background: #ffffff;
  border: 1px solid #f1f5f9;
  border-left: 4px solid var(--color-primary, #ea580c);
  border-radius: 12px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.03);
}

.story-title {
  margin: 0 0 12px 0;
  font-size: 20px;
  font-weight: 700;
  color: var(--color-text, #0f172a);
  line-height: 1.3;
}

.story-content {
  margin: 0;
  color: #334155;
  font-size: 15px;
  line-height: 1.8;
}

/* --- DESIGN CẢI TIẾN: ĐÁNH GIÁ & CẢM NHẬN --- */
.review-section-modern {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.rating-overview-card {
  display: flex;
  align-items: center;
  gap: 32px;
  padding: 24px;
  background: #f8fafc;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: var(--radius-lg, 16px);
}

.rating-big-score {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  min-width: 140px;
}

.score-number {
  font-size: 42px;
  font-weight: 800;
  color: var(--color-text, #0f172a);
  line-height: 1;
}

.score-stars {
  margin: 6px 0;
  font-size: 14px;
}

.score-count {
  font-size: 12px;
  color: var(--color-text-muted, #64748b);
}

.rating-divider {
  width: 1px;
  height: 60px;
  background: var(--color-border, #cbd5e1);
}

.rating-highlights {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.highlight-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  font-weight: 500;
  color: #334155;
}

.hl-icon {
  font-size: 16px;
}

.review-form-modern {
  padding: 24px;
  background: #ffffff;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: var(--radius-lg, 16px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.02);
}

.review-form-modern h3 {
  margin: 0 0 16px;
  font-size: 16px;
  font-weight: 700;
}

.submit-review-btn-modern {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  background: var(--color-primary, #2563eb);
  color: #ffffff;
  border: none;
  border-radius: var(--radius-md, 8px);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  justify-self: flex-start;
}

.submit-review-btn-modern:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

.reviews-list-modern {
  display: grid;
  gap: 16px;
}

.review-card-modern {
  padding: 20px;
  background: #ffffff;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.02);
}

.review-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.reviewer-profile {
  display: flex;
  align-items: center;
  gap: 12px;
}

.avatar-gradient {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
  color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 15px;
}

.reviewer-name {
  display: block;
  font-size: 15px;
  color: var(--color-text, #0f172a);
}

.review-date {
  font-size: 12px;
  color: var(--color-text-muted, #64748b);
}

.stars-badge {
  padding: 4px 10px;
  background: #fefce8;
  border: 1px solid #fef08a;
  border-radius: 20px;
  font-size: 12px;
}

.review-comment-text {
  margin: 0;
  color: #334155;
  font-size: 14px;
  line-height: 1.6;
}
/* --- SỬA LỖI GIAO DIỆN FORM ĐÁNH GIÁ --- */
.review-form-modern {
  padding: 24px;
  background: #ffffff;
  border: 1px solid var(--color-border, #e2e8f0);
  border-radius: var(--radius-lg, 16px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02);
  margin-bottom: var(--space-6);
}

.review-form-modern h3 {
  margin: 0 0 16px;
  font-size: 16px;
  font-weight: 700;
  color: var(--color-text, #0f172a);
}

.review-form {
  display: flex;
  flex-direction: column;
  gap: 16px; /* Khoảng cách giữa các hàng */
}

.form-row {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
  width: 100%;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
  width: 100%;
}

.form-group label {
  font-size: 13px;
  font-weight: 600;
  color: var(--color-text, #0f172a);
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid var(--color-border, #cbd5e1);
  border-radius: var(--radius-md, 8px);
  background: var(--color-background, #f8fafc);
  color: var(--color-text, #0f172a);
  font-size: 14px;
  outline: none;
  box-sizing: border-box; /* Đảm bảo không bị tràn viền */
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--color-primary, #2563eb);
  background: #ffffff;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.submit-review-btn-modern {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 24px;
  background: var(--color-primary, #2563eb);
  color: #ffffff;
  border: none;
  border-radius: var(--radius-md, 8px);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-top: 4px;
  width: fit-content;
}

.submit-review-btn-modern:hover {
  opacity: 0.9;
  transform: translateY(-1px);
}

@media (max-width: 639px) {
  .form-row {
    grid-template-columns: 1fr; /* Responsive trên màn hình nhỏ */
  }
}
/* --- TÙY CHỈNH CHUNG CHO CẢ 2 GIAO DIỆN SÁNG & TỐI --- */

.ingredient-card-modern,
.review-form-modern,
.review-card-modern,
.rating-overview-card,
.story-card-modern,
.info-item {
  background: var(--color-surface, #ffffff);
  border-color: var(--color-border, #e2e8f0);
  color: var(--color-text, #0f172a);
  transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease;
}

/* 1. Phần Nguyên liệu */
.ingredient-icon-box {
  background: var(--color-background, #f1f5f9);
}

/* 2. Phần Câu chuyện văn hóa */
.culture-section {
  background: linear-gradient(180deg, var(--color-surface, #f8fafc) 0%, var(--color-background, #ffffff) 100%);
  border-radius: var(--radius-lg, 16px);
  padding: var(--space-8);
  margin-top: var(--space-6);
  border: 1px solid var(--color-border, #e2e8f0);
}

.story-card-modern {
  border-left: 4px solid var(--color-primary, #ea580c);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.03);
}

.story-title {
  color: var(--color-text, #0f172a);
}

.story-content {
  color: var(--color-text-muted, #64748b);
}

/* 3. Phần Tổng quan Đánh giá */
.rating-overview-card {
  background: var(--color-background, #f8fafc);
}

.score-number {
  color: var(--color-text, #0f172a);
}

.rating-divider {
  background: var(--color-border, #cbd5e1);
}

.highlight-item {
  color: var(--color-text-muted, #64748b);
}

/* 4. Form Đánh giá & Ô nhập liệu (Input/Select/Textarea) */
.form-group label {
  color: var(--color-text, #0f172a);
  font-weight: 600;
  font-size: 13px;
}

.form-group input,
.form-group select,
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid var(--color-border, #cbd5e1);
  border-radius: var(--radius-md, 8px);
  background: var(--color-background, #f8fafc); /* Tự chuyển màu tối theo theme hệ thống */
  color: var(--color-text, #0f172a);           /* Chữ tự động trắng khi ở dark mode */
  font-size: 14px;
  outline: none;
  box-sizing: border-box;
  transition: border-color 0.2s ease, box-shadow 0.2s ease, background-color 0.3s ease;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
  color: var(--color-text-muted, #94a3b8);
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  border-color: var(--color-primary, #2563eb);
  background: var(--color-surface, #ffffff);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
}

/* Màu chữ trong Select options cho dễ nhìn ở Dark mode */
.form-group select option {
  background: var(--color-surface, #ffffff);
  color: var(--color-text, #0f172a);
}

/* 5. Thẻ Review của người dùng */
.reviewer-name {
  color: var(--color-text, #0f172a);
}

.review-comment-text {
  color: var(--color-text-muted, #64748b);
}

.stars-badge {
  background: var(--color-background, #fefce8);
  border-color: var(--color-border, #fef08a);
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
  text-decoration: none;
  color: inherit;
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

  .rating-overview-card {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .rating-divider {
    width: 100%;
    height: 1px;
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