<script setup>
import { computed, ref } from 'vue'

const selectedRegion = ref('')
const selectedProvince = ref('')

const locations = ref([
  {
    id: 1,
    name: 'Phố ẩm thực Hà Nội',
    address: 'Hà Nội',
    region: 'Bắc',
    province: 'Hà Nội',
    description: 'Khu vực tập trung nhiều món ăn đặc trưng của Hà Nội.'
  },
  {
    id: 2,
    name: 'Khu ẩm thực Huế',
    address: 'Huế',
    region: 'Trung',
    province: 'Huế',
    description: 'Không gian giới thiệu các món ăn đặc trưng của Huế.'
  },
  {
    id: 3,
    name: 'Chợ ẩm thực Đà Nẵng',
    address: 'Đà Nẵng',
    region: 'Trung',
    province: 'Đà Nẵng',
    description: 'Khu vực khám phá các món ăn địa phương Đà Nẵng.'
  }
])

const filteredLocations = computed(() => {
  return locations.value.filter((location) => {
    const matchRegion =
      !selectedRegion.value ||
      location.region === selectedRegion.value

    const matchProvince =
      !selectedProvince.value ||
      location.province === selectedProvince.value

    return matchRegion && matchProvince
  })
})

const resetFilters = () => {
  selectedRegion.value = ''
  selectedProvince.value = ''
}
</script>

<template>
  <main class="map-page">
    <div class="container">

      <!-- Page heading -->
      <section class="page-heading">
        <div>
          <p class="eyebrow">KHÁM PHÁ ẨM THỰC</p>

          <h1>Bản đồ ẩm thực vùng miền</h1>

          <p class="page-description">
            Khám phá các địa điểm và không gian ẩm thực
            theo vùng miền và tỉnh thành.
          </p>
        </div>
      </section>

      <!-- Filter -->
      <section class="filter-panel">
        <div class="filter-item">
          <label for="region">
            Vùng miền
          </label>

          <select
            id="region"
            v-model="selectedRegion"
          >
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

        <div class="filter-item">
          <label for="province">
            Tỉnh / thành phố
          </label>

          <select
            id="province"
            v-model="selectedProvince"
          >
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

        <button
          type="button"
          class="reset-button"
          @click="resetFilters"
        >
          Xóa bộ lọc
        </button>
      </section>

      <!-- Map + locations -->
      <section class="map-layout">

        <!-- Map placeholder -->
        <div class="map-container">

          <div class="map-placeholder">
            <div class="map-icon">
              📍
            </div>

            <h2>Khu vực bản đồ</h2>

            <p>
              Bản đồ sẽ được tích hợp khi API địa điểm
              và dữ liệu tọa độ được kết nối.
            </p>
          </div>

          <!-- Fake markers for UI -->
          <div class="map-marker marker-one">
            📍
          </div>

          <div class="map-marker marker-two">
            📍
          </div>

          <div class="map-marker marker-three">
            📍
          </div>
        </div>

        <!-- Location list -->
        <aside class="location-panel">

          <div class="location-header">
            <div>
              <h2>Địa điểm ẩm thực</h2>

              <p>
                {{ filteredLocations.length }} địa điểm
              </p>
            </div>
          </div>

          <div
            v-if="filteredLocations.length"
            class="location-list"
          >
            <article
              v-for="location in filteredLocations"
              :key="location.id"
              class="location-card"
            >
              <div class="location-card-icon">
                📍
              </div>

              <div class="location-card-content">
                <h3>
                  {{ location.name }}
                </h3>

                <p class="location-address">
                  {{ location.address }}
                </p>

                <p class="location-description">
                  {{ location.description }}
                </p>

                <span class="location-region">
                  Miền {{ location.region }}
                </span>
              </div>
            </article>
          </div>

          <div
            v-else
            class="empty-state"
          >
            <h3>Không tìm thấy địa điểm</h3>

            <p>
              Thử thay đổi bộ lọc để xem thêm địa điểm.
            </p>
          </div>

        </aside>
      </section>

    </div>
  </main>
</template>

<style scoped>
.map-page {
  padding: 48px 0 64px;
}

.page-heading {
  margin-bottom: 32px;
}

.eyebrow {
  margin: 0 0 8px;
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.08em;
  color: var(--color-primary);
}

