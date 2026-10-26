<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'

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

const route = useRoute()
const router = useRouter()

const journey = ref(null)

const schedules = ref([])

const loading = ref(false)

const errorMessage = ref('')

const selectedScheduleId = ref(null)

const paying = ref(false)
const paymentMessage = ref('')
const paymentError = ref('')
// Giữ chỗ
const guestCount = ref(1)
const holding = ref(false)
const holdError = ref('')
const holdSuccess = ref('')
const holdData = ref(null)

const remainingSeconds = ref(0)
let countdownInterval = null

const totalPrice = computed(() => {
  const price = Number(selectedSchedule.value?.gia_tham_khao || 0)
  return price * Number(guestCount.value || 0)
})

const formatCountdown = (seconds) => {
  const safeSeconds = Math.max(0, Number(seconds) || 0)
  const minutes = Math.floor(safeSeconds / 60)
  const secondsLeft = safeSeconds % 60

  return `${String(minutes).padStart(2, '0')}:${String(secondsLeft).padStart(2, '0')}`
}

const stopCountdown = () => {
  if (countdownInterval) {
    clearInterval(countdownInterval)
    countdownInterval = null
  }
}

const startCountdown = (expiryTime) => {
  stopCountdown()

  // Thời điểm hết hạn phải lấy từ backend, không tự đặt lại 15 phút.
  const expiryTimestamp = new Date(expiryTime).getTime()

  if (!Number.isFinite(expiryTimestamp)) {
    holdError.value = 'Không đọc được thời hạn giữ chỗ từ máy chủ.'
    return
  }

  const updateCountdown = () => {
    remainingSeconds.value = Math.max(
      0,
      Math.ceil((expiryTimestamp - Date.now()) / 1000)
    )

    if (remainingSeconds.value <= 0) {
      stopCountdown()
      holdSuccess.value = ''
      holdError.value =
        'Đã hết thời gian giữ chỗ. Đang cập nhật lại số chỗ khả dụng...'

      fetchSchedules()
    }
  }

  updateCountdown()

  if (remainingSeconds.value > 0) {
    countdownInterval = setInterval(updateCountdown, 1000)
  }
}

const holdSeats = async () => {
  if (!selectedSchedule.value || holding.value) return

  if (holdData.value) {
    holdError.value = 'Bạn đã có lượt giữ chỗ trên màn hình này.'
    return
  }

  const availableSeats = remainingSeats(selectedSchedule.value)

  if (guestCount.value < 1 || guestCount.value > availableSeats) {
    holdError.value = 'Số khách vượt quá số chỗ còn lại.'
    return
  }

  holding.value = true
  holdError.value = ''
  holdSuccess.value = ''

  try {
    const response = await fetch(
      '/api/dat-cho/hold',
      {
        method: 'POST',
        credentials: 'include',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          lich_kha_dung_id: selectedSchedule.value.lich_kha_dung_id,
          so_khach: Number(guestCount.value)
        })
      }
    )

    const result = await response.json()

    if (!response.ok) {
      throw new Error(
        result.message ||
        (response.status === 401
          ? 'Bạn cần đăng nhập trước khi giữ chỗ.'
          : `Không thể giữ chỗ (HTTP ${response.status}).`)
      )
    }

    const booking = result.data

    if (!booking?.het_han_giu) {
      throw new Error(
        'API chưa trả về thời điểm hết hạn giữ chỗ (het_han_giu).'
      )
    }

    holdData.value = booking
    holdSuccess.value = result.message || 'Giữ chỗ thành công.'

    startCountdown(booking.het_han_giu)

    await fetchSchedules()
  } catch (error) {
    console.error(error)
    holdError.value =
      error.message || 'Không thể kết nối đến máy chủ.'
  } finally {
    holding.value = false
  }
}

