
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

const apiProxy = {
  '/api': {
    target: 'https://cse703073-backend.onrender.com',
    changeOrigin: true,
    secure: true
  }
}

export default defineConfig({
  plugins: [vue()],

  server: {
    host: '0.0.0.0',
    allowedHosts: ['cse703073-at11.onrender.com'],
    proxy: apiProxy
  },

  preview: {
    host: '0.0.0.0',
    allowedHosts: ['cse703073-at11.onrender.com'],
    proxy: apiProxy
  }
})
