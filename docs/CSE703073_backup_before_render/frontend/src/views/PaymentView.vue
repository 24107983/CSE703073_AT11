
<script setup>
import { computed, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const bookingId = Number(route.params.datChoId)
const storageKey = `at11_payment_${bookingId}`

const readBooking = () => {
  try {
    const raw = sessionStorage.getItem(storageKey)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

const booking = ref(readBooking())
const paying = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const paymentMethod = ref('direct')

const customer = ref({
  fullName: '',
  phone: '',
  email: '',
  note: ''
})

const customerErrors = ref({})
const formatPrice = (price) => {
  const value = Number(price)
  if (!Number.isFinite(value)) return 'Chưa cập nhật'
  return new Intl.NumberFormat('vi-VN').format(value) + 'đ'
}

const journeyName = computed(() =>
  booking.value?.ten_hanh_trinh || 'Hành trình ẩm thực'
)

const canPay = computed(() => (
  Number.isInteger(bookingId) &&
  bookingId > 0 &&
  Number(booking.value?.dat_cho_id) === bookingId &&
  Number.isFinite(Number(booking.value?.tong_tien)) &&
  Number(booking.value?.tong_tien) >= 0 &&
  !successMessage.value
))
const validateCustomer = () => {
  const errors = {}
  const phone = customer.value.phone.trim()
  const email = customer.value.email.trim()

  if (!customer.value.fullName.trim()) {
    errors.fullName = 'Vui lòng nhập họ và tên.'
  }

  if (!phone) {
    errors.phone = 'Vui lòng nhập số điện thoại.'
  } else if (!/^(0|\+84)[0-9]{9}$/.test(phone.replace(/\s/g, ''))) {
    errors.phone = 'Số điện thoại chưa đúng định dạng.'
  }

  if (!email) {
    errors.email = 'Vui lòng nhập email.'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    errors.email = 'Email chưa đúng định dạng.'
  }

  customerErrors.value = errors
  return Object.keys(errors).length === 0
}
const confirmPayment = async () => {
if (!canPay.value || paying.value) return
if (!validateCustomer()) return
  paying.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await fetch('/api/thanh-toan/test', {
      method: 'POST',
      credentials: 'include',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        dat_cho_id: bookingId,
        ket_qua: 'success'
      })
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(
        result.message || `Không thể xác nhận đơn hàng (HTTP ${response.status}).`
      )
    }

    successMessage.value =
      'Đơn đặt chỗ của bạn đã được xác nhận thành công.'

    sessionStorage.removeItem(storageKey)
  } catch (error) {
    errorMessage.value =
      error.message || 'Không thể kết nối đến máy chủ. Vui lòng thử lại.'
  } finally {
    paying.value = false
  }
}

const goBack = () => {
  router.push(`/hanh-trinh/${route.query.journeyId || booking.value?.hanh_trinh_id || ''}`)
}

const goHome = () => {
  router.push('/')
}
</script>

<template>
  <main class="checkout-page">
    <header class="checkout-header">
      <button class="brand" type="button" @click="goHome">
        <span class="brand-mark">AT</span>
        <span>
          <strong>AT-11</strong>
          <small>Hành trình ẩm thực Việt</small>
        </span>
      </button>

      <div class="secure-note">
        <span class="secure-icon">✓</span>
        Đặt chỗ an toàn
      </div>
    </header>

    <div class="checkout-container">
      <nav class="checkout-steps" aria-label="Tiến trình đặt chỗ">
        <div class="step completed">
          <span>✓</span>
          <p>Chọn hành trình</p>
        </div>
        <div class="step-line"></div>
        <div class="step completed">
          <span>✓</span>
          <p>Thông tin đặt chỗ</p>
        </div>
        <div class="step-line"></div>
        <div class="step active">
          <span>3</span>
          <p>Thanh toán</p>
        </div>
      </nav>

      <div v-if="!booking" class="empty-state">
        <div class="empty-icon">!</div>
        <h1>Không tìm thấy đơn đặt chỗ</h1>
        <p>
          Thông tin đặt chỗ không còn trong phiên hiện tại.
          Bạn vui lòng quay lại hành trình và thực hiện giữ chỗ.
        </p>
        <button class="primary-button" type="button" @click="goBack">
          Quay lại hành trình
        </button>
      </div>

      <template v-else>
        <div v-if="successMessage" class="success-banner" role="status">
          <div class="success-icon">✓</div>
          <div>
            <h1>Đặt chỗ thành công!</h1>
            <p>{{ successMessage }}</p>
            <span>
              Mã đặt chỗ:
              <strong>{{ booking.ma_dat_cho || `#${booking.dat_cho_id}` }}</strong>
            </span>
          </div>
        </div>

        <div v-else class="page-heading">
          <p class="eyebrow">XÁC NHẬN ĐẶT CHỖ</p>
          <h1>Hoàn tất hành trình của bạn</h1>
          <p>Kiểm tra thông tin trước khi xác nhận đặt chỗ.</p>
        </div>

        <div class="checkout-layout">
          <section class="checkout-main">

<article class="panel customer-panel" v-if="!successMessage">
  <div class="panel-heading">
    <div>
      <span class="section-number">01</span>
      <h2>Thông tin người đặt</h2>
    </div>
  </div>

  <p class="panel-description">
    Vui lòng cung cấp thông tin để hoàn tất đơn đặt chỗ.
  </p>

  <form class="customer-form" @submit.prevent="confirmPayment">
    <div class="form-field">
      <label for="customer-name">Họ và tên <span>*</span></label>
      <input
        id="customer-name"
        v-model="customer.fullName"
        type="text"
        autocomplete="name"
        placeholder="Nhập họ và tên của bạn"
        maxlength="100"
      />
      <small v-if="customerErrors.fullName" class="field-error">
        {{ customerErrors.fullName }}
      </small>
    </div>

    <div class="form-grid">
      <div class="form-field">
        <label for="customer-phone">Số điện thoại <span>*</span></label>
        <input
          id="customer-phone"
          v-model="customer.phone"
          type="tel"
          autocomplete="tel"
          placeholder="0912 345 678"
          maxlength="15"
        />
        <small v-if="customerErrors.phone" class="field-error">
          {{ customerErrors.phone }}
        </small>
      </div>

      <div class="form-field">
        <label for="customer-email">Email <span>*</span></label>
        <input
          id="customer-email"
          v-model="customer.email"
          type="email"
          autocomplete="email"
          placeholder="email@example.com"
          maxlength="150"
        />
        <small v-if="customerErrors.email" class="field-error">
          {{ customerErrors.email }}
        </small>
      </div>
    </div>

    <div class="form-field">
      <label for="customer-note">Ghi chú <small>(không bắt buộc)</small></label>
      <textarea
        id="customer-note"
        v-model="customer.note"
        rows="3"
        maxlength="500"
        placeholder="Yêu cầu đặc biệt hoặc lưu ý cho hành trình..."
      ></textarea>
    </div>
  </form>
</article>

            <article class="panel journey-panel">
              <div class="panel-heading">
                <div>
                  <span class="section-number">01</span>
                  <h2>Thông tin hành trình</h2>
                </div>
                <span class="status-pill">
                  {{ successMessage ? 'Đã xác nhận' : 'Đang giữ chỗ' }}
                </span>
              </div>

              <div class="journey-info">
                <div class="journey-symbol">✦</div>
                <div class="journey-copy">
                  <span class="muted-label">HÀNH TRÌNH ẨM THỰC</span>
                  <h3>{{ journeyName }}</h3>
                  <p>Khám phá hương vị và văn hóa ẩm thực Việt Nam.</p>
                </div>
              </div>

              <div class="info-grid">
                <div class="info-item">
                  <span>Mã đặt chỗ</span>
                  <strong>{{ booking.ma_dat_cho || `#${booking.dat_cho_id}` }}</strong>
                </div>
                <div class="info-item">
                  <span>Số lượng khách</span>
                  <strong>{{ booking.so_khach }} người</strong>
                </div>
              </div>
            </article>

            <article v-if="!successMessage" class="panel">
              <div class="panel-heading">
                <div>
                  <span class="section-number">02</span>
                  <h2>Phương thức thanh toán</h2>
                </div>
              </div>

              <p class="panel-description">
                Chọn hình thức xác nhận thanh toán cho đơn đặt chỗ.
              </p>

              <label class="payment-option selected">
                <input
                  v-model="paymentMethod"
                  type="radio"
                  value="direct"
                />
                <span class="payment-icon">₫</span>
                <span class="payment-option-copy">
                  <strong>Thanh toán trực tiếp</strong>
                  <small>Xác nhận đơn đặt chỗ trên hệ thống</small>
                </span>
                <span class="radio-indicator"></span>
              </label>

              <p class="payment-disclaimer">
                Phương thức này xác nhận đơn trên hệ thống, không kết nối
                ngân hàng hoặc ví điện tử.
              </p>
            </article>

            <div v-if="errorMessage" class="error-banner" role="alert">
              <strong>Chưa thể xác nhận đơn</strong>
              <p>{{ errorMessage }}</p>
            </div>

            <div v-if="successMessage" class="next-step">
              <span class="next-step-icon">✓</span>
              <div>
                <strong>Thông tin đặt chỗ đã được cập nhật</strong>
                <p>
                  Bạn có thể quay lại hành trình hoặc trở về trang chủ.
                </p>
              </div>
            </div>
          </section>

          <aside class="order-panel">
            <div class="order-heading">
              <h2>Tổng kết đơn hàng</h2>
              <span>ĐƠN ĐẶT CHỖ</span>
            </div>

            <div class="order-journey">
              <div class="order-thumbnail">AT</div>
              <div>
                <strong>{{ journeyName }}</strong>
                <p>{{ booking.so_khach }} khách</p>
              </div>
            </div>

            <div class="price-row">
              <span>Số lượng khách</span>
              <strong>{{ booking.so_khach }}</strong>
            </div>

            <div class="price-row">
              <span>Phí đặt chỗ</span>
              <strong>Đã bao gồm</strong>
            </div>

            <div class="price-divider"></div>

            <div class="grand-total">
              <div>
                <span>Tổng thanh toán</span>
                <small>Đã bao gồm các chi phí</small>
              </div>
              <strong>{{ formatPrice(booking.tong_tien) }}</strong>
            </div>

            <button
              v-if="!successMessage"
              class="primary-button"
              type="button"
              :disabled="!canPay || paying || paymentMethod !== 'direct'"
              @click="confirmPayment"
            >
              {{ paying ? 'Đang xác nhận...' : 'Xác nhận đặt và thanh toán' }}
              <span v-if="!paying">→</span>
            </button>

            <button
              v-else
              class="primary-button"
              type="button"
              @click="goHome"
            >
              Hoàn tất
              <span>✓</span>
            </button>

            <button
              class="back-button"
              type="button"
              @click="goBack"
            >
              ← Quay lại hành trình
            </button>

            <div class="trust-note">
              <span>✓</span>
              <p>
                Thông tin đơn hàng được xử lý qua hệ thống đặt chỗ AT-11.
              </p>
            </div>
          </aside>
        </div>

        <footer class="checkout-footer">
          <span>AT-11 · Hành trình ẩm thực Việt</span>
          <span>Thông tin đặt chỗ · Hỗ trợ khách hàng</span>
        </footer>
      </template>
    </div>
  </main>
</template>

<style scoped>
* {
  box-sizing: border-box;
}

.checkout-page {
  min-height: 100vh;
  background: #f7f7f5;
  color: #262a30;
  padding-bottom: 36px;
}

.checkout-header {
  min-height: 76px;
  padding: 0 clamp(20px, 5vw, 76px);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  background: #fff;
  border-bottom: 1px solid #ecebe7;
}

.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0;
  border: 0;
  background: transparent;
  color: #252a30;
  text-align: left;
  cursor: pointer;
}

