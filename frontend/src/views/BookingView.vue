<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
const API_BASE_URL = '/api'

const route = useRoute()

const journey = ref(null)
const selectedSchedule = ref(null)
const soKhach = ref(1)

const loading = ref(true)
const submitting = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const journeyId = computed(() => Number(route.params.id))

const lichId = computed(() => {
  return Number(route.query.lich)
})

const availableSeats = computed(() => {
  if (!selectedSchedule.value) {
    return 0
  }

  // V3 đã trả sẵn so_cho_con_lai
  if (selectedSchedule.value.so_cho_con_lai !== undefined) {
    return Number(selectedSchedule.value.so_cho_con_lai)
  }

  return (
    Number(selectedSchedule.value.so_cho_total || 0) -
    Number(selectedSchedule.value.so_cho_held || 0) -
    Number(selectedSchedule.value.so_cho_sold || 0)
  )
})

const unitPrice = computed(() => {
  return Number(selectedSchedule.value?.gia_tham_khao || 0)
})

const totalPrice = computed(() => {
  return unitPrice.value * soKhach.value
})

const formatPrice = (price) => {
  if (price === null || price === undefined || price === '') {
    return 'Chưa cập nhật'
  }

  return new Intl.NumberFormat('vi-VN').format(price) + 'đ'
}

const formatDate = (date) => {
  if (!date) {
    return 'Chưa cập nhật'
  }

  return new Intl.DateTimeFormat('vi-VN', {
    weekday: 'long',
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  }).format(new Date(date))
}

const selectSchedule = (schedule) => {
  selectedSchedule.value = schedule
  successMessage.value = ''
  errorMessage.value = ''

  if (
    availableSeats.value > 0 &&
    soKhach.value > availableSeats.value
  ) {
    soKhach.value = availableSeats.value
  }
}

const decreaseGuests = () => {
  if (soKhach.value > 1) {
    soKhach.value--
    successMessage.value = ''
    errorMessage.value = ''
  }
}

const increaseGuests = () => {
  if (soKhach.value < availableSeats.value) {
    soKhach.value++
    successMessage.value = ''
    errorMessage.value = ''
  }
}

const handleHold = async () => {
  successMessage.value = ''
  errorMessage.value = ''

  // Chưa đăng nhập thì không được đặt chỗ
  const authUser = localStorage.getItem('auth_user')

  if (!authUser) {
    errorMessage.value = 'Bạn cần đăng nhập để đặt chỗ.'
    return
  }

  if (!selectedSchedule.value) {
    errorMessage.value = 'Vui lòng chọn lịch phục vụ.'
    return
  }

  if (soKhach.value < 1) {
    errorMessage.value = 'Số khách phải lớn hơn 0.'
    return
  }

  if (soKhach.value > availableSeats.value) {
    errorMessage.value = 'Số khách vượt quá số chỗ còn lại.'
    return
  }

  submitting.value = true

  try {
    const response = await fetch(`${API_BASE_URL}/dat-cho/hold`, {
      method: 'POST',
      credentials: 'include',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        lich_kha_dung_id: selectedSchedule.value.lich_kha_dung_id,
        so_khach: soKhach.value
      })
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(
        result.message || `HTTP ${response.status}`
      )
    }

    successMessage.value =
      result.message || 'Giữ chỗ thành công.'

    // Cập nhật số chỗ trên giao diện sau khi giữ chỗ
    if (selectedSchedule.value.so_cho_con_lai !== undefined) {
      selectedSchedule.value.so_cho_con_lai =
        Math.max(
          0,
          Number(selectedSchedule.value.so_cho_con_lai) -
            soKhach.value
        )
    } else {
      selectedSchedule.value.so_cho_held =
        Number(selectedSchedule.value.so_cho_held || 0) +
        soKhach.value
    }

  } catch (error) {
    console.error(error)

    errorMessage.value =
      error.message || 'Không thể thực hiện giữ chỗ.'
  } finally {
    submitting.value = false
  }
}

