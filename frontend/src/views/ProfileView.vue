<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink, useRouter } from 'vue-router'

const router = useRouter()
const activeTab = ref('info')

const currentUserEmail = ref('')
const userProfile = ref({
  name: 'Khách hàng',
  email: 'Chưa cập nhật',
  phone: 'Chưa cập nhật',
  membership: 'Thành viên Sành ăn',
  avatarText: 'K'
})

const bookmarkedDishes = ref([])
const bookmarkedLocations = ref([])
const loadingBookmarks = ref(false)
const loadingLocations = ref(false)
const registeredJourneys = ref([])

// Trạng thái modal chỉnh sửa thông tin
const showEditModal = ref(false)
const editPhoneInput = ref('')
const editNameInput = ref('')

function loadUserData() {
  const storedUser = localStorage.getItem('auth_user') || localStorage.getItem('user')

  if (storedUser) {
    try {
      const parsedUser = JSON.parse(storedUser)

      if (parsedUser.vai_tro === 'quan_tri_vien' || parsedUser.vai_tro === 'cong_tac_vien') {
        router.push('/')
        return
      }

      currentUserEmail.value = parsedUser.email || parsedUser.ten || 'default_user'
      const name = parsedUser.ho_ten || parsedUser.ten || parsedUser.name || 'Khách hàng'
      const email = parsedUser.email || 'Chưa cập nhật email'
      const phone = parsedUser.so_dien_thoai || parsedUser.phone || 'Chưa cập nhật'

      userProfile.value = {
        name,
        email,
        phone,
        membership: 'Thành viên Sành ăn',
        avatarText: name.charAt(0).toUpperCase()
      }

      fetchBookmarkedDishes()
      fetchBookmarkedLocations()
      loadUserJourneys()
    } catch (e) {
      console.error('Lỗi đọc thông tin tài khoản:', e)
    }
  } else {
    router.push('/dang-nhap')
  }
}

// Mở modal cập nhật thông tin
function openEditModal() {
  editNameInput.value = userProfile.value.name !== 'Khách hàng' ? userProfile.value.name : ''
  editPhoneInput.value = userProfile.value.phone !== 'Chưa cập nhật' ? userProfile.value.phone : ''
  showEditModal.value = true
}

// Lưu thông tin vào localStorage
function saveUserProfile() {
  if (!editPhoneInput.value.trim()) {
    alert('Vui lòng nhập số điện thoại hợp lệ!')
    return
  }

  if (editNameInput.value.trim()) {
    userProfile.value.name = editNameInput.value.trim()
    userProfile.value.avatarText = editNameInput.value.trim().charAt(0).toUpperCase()
  }
  userProfile.value.phone = editPhoneInput.value.trim()

  const storedUserKey = localStorage.getItem('auth_user') ? 'auth_user' : 'user'
  const storedUser = localStorage.getItem(storedUserKey)
  if (storedUser) {
    try {
      const parsedUser = JSON.parse(storedUser)
      if (editNameInput.value.trim()) {
        parsedUser.ho_ten = editNameInput.value.trim()
        parsedUser.ten = editNameInput.value.trim()
      }
      parsedUser.so_dien_thoai = editPhoneInput.value.trim()
      parsedUser.phone = editPhoneInput.value.trim()
      localStorage.setItem(storedUserKey, JSON.stringify(parsedUser))
    } catch (e) {
      console.error('Lỗi cập nhật localStorage:', e)
    }
  }

  showEditModal.value = false
  alert('✨ Cập nhật thông tin thành công!')
}