const payBooking = () => {
  if (!holdData.value?.dat_cho_id) {
    paymentError.value = 'Không tìm thấy mã đặt chỗ. Vui lòng giữ chỗ lại.'
    return
  }

  if (remainingSeconds.value <= 0) {
    paymentError.value = 'Thời gian giữ chỗ đã hết. Vui lòng giữ chỗ lại.'
    return
  }

  paymentError.value = ''
  paymentMessage.value = ''

  const booking = {
    ...holdData.value,
    hanh_trinh_id: journey.value?.hanh_trinh_id,
    ten_hanh_trinh: journey.value?.ten_hanh_trinh
  }

  sessionStorage.setItem(
    `at11_payment_${booking.dat_cho_id}`,
    JSON.stringify(booking)
  )

  router.push({
    name: 'thanh-toan',
    params: {
      datChoId: booking.dat_cho_id
    },
    query: {
      journeyId: route.params.id
    }
  })
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
   FETCH JOURNEY DETAIL
========================================================= */

const fetchJourneyDetail = async () => {
  loading.value = true

  errorMessage.value = ''

  try {

    const journeyId = route.params.id

    const response = await fetch(
      `/api/hanh-trinh-am-thuc/${journeyId}`,
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

    journey.value = {
      ...result.data,
      image: getJourneyImage(result.data.hanh_trinh_id)
    }

  } catch (error) {

    console.error(error)

    errorMessage.value =
      'Không thể tải thông tin hành trình.'

  } finally {

    loading.value = false

  }
}


/* =========================================================
   FETCH AVAILABLE SCHEDULES
========================================================= */

const fetchSchedules = async () => {

  try {

    const journeyId = route.params.id

    const response = await fetch(
      `/api/hanh-trinh-am-thuc/${journeyId}/lich-kha-dung`,
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

    schedules.value = result.data || []

    if (schedules.value.length > 0) {
      selectedScheduleId.value =
        schedules.value[0].lich_kha_dung_id
    }

  } catch (error) {

    console.error(error)

    schedules.value = []

  }
}


/* =========================================================
   SELECTED SCHEDULE
========================================================= */

const selectedSchedule = computed(() => {

  return schedules.value.find(
    (schedule) =>
      schedule.lich_kha_dung_id ===
      selectedScheduleId.value
  ) || null

})


/* =========================================================
   HELPERS
========================================================= */

const formatPrice = (price) => {

  if (
    price === null ||
    price === undefined ||
    price === ''
  ) {
    return 'Chưa cập nhật'
  }

  return (
    new Intl.NumberFormat('vi-VN').format(price)
    + 'đ'
  )

}


const formatDate = (date) => {

  if (!date) {
    return 'Chưa cập nhật'
  }

  const value = new Date(`${date}T00:00:00`)

  return new Intl.DateTimeFormat(
    'vi-VN',
    {
      weekday: 'long',
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    }
  ).format(value)

}


const remainingSeats = (schedule) => {

  if (!schedule) {
    return 0
  }

  return Number(
    schedule.so_cho_con_lai ?? 0
  )

}


const canBook = computed(() => {

  return (
    selectedSchedule.value &&
    remainingSeats(selectedSchedule.value) > 0
  )

})


/* =========================================================
   INITIAL LOAD
========================================================= */

onMounted(async () => {

  await Promise.all([
    fetchJourneyDetail(),
    fetchSchedules()
  ])

})
onUnmounted(() => {
  stopCountdown()
})
</script>


<template>

  <main class="page">

    <div class="container">


      <!-- =========================
           BACK
      ========================== -->

      <RouterLink
        to="/hanh-trinh"
        class="back-link"
      >
        ← Quay lại danh sách hành trình
      </RouterLink>


      <!-- =========================
           LOADING
      ========================== -->

      <section
        v-if="loading"
        class="state-card"
      >

        <div class="loading-spinner"></div>

        <p>
          Đang tải thông tin hành trình...
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

        <RouterLink
          to="/hanh-trinh"
          class="primary-button"
        >
          Quay lại danh sách
        </RouterLink>

      </section>


      <!-- =========================
           DETAIL
      ========================== -->

      <template v-else-if="journey">

        <!-- HERO -->

        <section class="detail-hero">

          <div class="detail-hero-content">

            <span class="eyebrow">
              HÀNH TRÌNH ẨM THỰC
            </span>

            <h1>
              {{ journey.ten_hanh_trinh }}
            </h1>

            <p>
              {{ journey.mo_ta }}
            </p>


            <div class="hero-meta">

              <span>
                ⏱
                {{ journey.thoi_luong }}
              </span>

              <span>
                🍽
                {{ journey.mon_an?.length || 0 }}
                món
              </span>

            </div>

          </div>


          <div
            v-if="journey.image"
            class="detail-hero-image"
          >

            <img
              :src="journey.image"
              :alt="journey.ten_hanh_trinh"
            />

          </div>


          <div
            v-else
            class="detail-hero-placeholder"
          >

            <span>
              🍜
            </span>

            <strong>
              ẨM THỰC VIỆT NAM
            </strong>

          </div>

        </section>


        <!-- =========================
             DISHES
        ========================== -->

        <section class="content-section">

          <div class="section-heading">

            <span class="eyebrow">
              TRẢI NGHIỆM
            </span>

            <h2>
              Điểm dừng ẩm thực
            </h2>

            <p>
              Những món ăn được kết hợp trong hành trình.
            </p>

          </div>


          <div
            v-if="journey.mon_an?.length"
            class="dish-list"
          >

            <article
              v-for="dish in journey.mon_an"
              :key="dish.mon_an_id"
              class="dish-item"
            >

              <div class="dish-number">
                {{ dish.thu_tu }}
              </div>

              <div class="dish-content">

                <h3>
                  {{ dish.ten_mon }}
                </h3>

                <p>
                  {{
                    dish.ghi_chu ||
                    'Điểm dừng ẩm thực trong hành trình.'
                  }}
                </p>

              </div>

            </article>

          </div>


          <div
            v-else
            class="empty-card"
          >
            Chưa có thông tin món ăn.
          </div>

        </section>


        <!-- =========================
             SCHEDULE
        ========================== -->

        <section class="content-section">

          <div class="section-heading">

            <span class="eyebrow">
              LỊCH PHỤC VỤ
            </span>

            <h2>
              Chọn ngày trải nghiệm
            </h2>

            <p>
              Lựa chọn lịch phù hợp trước khi đặt chỗ.
            </p>

          </div>


          <div
            v-if="schedules.length"
            class="schedule-list"
          >

            <button
              v-for="schedule in schedules"
              :key="schedule.lich_kha_dung_id"
              type="button"
              class="schedule-card"
              :class="{
                selected:
                  schedule.lich_kha_dung_id ===
                  selectedScheduleId
              }"
              @click="
                selectedScheduleId =
                  schedule.lich_kha_dung_id
              "
            >

              <div class="schedule-main">

                <span class="schedule-label">
                  Ngày phục vụ
                </span>

                <strong>
                  {{ formatDate(schedule.ngay_phuc_vu) }}
                </strong>

              </div>


              <div class="schedule-info">

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

                  <strong
                    :class="{
                      soldOut:
                        remainingSeats(schedule) === 0
                    }"
                  >
                    {{ remainingSeats(schedule) }}
                    chỗ
                  </strong>

                </div>

              </div>


              <div class="schedule-check">

                <span
                  v-if="
                    schedule.lich_kha_dung_id ===
                    selectedScheduleId
                  "
                >
                  ✓
                </span>

              </div>

            </button>

          </div>


          <div
            v-else
            class="empty-card"
          >

            Hiện chưa có lịch phục vụ cho hành trình này.

          </div>

        </section>


<!-- BOOKING / HOLD CTA -->
<section v-if="selectedSchedule" class="booking-cta">
  <template v-if="!holdData">
    <div class="booking-heading">
      <span class="eyebrow">GIỮ CHỖ</span>
      <h2>Sẵn sàng trải nghiệm?</h2>
      <p>
        {{ remainingSeats(selectedSchedule) }} chỗ còn lại cho ngày
        {{ formatDate(selectedSchedule.ngay_phuc_vu) }}.
      </p>
    </div>

    <div class="hold-form">
      <label for="guest-count">Số khách</label>

      <input
        id="guest-count"
        v-model.number="guestCount"
        type="number"
        min="1"
        :max="remainingSeats(selectedSchedule)"
        :disabled="holding"
      />

      <div class="hold-total">
        <span>Đơn giá</span>
        <strong>{{ formatPrice(selectedSchedule.gia_tham_khao) }}</strong>
      </div>

      <div class="hold-total">
        <span>Tổng tiền dự kiến</span>
        <strong>{{ formatPrice(totalPrice) }}</strong>
      </div>

      <button
        type="button"
        class="booking-button"
        :disabled="
          holding ||
          !canBook ||
          guestCount < 1 ||
          guestCount > remainingSeats(selectedSchedule)
        "
        @click="holdSeats"
      >
        {{ holding ? 'Đang giữ chỗ...' : 'Giữ chỗ trong 15 phút' }}
        <span v-if="!holding">→</span>
      </button>

      <p class="hold-note">
        Khi đặt chỗ, hệ thống sẽ giữ chỗ trong 15 phút để bạn hoàn tất thanh toán.
      </p>
      <p
  v-if="paymentMessage"
  class="hold-message"
  role="status"
>
  {{ paymentMessage }}
</p>

<p
  v-if="paymentError"
  class="hold-message hold-message-error"
  role="alert"
>
  {{ paymentError }}
</p>
    </div>

  </template>

  <section v-else class="hold-result">
    <div class="hold-result-heading">
      <div>
        <span class="eyebrow">ĐANG GIỮ CHỖ</span>
        <h2>Giữ chỗ thành công!</h2>
      </div>

      <span class="hold-badge">Đã giữ chỗ</span>
    </div>

    <p>{{ holdSuccess }}</p>

    <div class="hold-code">
      <span>Mã giữ chỗ</span>
      <strong>
        {{ holdData.ma_dat_cho || `#${holdData.dat_cho_id}` }}
      </strong>
    </div>

    <div class="countdown-panel">
      <span>Thời gian còn lại</span>
      <strong :class="{ 'countdown-expired': remainingSeconds === 0 }">
        {{ formatCountdown(remainingSeconds) }}
      </strong>

      <div class="countdown-track">
        <div
          class="countdown-progress"
          :style="{
            width: `${Math.min(100, (remainingSeconds / 900) * 100)}%`
          }"
        ></div>
      </div>
    </div>