.brand-mark {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  border-radius: 12px;
  background: #76523c;
  color: #fff;
  font-size: 15px;
  font-weight: 800;
  letter-spacing: -1px;
}

.brand strong,
.brand small {
  display: block;
}

.brand strong {
  font-size: 17px;
  letter-spacing: .3px;
}

.brand small {
  margin-top: 3px;
  color: #817a73;
  font-size: 11px;
}

.secure-note {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #686b68;
  font-size: 13px;
}

.secure-icon {
  width: 22px;
  height: 22px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #e9f4ec;
  color: #31784a;
  font-weight: 800;
}

.checkout-container {
  width: min(1160px, calc(100% - 40px));
  margin: 0 auto;
}

.checkout-steps {
  max-width: 660px;
  margin: 34px auto 42px;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.step {
  width: 150px;
  flex-shrink: 0;
  text-align: center;
  color: #96958f;
}

.step > span {
  width: 32px;
  height: 32px;
  margin: 0 auto 9px;
  display: grid;
  place-items: center;
  border: 1px solid #dcdad4;
  border-radius: 50%;
  background: #fff;
  font-size: 13px;
  font-weight: 700;
}

.step p {
  margin: 0;
  font-size: 12px;
}

.step.completed > span {
  border-color: #76523c;
  background: #76523c;
  color: #fff;
}

.step.active {
  color: #76523c;
  font-weight: 700;
}

.step.active > span {
  border-color: #76523c;
  color: #76523c;
  box-shadow: 0 0 0 4px #eee5de;
}

.step-line {
  height: 1px;
  flex: 1;
  margin-top: 16px;
  background: #dcdad4;
}

.page-heading {
  margin-bottom: 28px;
}

.eyebrow {
  margin: 0 0 10px;
  color: #8a654b;
  font-size: 11px;
  font-weight: 800;
  letter-spacing: 1.5px;
}

.page-heading h1,
.success-banner h1 {
  margin: 0;
  color: #282b30;
  font-size: clamp(26px, 3vw, 35px);
  line-height: 1.25;
  letter-spacing: -.8px;
}

.page-heading > p:last-child {
  margin: 10px 0 0;
  color: #777872;
  font-size: 14px;
  line-height: 1.6;
}

.checkout-layout {
  display: grid;
  grid-template-columns: minmax(0, 1.55fr) minmax(300px, .85fr);
  align-items: start;
  gap: 24px;
}

.checkout-main {
  display: grid;
  gap: 20px;
  min-width: 0;
}

.panel,
.order-panel {
  background: #fff;
  border: 1px solid #e9e7e1;
  border-radius: 15px;
  box-shadow: 0 4px 16px rgba(34, 32, 27, .025);
}

.panel {
  padding: 25px;
}

.panel-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 14px;
  margin-bottom: 23px;
}

