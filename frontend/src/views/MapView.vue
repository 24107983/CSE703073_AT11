
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

let map = null
let markerLayer = null
const markersById = new Map()


const regionOptions = [
  { label: 'Miền Bắc', value: 'Bắc' },
  { label: 'Miền Trung', value: 'Trung' },
  { label: 'Miền Nam', value: 'Nam' },
]

// Ánh xạ tạm theo các tỉnh/thành trong bộ dữ liệu hiện tại.
// Khi API trả tên tỉnh và vùng miền, nên chuyển sang dùng dữ liệu API.
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

    // Lọc theo tỉnh/thành
    if (
      selectedProvince.value &&
      province.id !== selectedProvince.value
    ) {
      return false
    }

    // Lọc theo vùng miền
    if (
      selectedRegion.value &&
      province.region !== selectedRegion.value
    ) {
      return false
    }

    // Tìm theo tên địa điểm, địa chỉ, tỉnh/thành
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

function selectLocation(item) {
  selectedLocationId.value = item.dia_diem_id
  const marker = markersById.get(String(item.dia_diem_id))

  if (marker && map) {
    map.setView(marker.getLatLng(), Math.max(map.getZoom(), 13))
    marker.openPopup()
  }
}

function drawMarkers() {
  if (!map || !markerLayer) return

  markerLayer.clearLayers()
  markersById.clear()

  for (const item of mappedLocations.value) {
    const marker = L.marker([Number(item.vi_do), Number(item.kinh_do)])
      .bindPopup(`
        <strong>${escapeHtml(item.ten_dia_diem || 'Địa điểm ẩm thực')}</strong>
        <br>${escapeHtml(item.dia_chi || 'Chưa có địa chỉ')}
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
    map.setView([16.2, 107.8], 5)
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
  map = L.map(mapElement.value, {
    zoomControl: true,
    scrollWheelZoom: true,
  }).setView([16.2, 107.8], 5)


L.tileLayer(
  'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
  {
    attribution: 'Tiles &copy; Esri',
    maxZoom: 19,
  }
).addTo(map)


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
        <h1>Bản đồ ẩm thực vùng miền</h1>
        <p class="page-description">
          Khám phá các địa điểm ẩm thực trên bản đồ Việt Nam.
        </p>
      </header>

      <section class="filter-panel">

      <section class="search-panel">
        <form class="search-form" @submit.prevent="searchLocations">
          <span class="search-icon">⌕</span>
          <input
            v-model.trim="searchKeyword"
            type="search"
            placeholder="Tìm món ăn, địa điểm hoặc tỉnh/thành phố..."
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
        <div class="map-container">
          <div ref="mapElement" class="leaflet-map" aria-label="Bản đồ địa điểm ẩm thực"></div>
          <div v-if="loading" class="map-status">Đang tải địa điểm...</div>
          <div v-else-if="!mappedLocations.length" class="map-status">
            Chưa có địa điểm với tọa độ hợp lệ để hiển thị.
          </div>
        </div>

        <aside class="location-panel">
          <div class="location-header">
            <div>
              <h2>Địa điểm ẩm thực</h2>
              <p>{{ filteredLocations.length }} địa điểm · {{ mappedLocations.length }} có tọa độ</p>
            </div>
          </div>

          <div v-if="loading && !locations.length" class="empty-state">
            Đang tải dữ liệu địa điểm...
          </div>

          <div v-else-if="filteredLocations.length" class="location-list">
            <button
              v-for="location in filteredLocations"
              :key="location.dia_diem_id"
              type="button"
              class="location-card"
              :class="{ selected: selectedLocationId === location.dia_diem_id }"
              @click="selectLocation(location)"
            >
              <span class="location-card-icon">📍</span>
              <span class="location-card-content">
                <strong>{{ location.ten_dia_diem || 'Địa điểm chưa có tên' }}</strong>
                <span class="location-address">{{ location.dia_chi || 'Chưa có địa chỉ' }}</span>
                <span v-if="!hasCoordinates(location)" class="no-coordinate">
                  Chưa có tọa độ bản đồ
                </span>
              </span>
            </button>
          </div>

          <div v-else class="empty-state">
            <h3>Chưa có dữ liệu địa điểm</h3>
            <p>Danh sách sẽ hiển thị khi API địa điểm được triển khai và trả về dữ liệu.</p>
          </div>
        </aside>
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
  grid-template-columns: minmax(0, 1.55fr) minmax(300px, .85fr);
  gap: 22px;
}

.map-container {
  position: relative;
  min-width: 0;
  height: 600px;
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
  max-height: 600px;
  padding: 18px;
  overflow: auto;
  border: 1px solid var(--color-border);
  border-radius: 16px;
  background: var(--color-background);
}

.location-header {
  padding-bottom: 14px;
  border-bottom: 1px solid var(--color-border);
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
  gap: 10px;
  margin-top: 14px;
}

.location-card {
  display: flex;
  width: 100%;
  gap: 11px;
  padding: 13px;
  border: 1px solid var(--color-border);
  border-radius: 12px;
  background: var(--color-surface);
  color: var(--color-text);
  text-align: left;
  cursor: pointer;
}

.location-card:hover,
.location-card.selected {
  border-color: var(--color-primary);
}

.location-card-icon {
  flex: 0 0 auto;
}

.location-card-content {
  display: grid;
  gap: 6px;
  min-width: 0;
}

.location-card-content strong {
  overflow-wrap: anywhere;
}

.location-address,
.no-coordinate {
  color: var(--color-text-muted);
  font-size: 13px;
  line-height: 1.5;
}

.no-coordinate {
  color: #a16207;
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

/* Thanh tìm kiếm địa điểm */
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

.search-form input::-webkit-search-cancel-button {
  cursor: pointer;
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

@media (max-width: 639px) {
  .search-form {
    gap: 8px;
    padding-left: 12px;
  }

  .search-button {
    padding: 0 14px;
  }
}

</style>
