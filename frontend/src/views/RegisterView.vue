<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const fullName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')

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
    const response = await fetch(
      '/api/auth/register',
      {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json'
        },
        credentials: 'include',
        body: JSON.stringify({
          ho_ten: fullName.value,
          email: email.value,
          mat_khau: password.value
        })
      }
    )

    const result = await response.json().catch(() => ({}))

    if (!response.ok) {
      throw new Error(
        result.message || `HTTP ${response.status}`
      )
    }

    successMessage.value = 'Đăng ký thành công.'

    fullName.value = ''
    email.value = ''
    password.value = ''
    confirmPassword.value = ''

    setTimeout(() => {
      router.push('/dang-nhap')
    }, 1000)
  } catch (error) {
    console.error(error)

    errorMessage.value =
      error.message || 'Đăng ký thất bại.'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <main class="page">
    <div class="container">
      <section class="register-section">
        <div class="register-card">
          <h1>Đăng ký</h1>

          <p class="register-description">
            Tạo tài khoản để sử dụng hệ thống.
          </p>

          <form @submit.prevent="handleRegister">
            <div class="form-group">
              <label for="fullName">
                Họ và tên
              </label>

              <input
                id="fullName"
                v-model="fullName"
                type="text"
                placeholder="Nhập họ và tên"
                autocomplete="name"
                required
              />
            </div>

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

            <div class="form-group">
              <label for="password">
                Mật khẩu
              </label>

              <input
                id="password"
                v-model="password"
                type="password"
                placeholder="Nhập mật khẩu"
                autocomplete="new-password"
                required
              />
            </div>

            <div class="form-group">
              <label for="confirmPassword">
                Xác nhận mật khẩu
              </label>

              <input
                id="confirmPassword"
                v-model="confirmPassword"
                type="password"
                placeholder="Nhập lại mật khẩu"
                autocomplete="new-password"
                required
              />
            </div>

            <div
              v-if="errorMessage"
              class="message error"
            >
              {{ errorMessage }}
            </div>

            <div
              v-if="successMessage"
              class="message success"
            >
              {{ successMessage }}
            </div>

            <button
              type="submit"
              class="register-button"
              :disabled="loading"
            >
              {{
                loading
                  ? 'Đang đăng ký...'
                  : 'Đăng ký'
              }}
            </button>
          </form>

          <p class="login-link">
            Đã có tài khoản?

            <RouterLink to="/dang-nhap">
              Đăng nhập
            </RouterLink>
          </p>
          <p class="register-link">
  Chưa có tài khoản?

  <RouterLink to="/dang-ky">
    Đăng ký
  </RouterLink>
</p>
        </div>
      </section>
    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-12) 0;
}

.register-section {
  max-width: 480px;
  margin: 0 auto;
}

.register-card {
  padding: var(--space-8);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.register-card h1 {
  margin: 0 0 var(--space-3);
  font-size: var(--font-size-2xl);
}

.register-description {
  margin: 0 0 var(--space-8);
  color: var(--color-text-muted);
}

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

.register-button {
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

.register-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.message {
  margin-bottom: var(--space-4);
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
}

.message.error {
  color: var(--color-danger);
  border: 1px solid var(--color-danger);
}

.message.success {
  color: var(--color-secondary);
  border: 1px solid var(--color-secondary);
}

.login-link {
  margin: var(--space-6) 0 0;
  text-align: center;
  color: var(--color-text-muted);
}

.login-link a {
  color: var(--color-primary);
  font-weight: 600;
  text-decoration: none;
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
</style>