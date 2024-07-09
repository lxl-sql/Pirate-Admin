/** @type {import('tailwindcss').Config} */
import plugin from "tailwindcss/plugin";
import defaultTheme from 'tailwindcss/defaultTheme'

export default {
  content: [
    "./index.html",
    './src/**/*.{vue,js,ts,jsx,tsx,html}'
  ],
  theme: {
    extend: {
      zIndex: {
        1: '1'
      },
      maxHeight: {
        '65vh': '65vh'
      }
    },
    screens: {
      ...defaultTheme.screens,
      xs: '480px',
      sm: '576px',
      md: '768px',
      lg: '1024px',
      xl: '1280px',
      "2xl": '1536px',
    }
  },
  corePlugins: {
    preflight: false, // 删除默认样式
  },
  plugins: [
    plugin(function ({addUtilities}) {
      addUtilities({
        '.rotate-x-20': {transform: 'rotateX(20deg)',},
        '.rotate-x-180': {transform: 'rotateX(180deg)',},
        '.style-preserve-3d': {transformStyle: 'preserve-3d'}, // 3d 旋转风格
      })
    })
  ],
}