const fetchJourney = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    // Lấy thông tin hành trình
    const journeyResponse = await fetch(
      `${API_BASE_URL}/hanh-trinh-am-thuc/${journeyId.value}`,
      {
        headers: {
          Accept: 'application/json'
        }
      }
    )

    if (!journeyResponse.ok) {
      throw new Error(`HTTP ${journeyResponse.status}`)
    }

    const journeyResult = await journeyResponse.json()

    journey.value = journeyResult.data

    // Lấy lịch khả dụng
    const scheduleResponse = await fetch(
      `${API_BASE_URL}/hanh-trinh-am-thuc/${journeyId.value}/lich-kha-dung`,
      {
        headers: {
          Accept: 'application/json'
        }
      }
    )

    if (!scheduleResponse.ok) {
      throw new Error(`HTTP ${scheduleResponse.status}`)
    }

    const scheduleResult = await scheduleResponse.json()

    const schedules = scheduleResult.data || []

    journey.value.lich = schedules

    // Nếu URL có ?lich=... thì chọn đúng lịch đó
    if (lichId.value) {
      const matchedSchedule = schedules.find(
        (schedule) =>
          Number(schedule.lich_kha_dung_id) === lichId.value
      )

      if (matchedSchedule) {
        selectedSchedule.value = matchedSchedule
      }
    }

    // Nếu chưa chọn thì chọn lịch đầu tiên
    if (!selectedSchedule.value && schedules.length > 0) {
      selectedSchedule.value = schedules[0]
    }

  } catch (error) {
    console.error(error)

    errorMessage.value =
      'Không thể tải thông tin đặt chỗ.'
  } finally {
    loading.value = false
  }
}
const existingBookings = JSON.parse(localStorage.getItem('user_bookings') || '[]')
existingBookings.push({
  email: currentUserEmail, // Email hoặc tài khoản đang đăng nhập
  tenHanhTrinh: 'Tên hành trình vừa đặt',
  ngayDat: new Date().toLocaleDateString('vi-VN'),
  soLuong: 2,
  status: 'Đã xác nhận'
})
localStorage.setItem('user_bookings', JSON.stringify(existingBookings))
onMounted(() => {
  fetchJourney()
})
</script>

<template>
  <main class="page">
    <div class="container">

      <!-- BACK -->
      <div class="back-row">
        <RouterLink
          :to="`/hanh-trinh/${journeyId}`"
          class="back-link"
        >
          ← Quay lại chi tiết hành trình
        </RouterLink>
      </div>

      <!-- LOADING -->
      <section
        v-if="loading"
        class="state-card"
      >
        <div class="loading-spinner"></div>

        <p>
          Đang tải thông tin đặt chỗ...
        </p>
      </section>

      <!-- ERROR -->
      <section
        v-else-if="!journey"
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
      </section>

      <!-- CONTENT -->
      <template v-else>

        <!-- HEADING -->
        <section class="page-heading">

          <span class="eyebrow">
            ĐẶT CHỖ HÀNH TRÌNH
          </span>

          <h1>
            {{ journey.ten_hanh_trinh }}
          </h1>

          <p>
            Chọn lịch phục vụ và số lượng khách để tiếp tục.
          </p>

        </section>

        <div class="booking-layout">

          <!-- LEFT -->
          <section class="booking-main">

            <!-- SCHEDULE -->
            <div class="booking-section">

              <div class="section-heading">
                <div>
                  <span class="section-eyebrow">
                    BƯỚC 1
                  </span>

                  <h2>
                    Chọn lịch phục vụ
                  </h2>
                </div>
              </div>

              <div
                v-if="journey.lich?.length"
                class="schedule-options"
              >

                <button
                  v-for="schedule in journey.lich"
                  :key="schedule.lich_kha_dung_id"
                  type="button"
                  class="schedule-option"
                  :class="{
                    selected:
                      selectedSchedule?.lich_kha_dung_id ===
                      schedule.lich_kha_dung_id
                  }"
                  @click="selectSchedule(schedule)"
                >

                  <div class="schedule-option-date">
                    <span>
                      Ngày phục vụ
                    </span>

                    <strong>
                      {{ formatDate(schedule.ngay_phuc_vu) }}
                    </strong>
                  </div>

                  <div class="schedule-option-info">

                    <div>
                      <span>
                        Giá
                      </span>

                      <strong>
                        {{ formatPrice(schedule.gia_tham_khao) }}
                      </strong>
                    </div>

                    <div>
                      <span>
                        Còn lại
                      </span>

                      <strong>
                        {{
                          schedule.so_cho_total -
                          schedule.so_cho_held -
                          schedule.so_cho_sold
                        }}
                        chỗ
                      </strong>
                    </div>

                  </div>

                  <span class="check-mark">
                    ✓
                  </span>

                </button>

              </div>

              <div
                v-else
                class="empty-card"
              >
                Hiện chưa có lịch phục vụ.
              </div>

            </div>

            <!-- GUEST -->
            <div class="booking-section">

              <div class="section-heading">
                <div>
                  <span class="section-eyebrow">
                    BƯỚC 2
                  </span>

                  <h2>
                    Số lượng khách
                  </h2>
                </div>
              </div>

              <div class="guest-card">

                <div>
                  <h3>
                    Số khách tham gia
                  </h3>

                  <p>
                    Tối đa {{ availableSeats }} khách theo số chỗ hiện có.
                  </p>
                </div>

                <div class="quantity-control">

                  <button
                    type="button"
                    :disabled="soKhach <= 1"
                    @click="decreaseGuests"
                  >
                    −
                  </button>

                  <span>
                    {{ soKhach }}
                  </span>

                  <button
                    type="button"
                    :disabled="soKhach >= availableSeats"
                    @click="increaseGuests"
                  >
                    +
                  </button>

                </div>

              </div>

            </div>

            <!-- NOTE -->
