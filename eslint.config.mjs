export default [
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
    },
    rules: {
      // Per .agent/rules/github-script.instructions.md: Use core.* instead of console.*
      "no-console": "error",
    },
  },
];
