<script setup>
import { ref } from 'vue'

const email = ref('')
const password = ref('')

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
    const response = await fetch('/api/auth/login',
      {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'include',
        body: JSON.stringify({
          email: email.value,
          mat_khau: password.value
        })
      }
    )

    const result = await response.json()

    if (!response.ok) {
      throw new Error(
        result.message || `HTTP ${response.status}`
      )
    }

    user.value = result.data

localStorage.setItem(
  'auth_user',
  JSON.stringify(result.data)
)
window.dispatchEvent(
  new Event('auth-changed')
)

successMessage.value = 'Đăng nhập thành công.'
  } catch (error) {
    console.error(error)
    errorMessage.value =
      error.message || 'Đăng nhập thất bại.'
  } finally {
    loading.value = false
  }
}

const handleLogout = async () => {
  logoutLoading.value = true
  errorMessage.value = ''
  successMessage.value = ''

  try {
    const response = await fetch(
      '/api/auth/logout',
      {
        method: 'POST',
        headers: {
          Accept: 'application/json'
        },
        credentials: 'include'
      }
    )

    if (!response.ok && response.status !== 204) {
      const result = await response.json().catch(() => ({}))

      throw new Error(
        result.message || `HTTP ${response.status}`
      )
    }

    user.value = null
    email.value = ''
    password.value = ''

    successMessage.value = 'Đã đăng xuất.'
  } catch (error) {
    console.error(error)
    errorMessage.value =
      error.message || 'Đăng xuất thất bại.'
  } finally {
    logoutLoading.value = false
  }
}
</script>

<template>
  <main class="page">
    <div class="container">

      <section class="login-section">

        <div class="login-card">

          <h1>Đăng nhập</h1>

          <p class="login-description">
            Đăng nhập vào hệ thống để sử dụng các chức năng.
          </p>

          <!-- FORM ĐĂNG NHẬP -->
          <form
            v-if="!user"
            @submit.prevent="handleLogin"
          >

            <!-- Email -->
            <div class="form-group">
              <label for="email">
                Email
              </label>

              <input
                id="email"
                v-model="email"
                type="email"
                placeholder="Nhập email"
                autocomplete="email"
                required
              />
            </div>

            <!-- Mật khẩu -->
            <div class="form-group">
              <label for="password">
                Mật khẩu
              </label>

              <input
                id="password"
                v-model="password"
                type="password"
                placeholder="Nhập mật khẩu"
                autocomplete="current-password"
                required
              />
            </div>

            <!-- Lỗi -->
            <div
              v-if="errorMessage"
              class="message error"
            >
              {{ errorMessage }}
            </div>

            <!-- Thành công -->
            <div
              v-if="successMessage"
              class="message success"
            >
              {{ successMessage }}
            </div>

            <!-- Nút đăng nhập -->
            <button
              type="submit"
              class="login-button"
              :disabled="loading"
            >
              {{ loading ? 'Đang đăng nhập...' : 'Đăng nhập' }}
            </button>
            <p class="register-link">
  Chưa có tài khoản?

  <RouterLink to="/dang-ky">
    Đăng ký
  </RouterLink>
</p>

          </form>

          <!-- THÔNG TIN TÀI KHOẢN -->
          <div
            v-if="user"
            class="user-result"
          >

            <div class="account-header">
              <div class="account-icon">
                ✓
              </div>

              <div>
                <h2>Đăng nhập thành công</h2>

                <p>
                  Thông tin tài khoản
                </p>
              </div>
            </div>

            <div class="account-info">

              <div class="info-row">
                <span>Họ tên</span>
                <strong>{{ user.ho_ten }}</strong>
              </div>

              <div class="info-row">
                <span>Email</span>
                <strong>{{ user.email }}</strong>
              </div>

              <div class="info-row">
                <span>Vai trò</span>
                <strong>{{ user.vai_tro }}</strong>
              </div>

            </div>

            <!-- Thông báo -->
            <div
              v-if="successMessage"
              class="message success"
            >
              {{ successMessage }}
            </div>

            <div
              v-if="errorMessage"
              class="message error"
            >
              {{ errorMessage }}
            </div>

            <!-- NÚT ĐĂNG XUẤT -->
            <button
              type="button"
              class="logout-button"
              :disabled="logoutLoading"
              @click="handleLogout"
            >
              {{
                logoutLoading
                  ? 'Đang đăng xuất...'
                  : 'Đăng xuất'
              }}
            </button>

          </div>

        </div>

      </section>

    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-12) 0;
}

.login-section {
  max-width: 480px;
  margin: 0 auto;
}

.login-card {
  padding: var(--space-8);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.login-card h1 {
  margin: 0 0 var(--space-3);
  font-size: var(--font-size-2xl);
}

.login-description {
  margin: 0 0 var(--space-8);
  color: var(--color-text-muted);
}

/* FORM */

.form-group {
  margin-bottom: var(--space-5);
}

.form-group label {
  display: block;
  margin-bottom: var(--space-2);
  font-weight: 500;
}

.form-group input {
  width: 100%;
  box-sizing: border-box;
  padding: var(--space-3) var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
}

.form-group input:focus {
  outline: 2px solid var(--color-primary);
  outline-offset: 1px;
}

/* LOGIN BUTTON */

.login-button {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  border: none;
  border-radius: var(--radius-md);
  background: var(--color-primary);
  color: white;
  font: inherit;
  font-weight: 600;
  cursor: pointer;
}

.login-button:hover {
  opacity: 0.92;
}

.login-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* MESSAGE */

.message {
  margin-bottom: var(--space-4);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
}

.message.error {
  color: var(--color-danger);
  border: 1px solid var(--color-danger);
  background: var(--color-background);
}

.message.success {
  color: var(--color-secondary);
  border: 1px solid var(--color-secondary);
  background: var(--color-background);
}

/* ACCOUNT */

.user-result {
  margin-top: var(--space-6);
  padding-top: var(--space-6);
  border-top: 1px solid var(--color-border);
}

.account-header {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  margin-bottom: var(--space-6);
}

.account-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  flex-shrink: 0;
  border-radius: 9999px;
  background: var(--color-secondary);
  color: white;
  font-weight: 700;
}

.account-header h2 {
  margin: 0;
  font-size: var(--font-size-lg);
}

.account-header p {
  margin: 4px 0 0;
  color: var(--color-text-muted);
  font-size: 14px;
}

.account-info {
  margin-bottom: var(--space-6);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
}

.info-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-4);
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-border);
}

.info-row:last-child {
  border-bottom: none;
}

.info-row span {
  color: var(--color-text-muted);
  font-size: 14px;
}

.info-row strong {
  text-align: right;
  font-size: 14px;
  word-break: break-word;
}

/* LOGOUT */

.logout-button {
  width: 100%;
  padding: var(--space-3) var(--space-4);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: var(--color-background);
  color: var(--color-text);
  font: inherit;
  font-weight: 600;
  cursor: pointer;
}

.logout-button:hover {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.logout-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* MOBILE */

@media (max-width: 639px) {
  .page {
    padding: var(--space-8) 0;
  }

  .login-card {
    padding: var(--space-6);
  }

  .info-row {
    align-items: flex-start;
    flex-direction: column;
    gap: 4px;
  }

  .info-row strong {
    text-align: left;
  }
}
.register-link {
  margin: var(--space-6) 0 0;
  text-align: center;
  color: var(--color-text-muted);
}

.register-link a {
  color: var(--color-primary);
  font-weight: 600;
  text-decoration: none;
}

.register-link a:hover {
  text-decoration: underline;
}
</style>