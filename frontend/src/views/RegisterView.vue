<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const fullName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const handleRegister = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  if (password.value !== confirmPassword.value) {
    errorMessage.value = 'Mật khẩu xác nhận không khớp.'
    return
  }
  loading.value = true
  try {
    const response = await fetch('/api/auth/register', {
      method: 'POST',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ ho_ten: fullName.value.trim(), email: email.value.trim(), mat_khau: password.value })
    })
    const result = await response.json().catch(() => ({}))
    if (!response.ok) throw new Error(result.message || `HTTP ${response.status}`)
    successMessage.value = 'Đăng ký thành công. Đang chuyển đến trang đăng nhập...'
    fullName.value = ''
    email.value = ''
    password.value = ''
    confirmPassword.value = ''
    setTimeout(() => router.push('/dang-nhap'), 1000)
  } catch (error) {
    console.error(error)
    errorMessage.value = error.message || 'Đăng ký thất bại.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-layout">
      <aside class="auth-aside">
        <RouterLink to="/" class="brand"><span class="brand-mark">AT</span><span>AT-11<small>Ẩm thực vùng miền</small></span></RouterLink>
        <div class="aside-content">
          <span class="eyebrow">BẮT ĐẦU HÀNH TRÌNH</span>
          <h2>Khám phá Việt Nam<br />qua từng <span>hương vị.</span></h2>
          <p>Tạo tài khoản miễn phí để bắt đầu hành trình khám phá bản sắc ẩm thực ba miền.</p>

          <div class="aside-feature">
            <span class="feature-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
              </svg>
            </span>
            <div>
              <strong>Một tài khoản, nhiều trải nghiệm</strong>
              <span>Lưu giữ những khám phá ẩm thực của riêng bạn.</span>
            </div>
          </div>

          <div class="aside-feature">
            <span class="feature-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"></polygon>
                <line x1="8" y1="2" x2="8" y2="18"></line>
                <line x1="16" y1="6" x2="16" y2="22"></line>
              </svg>
            </span>
            <div>
              <strong>Khám phá theo vùng miền</strong>
              <span>Tìm hiểu món ngon và địa điểm trên bản đồ.</span>
            </div>
          </div>

        </div>
        <p class="aside-footer">BẢN ĐỒ ÂM THỰC VÙNG MIỀN · AT-11</p>
      </aside>
      <div class="auth-main">
        <div class="auth-card">
          <div class="mobile-brand"><span class="brand-mark">AT</span><strong>AT-11</strong></div>
          <div class="heading-icon" aria-hidden="true">＋</div>
          <p class="form-eyebrow">TẠO TÀI KHOẢN MỚI</p>
          <h1>Tham gia cùng AT-11</h1>
          <p class="auth-description">Tạo tài khoản để bắt đầu khám phá ẩm thực Việt Nam.</p>
          <form class="auth-form" @submit.prevent="handleRegister">
            <div class="form-group"><label for="register-name">Họ và tên</label><div class="input-wrap"><span class="field-icon">♙</span><input id="register-name" v-model="fullName" type="text" placeholder="Nguyễn Văn A" autocomplete="name" maxlength="255" required /></div></div>
            <div class="form-group"><label for="register-email">Email</label><div class="input-wrap"><span class="field-icon">✉</span><input id="register-email" v-model="email" type="email" placeholder="name@example.com" autocomplete="email" required /></div></div>
            <div class="form-group"><label for="register-password">Mật khẩu</label><div class="input-wrap"><span class="field-icon">▣</span><input id="register-password" v-model="password" :type="showPassword ? 'text' : 'password'" placeholder="Tạo mật khẩu" autocomplete="new-password" required /><button class="password-toggle" type="button" @click="showPassword = !showPassword">{{ showPassword ? 'Ẩn' : 'Hiện' }}</button></div></div>
            <div class="form-group"><label for="register-confirm-password">Xác nhận mật khẩu</label><div class="input-wrap" :class="{ 'input-invalid': confirmPassword && password !== confirmPassword }"><span class="field-icon">▣</span><input id="register-confirm-password" v-model="confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" placeholder="Nhập lại mật khẩu" autocomplete="new-password" required :aria-invalid="Boolean(confirmPassword && password !== confirmPassword)" /><button class="password-toggle" type="button" @click="showConfirmPassword = !showConfirmPassword">{{ showConfirmPassword ? 'Ẩn' : 'Hiện' }}</button></div><p v-if="confirmPassword && password !== confirmPassword" class="field-hint">Mật khẩu xác nhận chưa khớp.</p></div>
            <div v-if="errorMessage" class="message error" role="alert">{{ errorMessage }}</div>
            <div v-if="successMessage" class="message success" role="status">{{ successMessage }}</div>
            <button type="submit" class="primary-button" :disabled="loading">{{ loading ? 'Đang tạo tài khoản...' : 'Tạo tài khoản' }} <span v-if="!loading">→</span><span v-else class="spinner"></span></button>
          </form>
          <div class="auth-switch">Đã có tài khoản? <RouterLink to="/dang-nhap">Đăng nhập →</RouterLink></div>
          <p class="privacy-note">♧ Hãy sử dụng email bạn có thể truy cập.</p>
        </div>
        <footer class="main-footer">© AT-11 · Bản đồ ẩm thực vùng miền</footer>
      </div>
    </section>
  </main>
</template>

<style scoped>
.auth-page {
  min-height: calc(100vh - 56px);
  padding: clamp(16px, 4vw, 48px);
  display: grid;
  place-items: center;
  background: var(--color-background, #f3f6fc);
  color: var(--color-text, #172033);
  transition: background 0.3s ease, color 0.3s ease;
}

:global([data-theme="dark"]) .auth-page {
  background: #0b0f19 !important;
}

.auth-layout {
  width: min(1080px, 100%);
  display: grid;
  grid-template-columns: 0.92fr 1.08fr;
  background: var(--color-background, #fff);
  border: 1px solid var(--color-border, #e4eaf3);
  border-radius: 26px;
  overflow: hidden;
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.08);
  transition: background 0.3s ease, border-color 0.3s ease;
}

:global([data-theme="dark"]) .auth-layout {
  background: #111827 !important;
  border-color: #1f2937 !important;
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.5);
}

.auth-aside {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 34px;
  color: white;
  background: radial-gradient(ellipse at 15% 85%, #5a97ff6b, transparent 42%), linear-gradient(145deg, #173b83, #2563eb 60%, #397df5);
}

.brand { display: flex; align-items: center; gap: 11px; width: max-content; color: #fff; text-decoration: none; font-weight: 800; }
.brand-mark { width: 40px; height: 40px; display: grid; place-items: center; border-radius: 12px; background: #fff; color: #245ee8; font-weight: 900; }
.brand small { display: block; margin-top: 3px; font-size: 10px; font-weight: 500; opacity: 0.8; }

.aside-content { max-width: 380px; margin: 36px 0; }
.eyebrow, .form-eyebrow { font-size: 10px; letter-spacing: 0.15em; font-weight: 800; }
.eyebrow { color: #c9dcff; }
.aside-content h2 { margin: 16px 0; font-size: clamp(28px, 3.0vw, 38px); line-height: 1.18; letter-spacing: -0.04em; }
.aside-content h2 span { color: #c5dcff; }
.aside-content > p { color: #e0eaff; font-size: 14px; line-height: 1.75; margin-bottom: 24px; }

.aside-feature { display: flex; align-items: center; gap: 14px; margin-top: 18px; }
.feature-icon {
  width: 42px;
  height: 42px;
  min-width: 42px;
  min-height: 42px;
  flex-shrink: 0;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  border: 1px solid rgba(255, 255, 255, 0.35);
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.12);
  color: #ffffff;
  box-sizing: border-box;
}
.feature-icon svg {
  width: 20px;
  height: 20px;
  stroke: currentColor;
  display: block;
}
.aside-feature strong, .aside-feature span { display: block; }
.aside-feature strong { font-size: 13px; font-weight: 700; color: #ffffff; }
.aside-feature span { margin-top: 3px; color: #d8e5ff; font-size: 11.5px; line-height: 1.45; }
.aside-footer { margin: 0; color: #d2e0ff; font-size: 9px; letter-spacing: 0.12em; }

.auth-main { display: flex; flex-direction: column; justify-content: center; align-items: center; padding: clamp(26px, 4vw, 48px); background: transparent; }
.auth-card { width: min(100%, 410px); }

.heading-icon { width: 42px; height: 42px; display: grid; place-items: center; margin-bottom: 17px; border: 1px solid var(--color-border, #dce7ff); border-radius: 13px; background: var(--color-surface, #f0f5ff); color: var(--color-primary, #2864ed); font-size: 22px; }
:global([data-theme="dark"]) .heading-icon { background: rgba(37, 99, 235, 0.15); border-color: rgba(59, 130, 246, 0.3); color: #60a5fa; }

.form-eyebrow { margin: 0 0 8px; color: var(--color-primary, #3268e9); }
:global([data-theme="dark"]) .form-eyebrow { color: #60a5fa; }

.auth-card h1 { margin: 0; font-size: clamp(26px, 2.7vw, 32px); font-weight: 800; line-height: 1.2; letter-spacing: -0.04em; color: var(--color-text, #172033); }
.auth-description { margin: 10px 0 21px; color: var(--color-text-muted, #69758a); font-size: 13px; line-height: 1.7; }

.auth-form { display: grid; gap: 14px; }
.form-group label { display: block; margin-bottom: 7px; color: var(--color-text, #263248); font-size: 12px; font-weight: 700; }

.input-wrap { height: 46px; display: flex; align-items: center; gap: 10px; padding: 0 12px; border: 1px solid var(--color-border, #dfe5ef); border-radius: 11px; background: var(--color-background, #fff); transition: border-color 0.2s, box-shadow 0.2s, background 0.2s; }
:global([data-theme="dark"]) .input-wrap { background: #1f2937; border-color: #374151; }
.input-wrap:focus-within { border-color: var(--color-primary, #3974f6); box-shadow: 0 0 0 4px rgba(57, 116, 246, 0.12); }
.field-icon { color: var(--color-text-muted, #8793a8); }
.input-wrap input { width: 100%; min-width: 0; height: 100%; border: 0; outline: 0; background: transparent; color: var(--color-text, #172033); font: inherit; font-size: 13px; }
.input-wrap input::placeholder { color: var(--color-text-muted, #9aa5b5); }

.password-toggle { padding: 5px 0; border: 0; background: transparent; color: var(--color-primary, #3268e9); font-size: 11px; font-weight: 700; cursor: pointer; }
:global([data-theme="dark"]) .password-toggle { color: #60a5fa; }

.input-invalid { border-color: #dc5454; }
.field-hint { margin: 6px 0 0; color: #b42318; font-size: 11px; }
:global([data-theme="dark"]) .field-hint { color: #fca5a5; }

.primary-button { width: 100%; min-height: 48px; display: flex; align-items: center; justify-content: center; gap: 10px; margin-top: 3px; padding: 12px 18px; border: 0; border-radius: 11px; color: white; background: linear-gradient(100deg, #2861ed, #3478f6); box-shadow: 0 8px 18px #2962ed35; font: inherit; font-size: 13px; font-weight: 750; cursor: pointer; transition: transform 0.18s, box-shadow 0.18s; }
.primary-button:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 12px 24px #2962ed45; }
.primary-button:disabled { opacity: 0.65; cursor: not-allowed; }

.spinner { width: 16px; height: 16px; border: 2px solid #ffffff70; border-top-color: white; border-radius: 50%; animation: spin 0.7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.message { padding: 10px 12px; border: 1px solid; border-radius: 10px; font-size: 12px; line-height: 1.55; }
.message.error { color: #b42318; border-color: #f4c7c3; background: #fff5f4; }
:global([data-theme="dark"]) .message.error { color: #fca5a5; border-color: rgba(239, 68, 68, 0.4); background: rgba(239, 68, 68, 0.15); }
.message.success { color: #167647; border-color: #b8e5cc; background: #f0fbf5; }
:global([data-theme="dark"]) .message.success { color: #86efac; border-color: rgba(34, 197, 94, 0.4); background: rgba(34, 197, 94, 0.15); }

.auth-switch { margin-top: 20px; padding-top: 18px; border-top: 1px solid var(--color-border, #edf0f5); text-align: center; color: var(--color-text-muted, #6d788b); font-size: 12px; }
.auth-switch a { margin-left: 4px; color: var(--color-primary, #2864ed); text-decoration: none; font-weight: 750; }
:global([data-theme="dark"]) .auth-switch a { color: #60a5fa; }
.auth-switch a:hover { text-decoration: underline; }

.privacy-note { margin: 15px 0 0; text-align: center; color: var(--color-text-muted, #929bad); font-size: 10px; }
.main-footer { margin-top: 25px; color: var(--color-text-muted, #9aa3b2); text-align: center; font-size: 10px; }
.mobile-brand { display: none; }

/* Responsive chuẩn Tablet (< 1024px) */
@media(max-width: 1023px) {
  .auth-page { padding: 14px; min-height: calc(100vh - 56px); }
  .auth-layout { grid-template-columns: 1fr; border-radius: 21px; }
  .auth-aside { display: none; }
  .auth-main { padding: 25px 22px 19px; }
  .mobile-brand { display: flex; align-items: center; gap: 10px; margin-bottom: 24px; }
  .mobile-brand .brand-mark { width: 35px; height: 35px; background: var(--color-surface, #edf3ff); box-shadow: none; }
  .auth-card { width: min(100%, 420px); }
  .main-footer { margin-top: 22px; }
}

@media(max-width:380px){.auth-main{padding:21px 15px 15px}.input-wrap{padding:0 9px}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
</style>