<div class="hold-summary">
  <span>Số khách: {{ holdData.so_khach }}</span>
  <strong>
    Tổng tiền: {{ formatPrice(holdData.tong_tien) }}
  </strong>
</div>

<div class="payment-actions">
  <button
    type="button"
    class="booking-button"
    :disabled="remainingSeconds <= 0 || paying"
    @click="payBooking"
  >
    {{ paying ? 'Đang xử lý thanh toán...' : 'Thanh toán ngay' }}
    <span v-if="!paying">→</span>
  </button>

  <p class="hold-note">
    Vui lòng thanh toán trước khi thời gian giữ chỗ kết thúc.
  </p>
</div>

    <p class="hold-note">
      Đồng hồ chỉ hiển thị thời hạn. Trạng thái hết hạn và việc trả chỗ
      do backend xử lý.
    </p>
  </section>

  <p v-if="holdError" class="hold-message hold-message-error" role="alert">
    {{ holdError }}
  </p>
</section>

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
    var(--space-8)
    0
    var(--space-16);
}


/* =========================================================
   BACK
========================================================= */

.back-link {
  display: inline-flex;

  align-items: center;

  margin-bottom:
    var(--space-6);

  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-sm);

  text-decoration: none;
}


.back-link:hover {
  color:
    var(--color-primary);
}


