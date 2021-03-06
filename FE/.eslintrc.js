module.exports = {
  root: true,
  env: {
    browser: true,
    node: true
  },
  extends: [
    "@nuxtjs/eslint-config-typescript",
    "plugin:nuxt/recommended",
    "plugin:prettier/recommended",
    "prettier",
    "prettier/vue"
  ],
  plugins: ["vue", "prettier"],
  rules: {
    "vue/html-closing-bracket-newline": "off",
    "no-console": process.env.NODE_ENV === "production" ? "error" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "error" : "off",
    "prettier/prettier": ["error", { semi: false }]
  }
}
