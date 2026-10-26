<script setup>
import AppHeader from './components/AppHeader.vue'
import AppFooter from './components/AppFooter.vue'
</script>

<template>
  <div class="app">
    <!-- Header của bạn -->
    <AppHeader />

    <!-- Nội dung thay đổi theo đường dẫn (Router) -->
    <main class="main-content">
      <RouterView />
    </main>

    <!-- Footer dùng chung cho mọi trang -->
    <AppFooter />
  </div>
</template>

<style>
.app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
}
</style>