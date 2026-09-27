<script setup>
import { computed } from 'vue'

const authUser = computed(() => {
  const user = localStorage.getItem('auth_user')

  return user ? JSON.parse(user) : null
})
</script>

<template>
  <main class="page">
    <div class="container">
      <section
        v-if="authUser?.vai_tro === 'quan_tri_vien'"
        class="admin-card"
      >
        <span class="admin-badge">ADMIN</span>

        <h1>Trang quản trị</h1>

        <p>
          Xin chào, {{ authUser.ho_ten }}.
        </p>

        <p>
          Vai trò:
          <strong>{{ authUser.vai_tro }}</strong>
        </p>

        <div class="admin-placeholder">
          Khu vực quản trị dữ liệu món ăn
        </div>
      </section>

      <section
        v-else
        class="forbidden-card"
      >
        <div class="forbidden-code">403</div>

        <h1>Không có quyền truy cập</h1>

        <p>
          Tài khoản hiện tại không có quyền truy cập trang quản trị.
        </p>

        <p v-if="authUser">
          Vai trò hiện tại:
          <strong>{{ authUser.vai_tro }}</strong>
        </p>
      </section>
    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-12) 0;
}

.admin-card,
.forbidden-card {
  max-width: 720px;
  margin: 0 auto;
  padding: var(--space-8);
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.admin-badge {
  display: inline-block;
  margin-bottom: var(--space-4);
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-md);
  background: var(--color-primary);
  color: white;
  font-size: var(--font-size-sm);
  font-weight: 700;
}

.admin-card h1,
.forbidden-card h1 {
  margin: 0 0 var(--space-3);
}

.admin-placeholder {
  margin-top: var(--space-6);
  padding: var(--space-6);
  border: 1px dashed var(--color-border);
  border-radius: var(--radius-md);
  color: var(--color-text-muted);
}

.forbidden-card {
  text-align: center;
}

.forbidden-code {
  margin-bottom: var(--space-3);
  font-size: 48px;
  font-weight: 700;
  color: var(--color-danger);
}
</style>