<div class="notice-box">
  <span class="notice-icon">ⓘ</span>

  <div>
    <strong>Lưu ý về giữ chỗ</strong>

    <p>
      Yêu cầu giữ chỗ sẽ được gửi đến máy chủ để kiểm tra
      và xử lý theo dữ liệu lịch phục vụ hiện tại.
    </p>
  </div>
</div>

          </section>

          <!-- RIGHT -->
          <aside class="booking-summary">

            <div class="summary-card">

              <span class="summary-eyebrow">
                TÓM TẮT ĐẶT CHỖ
              </span>

              <h2>
                {{ journey.ten_hanh_trinh }}
              </h2>

              <div
                v-if="selectedSchedule"
                class="summary-details"
              >

                <div class="summary-row">
                  <span>
                    Ngày phục vụ
                  </span>

                  <strong>
                    {{ formatDate(selectedSchedule.ngay_phuc_vu) }}
                  </strong>
                </div>

                <div class="summary-row">
                  <span>
                    Số khách
                  </span>

                  <strong>
                    {{ soKhach }} khách
                  </strong>
                </div>

                <div class="summary-row">
                  <span>
                    Đơn giá
                  </span>

                  <strong>
                    {{ formatPrice(unitPrice) }}
                  </strong>
                </div>

                <div class="summary-row">
                  <span>
                    Chỗ còn lại
                  </span>

                  <strong>
                    {{ availableSeats }} chỗ
                  </strong>
                </div>

              </div>

              <div class="summary-total">

                <span>
                  Tổng tiền tham khảo
                </span>

                <strong>
                  {{ formatPrice(totalPrice) }}
                </strong>

              </div>

<button
  type="button"
  class="hold-button"
  :disabled="
    !selectedSchedule ||
    availableSeats < 1 ||
    submitting
  "
  @click="handleHold"
>
  <span v-if="submitting">
    Đang xử lý...
  </span>

  <span v-else>
    Giữ chỗ
  </span>

  <span v-if="!submitting">→</span>
</button>

              <!-- ERROR -->
              <p
                v-if="errorMessage"
                class="message error-message"
              >
                {{ errorMessage }}
              </p>

              <!-- SUCCESS -->
              <p
                v-if="successMessage"
                class="message success-message"
              >
                {{ successMessage }}
              </p>

            </div>

          </aside>

        </div>

      </template>

    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-8) 0 var(--space-16);
}

/* =========================
   BACK
========================= */

.back-row {
  margin-bottom: var(--space-6);
}

.back-link {
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  text-decoration: none;
}

.back-link:hover {
  color: var(--color-primary);
}

/* =========================
   HEADING
========================= */

.page-heading {
  margin-bottom: var(--space-8);
}

.eyebrow,
.section-eyebrow,
.summary-eyebrow {
  display: inline-block;

  margin-bottom: var(--space-3);

  color: var(--color-primary);

  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-bold);

  letter-spacing: 0.08em;
}

