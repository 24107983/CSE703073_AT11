<script setup>
import { ref } from 'vue'

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const loading = ref(false)
const logoutLoading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const user = ref(null)

const handleLogin = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  user.value = null
  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
      credentials: 'include',
      body: JSON.stringify({ email: email.value.trim(), mat_khau: password.value })
    })
    const result = await response.json().catch(() => ({}))
    if (!response.ok) throw new Error(result.message || `HTTP ${response.status}`)
    user.value = result.data
    localStorage.setItem('auth_user', JSON.stringify(result.data))
    window.dispatchEvent(new Event('auth-changed'))
    successMessage.value = 'Đăng nhập thành công.'
  } catch (error) {
    console.error(error)
    errorMessage.value = error.message || 'Đăng nhập thất bại.'
  } finally {
    loading.value = false
  }
}

const handleLogout = async () => {
  logoutLoading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  try {
    const response = await fetch('/api/auth/logout', {
      method: 'POST', headers: { Accept: 'application/json' }, credentials: 'include'
    })
    if (!response.ok && response.status !== 204) {
      const result = await response.json().catch(() => ({}))
      throw new Error(result.message || `HTTP ${response.status}`)
    }
    user.value = null
    email.value = ''
    password.value = ''
    localStorage.removeItem('auth_user')
    window.dispatchEvent(new Event('auth-changed'))
    successMessage.value = 'Đã đăng xuất.'
  } catch (error) {
    console.error(error)
    errorMessage.value = error.message || 'Đăng xuất thất bại.'
  } finally {
    logoutLoading.value = false
  }
}
</script>

<template>
  <main class="auth-page">
    <section class="auth-layout">
      <aside class="auth-aside">
        <RouterLink to="/" class="brand"><span class="brand-mark">AT</span><span>AT-11<small>Ẩm thực vùng miền</small></span></RouterLink>
        <div class="aside-content">
          <span class="eyebrow">KHÁM PHÁ VIỆT NAM</span>
          <h2>Mỗi hành trình<br />bắt đầu từ một<br /><span>hương vị.</span></h2>
          <p>Đăng nhập để lưu lại những món ngon và khám phá thêm nét đặc sắc của ẩm thực Việt Nam.</p>
          <div class="aside-points"><span><i>✓</i> Khám phá món ăn vùng miền</span><span><i>✓</i> Lưu lại trải nghiệm yêu thích</span></div>
        </div>
        <p class="aside-footer">BẢN ĐỒ ẨM THỰC VÙNG MIỀN · AT-11</p>
      </aside>
      <div class="auth-main">
        <div class="auth-card">
          <div class="mobile-brand"><span class="brand-mark">AT</span><strong>AT-11</strong></div>
          <template v-if="!user">
            <div class="heading-icon" aria-hidden="true">↗</div>
            <p class="form-eyebrow">CHÀO MỪNG BẠN TRỞ LẠI</p>
            <h1>Đăng nhập</h1>
            <p class="auth-description">Đăng nhập để tiếp tục khám phá những hương vị Việt Nam.</p>
            <form class="auth-form" @submit.prevent="handleLogin">
              <div class="form-group">
                <label for="login-email">Email</label>
                <div class="input-wrap"><span class="field-icon">✉</span><input id="login-email" v-model="email" type="email" placeholder="name@example.com" autocomplete="email" required /></div>
              </div>
              <div class="form-group">
                <label for="login-password">Mật khẩu</label>
                <div class="input-wrap"><span class="field-icon">▣</span><input id="login-password" v-model="password" :type="showPassword ? 'text' : 'password'" placeholder="Nhập mật khẩu" autocomplete="current-password" required /><button class="password-toggle" type="button" @click="showPassword = !showPassword">{{ showPassword ? 'Ẩn' : 'Hiện' }}</button></div>
              </div>
              <div v-if="errorMessage" class="message error" role="alert">{{ errorMessage }}</div>
              <div v-if="successMessage" class="message success" role="status">{{ successMessage }}</div>
              <button type="submit" class="primary-button" :disabled="loading">{{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }} <span v-if="!loading">→</span><span v-else class="spinner"></span></button>
            </form>
            <div class="auth-switch">Chưa có tài khoản? <RouterLink to="/dang-ky">Tạo tài khoản →</RouterLink></div>
            <p class="privacy-note">♧ Thông tin của bạn được sử dụng để đăng nhập hệ thống.</p>
          </template>
          <section v-else class="user-result">
            <div class="success-mark">✓</div><p class="form-eyebrow">XÁC THỰC THÀNH CÔNG</p><h1>Xin chào!</h1><p class="auth-description">Bạn đã đăng nhập vào hệ thống AT-11.</p>
            <div class="account-info"><div class="info-row"><span>Họ tên</span><strong>{{ user.ho_ten || 'Chưa cập nhật' }}</strong></div><div class="info-row"><span>Email</span><strong>{{ user.email || email }}</strong></div><div class="info-row"><span>Vai trò</span><strong>{{ user.vai_tro || 'Người dùng' }}</strong></div></div>
            <div v-if="successMessage" class="message success" role="status">{{ successMessage }}</div><div v-if="errorMessage" class="message error" role="alert">{{ errorMessage }}</div>
            <button type="button" class="secondary-button" :disabled="logoutLoading" @click="handleLogout">{{ logoutLoading ? 'Đang đăng xuất...' : 'Đăng xuất' }}</button>
            <RouterLink class="continue-link" to="/">Tiếp tục khám phá →</RouterLink>
          </section>
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
  min-height: 620px;
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