.panel-heading > div {
  display: flex;
  align-items: center;
  gap: 12px;
}

.section-number {
  color: #a38a76;
  font-size: 12px;
  font-weight: 800;
}

.panel-heading h2 {
  margin: 0;
  color: #303239;
  font-size: 17px;
  letter-spacing: -.2px;
}

.status-pill {
  padding: 7px 10px;
  border-radius: 20px;
  background: #f5eee8;
  color: #805c43;
  font-size: 11px;
  font-weight: 700;
  white-space: nowrap;
}

.journey-info {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 18px;
  border-radius: 12px;
  background: #f8f6f2;
}

.journey-symbol {
  width: 46px;
  height: 46px;
  flex-shrink: 0;
  display: grid;
  place-items: center;
  border-radius: 12px;
  background: #eae0d5;
  color: #79563d;
  font-size: 24px;
}

.muted-label {
  color: #978575;
  font-size: 10px;
  font-weight: 800;
  letter-spacing: 1px;
}

.journey-copy h3 {
  margin: 7px 0;
  color: #342d28;
  font-size: 17px;
}

.journey-copy p {
  margin: 0;
  color: #817a73;
  font-size: 12px;
  line-height: 1.6;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  padding-top: 22px;
}

.info-item span,
.info-item strong {
  display: block;
}

