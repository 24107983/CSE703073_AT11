<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const user = ref(null)

const loadUser = () => {
  const savedUser = localStorage.getItem('auth_user')

  user.value = savedUser
    ? JSON.parse(savedUser)
    : null
}

const handleAuthChange = () => {
  loadUser()
}

const handleLogout = async () => {
  try {
    const response = await fetch(
      'http://10.240.223.32:8000/api/auth/logout',
      {
        method: 'POST',
        headers: {
          Accept: 'application/json'
        },
        credentials: 'include'
      }
    )

    if (!response.ok && response.status !== 204) {
      throw new Error(`HTTP ${response.status}`)
    }
  } catch (error) {
    console.error(error)
  } finally {
    localStorage.removeItem('auth_user')

    window.dispatchEvent(
      new Event('auth-changed')
    )

    router.push('/dang-nhap')
  }
}

onMounted(() => {
  loadUser()

  window.addEventListener(
    'auth-changed',
    handleAuthChange
  )
})

onUnmounted(() => {
  window.removeEventListener(
    'auth-changed',
    handleAuthChange
  )
})
</script>

<template>
  <header class="site-header">
    <div class="container header-inner">

      <div class="logo">
        AT-11
      </div>

      <nav class="main-nav">
        <RouterLink to="/">
          Trang chủ
        </RouterLink>

        <RouterLink to="/mon-an">
          Món ăn
        </RouterLink>

        <RouterLink to="/ban-do">
          Bản đồ
        </RouterLink>

        <RouterLink to="/hanh-trinh">
          Hành trình ẩm thực
        </RouterLink>
      </nav>

      <!-- CHƯA ĐĂNG NHẬP -->
      <div
        v-if="!user"
        class="auth-actions"
      >
        <RouterLink
          to="/dang-ky"
          class="auth-link"
        >
          Đăng ký
        </RouterLink>

        <RouterLink
          to="/dang-nhap"
          class="auth-link"
        >
          Đăng nhập
        </RouterLink>
      </div>

      <!-- ĐÃ ĐĂNG NHẬP -->
      <div
        v-else
        class="auth-actions"
      >
        <button
          type="button"
          class="auth-link logout-button"
          @click="handleLogout"
        >
          Đăng xuất
        </button>
      </div>

    </div>
  </header>
</template>

<style scoped>
.site-header {
  border-bottom: 1px solid var(--color-border);
  background: var(--color-background);
}

.container {
  width: min(
    var(--container-max-width),
    calc(100% - (var(--space-4) * 2))
  );

  margin: 0 auto;
}

.header-inner {
  min-height: 72px;
  display: flex;
  align-items: center;
  gap: var(--space-8);
}

.logo {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-bold);
  color: var(--color-primary);
  white-space: nowrap;
}

.main-nav {
  display: flex;
  align-items: center;
  gap: 24px;
  flex: 1;
}

.main-nav a {
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-medium);
  text-decoration: none;
  color: var(--color-text);
}

.main-nav a:hover {
  color: var(--color-primary);
}

.auth-actions {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  margin-left: auto;
}

.auth-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;

  padding: var(--space-2) var(--space-4);

  border: 1px solid var(--color-primary);
  border-radius: var(--radius-md);

  background: transparent;
  color: var(--color-primary);

  font: inherit;
  font-weight: var(--font-weight-medium);
  text-decoration: none;

  cursor: pointer;
}

.auth-link:hover {
  background: var(--color-primary);
  color: white;
}

.logout-button {
  appearance: none;
}

@media (max-width: 639px) {
  .header-inner {
    min-height: auto;
    padding: var(--space-4) 0;
    flex-wrap: wrap;
    gap: var(--space-4);
  }

  .main-nav {
    order: 3;
    width: 100%;
    overflow-x: auto;
    gap: var(--space-4);
  }

  .auth-actions {
    margin-left: auto;
  }
}
</style>