async function fetchBookmarkedDishes() {
  loadingBookmarks.value = true
  try {
    // Quét cả key kèm email lẫn key chung không có email
    const storageKeyWithEmail = `bookmarked_dishes_${currentUserEmail.value}`
    const savedBookmarks = JSON.parse(
      localStorage.getItem(storageKeyWithEmail) || localStorage.getItem('bookmarked_dishes') || '{}'
    )
    const bookmarkedIds = Object.keys(savedBookmarks).filter(id => savedBookmarks[id])

    if (bookmarkedIds.length === 0) {
      bookmarkedDishes.value = []
      loadingBookmarks.value = false
      return
    }

    const response = await fetch('/api/mon-an?page=1&per_page=100', {
      headers: { Accept: 'application/json' }
    })
    if (!response.ok) throw new Error('Không thể tải dữ liệu món ăn')

    const result = await response.json()
    const allDishes = result.data?.data ?? []

    bookmarkedDishes.value = allDishes.filter(dish =>
      bookmarkedIds.includes(String(dish.mon_an_id))
    )
  } catch (error) {
    console.error('Lỗi tải danh sách yêu thích:', error)
  } finally {
    loadingBookmarks.value = false
  }
}

async function fetchBookmarkedLocations() {
  loadingLocations.value = true
  try {
    // Quét cả key kèm email lẫn key chung không có email
    const storageKeyWithEmail = `bookmarked_locations_${currentUserEmail.value}`
    const savedBookmarks = JSON.parse(
      localStorage.getItem(storageKeyWithEmail) || localStorage.getItem('bookmarked_locations') || '{}'
    )
    const bookmarkedIds = Object.keys(savedBookmarks).filter(id => savedBookmarks[id])

    if (bookmarkedIds.length === 0) {
      bookmarkedLocations.value = []
      loadingLocations.value = false
      return
    }

    const response = await fetch('/api/dia-diem', {
      headers: { Accept: 'application/json' }
    })
    if (!response.ok) throw new Error('Không thể tải dữ liệu địa điểm')

    const result = await response.json()
    const rows = Array.isArray(result) ? result : result?.data?.data ?? result?.data ?? result?.items ?? []

    bookmarkedLocations.value = rows.filter(loc =>
      bookmarkedIds.includes(String(loc.dia_diem_id))
    )
  } catch (error) {
    console.error('Lỗi tải danh sách điểm đến yêu thích:', error)
  } finally {
    loadingLocations.value = false
  }
}

function removeBookmark(dishId) {
  // Đồng bộ xóa trên cả 2 loại key để tránh sót dữ liệu
  const storageKeyWithEmail = `bookmarked_dishes_${currentUserEmail.value}`
  
  [storageKeyWithEmail, 'bookmarked_dishes'].forEach(key => {
    const savedBookmarks = JSON.parse(localStorage.getItem(key) || '{}')
    if (savedBookmarks[dishId] !== undefined) {
      savedBookmarks[dishId] = false
      localStorage.setItem(key, JSON.stringify(savedBookmarks))
    }
  })

  bookmarkedDishes.value = bookmarkedDishes.value.filter(d => d.mon_an_id !== dishId)
}


function removeLocationBookmark(locationId) {
  const storageKey = `bookmarked_locations_${currentUserEmail.value}`
  const savedBookmarks = JSON.parse(localStorage.getItem(storageKey) || '{}')
  savedBookmarks[locationId] = false
  localStorage.setItem(storageKey, JSON.stringify(savedBookmarks))

  bookmarkedLocations.value = bookmarkedLocations.value.filter(l => l.dia_diem_id !== locationId)
}

