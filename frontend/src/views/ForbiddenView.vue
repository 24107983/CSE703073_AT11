<template>
  <main class="page">
    <div class="container">
      <section class="forbidden-card">
        <div class="code">403</div>

        <h1>Không có quyền truy cập</h1>

        <p>
          Tài khoản hiện tại không có quyền truy cập trang quản trị.
        </p>

        <RouterLink to="/" class="back-button">
          Về trang chủ
        </RouterLink>
      </section>
    </div>
  </main>
</template>

<style scoped>
.page {
  padding: var(--space-12) 0;
}

.forbidden-card {
  max-width: 600px;
  margin: 0 auto;
  padding: var(--space-8);
  text-align: center;
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
}

.code {
  margin-bottom: var(--space-3);
  font-size: 56px;
  font-weight: 700;
  color: var(--color-danger);
}

.forbidden-card h1 {
  margin: 0 0 var(--space-3);
}

.forbidden-card p {
  margin: 0 0 var(--space-6);
  color: var(--color-text-muted);
}

.back-button {
  display: inline-block;
  padding: var(--space-3) var(--space-4);
  border-radius: var(--radius-md);
  background: var(--color-primary);
  color: white;
  text-decoration: none;
  font-weight: 600;
}
</style>