.aside-content { max-width: 360px; margin: 42px 0; }
.eyebrow, .form-eyebrow { font-size: 10px; letter-spacing: 0.15em; font-weight: 800; }
.eyebrow { color: #c9dcff; }
.aside-content h2 { margin: 20px 0; font-size: clamp(32px, 3.5vw, 44px); line-height: 1.16; letter-spacing: -0.04em; }
.aside-content h2 span { color: #c5dcff; }
.aside-content > p { color: #e0eaff; font-size: 14px; line-height: 1.85; }
.aside-points { display: grid; gap: 13px; margin-top: 28px; font-size: 12px; }
.aside-points span { display: flex; align-items: center; gap: 10px; }
.aside-points i { width: 21px; height: 21px; display: grid; place-items: center; border: 1px solid #ffffff65; border-radius: 50%; font-style: normal; }
.aside-footer { margin: 0; color: #d2e0ff; font-size: 9px; letter-spacing: 0.12em; }

.auth-main { display: flex; flex-direction: column; justify-content: center; align-items: center; padding: clamp(28px, 5vw, 60px); background: transparent; }
.auth-card { width: min(100%, 390px); }

.heading-icon { width: 46px; height: 46px; display: grid; place-items: center; margin-bottom: 22px; border: 1px solid var(--color-border, #dce7ff); border-radius: 14px; background: var(--color-surface, #f0f5ff); color: var(--color-primary, #2864ed); font-size: 24px; }
:global([data-theme="dark"]) .heading-icon { background: rgba(37, 99, 235, 0.15); border-color: rgba(59, 130, 246, 0.3); color: #60a5fa; }

.form-eyebrow { margin: 0 0 9px; color: var(--color-primary, #3268e9); }
:global([data-theme="dark"]) .form-eyebrow { color: #60a5fa; }

.auth-card h1 { margin: 0; font-size: clamp(30px, 3vw, 36px); font-weight: 800; letter-spacing: -0.04em; color: var(--color-text, #172033); }
.auth-description { margin: 11px 0 28px; color: var(--color-text-muted, #69758a); font-size: 14px; line-height: 1.75; }

.auth-form { display: grid; gap: 19px; }
.form-group label { display: block; margin-bottom: 8px; color: var(--color-text, #263248); font-size: 13px; font-weight: 700; }

.input-wrap { height: 51px; display: flex; align-items: center; gap: 10px; padding: 0 13px; border: 1px solid var(--color-border, #dfe5ef); border-radius: 11px; background: var(--color-background, #fff); transition: border-color 0.2s, box-shadow 0.2s, background 0.2s; }
:global([data-theme="dark"]) .input-wrap { background: #1f2937; border-color: #374151; }
.input-wrap:focus-within { border-color: var(--color-primary, #3974f6); box-shadow: 0 0 0 4px rgba(57, 116, 246, 0.12); }
.field-icon { color: var(--color-text-muted, #8793a8); }
.input-wrap input { width: 100%; min-width: 0; height: 100%; border: 0; outline: 0; background: transparent; color: var(--color-text, #172033); font: inherit; font-size: 14px; }
.input-wrap input::placeholder { color: var(--color-text-muted, #9aa5b5); }

.password-toggle { padding: 5px 0; border: 0; background: transparent; color: var(--color-primary, #3268e9); font-size: 12px; font-weight: 700; cursor: pointer; }
:global([data-theme="dark"]) .password-toggle { color: #60a5fa; }

.primary-button, .secondary-button { width: 100%; min-height: 51px; display: flex; align-items: center; justify-content: center; gap: 10px; margin-top: 4px; padding: 12px 18px; border: 0; border-radius: 11px; font: inherit; font-size: 14px; font-weight: 750; cursor: pointer; }
.primary-button { color: white; background: linear-gradient(100deg, #2861ed, #3478f6); box-shadow: 0 8px 18px #2962ed35; transition: transform 0.18s, box-shadow 0.18s; }
.primary-button:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 12px 24px #2962ed45; }
.primary-button:disabled, .secondary-button:disabled { opacity: 0.65; cursor: not-allowed; }

.spinner { width: 16px; height: 16px; border: 2px solid #ffffff70; border-top-color: white; border-radius: 50%; animation: spin 0.7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.message { padding: 11px 13px; border: 1px solid; border-radius: 10px; font-size: 12px; line-height: 1.55; }
.message.error { color: #b42318; border-color: #f4c7c3; background: #fff5f4; }
:global([data-theme="dark"]) .message.error { color: #fca5a5; border-color: rgba(239, 68, 68, 0.4); background: rgba(239, 68, 68, 0.15); }
.message.success { color: #167647; border-color: #b8e5cc; background: #f0fbf5; }
:global([data-theme="dark"]) .message.success { color: #86efac; border-color: rgba(34, 197, 94, 0.4); background: rgba(34, 197, 94, 0.15); }

.auth-switch { margin-top: 25px; padding-top: 21px; border-top: 1px solid var(--color-border, #edf0f5); text-align: center; color: var(--color-text-muted, #6d788b); font-size: 13px; }
.auth-switch a, .continue-link { margin-left: 4px; color: var(--color-primary, #2864ed); text-decoration: none; font-weight: 750; }
:global([data-theme="dark"]) .auth-switch a, :global([data-theme="dark"]) .continue-link { color: #60a5fa; }
.auth-switch a:hover, .continue-link:hover { text-decoration: underline; }

.privacy-note { margin: 20px 0 0; text-align: center; color: var(--color-text-muted, #929bad); font-size: 11px; }
.main-footer { margin-top: 32px; color: var(--color-text-muted, #9aa3b2); text-align: center; font-size: 10px; }
.mobile-brand { display: none; }

.user-result { text-align: center; }
.success-mark { width: 56px; height: 56px; display: grid; place-items: center; margin: 0 auto 20px; border-radius: 50%; background: #eaf9f0; color: #16834b; font-size: 26px; font-weight: 800; }
:global([data-theme="dark"]) .success-mark { background: rgba(34, 197, 94, 0.2); color: #4ade80; }
.user-result .auth-description { margin-bottom: 22px; }

.account-info { margin: 22px 0; border: 1px solid var(--color-border, #e4e9f1); border-radius: 12px; overflow: hidden; text-align: left; background: var(--color-background, #fff); }
:global([data-theme="dark"]) .account-info { background: #1f2937; border-color: #374151; }

.info-row { display: flex; justify-content: space-between; gap: 16px; padding: 14px; border-bottom: 1px solid var(--color-border, #edf0f5); }
.info-row:last-child { border-bottom: 0; }
.info-row span { color: var(--color-text-muted, #778297); font-size: 12px; }
.info-row strong { max-width: 65%; overflow-wrap: anywhere; text-align: right; font-size: 13px; color: var(--color-text, #172033); }

.secondary-button { border: 1px solid var(--color-border, #dce3ee); background: var(--color-background, white); color: var(--color-text, #273248); }
:global([data-theme="dark"]) .secondary-button { background: #1f2937; border-color: #374151; color: #f9fafb; }

.continue-link { display: inline-block; margin-top: 20px; font-size: 13px; }

/* Responsive áp dụng chuẩn Tablet (< 1024px chuyển về 1 cột) */
@media(max-width: 1023px) {
  .auth-page { padding: 14px; min-height: calc(100vh - 56px); }
  .auth-layout { min-height: 0; grid-template-columns: 1fr; border-radius: 21px; }
  .auth-aside { display: none; }
  .auth-main { padding: 28px 23px 20px; }
  .mobile-brand { display: flex; align-items: center; gap: 10px; margin-bottom: 28px; }
  .mobile-brand .brand-mark { width: 35px; height: 35px; background: var(--color-surface, #edf3ff); box-shadow: none; }
  .auth-card { width: min(100%, 420px); }
  .main-footer { margin-top: 24px; }
}

@media(max-width:380px){.auth-main{padding:22px 16px 16px}.input-wrap{padding:0 10px}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important}}
</style>