/* =========================================================
   EYEBROW
========================================================= */

.eyebrow {
  display: inline-block;

  margin-bottom:
    var(--space-3);

  color:
    var(--color-primary);

  font-size:
    var(--font-size-xs);

  font-weight:
    var(--font-weight-bold);

  letter-spacing:
    0.08em;
}


/* =========================================================
   HERO
========================================================= */

.detail-hero {
  display: grid;

  grid-template-columns:
    minmax(0, 1fr)
    minmax(360px, 0.72fr);

  min-height: 360px;

  overflow: hidden;

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-xl);

  background:
    var(--color-surface);

  box-shadow:
    var(--shadow-sm);
}


.detail-hero-content {
  display: flex;

  flex-direction: column;

  justify-content: center;

  padding:
    var(--space-10);
}


.detail-hero-content h1 {
  max-width: 720px;

  margin:
    0
    0
    var(--space-4);

  color:
    var(--color-text);

  font-size:
    clamp(
      2rem,
      4vw,
      3.5rem
    );

  line-height:
    1.12;
}


.detail-hero-content p {
  max-width: 680px;

  margin:
    0;

  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-md);

  line-height:
    1.7;
}


.hero-meta {
  display: flex;

  flex-wrap: wrap;

  gap:
    var(--space-5);

  margin-top:
    var(--space-6);

  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-sm);

  font-weight:
    var(--font-weight-medium);
}


