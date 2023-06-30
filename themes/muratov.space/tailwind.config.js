const defaultTheme = require("tailwindcss/defaultTheme");

/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./layouts/**/*.html"],
  darkMode: "class",
  theme: {
    fontFamily: {
      sans: ["Poppins", ...defaultTheme.fontFamily.sans],
      serif: ["Lora", ...defaultTheme.fontFamily.serif],
      mono: ["IBM Plex Mono", ...defaultTheme.fontFamily.mono],
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
