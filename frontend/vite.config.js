
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'https://hardly-angeles-ears-rebecca.trycloudflare.com',
        changeOrigin: true,
        secure: false
      }
    }
  },
  preview: {
    allowedHosts: ['cse703073-at11.onrender.com']
  }
})