.info-item span {
  margin-bottom: 8px;
  color: #898780;
  font-size: 12px;
}

.info-item strong {
  color: #36363a;
  font-size: 13px;
  overflow-wrap: anywhere;
}

.panel-description {
  margin: -10px 0 18px;
  color: #777872;
  font-size: 13px;
  line-height: 1.6;
}

.payment-option {
  position: relative;
  display: flex;
  align-items: center;
  gap: 13px;
  padding: 16px;
  border: 1px solid #dcd4cb;
  border-radius: 11px;
  cursor: pointer;
}

.payment-option.selected {
  border-color: #8b6b51;
  background: #fcfaf7;
}

.payment-option input {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

.payment-icon {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 10px;
  background: #eee5dc;
  color: #79563d;
  font-size: 20px;
  font-weight: 800;
}

.payment-option-copy {
  display: grid;
  gap: 5px;
  flex: 1;
}

.payment-option-copy strong {
  color: #393530;
  font-size: 13px;
}

.payment-option-copy small {
  color: #878078;
  font-size: 11px;
  line-height: 1.5;
}

.radio-indicator {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
  border: 1px solid #9d8b7b;
  border-radius: 50%;
}

.payment-option.selected .radio-indicator {
  border: 5px solid #76523c;
}

.payment-disclaimer {
  margin: 14px 0 0;
  color: #8b837a;
  font-size: 11px;
  line-height: 1.7;
}

.order-panel {
  position: sticky;
  top: 24px;
  padding: 25px;
}

.order-heading {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding-bottom: 20px;
  border-bottom: 1px solid #eeeae4;
}

.order-heading h2 {
  margin: 0;
  font-size: 17px;
}

.order-heading > span {
  color: #a09487;
  font-size: 9px;
  font-weight: 800;
  letter-spacing: .8px;
}

.order-journey {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 22px 0;
}

.order-thumbnail {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 12px;
  background: #76523c;
  color: #fff;
  font-size: 15px;
  font-weight: 800;
}

.order-journey strong {
  display: block;
  color: #3a342e;
  font-size: 13px;
  line-height: 1.5;
}

.order-journey p {
  margin: 5px 0 0;
  color: #89837b;
  font-size: 12px;
}

.price-row {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  margin: 15px 0;
  color: #77736d;
  font-size: 12px;
}

.price-row strong {
  color: #45413c;
  text-align: right;
}

.price-divider {
  height: 1px;
  margin: 20px 0;
  border-top: 1px dashed #ded8cf;
}

.grand-total {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 14px;
  margin-bottom: 22px;
}

.grand-total span,
.grand-total small {
  display: block;
}

.grand-total span {
  color: #45413c;
  font-size: 13px;
  font-weight: 700;
}

.grand-total small {
  margin-top: 6px;
  color: #969087;
  font-size: 10px;
}

.grand-total > strong {
  color: #79543b;
  font-size: 23px;
  letter-spacing: -.6px;
  text-align: right;
  overflow-wrap: anywhere;
}

.primary-button,
.back-button {
  width: 100%;
  min-height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  border-radius: 9px;
  font-family: inherit;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: background .2s, transform .2s;
}

.primary-button {
  padding: 12px 16px;
  border: 1px solid #76523c;
  background: #76523c;
  color: #fff;
}

.primary-button:hover:not(:disabled) {
  background: #60422f;
  transform: translateY(-1px);
}

.primary-button:disabled {
  opacity: .6;
  cursor: not-allowed;
}

.back-button {
  margin-top: 10px;
  border: 1px solid transparent;
  background: #fff;
  color: #76685d;
}

.back-button:hover {
  background: #f8f5f1;
}

.trust-note {
  display: flex;
  align-items: flex-start;
  gap: 9px;
  margin-top: 20px;
  padding-top: 18px;
  border-top: 1px solid #eeeae4;
}

.trust-note > span {
  color: #51815f;
  font-weight: 800;
}

.trust-note p {
  margin: 0;
  color: #8b857d;
  font-size: 10px;
  line-height: 1.7;
}

.error-banner,
.success-banner,
.next-step {
  border-radius: 13px;
}

.error-banner {
  padding: 17px;
  border: 1px solid #f1d0cc;
  background: #fff5f3;
  color: #9c352d;
}

.error-banner p {
  margin: 8px 0 0;
  font-size: 13px;
  line-height: 1.6;
}

.success-banner {
  display: flex;
  align-items: flex-start;
  gap: 18px;
  margin-bottom: 28px;
  padding: 24px;
  border: 1px solid #cde6d4;
  background: #f0f8f1;
}

.success-icon {
  width: 46px;
  height: 46px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 50%;
  background: #d8eddd;
  color: #287443;
  font-size: 23px;
  font-weight: 800;
}

.success-banner h1 {
  color: #24673b;
  font-size: 25px;
}

.success-banner p {
  margin: 10px 0;
  color: #4e6f56;
  font-size: 13px;
  line-height: 1.7;
}

.success-banner span {
  color: #4e6f56;
  font-size: 12px;
}

.next-step {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 18px;
  border: 1px solid #e8e4dc;
  background: #fff;
}

.next-step-icon {
  color: #387b4c;
  font-size: 19px;
}

.next-step strong {
  font-size: 13px;
}

.next-step p {
  margin: 6px 0 0;
  color: #817c74;
  font-size: 12px;
  line-height: 1.6;
}

.checkout-footer {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  margin-top: 34px;
  padding-top: 20px;
  border-top: 1px solid #e8e5df;
  color: #928b81;
  font-size: 11px;
}

.empty-state {
  max-width: 520px;
  margin: 70px auto;
  padding: 38px;
  border: 1px solid #e9e7e1;
  border-radius: 16px;
  background: #fff;
  text-align: center;
}

.empty-icon {
  width: 44px;
  height: 44px;
  margin: 0 auto 18px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: #f8eee3;
  color: #855b3b;
  font-size: 23px;
  font-weight: 800;
}

.empty-state h1 {
  font-size: 22px;
}

.empty-state p {
  color: #777872;
  font-size: 13px;
  line-height: 1.7;
}

.empty-state .primary-button {
  margin-top: 22px;
}

@media (max-width: 820px) {
  .checkout-layout {
    grid-template-columns: 1fr;
  }

  .order-panel {
    position: static;
    grid-row: 1;
  }

  .checkout-steps {
    margin: 28px auto 32px;
  }

  .step {
    width: 120px;
  }
}

@media (max-width: 520px) {
  .checkout-header {
    min-height: 68px;
    padding: 0 18px;
  }

  .secure-note {
    font-size: 11px;
  }

  .checkout-container {
    width: calc(100% - 28px);
  }

  .checkout-steps {
    margin: 24px auto 30px;
  }

  .step {
    width: 100px;
  }

  .step p {
    font-size: 10px;
  }

  .panel,
  .order-panel {
    padding: 19px;
  }

  .panel-heading h2 {
    font-size: 15px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .grand-total > strong {
    font-size: 20px;
  }

  .checkout-footer {
    flex-direction: column;
    gap: 8px;
  }

  .success-banner {
    padding: 18px;
    gap: 12px;
  }

  .success-banner h1 {
    font-size: 21px;
  }
}

.customer-form {
  display: grid;
  gap: 18px;
}

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 0;
}

.form-field label {
  color: #45413c;
  font-size: 12px;
  font-weight: 700;
}

.form-field label span {
  color: #b44a3d;
}

.form-field label small {
  color: #89837b;
  font-weight: 400;
}

.form-field input,
.form-field textarea {
  width: 100%;
  padding: 12px 13px;
  border: 1px solid #dedbd5;
  border-radius: 8px;
  background: #fff;
  color: #303239;
  font: inherit;
  font-size: 13px;
  outline: none;
  transition: border-color .2s, box-shadow .2s;
}

.form-field input:focus,
.form-field textarea:focus {
  border-color: #8b6b51;
  box-shadow: 0 0 0 3px rgba(139, 107, 81, .12);
}

.form-field input::placeholder,
.form-field textarea::placeholder {
  color: #aaa49c;
}

.form-field textarea {
  resize: vertical;
  min-height: 88px;
}

.field-error {
  color: #b33d35;
  font-size: 11px;
}

@media (max-width: 520px) {
  .form-grid {
    grid-template-columns: 1fr;
  }
}

</style>
