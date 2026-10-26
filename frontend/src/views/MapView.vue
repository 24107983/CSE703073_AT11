<script setup>
import { computed, nextTick, onMounted, onBeforeUnmount, ref, watch } from 'vue'
import axios from 'axios'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

const mapElement = ref(null)
const mapError = ref('')
const loading = ref(false)
const apiUnavailable = ref(false)
const locations = ref([])
const selectedRegion = ref('')
const selectedProvince = ref('')
const searchKeyword = ref('')
const selectedLocationId = ref(null)

const currentUserEmail = ref('guest')
const bookmarks = ref({})

let map = null
let markerLayer = null
const markersById = new Map()

const regionOptions = [
  { label: 'Miền Bắc', value: 'Bắc' },
  { label: 'Miền Trung', value: 'Trung' },
  { label: 'Miền Nam', value: 'Nam' },
]

const provinceMap = {
  1: { name: 'Hà Nội', region: 'Bắc' },
  2: { name: 'Hải Phòng', region: 'Bắc' },
  3: { name: 'Hà Giang', region: 'Bắc' },
  4: { name: 'Huế', region: 'Trung' },
  5: { name: 'Đà Nẵng', region: 'Trung' },
  6: { name: 'Quảng Nam', region: 'Trung' },
  7: { name: 'TP. Hồ Chí Minh', region: 'Nam' },
  8: { name: 'Cần Thơ', region: 'Nam' },
  9: { name: 'An Giang', region: 'Nam' },
}

function loadUserBookmarks() {
  const storedUser = localStorage.getItem('auth_user') || localStorage.getItem('user')
  if (storedUser) {
    try {
      const parsed = JSON.parse(storedUser)
      currentUserEmail.value = parsed.email || parsed.ten || 'guest'
    } catch (e) {}
  }
  const storageKey = `bookmarked_locations_${currentUserEmail.value}`
  bookmarks.value = JSON.parse(localStorage.getItem(storageKey) || '{}')
}

function isBookmarked(id) {
  return !!bookmarks.value[id]
}

function toggleBookmark(location) {
  const id = location.dia_diem_id
  bookmarks.value[id] = !bookmarks.value[id]
  const storageKey = `bookmarked_locations_${currentUserEmail.value}`
  localStorage.setItem(storageKey, JSON.stringify(bookmarks.value))
}

function getProvinceInfo(item) {
  const id = item.tinh_thanh_id
  const mapped = provinceMap[id] ?? provinceMap[String(id)]

  return {
    id: id == null ? '' : String(id),
    name:
      item.ten_tinh ??
      item.ten_tinh_thanh ??
      item.tinhThanh?.ten_tinh ??
      item.tinh_thanh?.ten_tinh ??
      mapped?.name ??
      '',
    region:
      item.ten_vung ??
      item.vung_mien?.ten_vung ??
      item.vungMien?.ten_vung ??
      mapped?.region ??
      '',
  }
}

const provinceOptions = computed(() => {
  const unique = new Map()

  for (const item of locations.value) {
    const province = getProvinceInfo(item)

    if (!province.id || !province.name) continue

    if (
      selectedRegion.value &&
      province.region !== selectedRegion.value
    ) {
      continue
    }

    unique.set(province.id, {
      value: province.id,
      label: province.name,
    })
  }

  return [...unique.values()].sort(
    (a, b) => a.label.localeCompare(b.label, 'vi')
  )
})

const filteredLocations = computed(() => {
  const keyword = searchKeyword.value
    .trim()
    .toLocaleLowerCase('vi')

  return locations.value.filter((item) => {
    const province = getProvinceInfo(item)

    if (
      selectedProvince.value &&
      province.id !== selectedProvince.value
    ) {
      return false
    }

    if (
      selectedRegion.value &&
      province.region !== selectedRegion.value
    ) {
      return false
    }

    if (keyword) {
      const searchableText = [
        item.ten_dia_diem,
        item.dia_chi,
        province.name,
        item.ten_mon_an,
        item.mo_ta,
      ]
        .filter(Boolean)
        .join(' ')
        .toLocaleLowerCase('vi')

      if (!searchableText.includes(keyword)) {
        return false
      }
    }

    return true
  })
})

const validCoordinate = (value, min, max) => {
  if (value === null || value === undefined || value === '') return false
  const number = Number(value)
  return Number.isFinite(number) && number >= min && number <= max
}

const hasCoordinates = (item) =>
  validCoordinate(item.vi_do, -90, 90) &&
  validCoordinate(item.kinh_do, -180, 180)

