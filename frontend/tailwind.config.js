/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        cine: {
          dark: '#0f172a',
          darker: '#020617',
          gold: '#fbbf24',
          panel: '#1e293b'
        }
      }
    },
  },
  plugins: [],
}
