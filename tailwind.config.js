/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx,elm}"],
  theme: {
    colors: {
      //& Surface
      "surface-100": "hsla(var(--clr-surface-100-hsl) / <alpha-value>)",
      "surface-400": "hsla(var(--clr-surface-400-hsl) / <alpha-value>)",
      // & Brand
      "brand-400": "hsla(var(--clr-brand-400-hsl) / <alpha-value>)",
      "brand-500": "hsla(var(--clr-brand-500-hsl) / <alpha-value>)",
      "brand-800": "hsla(var(--clr-brand-800-hsl) / <alpha-value>)",
      // & Static
      "static-100": "hsla(var(--clr-static-100-hsl) / <alpha-value>)",
      "static-200": "hsla(var(--clr-static-200-hsl) / <alpha-value>)",
      "static-800": "hsla(var(--clr-static-800-hsl) / <alpha-value>)",
      // & Accent
      "accent-mango": "hsla(var(--clr-accent-mango-hsl) / <alpha-value>)",
      "accent-coral": "hsla(var(--clr-accent-coral-hsl) / <alpha-value>)",
      "accent-cyan": "hsla(var(--clr-accent-cyan-hsl) / <alpha-value>)",
    },
    fontSize: {
      00: "var(--fsf-00)",
      01: "var(--fsf-01)",
      02: "var(--fsf-02)",
      03: "var(--fsf-03)",
      04: "var(--fsf-04)",
      05: "var(--fsf-05)",
      06: "var(--fsf-06)",
      07: "var(--fsf-07)",
    },
    fontWeight: {
      100: 100,
      100: 100,
      200: 200,
      300: 300,
      400: 400,
      500: 500,
      600: 600,
      700: 700,
      800: 800,
      900: 900,
    },

    // extend: {},
  },
  plugins: [],
  corePlugins: {
    preflight: false,
  },
};