.page-heading h1 {
  margin: 0 0 var(--space-3);

  color: var(--color-text);

  font-size: clamp(
    2rem,
    4vw,
    2.75rem
  );

  line-height: 1.15;
}

.page-heading p {
  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-md);
  line-height: 1.7;
}

/* =========================
   LAYOUT
========================= */

.booking-layout {
  display: grid;

  grid-template-columns:
    minmax(0, 1fr)
    360px;

  align-items: start;

  gap: var(--space-8);
}

.booking-main {
  display: flex;
  flex-direction: column;

  gap: var(--space-8);
}

.booking-section {
  padding: var(--space-6);

  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);

  background: var(--color-background);
}

.section-heading {
  margin-bottom: var(--space-5);
}

.section-heading h2 {
  margin: 0;

  font-size: var(--font-size-xl);
}

/* =========================
   SCHEDULE
========================= */

.schedule-options {
  display: flex;
  flex-direction: column;

  gap: var(--space-3);
}

.schedule-option {
  position: relative;

  display: grid;

  grid-template-columns:
    minmax(0, 1fr)
    auto
    28px;

  align-items: center;

  gap: var(--space-5);

  width: 100%;

  padding: var(--space-4);

  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);

  background: var(--color-background);

  color: var(--color-text);

  text-align: left;

  font: inherit;

  cursor: pointer;

  transition:
    border-color 0.2s ease,
    background 0.2s ease;
}

.schedule-option:hover {
  border-color: var(--color-primary);
}

.schedule-option.selected {
  border-color: var(--color-primary);

  background:
    rgba(37, 99, 235, 0.05);
}

.schedule-option-date,
.schedule-option-info {
  display: flex;
  flex-direction: column;

  gap: var(--space-1);
}

.schedule-option-date span,
.schedule-option-info span {
  color: var(--color-text-muted);

  font-size: var(--font-size-xs);
}

.schedule-option-date strong {
  font-size: var(--font-size-sm);
}

.schedule-option-info {
  flex-direction: row;

  gap: var(--space-6);
}

.schedule-option-info div {
  display: flex;
  flex-direction: column;

  gap: var(--space-1);
}

.schedule-option-info strong {
  color: var(--color-primary);

  font-size: var(--font-size-sm);
}

.check-mark {
  display: flex;
  align-items: center;
  justify-content: center;

  width: 26px;
  height: 26px;

  border: 1px solid var(--color-border);
  border-radius: 50%;

  color: transparent;

  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-bold);
}

.schedule-option.selected .check-mark {
  border-color: var(--color-primary);

  background: var(--color-primary);

  color: white;
}

/* =========================
   GUEST
========================= */

.guest-card {
  display: flex;
  align-items: center;
  justify-content: space-between;

  gap: var(--space-5);

  padding: var(--space-5);

  border-radius: var(--radius-md);

  background: var(--color-surface);
}

.guest-card h3 {
  margin: 0 0 var(--space-2);

  font-size: var(--font-size-md);
}

.guest-card p {
  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}

.quantity-control {
  display: flex;
  align-items: center;

  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);

  overflow: hidden;

  background: var(--color-background);
}

.quantity-control button {
  width: 42px;
  height: 42px;

  border: 0;

  background: transparent;

  color: var(--color-text);

  font-size: 1.25rem;

  cursor: pointer;
}

.quantity-control button:hover:not(:disabled) {
  background: var(--color-surface);
}

.quantity-control button:disabled {
  opacity: 0.35;
  cursor: not-allowed;
}

.quantity-control span {
  display: flex;
  align-items: center;
  justify-content: center;

  min-width: 44px;
  height: 42px;

  border-right: 1px solid var(--color-border);
  border-left: 1px solid var(--color-border);

  font-weight: var(--font-weight-bold);
}

/* =========================
   NOTICE
========================= */

.notice-box {
  display: flex;

  gap: var(--space-3);

  padding: var(--space-4);

  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);

  background: var(--color-surface);
}

.notice-icon {
  flex-shrink: 0;

  color: var(--color-primary);

  font-size: 1.1rem;
}

.notice-box strong {
  display: block;

  margin-bottom: var(--space-1);

  font-size: var(--font-size-sm);
}

