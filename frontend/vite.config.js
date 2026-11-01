
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
  },

  preview: {
    host: '0.0.0.0',
    allowedHosts: ['cse703073-at11.onrender.com']
  }
})
