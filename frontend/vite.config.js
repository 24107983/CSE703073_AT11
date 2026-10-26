
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'https://dominant-enter-locked-trucks.trycloudflare.com',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