.notice-box p {
  margin: 0;

  color: var(--color-text-muted);

  font-size: var(--font-size-xs);
  line-height: 1.6;
}

/* =========================
   SUMMARY
========================= */

.booking-summary {
  position: sticky;
  top: var(--space-5);
}

.summary-card {
  padding: var(--space-6);

  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);

  background: var(--color-background);

  box-shadow: var(--shadow-md);
}

.summary-card h2 {
  margin: 0 0 var(--space-6);

  font-size: var(--font-size-lg);
  line-height: 1.4;
}

.summary-details {
  display: flex;
  flex-direction: column;

  gap: var(--space-4);

  padding-bottom: var(--space-5);

  border-bottom: 1px solid var(--color-border);
}

.summary-row {
  display: flex;
  justify-content: space-between;

  gap: var(--space-4);

  font-size: var(--font-size-sm);
}

.summary-row span {
  color: var(--color-text-muted);
}

.summary-row strong {
  text-align: right;
}

.summary-total {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;

  gap: var(--space-4);

  padding: var(--space-5) 0;
}

.summary-total span {
  color: var(--color-text-muted);

  font-size: var(--font-size-sm);
}

.summary-total strong {
  color: var(--color-primary);

  font-size: var(--font-size-lg);
}

/* =========================
   HOLD
========================= */

.hold-button {
  display: flex;
  align-items: center;
  justify-content: space-between;

  width: 100%;

  padding: var(--space-4);

  border: 0;
  border-radius: var(--radius-md);

  background: var(--color-primary);
  color: white;

  font: inherit;
  font-weight: var(--font-weight-bold);

  cursor: pointer;

  transition:
    opacity 0.2s ease,
    transform 0.2s ease;
}

.hold-button:hover:not(:disabled) {
  opacity: 0.92;

  transform: translateY(-1px);
}

.hold-button:disabled {
  opacity: 0.45;

  cursor: not-allowed;
}

/* =========================
   MESSAGES
========================= */

.message {
  margin: var(--space-4) 0 0;

  padding: var(--space-3);

  border-radius: var(--radius-md);

  font-size: var(--font-size-xs);
  line-height: 1.5;
}

.error-message {
  background: rgba(220, 38, 38, 0.08);

  color: var(--color-danger);
}

.success-message {
  background: rgba(22, 163, 74, 0.08);

  color: var(--color-secondary);
}

/* =========================
   EMPTY / LOADING
========================= */

.empty-card,
.state-card {
  display: flex;
  flex-direction: column;

  align-items: center;
  justify-content: center;

  min-height: 220px;

  padding: var(--space-8);

  border: 1px solid var(--color-border);
  border-radius: var(--radius-xl);

  background: var(--color-surface);

  text-align: center;
}

.state-card p {
  margin: var(--space-4) 0 0;

  color: var(--color-text-muted);
}

.state-icon {
  display: flex;
  align-items: center;
  justify-content: center;

  width: 48px;
  height: 48px;

  border-radius: 50%;

  background: var(--color-danger);
  color: white;

  font-weight: var(--font-weight-bold);
}

.loading-spinner {
  width: 34px;
  height: 34px;

  border: 3px solid var(--color-border);
  border-top-color: var(--color-primary);

  border-radius: 50%;

  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* =========================
   TABLET
========================= */

@media (max-width: 1024px) {
  .booking-layout {
    grid-template-columns: 1fr;
  }

  .booking-summary {
    position: static;
  }
}

/* =========================
   MOBILE
========================= */

@media (max-width: 640px) {
  .page {
    padding: var(--space-6) 0 var(--space-10);
  }

  .page-heading {
    margin-bottom: var(--space-6);
  }

  .page-heading h1 {
    font-size: 2rem;
  }

  .booking-section {
    padding: var(--space-4);
  }

  .schedule-option {
    grid-template-columns: 1fr 28px;

    gap: var(--space-3);
  }

  .schedule-option-info {
    grid-column: 1 / -1;

    justify-content: space-between;
  }

  .schedule-option .check-mark {
    grid-column: 2;
    grid-row: 1;
  }

  .guest-card {
    align-items: flex-start;
    flex-direction: column;
  }

  .quantity-control {
    align-self: stretch;
    justify-content: center;
  }

  .summary-card {
    padding: var(--space-5);
  }
}
</style>