.page-heading h1 {
  margin: 0;
  font-size: 32px;
  line-height: 1.2;
}

.page-description {
  max-width: 680px;
  margin: 12px 0 0;
  color: var(--color-text-muted);
  line-height: 1.6;
}

/* Filter */

.filter-panel {
  display: flex;
  align-items: end;
  gap: 16px;
  padding: 20px;
  margin-bottom: 24px;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: 12px;
}

.filter-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 220px;
}

.filter-item label {
  font-size: 14px;
  font-weight: 600;
}

.filter-item select {
  width: 100%;
  height: 42px;
  padding: 0 12px;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
}

.reset-button {
  height: 42px;
  padding: 0 16px;
  border: 1px solid var(--color-border);
  border-radius: 8px;
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
  cursor: pointer;
}

.reset-button:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

/* Main layout */

.map-layout {
  display: grid;
  grid-template-columns: minmax(0, 1.6fr) minmax(320px, 0.9fr);
  gap: 24px;
}

/* Map */

.map-container {
  position: relative;
  min-height: 560px;
  overflow: hidden;
  border: 1px solid var(--color-border);
  border-radius: 16px;
  background:
    linear-gradient(
      135deg,
      #eef4ff 0%,
      #f8fafc 50%,
      #edf8f0 100%
    );
}

.map-placeholder {
  position: absolute;
  top: 50%;
  left: 50%;
  width: min(420px, 80%);
  transform: translate(-50%, -50%);
  text-align: center;
}

.map-icon {
  margin-bottom: 12px;
  font-size: 48px;
}

.map-placeholder h2 {
  margin: 0 0 8px;
  font-size: 22px;
}

.map-placeholder p {
  margin: 0;
  color: var(--color-text-muted);
  line-height: 1.6;
}

.map-marker {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 9999px;
  background: var(--color-background);
  box-shadow: var(--shadow-md);
  font-size: 22px;
}

.marker-one {
  top: 28%;
  left: 30%;
}

.marker-two {
  top: 48%;
  right: 28%;
}

.marker-three {
  bottom: 24%;
  left: 52%;
}

/* Location panel */

.location-panel {
  min-height: 560px;
  padding: 20px;
  border: 1px solid var(--color-border);
  border-radius: 16px;
  background: var(--color-background);
}

.location-header {
  padding-bottom: 16px;
  border-bottom: 1px solid var(--color-border);
}

.location-header h2 {
  margin: 0;
  font-size: 20px;
}

.location-header p {
  margin: 6px 0 0;
  color: var(--color-text-muted);
  font-size: 14px;
}

.location-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 16px;
}

.location-card {
  display: flex;
  gap: 12px;
  padding: 14px;
  border: 1px solid var(--color-border);
  border-radius: 12px;
  background: var(--color-surface);
}

.location-card-icon {
  flex: 0 0 auto;
  font-size: 22px;
}

.location-card-content {
  min-width: 0;
}

.location-card h3 {
  margin: 0;
  font-size: 16px;
}

.location-address {
  margin: 4px 0;
  color: var(--color-text-muted);
  font-size: 13px;
}

.location-description {
  margin: 8px 0;
  color: var(--color-text-muted);
  font-size: 14px;
  line-height: 1.5;
}

.location-region {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 9999px;
  background: var(--color-background);
  color: var(--color-primary);
  font-size: 12px;
  font-weight: 600;
}

.empty-state {
  padding: 40px 12px;
  text-align: center;
}

.empty-state h3 {
  margin: 0 0 8px;
}

.empty-state p {
  margin: 0;
  color: var(--color-text-muted);
}

/* Tablet */

@media (max-width: 1023px) {
  .map-layout {
    grid-template-columns: 1fr;
  }

  .location-panel {
    min-height: auto;
  }
}

/* Mobile */

@media (max-width: 639px) {
  .map-page {
    padding: 32px 0 48px;
  }

  .page-heading h1 {
    font-size: 26px;
  }

  .filter-panel {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-item {
    min-width: 0;
  }

  .map-container {
    min-height: 400px;
  }

  .map-marker {
    width: 36px;
    height: 36px;
  }

  .location-panel {
    padding: 16px;
  }
}
</style>