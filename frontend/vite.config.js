
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'https://posters-alignment-seven-berkeley.trycloudflare.com',
        changeOrigin: true,
        secure: false
      }
    }
  }
})