function getGoogleMapsUrl(item) {
  const query = item.dia_chi
    ? `${item.ten_dia_diem || ''} ${item.dia_chi}`
    : `${item.vi_do},${item.kinh_do}`
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`
}

function loadUserJourneys() {
  try {
    const allBookings = JSON.parse(localStorage.getItem('user_bookings') || '[]')
    // Cho phép hiển thị toàn bộ đơn đặt chỗ đã lưu hoặc khớp email
    registeredJourneys.value = allBookings
  } catch (e) {
    registeredJourneys.value = []
  }
}

function formatPrice(price) {
  if (!price) return 'Chưa cập nhật'
  return new Intl.NumberFormat('vi-VN').format(Number(price)) + 'đ'
}

onMounted(() => {
  loadUserData()
})
</script>

<template>
  <main class="page">
    <div class="container">

      <!-- Breadcrumb -->
      <nav class="breadcrumb" aria-label="Đường dẫn">
        <RouterLink to="/">Trang chủ</RouterLink>
        <span>/</span>
        <span aria-current="page">Hồ sơ cá nhân</span>
      </nav>

      <!-- Profile Header Banner -->
      <section class="profile-header-banner">
        <div class="profile-avatar-large">
          {{ userProfile.avatarText }}
        </div>
        <div class="profile-header-info">
          <span class="membership-tag">{{ userProfile.membership }}</span>
          <h1>{{ userProfile.name }}</h1>
          <p>{{ userProfile.email }} • Thành viên tích cực tại Vietnam Culinary Editorial</p>
        </div>
        <button type="button" class="btn-edit-profile" @click="openEditModal">
          ✏️ Chỉnh sửa hồ sơ
        </button>
      </section>

      <!-- Dashboard Layout -->
      <div class="profile-layout">

        <!-- Sidebar Navigation -->
        <aside class="profile-sidebar">
          <button
            type="button"
            class="sidebar-tab-btn"
            :class="{ active: activeTab === 'info' }"
            @click="activeTab = 'info'"
          >
            <span>👤</span> Thông tin tài khoản
          </button>
          <button
            type="button"
            class="sidebar-tab-btn"
            :class="{ active: activeTab === 'bookmarks' }"
            @click="activeTab = 'bookmarks'"
          >
            <span>♥</span> Món ăn đã lưu <small class="badge-count">{{ bookmarkedDishes.length }}</small>
          </button>
          <button
            type="button"
            class="sidebar-tab-btn"
            :class="{ active: activeTab === 'locations' }"
            @click="activeTab = 'locations'"
          >
            <span>📍</span> Điểm đến yêu thích <small class="badge-count">{{ bookmarkedLocations.length }}</small>
          </button>
          <button
            type="button"
            class="sidebar-tab-btn"
            :class="{ active: activeTab === 'journeys' }"
            @click="activeTab = 'journeys'"
          >
            <span>🗺️</span> Hành trình của tôi <small class="badge-count">{{ registeredJourneys.length }}</small>
          </button>
        </aside>

        <!-- Main Content Area -->
        <div class="profile-content">

          <!-- Tab 1: Thông tin tài khoản -->
          <div v-if="activeTab === 'info'" class="tab-pane">
            <div class="tab-header-flex">
              <div>
                <h2>Thông tin cá nhân</h2>
                <p class="section-desc">Quản lý thông tin hồ sơ và quyền lợi thành viên của bạn.</p>
              </div>
            </div>

            <div class="info-card-grid">
              <div class="info-field-card">
                <span>Họ và tên</span>
                <strong>{{ userProfile.name }}</strong>
              </div>
              <div class="info-field-card">
                <span>Địa chỉ Email</span>
                <strong>{{ userProfile.email }}</strong>
              </div>
              <div class="info-field-card clickable-card" @click="openEditModal">
                <div class="field-top-row">
                  <span>Số điện thoại</span>
                  <span class="btn-inline-edit">Cập nhật ✎</span>
                </div>
                <strong>{{ userProfile.phone }}</strong>
              </div>
              <div class="info-field-card">
                <span>Hạng thành viên</span>
                <strong class="highlight-text">{{ userProfile.membership }}</strong>
              </div>
            </div>
          </div>

          <!-- Tab 2: Món ăn đã lưu -->
          <div v-if="activeTab === 'bookmarks'" class="tab-pane">
            <h2>Món ăn đã lưu</h2>
            <p class="section-desc">Danh sách các món ăn đặc sắc bạn đã lưu lại để khám phá.</p>

            <div v-if="loadingBookmarks" class="status-message">
              Đang tải danh sách yêu thích...
            </div>

            <div v-else-if="bookmarkedDishes.length === 0" class="empty-state">
              <p>Bạn chưa lưu món ăn nào.</p>
              <RouterLink to="/mon-an" class="explore-link">Khám phá danh sách món ăn ngay →</RouterLink>
            </div>

            <div v-else class="bookmarked-grid">
              <div v-for="dish in bookmarkedDishes" :key="dish.mon_an_id" class="bookmark-card">
                <div class="bookmark-card-body">
                  <div class="bookmark-top-row">
                    <h3>{{ dish.ten_mon }}</h3>
                    <button type="button" class="remove-bookmark-btn" @click="removeBookmark(dish.mon_an_id)" title="Bỏ lưu">
                      ✕
                    </button>
                  </div>
                  <p class="bookmark-desc">{{ dish.mo_ta }}</p>
                  <div class="bookmark-footer">
                    <span class="dish-price">{{ formatPrice(dish.gia_tham_khao) }}</span>
                    <RouterLink :to="`/mon-an/${dish.mon_an_id}`" class="detail-link">Xem chi tiết →</RouterLink>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 3: Điểm đến yêu thích -->
          <div v-if="activeTab === 'locations'" class="tab-pane">
            <h2>Điểm đến yêu thích</h2>
            <p class="section-desc">Danh sách các quán ăn và địa điểm bạn đã lưu lại trên bản đồ.</p>

            <div v-if="loadingLocations" class="status-message">
              Đang tải điểm đến yêu thích...
            </div>

            <div v-else-if="bookmarkedLocations.length === 0" class="empty-state">
              <p>Bạn chưa lưu điểm đến nào.</p>
              <RouterLink to="/ban-do" class="explore-link">Khám phá bản đồ ẩm thực ngay →</RouterLink>
            </div>

            <div v-else class="bookmarked-grid">
              <div v-for="loc in bookmarkedLocations" :key="loc.dia_diem_id" class="bookmark-card">
                <div class="bookmark-card-body">
                  <div class="bookmark-top-row">
                    <h3>{{ loc.ten_dia_diem || 'Quán ăn' }}</h3>
                    <button type="button" class="remove-bookmark-btn" @click="removeLocationBookmark(loc.dia_diem_id)" title="Bỏ lưu">
                      ✕
                    </button>
                  </div>
                  <p class="bookmark-desc">📍 {{ loc.dia_chi || 'Chưa có địa chỉ' }}</p>
                  <div class="bookmark-footer">
                    <a :href="getGoogleMapsUrl(loc)" target="_blank" class="detail-link">Xem trên Google Maps →</a>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Tab 4: Hành trình của tôi (Cập nhật hiển thị chuẩn) -->
          <div v-if="activeTab === 'journeys'" class="tab-pane">
            <h2>Hành trình ẩm thực đã đăng ký</h2>
            <p class="section-desc">Theo dõi các chuyến đi thực tế và trải nghiệm văn hóa ba miền của bạn.</p>

            <div v-if="registeredJourneys.length === 0" class="empty-state">
              <p>Bạn chưa đặt chỗ hành trình nào.</p>
              <RouterLink to="/hanh-trinh" class="explore-link">Xem các hành trình hiện có →</RouterLink>
            </div>

            <div v-else class="journey-list">
              <div v-for="journey in registeredJourneys" :key="journey.dat_cho_id" class="journey-item-card">
                <div class="journey-item-info">
                  <span class="status-tag">{{ journey.status || 'Đã thanh toán' }}</span>
                  <h3>{{ journey.tenHanh_trinh || journey.tenHanhTrinh || 'Hành trình ẩm thực' }}</h3>
                  <p>📅 Ngày đặt: <strong>{{ journey.ngayDat || 'Hôm nay' }}</strong> • 👥 Số lượng: <strong>{{ journey.so_khach || 1 }} người</strong> • Mã: <code>{{ journey.ma_dat_cho }}</code></p>
                </div>
                <div class="journey-item-action">
                  <span class="badge-success">{{ formatPrice(journey.tong_tien) }}</span>
                </div>
              </div>
            </div>
          </div>

        </div>

      </div>

    </div>

    <!-- MODAL CHỈNH SỬA THÔNG TIN -->
    <div v-if="showEditModal" class="modal-overlay" @click.self="showEditModal = false">
      <div class="modal-card">
        <div class="modal-header">
          <h3>Cập nhật thông tin cá nhân</h3>
          <button type="button" class="close-btn" @click="showEditModal = false">✕</button>
        </div>
        <form @submit.prevent="saveUserProfile" class="modal-form">
          <div class="form-group">
            <label>Họ và tên</label>
            <input v-model="editNameInput" type="text" placeholder="Nhập họ và tên của bạn..." />
          </div>
          <div class="form-group">
            <label>Số điện thoại</label>
            <input v-model="editPhoneInput" type="tel" placeholder="Nhập số điện thoại (VD: 0912345678)..." required />
          </div>
          <div class="modal-actions">
            <button type="button" class="btn-cancel" @click="showEditModal = false">Hủy</button>
            <button type="submit" class="btn-save">Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>

  </main>
</template>

<style scoped>
/* Giữ nguyên toàn bộ định dạng style cũ của bạn */
.page { padding: var(--space-10) 0 var(--space-12); }
.breadcrumb { display: flex; align-items: center; gap: var(--space-2); margin-bottom: var(--space-8); color: var(--color-text-muted); font-size: var(--font-size-base); }
.breadcrumb a { color: var(--color-primary); text-decoration: none; }
.breadcrumb a:hover { text-decoration: underline; }
.profile-header-banner { display: flex; align-items: center; gap: 24px; padding: 32px; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); margin-bottom: var(--space-8); box-shadow: 0 4px 20px rgba(0,0,0,0.03); position: relative; }
.profile-avatar-large { width: 80px; height: 80px; border-radius: 50%; background: var(--color-primary); color: #ffffff; display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: bold; flex-shrink: 0; }
.profile-header-info { min-width: 0; flex: 1; }
.membership-tag { display: inline-block; padding: 4px 10px; background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-full); font-size: 12px; font-weight: 600; color: var(--color-primary); margin-bottom: 8px; }
.profile-header-info h1 { margin: 0 0 6px; font-size: 24px; font-weight: var(--font-weight-bold); color: var(--color-text); }
.profile-header-info p { margin: 0; color: var(--color-text-muted); font-size: 14px; }
.btn-edit-profile { padding: 10px 18px; background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-md); color: var(--color-text); font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; }
.btn-edit-profile:hover { border-color: var(--color-primary); color: var(--color-primary); }
.profile-layout { display: grid; grid-template-columns: 280px minmax(0, 1fr); gap: var(--space-8); }
.profile-sidebar { display: flex; flex-direction: column; gap: 8px; height: fit-content; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.02); }
.sidebar-tab-btn { display: flex; align-items: center; justify-content: space-between; width: 100%; padding: 12px 16px; background: transparent; border: none; border-radius: var(--radius-md); color: var(--color-text); font-size: 14px; font-weight: 500; text-align: left; cursor: pointer; transition: all 0.2s ease; }
.sidebar-tab-btn:hover { background: var(--color-background); color: var(--color-primary); }
.sidebar-tab-btn.active { background: var(--color-primary); color: #ffffff; font-weight: 600; }
.badge-count { padding: 2px 8px; background: var(--color-background); color: var(--color-text); border-radius: var(--radius-full); font-size: 12px; }
.sidebar-tab-btn.active .badge-count { background: rgba(255,255,255,0.2); color: #ffffff; }
.profile-content { background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.02); }
.tab-pane h2 { margin: 0 0 6px; font-size: 20px; font-weight: var(--font-weight-bold); color: var(--color-text); }
.section-desc { margin: 0 0 24px; color: var(--color-text-muted); font-size: 14px; }
.info-card-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.info-field-card { padding: 20px; background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-md); transition: border-color 0.2s ease; }
.info-field-card.clickable-card { cursor: pointer; }
.info-field-card.clickable-card:hover { border-color: var(--color-primary); }
.field-top-row { display: flex; align-items: center; justify-content: space-between; }
.btn-inline-edit { font-size: 12px; color: var(--color-primary); font-weight: 600; }
.info-field-card span { display: block; font-size: 13px; color: var(--color-text-muted); margin-bottom: 6px; }
.info-field-card strong { font-size: 15px; color: var(--color-text); font-weight: 600; }
.highlight-text { color: var(--color-primary); }
.bookmarked-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; }
.bookmark-card { background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-md); padding: 20px; display: flex; flex-direction: column; justify-content: space-between; }
.bookmark-top-row { display: flex; align-items: flex-start; justify-content: space-between; gap: 12px; margin-bottom: 8px; }
.bookmark-card h3 { margin: 0; font-size: 16px; font-weight: bold; color: var(--color-text); }
.remove-bookmark-btn { background: none; border: none; color: var(--color-text-muted); font-size: 16px; cursor: pointer; padding: 0; transition: color 0.2s ease; }
.remove-bookmark-btn:hover { color: #ef4444; }
.bookmark-desc { margin: 0 0 16px; color: var(--color-text-muted); font-size: 13px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
.bookmark-footer { display: flex; align-items: center; justify-content: space-between; border-top: 1px solid var(--color-border); padding-top: 12px; }
.dish-price { font-weight: bold; color: var(--color-primary); font-size: 14px; }
.detail-link { font-size: 13px; font-weight: 600; color: var(--color-primary); text-decoration: none; }
.detail-link:hover { text-decoration: underline; }
.journey-list { display: grid; gap: 16px; }
.journey-item-card { display: flex; align-items: center; justify-content: space-between; padding: 20px; background: var(--color-background); border: 1px solid var(--color-border); border-radius: var(--radius-md); }
.journey-item-info h3 { margin: 6px 0; font-size: 16px; color: var(--color-text); }
.journey-item-info p { margin: 0; font-size: 13px; color: var(--color-text-muted); }
.status-tag { display: inline-block; padding: 2px 8px; background: #dbeafe; color: #1e40af; border-radius: var(--radius-full); font-size: 11px; font-weight: 600; }
.badge-success { padding: 6px 12px; background: #d1fae5; color: #065f46; border-radius: var(--radius-md); font-size: 13px; font-weight: 600; }
.empty-state { padding: 40px; text-align: center; color: var(--color-text-muted); border: 1px dashed var(--color-border); border-radius: var(--radius-md); }
.explore-link { display: inline-block; margin-top: 12px; font-weight: 600; color: var(--color-primary); text-decoration: none; }
.explore-link:hover { text-decoration: underline; }
.modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.4); display: flex; align-items: center; justify-content: center; z-index: 1000; backdrop-filter: blur(4px); }
.modal-card { width: 100%; max-width: 440px; background: var(--color-surface); border: 1px solid var(--color-border); border-radius: var(--radius-lg); padding: 28px; box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
.modal-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.modal-header h3 { margin: 0; font-size: 18px; color: var(--color-text); }
.close-btn { background: none; border: none; font-size: 18px; cursor: pointer; color: var(--color-text-muted); }
.modal-form { display: grid; gap: 16px; }
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group label { font-size: 13px; font-weight: 600; color: var(--color-text); }
.form-group input { padding: 10px 14px; border: 1px solid var(--color-border); border-radius: var(--radius-md); background: var(--color-background); color: var(--color-text); font-size: 14px; outline: none; }
.form-group input:focus { border-color: var(--color-primary); }
.modal-actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 8px; }
.btn-cancel { padding: 8px 16px; background: transparent; border: 1px solid var(--color-border); border-radius: var(--radius-md); color: var(--color-text); font-size: 14px; cursor: pointer; }
.btn-save { padding: 8px 18px; background: var(--color-primary); border: none; border-radius: var(--radius-md); color: #ffffff; font-size: 14px; font-weight: 600; cursor: pointer; }
@media (max-width: 1023px) {
  .profile-layout { grid-template-columns: 1fr; }
  .info-card-grid, .bookmarked-grid { grid-template-columns: 1fr; }
  .profile-header-banner { flex-direction: column; align-items: flex-start; }
}
</style>