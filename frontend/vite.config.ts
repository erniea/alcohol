import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    // 개발 중 CORS 우회: /api → 실제 백엔드로 프록시
    proxy: {
      '/api': {
        target: 'https://alcohol.bada.works',
        changeOrigin: true,
        secure: true,
      },
    },
  },
})
