
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'https://internationally-red-pipes-baseball.trycloudflare.com',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