/* =========================================================
   HERO IMAGE
========================================================= */

.detail-hero-image,
.detail-hero-placeholder {
  min-height: 360px;
}


.detail-hero-image img {
  width: 100%;

  height: 100%;

  display: block;

  object-fit: cover;
}


.detail-hero-placeholder {
  display: flex;

  flex-direction: column;

  align-items: center;

  justify-content: center;

  gap:
    var(--space-3);

  background:
    var(--color-surface);

  color:
    var(--color-text-muted);
}


.detail-hero-placeholder span {
  font-size: 4rem;
}


.detail-hero-placeholder strong {
  font-size:
    var(--font-size-xs);

  letter-spacing:
    0.1em;
}


/* =========================================================
   CONTENT
========================================================= */

.content-section {
  margin-top:
    var(--space-12);
}


.section-heading {
  margin-bottom:
    var(--space-6);
}


.section-heading h2 {
  margin:
    0
    0
    var(--space-2);

  color:
    var(--color-text);

  font-size:
    var(--font-size-2xl);
}


.section-heading p {
  margin: 0;

  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-sm);

  line-height:
    1.6;
}


/* =========================================================
   DISH LIST
========================================================= */

.dish-list {
  display: grid;

  grid-template-columns:
    repeat(
      3,
      minmax(0, 1fr)
    );

  gap:
    var(--space-4);
}


.dish-item {
  display: flex;

  gap:
    var(--space-4);

  padding:
    var(--space-5);

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-lg);

  background:
    var(--color-background);
}


.dish-number {
  display: flex;

  flex-shrink: 0;

  align-items: center;

  justify-content: center;

  width: 40px;

  height: 40px;

  border-radius: 50%;

  background:
    var(--color-primary);

  color: white;

  font-weight:
    var(--font-weight-bold);
}


.dish-content h3 {
  margin:
    0
    0
    var(--space-2);

  font-size:
    var(--font-size-md);
}


.dish-content p {
  margin: 0;

  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-sm);

  line-height:
    1.55;
}


/* =========================================================
   SCHEDULE
========================================================= */

.schedule-list {
  display: grid;

  gap:
    var(--space-3);
}


.schedule-card {
  position: relative;

  display: grid;

  grid-template-columns:
    minmax(0, 1fr)
    auto
    42px;

  align-items: center;

  width: 100%;

  padding:
    var(--space-5);

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-lg);

  background:
    var(--color-background);

  color:
    var(--color-text);

  text-align: left;

  font: inherit;

  cursor: pointer;

  transition:
    border-color 0.2s ease,
    background 0.2s ease,
    box-shadow 0.2s ease;
}


