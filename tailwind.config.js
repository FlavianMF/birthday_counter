/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,html}',
    './app/components/**/*.{erb,html}'
  ],
  theme: {
    extend: {
      colors: {
        // Modern Festive Dark Theme
        background: '#0F172A', // Slate 950
        surface: 'rgba(30, 41, 59, 0.7)', // Slate 800 with transparency
        primary: {
          DEFAULT: '#8B5CF6', // Violet 500
          hover: '#7C3AED', // Violet 600
          glow: 'rgba(139, 92, 246, 0.5)'
        },
        secondary: {
          DEFAULT: '#F59E0B', // Amber 500
          hover: '#D97706', // Amber 600
          glow: 'rgba(245, 158, 11, 0.5)'
        },
        accent: {
          DEFAULT: '#EF4444', // Red 500
          hover: '#DC2626', // Red 600
        },
        success: '#10B981', // Emerald 500
        info: '#3B82F6', // Blue 500
        fuchsia: {
          DEFAULT: '#D946EF', // Fuchsia 500
          glow: 'rgba(217, 70, 239, 0.5)'
        },
        cyan: {
          DEFAULT: '#06B6D4',
          glow: 'rgba(6, 182, 212, 0.5)'
        }
      },
      fontFamily: {
        heading: ['Montserrat', 'Inter', 'system-ui', 'sans-serif'],
        body: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      backgroundImage: {
        'gradient-primary': 'linear-gradient(to right, #8B5CF6, #D946EF)',
        'gradient-secondary': 'linear-gradient(to right, #F59E0B, #F97316)',
        'gradient-dark': 'linear-gradient(to bottom, #0F172A, #1E293B)',
        'gradient-radial': 'radial-gradient(circle at center, var(--tw-gradient-stops))',
      },
      animation: {
        'fade-in': 'fadeIn 0.3s ease-in-out',
        'slide-up': 'slideUp 0.4s ease-out',
        'slide-down': 'slideDown 0.4s ease-out',
        'slide-right': 'slideRight 0.4s ease-out',
        'pulse-glow': 'pulseGlow 2s infinite',
        'bounce-slow': 'bounce 3s infinite',
        'float': 'float 3s ease-in-out infinite',
        'float-delayed': 'float 3s ease-in-out 1.5s infinite',
        'spin-slow': 'spin 3s linear infinite',
        'ping-slow': 'ping 2s cubic-bezier(0, 0, 0.2, 1) infinite',
        'scale-in': 'scaleIn 0.3s ease-out',
        'shimmer': 'shimmer 2s linear infinite',
        'gradient': 'gradient 8s ease infinite',
        'blob': 'blob 7s infinite',
        'bounce-soft': 'bounceSoft 2s infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        slideRight: {
          '0%': { transform: 'translateX(-20px)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        },
        pulseGlow: {
          '0%, 100%': { boxShadow: '0 0 20px rgba(139, 92, 246, 0.5)' },
          '50%': { boxShadow: '0 0 40px rgba(139, 92, 246, 0.8)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.9)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
        gradient: {
          '0%, 100%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' },
        },
        blob: {
          '0%': { transform: 'translate(0px, 0px) scale(1)' },
          '33%': { transform: 'translate(30px, -50px) scale(1.1)' },
          '66%': { transform: 'translate(-20px, 20px) scale(0.9)' },
          '100%': { transform: 'translate(0px, 0px) scale(1)' },
        },
        bounceSoft: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-5px)' },
        },
      },
      borderRadius: {
        '4xl': '2.5rem',
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
        '128': '32rem',
      },
    },
  },
  plugins: [],
}