const mappedLocations = computed(() =>
  filteredLocations.value.filter(hasCoordinates),
)

function getGoogleMapsUrl(item) {
  const query = item.dia_chi
    ? `${item.ten_dia_diem || ''} ${item.dia_chi}`
    : `${item.vi_do},${item.kinh_do}`
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`
}

function selectLocation(item) {
  selectedLocationId.value = item.dia_diem_id
  const marker = markersById.get(String(item.dia_diem_id))

  if (marker && map) {
    map.setView(marker.getLatLng(), Math.max(map.getZoom(), 15))
    marker.openPopup()
  }
}

function drawMarkers() {
  if (!map || !markerLayer) return

  markerLayer.clearLayers()
  markersById.clear()

  for (const item of mappedLocations.value) {
    const customIcon = L.divIcon({
      className: 'custom-clean-marker',
      html: `
        <div class="map-pin-dot" title="${escapeHtml(item.ten_dia_diem || 'Quán ăn')}">
          <span>📍</span>
        </div>
      `,
      iconSize: [36, 36],
      iconAnchor: [18, 18]
    })

    const mapsUrl = getGoogleMapsUrl(item)

    const marker = L.marker([Number(item.vi_do), Number(item.kinh_do)], { icon: customIcon })
      .bindPopup(`
        <div style="font-family: inherit; min-width: 180px;">
          <strong style="font-size: 14px; color: #0f172a;">${escapeHtml(item.ten_dia_diem || 'Quán ăn ẩm thực')}</strong>
          <p style="margin: 4px 0 8px; font-size: 12px; color: #64748b;">${escapeHtml(item.dia_chi || 'Chưa có địa chỉ')}</p>
          <a href="${mapsUrl}" target="_blank" style="display: inline-block; padding: 4px 10px; background: #2563eb; color: #fff; border-radius: 6px; font-size: 12px; text-decoration: none; font-weight: 600;">Xem trên Google Maps →</a>
        </div>
      `)

    marker.on('click', () => {
      selectedLocationId.value = item.dia_diem_id
    })

    marker.addTo(markerLayer)
    markersById.set(String(item.dia_diem_id), marker)
  }

  const markers = [...markersById.values()]
  if (markers.length > 0) {
    const bounds = L.featureGroup(markers).getBounds()
    map.fitBounds(bounds, { padding: [36, 36], maxZoom: 13 })
  } else {
    map.setView([16.0471, 108.2068], 6)
  }
}

function escapeHtml(value) {
  return String(value).replace(/[&<>"']/g, (char) => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
  })[char])
}

async function loadLocations() {
  loading.value = true
  mapError.value = ''
  apiUnavailable.value = false

  try {
    const response = await axios.get('/api/dia-diem', {
      params: { page: 1, per_page: 100 },
    })

    const payload = response.data
    const rows = Array.isArray(payload)
      ? payload
      : payload?.data?.data ?? payload?.data ?? payload?.items ?? []

    if (!Array.isArray(rows)) {
      throw new Error('Dữ liệu API địa điểm chưa đúng định dạng danh sách.')
    }

    locations.value = rows
  } catch (error) {
    locations.value = []
    apiUnavailable.value = error.response?.status === 404
    mapError.value = apiUnavailable.value
      ? 'API địa điểm chưa được triển khai. Vui lòng thử lại sau khi backend bàn giao.'
      : 'Không tải được dữ liệu địa điểm. Hãy kiểm tra kết nối backend rồi thử lại.'
  } finally {
    loading.value = false
    await nextTick()
    drawMarkers()
  }
}

function resetFilters() {
  searchKeyword.value = ''
  selectedRegion.value = ''
  selectedProvince.value = ''
  selectedLocationId.value = null
}

function searchLocations() {
  selectedLocationId.value = null
}

onMounted(async () => {
  loadUserBookmarks()

  map = L.map(mapElement.value, {
    zoomControl: false,
    scrollWheelZoom: true,
  }).setView([16.0471, 108.2068], 6)

  L.control.zoom({ position: 'topleft' }).addTo(map)

  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    maxZoom: 19
  }).addTo(map)

  const createTextLabel = (lat, lng, text, className) => {
    const labelIcon = L.divIcon({
      className: className,
      html: `<div>${text}</div>`,
      iconSize: [140, 40]
    })
    L.marker([lat, lng], { icon: labelIcon, interactive: false }).addTo(map)
  }

  createTextLabel(16.2, 111.5, 'QĐ. Hoàng Sa<br><span style="font-size:11px; font-weight:normal;">(Việt Nam)</span>', 'map-text-label')
  createTextLabel(12.0, 115.0, 'Biển Đông', 'map-text-bien-dong')
  createTextLabel(8.5, 112.5, 'QĐ. Trường Sa<br><span style="font-size:11px; font-weight:normal;">(Việt Nam)</span>', 'map-text-label')

  markerLayer = L.layerGroup().addTo(map)
  await loadLocations()
  setTimeout(() => map?.invalidateSize(), 100)
})

watch([filteredLocations], () => {
  drawMarkers()
})

onBeforeUnmount(() => {
  if (map) {
    map.remove()
    map = null
  }
})
</script>

<template>
  <main class="map-page">
    <div class="container">
      <header class="page-heading">
        <p class="eyebrow">KHÁM PHÁ ẨM THỰC</p>
        <h1>Bản đồ quán ăn & Địa điểm</h1>
        <p class="page-description">
          Tra cứu danh sách các quán ăn đặc sắc và mở chỉ đường nhanh chóng trên Google Maps.
        </p>
      </header>

      <section class="filter-panel">
        <section class="search-panel">
          <form class="search-form" @submit.prevent="searchLocations">
            <span class="search-icon">⌕</span>
            <input
              v-model.trim="searchKeyword"
              type="search"
              placeholder="Tìm quán ăn, địa chỉ hoặc tỉnh/thành phố..."
              aria-label="Tìm kiếm địa điểm ẩm thực"
            />
            <button type="submit" class="search-button">
              Tìm kiếm
            </button>
          </form>
        </section>

        <div class="filter-item">
          <label for="region">Vùng miền</label>
          <select id="region" v-model="selectedRegion">
            <option value="">Tất cả vùng miền</option>
            <option v-for="region in regionOptions" :key="region.value" :value="region.value">
              {{ region.label }}
            </option>
          </select>
        </div>

        <div class="filter-item">
          <label for="province">Tỉnh / thành phố</label>
          <select id="province" v-model="selectedProvince">
            <option value="">Tất cả tỉnh / thành</option>
            <option v-for="province in provinceOptions" :key="province.value" :value="province.value">
              {{ province.label }}
            </option>
          </select>
        </div>

        <button type="button" class="reset-button" @click="resetFilters">
          Xóa bộ lọc
        </button>
        <button type="button" class="refresh-button" :disabled="loading" @click="loadLocations">
          {{ loading ? 'Đang tải...' : 'Tải lại dữ liệu' }}
        </button>
      </section>

      <p v-if="mapError" class="status-message error-message" role="alert">
        {{ mapError }}
      </p>

      <section class="map-layout">
        <!-- CỘT TRÁI: DANH SÁCH Địa điểm -->
        <aside class="location-panel">
          <div class="location-header">
            <div>
              <h2>Danh sách Địa điểm</h2>
              <p>{{ filteredLocations.length }} quán · {{ mappedLocations.length }} hiển thị trên bản đồ</p>
            </div>
          </div>

          <div v-if="loading && !locations.length" class="empty-state">
            Đang tải dữ liệu địa điểm...
          </div>

          <div v-else-if="filteredLocations.length" class="location-list">
            <div
              v-for="location in filteredLocations"
              :key="location.dia_diem_id"
              class="restaurant-card"
              :class="{ selected: selectedLocationId === location.dia_diem_id }"
            >
              <div class="restaurant-card-header" @click="selectLocation(location)">
                <h3>{{ location.ten_dia_diem || 'Quán ăn ẩm thực' }}</h3>
                <span class="restaurant-tag">Đặc sản địa phương</span>
              </div>
              <p class="restaurant-address" @click="selectLocation(location)">
                📍 {{ location.dia_chi || 'Chưa cập nhật địa chỉ chi tiết' }}
              </p>
              <p v-if="location.mo_ta" class="restaurant-desc" @click="selectLocation(location)">
                {{ location.mo_ta }}
              </p>

              <!-- THANH CÔNG CỤ LIÊN KẾT & LƯU YÊU THÍCH -->
              <div class="restaurant-actions">
                <a
                  :href="getGoogleMapsUrl(location)"
                  target="_blank"
                  class="action-pill-btn map-link"
                  title="Mở vị trí trên Google Maps"
                >
                  <span>🗺️</span> Google Maps
                </a>
                <button type="button" class="action-pill-btn" @click="selectLocation(location)">
                  <span>📍</span> Trên bản đồ
                </button>
                <button
                  type="button"
                  class="action-pill-btn bookmark-action-btn"
                  :class="{ active: isBookmarked(location.dia_diem_id) }"
                  @click="toggleBookmark(location)"
                >
                  <span>{{ isBookmarked(location.dia_diem_id) ? '♥' : '♡' }}</span>
                  <span>{{ isBookmarked(location.dia_diem_id) ? 'Đã lưu' : 'Lưu' }}</span>
                </button>
              </div>
            </div>
          </div>

          <div v-else class="empty-state">
            <h3>Không tìm thấy quán ăn phù hợp</h3>
            <p>Vui lòng thử lại với từ khóa hoặc bộ lọc khác.</p>
          </div>
        </aside>

        <!-- CỘT PHẢI: BẢN ĐỒ TƯƠNG TÁC -->
        <div class="map-container">
          <div ref="mapElement" class="leaflet-map" aria-label="Bản đồ địa điểm ẩm thực"></div>
          <div v-if="loading" class="map-status">Đang tải địa điểm...</div>
          <div v-else-if="!mappedLocations.length" class="map-status">
            Chưa có quán ăn với tọa độ hợp lệ để hiển thị.
          </div>
        </div>
      </section>
    </div>
  </main>
</template>

<style scoped>
.map-page {
  padding: 40px 0 64px;
}

.page-heading {
  margin-bottom: 28px;
}

.eyebrow {
  margin: 0 0 8px;
  color: var(--color-primary);
  font-size: 12px;
  font-weight: 800;
  letter-spacing: .12em;
}

.page-heading h1 {
  margin: 0;
  font-size: clamp(26px, 4vw, 36px);
  line-height: 1.2;
}

.page-description {
  margin: 12px 0 0;
  color: var(--color-text-muted);
  line-height: 1.6;
}

.filter-panel {
  display: flex;
  align-items: end;
  flex-wrap: wrap;
  gap: 14px;
  padding: 18px;
  margin-bottom: 22px;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 14px;
}

.filter-item {
  display: flex;
  flex: 1 1 210px;
  flex-direction: column;
  gap: 8px;
}

.filter-item label {
  font-size: 13px;
  font-weight: 700;
}

.filter-item select,
.reset-button,
.refresh-button {
  min-height: 42px;
  padding: 0 12px;
  border: 1px solid var(--color-border);
  border-radius: 9px;
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
}

.reset-button,
.refresh-button {
  cursor: pointer;
}

.refresh-button {
  background: var(--color-primary);
  color: white;
  border-color: transparent;
}

.refresh-button:disabled {
  opacity: .6;
  cursor: wait;
}

.map-layout {
  display: grid;
  grid-template-columns: minmax(340px, 0.9fr) minmax(0, 1.45fr);
  gap: 22px;
}

.map-container {
  position: relative;
  min-width: 0;
  height: 650px;
  overflow: hidden;
  border: 1px solid var(--color-border);
  border-radius: 16px;
  background: #edf2f7;
}

.leaflet-map {
  width: 100%;
  height: 100%;
  z-index: 1;
}

.map-status {
  position: absolute;
  z-index: 500;
  bottom: 14px;
  left: 50%;
  max-width: calc(100% - 28px);
  transform: translateX(-50%);
  padding: 9px 13px;
  border: 1px solid var(--color-border);
  border-radius: 10px;
  background: var(--color-background);
  box-shadow: 0 3px 14px #00000012;
  color: var(--color-text);
  font-size: 13px;
  text-align: center;
}

.status-message {
  margin: 0 0 18px;
  padding: 12px 14px;
  border-radius: 10px;
  line-height: 1.5;
}

.error-message {
  background: #fff1f0;
  color: #a52822;
  border: 1px solid #ffd2cf;
}

.location-panel {
  min-width: 0;
  max-height: 650px;
  padding: 18px;
  overflow: auto;
  border: 1px solid var(--color-border);
  border-radius: 16px;
  background: var(--color-background);
}

.location-header {
  padding-bottom: 14px;
  border-bottom: 1px solid var(--color-border);
  margin-bottom: 14px;
}

.location-header h2 {
  margin: 0;
  font-size: 19px;
}

.location-header p {
  margin: 6px 0 0;
  color: var(--color-text-muted);
  font-size: 13px;
}

.location-list {
  display: grid;
  gap: 14px;
}

.restaurant-card {
  padding: 16px;
  border: 1px solid var(--color-border);
  border-radius: 12px;
  background: var(--color-surface);
  color: var(--color-text);
  transition: border-color 0.2s ease, transform 0.2s ease;
  box-shadow: 0 2px 8px rgba(0,0,0,0.02);
}

.restaurant-card:hover,
.restaurant-card.selected {
  border-color: var(--color-primary);
}

.restaurant-card-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 8px;
  cursor: pointer;
  margin-bottom: 6px;
}

.restaurant-card-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: bold;
  color: var(--color-text);
}

.restaurant-tag {
  display: inline-block;
  padding: 2px 8px;
  background: #f1f5f9;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-full);
  font-size: 11px;
  font-weight: 600;
  color: var(--color-primary);
  flex-shrink: 0;
}

.restaurant-address {
  margin: 0 0 8px;
  color: var(--color-text-muted);
  font-size: 13px;
  cursor: pointer;
}

.restaurant-desc {
  margin: 0 0 12px;
  color: var(--color-text-muted);
  font-size: 13px;
  line-height: 1.5;
  cursor: pointer;
}

.restaurant-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  border-top: 1px solid var(--color-border);
  padding-top: 12px;
}

.action-pill-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: var(--color-background);
  border: 1px solid var(--color-border);
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  color: var(--color-text);
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s ease;
}

.action-pill-btn:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.action-pill-btn.map-link {
  background: #eff6ff;
  border-color: #bfdbfe;
  color: #1d4ed8;
}

.action-pill-btn.map-link:hover {
  background: #dbeafe;
}

.action-pill-btn.bookmark-action-btn.active {
  background: #fef2f2;
  border-color: #f87171;
  color: #ef4444;
}

.empty-state {
  padding: 32px 8px;
  color: var(--color-text-muted);
  text-align: center;
  line-height: 1.6;
}

.empty-state h3 {
  margin: 0 0 8px;
  color: var(--color-text);
}

:deep(.custom-clean-marker) {
  background: transparent;
  border: none;
}

.map-pin-dot {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  background: #ffffff;
  border-radius: 50%;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
  font-size: 18px;
  cursor: pointer;
  transition: transform 0.2s ease, background-color 0.2s ease;
}

.map-pin-dot:hover {
  transform: scale(1.15);
  background: #f8fafc;
}

:deep(.map-text-label) {
  background: transparent;
  border: none;
  color: #0369a1;
  font-weight: bold;
  font-size: 13px;
  text-align: center;
  text-shadow: 0 1px 3px rgba(255, 255, 255, 0.9);
  pointer-events: none;
}

:deep(.map-text-bien-dong) {
  background: transparent;
  border: none;
  color: #0284c7;
  font-weight: 700;
  font-size: 15px;
  letter-spacing: 1px;
  text-align: center;
  text-shadow: 0 1px 3px rgba(255, 255, 255, 0.9);
  pointer-events: none;
}

@media (max-width: 1023px) {
  .map-layout {
    grid-template-columns: 1fr;
  }
  .location-panel {
    max-height: none;
  }
}

@media (max-width: 639px) {
  .map-page {
    padding: 28px 0 44px;
  }
  .filter-panel {
    align-items: stretch;
    flex-direction: column;
  }
  .map-container {
    height: 440px;
  }
  .location-panel {
    padding: 14px;
  }
}

.search-panel {
  width: 100%;
  min-width: 0;
}

.search-form {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  min-width: 0;
  height: 48px;
  padding: 4px 5px 4px 16px;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 12px;
  box-sizing: border-box;
  transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.search-form:focus-within {
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

.search-icon {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #64748b;
  font-size: 21px;
  line-height: 1;
}

.search-form input {
  flex: 1;
  width: 0;
  min-width: 0;
  height: 100%;
  padding: 0;
  border: none;
  outline: none;
  background: transparent;
  color: #0f172a;
  font: inherit;
  font-size: 15px;
  box-shadow: none;
}

.search-form input::placeholder {
  color: #94a3b8;
}

.search-form input:focus {
  outline: none;
  border: none;
  box-shadow: none;
}

.search-button {
  flex-shrink: 0;
  height: 38px;
  padding: 0 20px;
  border: 1px solid #2563eb;
  border-radius: 9px;
  background: #2563eb;
  color: #ffffff;
  font-family: inherit;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.2s ease;
}

.search-button:hover {
  background: #1d4ed8;
}

.search-button:active {
  transform: scale(0.98);
}
</style>