.schedule-card:hover {
  border-color:
    var(--color-primary);
}


.schedule-card.selected {
  border-color:
    var(--color-primary);

  background:
    rgba(37, 99, 235, 0.05);

  box-shadow:
    0 0 0 1px
    var(--color-primary);
}


.schedule-main {
  display: flex;

  flex-direction: column;

  gap:
    6px;
}


.schedule-label,
.schedule-info span {
  color:
    var(--color-text-muted);

  font-size:
    var(--font-size-sm);
}


.schedule-main strong {
  font-size:
    var(--font-size-md);
}


.schedule-info {
  display: flex;

  gap:
    var(--space-8);
}


.schedule-info div {
  display: flex;

  flex-direction: column;

  align-items: flex-end;

  gap:
    5px;
}


.schedule-info strong {
  color:
    var(--color-primary);

  font-size:
    var(--font-size-sm);
}


.schedule-info strong.soldOut {
  color:
    var(--color-danger);
}


.schedule-check {
  display: flex;

  align-items: center;

  justify-content: center;

  width: 30px;

  height: 30px;

  border:
    1px solid
    var(--color-border);

  border-radius: 50%;

  color: white;

  font-weight:
    var(--font-weight-bold);
}


.schedule-card.selected
.schedule-check {
  border-color:
    var(--color-primary);

  background:
    var(--color-primary);
}


/* =========================================================
   BOOKING CTA
========================================================= */

.booking-cta {
  display: flex;

  align-items: center;

  justify-content: space-between;

  gap:
    var(--space-6);

  margin-top:
    var(--space-12);

  padding:
    var(--space-8);

  border-radius:
    var(--radius-xl);

  background:
    var(--color-text);

  color: white;
}


.booking-cta .eyebrow {
  margin-bottom:
    var(--space-2);

  color:
    #93c5fd;
}


.booking-cta h2 {
  margin:
    0
    0
    var(--space-2);

  color: white;

  font-size:
    var(--font-size-xl);
}


.booking-cta p {
  margin: 0;

  color:
    rgba(255,255,255,0.72);

  font-size:
    var(--font-size-sm);
}


.booking-button {
  display: inline-flex;

  flex-shrink: 0;

  align-items: center;

  justify-content: center;

  gap:
    var(--space-4);

  min-width: 170px;

  min-height: 52px;

  padding:
    0
    var(--space-6);

  border: 0;

  border-radius:
    var(--radius-md);

  background:
    var(--color-primary);

  color: white;

  font: inherit;

  font-weight:
    var(--font-weight-bold);

  text-decoration: none;

  cursor: pointer;
}


.booking-button:hover {
  opacity: 0.92;
}


.booking-button.disabled {
  background:
    #6b7280;

  cursor:
    not-allowed;
}


/* =========================================================
   STATES
========================================================= */

.state-card,
.empty-card {
  display: flex;

  flex-direction: column;

  align-items: center;

  justify-content: center;

  min-height: 240px;

  padding:
    var(--space-8);

  border:
    1px solid
    var(--color-border);

  border-radius:
    var(--radius-xl);

  background:
    var(--color-surface);

  color:
    var(--color-text-muted);

  text-align: center;
}


.state-card h2 {
  margin:
    var(--space-4)
    0
    var(--space-2);

  color:
    var(--color-text);
}


.state-card p {
  margin: 0;
}


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
  display: inline-flex;

  align-items: center;

  justify-content: center;

  margin-top:
    var(--space-5);

  padding:
    var(--space-3)
    var(--space-5);

  border-radius:
    var(--radius-md);

  background:
    var(--color-primary);

  color: white;

  font-weight:
    var(--font-weight-medium);

  text-decoration: none;
}


/* =========================================================
   TABLET
========================================================= */

@media (max-width: 900px) {

  .detail-hero {
    grid-template-columns: 1fr;
  }


  .detail-hero-image,
  .detail-hero-placeholder {
    min-height: 300px;
  }


  .dish-list {
    grid-template-columns:
      repeat(
        2,
        minmax(0, 1fr)
      );
  }


  .booking-cta {
    align-items: flex-start;

    flex-direction: column;
  }

}


/* =========================================================
   MOBILE
========================================================= */

@media (max-width: 640px) {

  .page {
    padding:
      var(--space-6)
      0
      var(--space-10);
  }


  .detail-hero-content {
    padding:
      var(--space-6);
  }


  .detail-hero-content h1 {
    font-size: 2rem;
  }


  .detail-hero-content p {
    font-size:
      var(--font-size-sm);
  }


  .detail-hero-image,
  .detail-hero-placeholder {
    min-height: 230px;
  }


  .dish-list {
    grid-template-columns: 1fr;
  }


  .schedule-card {
    grid-template-columns:
      1fr
      32px;

    gap:
      var(--space-4);
  }


  .schedule-info {
    grid-column: 1 / -1;

    justify-content: space-between;

    gap:
      var(--space-4);
  }


  .schedule-info div {
    align-items: flex-start;
  }


  .schedule-check {
    grid-column: 2;

    grid-row: 1;
  }


  .booking-cta {
    padding:
      var(--space-6);
  }


  .booking-button {
    width: 100%;
  }

}
/* HOLD FORM */
.hold-form {
  display: grid;
  gap: 12px;
  width: min(100%, 420px);
}

.hold-form label,
.hold-total span,
.hold-code span,
.countdown-panel > span {
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
}

.hold-form input {
  width: 100%;
  min-height: 46px;
  padding: 10px 12px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
}

.hold-total,
.hold-code,
.hold-summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.hold-total strong,
.hold-code strong {
  overflow-wrap: anywhere;
}

.hold-note {
  color: var(--color-text-muted) !important;
  font-size: var(--font-size-sm) !important;
  line-height: 1.6;
}

.booking-button:disabled {
  opacity: 0.55;
  cursor: not-allowed;
}

/* HOLD RESULT */
.hold-result {
  width: 100%;
  padding: 22px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  background: var(--color-background);
  color: var(--color-text);
}

.hold-result-heading {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.hold-result h2 {
  margin: 0 0 12px;
  color: var(--color-text);
  font-size: var(--font-size-xl);
}

.hold-badge {
  padding: 6px 10px;
  border-radius: var(--radius-full);
  background: #dcfce7;
  color: #166534;
  font-size: var(--font-size-xs);
  white-space: nowrap;
}

.hold-code {
  margin: 18px 0;
  padding: 14px 0;
  border-top: 1px solid var(--color-border);
  border-bottom: 1px solid var(--color-border);
}

.countdown-panel {
  display: grid;
  gap: 10px;
  margin-bottom: 18px;
}

.countdown-panel > strong {
  color: #dc2626;
  font-size: 2rem;
  font-variant-numeric: tabular-nums;
}

.countdown-panel > strong.countdown-expired {
  color: var(--color-text-muted);
}

.countdown-track {
  height: 6px;
  overflow: hidden;
  border-radius: 999px;
  background: var(--color-border);
}

.countdown-progress {
  height: 100%;
  border-radius: inherit;
  background: var(--color-primary);
  transition: width 1s linear;
}

.hold-summary {
  flex-wrap: wrap;
  padding-top: 14px;
  border-top: 1px solid var(--color-border);
}

.hold-message {
  margin: 14px 0 0;
  font-size: var(--font-size-sm);
  line-height: 1.6;
}

.hold-message-error {
  color: var(--color-danger);
}

@media (max-width: 640px) {
  .hold-form {
    width: 100%;
  }

  .hold-result {
    padding: 16px;
  }

  .hold-result-heading {
    align-items: flex-start;
    flex-direction: column;
  }
}
</style>