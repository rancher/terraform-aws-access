# Plan: Fix Agentic Hook Linter Configuration

- **Executed Date:** pending
- **Purpose:** Resolve the ESLint `no-console` violation errors triggered by local NodeJS hook scripts (`.agent/hooks/*.js`) and ensure shellcheck excludes JS/MD files.

## Detailed Architectural Blueprint & Spec

Local hooks in our agentic framework (e.g., `block-rancher-git.js` and `enforce-planning.js`) run locally on NodeJS and communicate with the host process via stdout/stderr (e.g. JSON-formatted decisions). These scripts must use `console.log` and `console.error` to perform their duties. They do not run in the GitHub Actions runner context, so they do not have `@actions/core` available.

However, scripts in `.github/workflows/scripts/**/*.js` execute as part of GitHub Actions workflows, where `@actions/core` is available, and `core.info` or `core.error` should be used instead of `console.*` to conform to logging standards.

To support this architectural boundary:
1. **General/GitHub Scripts:** Maintain `"no-console": "error"` as per our `.agent/rules/github-script.instructions.md` rules.
2. **Local Hook Scripts (`.agent/hooks/**/*.js`):** Add an override config block in the ESLint flat config (`eslint.config.mjs`) to set `"no-console": "off"`.

Additionally, we must ensure that our custom `shellcheck` scanner doesn't mistakenly inspect `.js` or `.md` files that have `#!` shebangs. The fix already exists in the working tree within `.github/workflows/scripts/shellcheck.sh` and will be validated as part of this plan.

## Implementation Checklist

### Phase 1: Local Reproduction & Verification
- [x] Run `eslint .` to reproduce the baseline console errors.
- [x] Verify the `shellcheck` issue and the existing unstaged fix in `.github/workflows/scripts/shellcheck.sh`.

### Phase 2: Modify ESLint Flat Configuration
- [x] Edit `eslint.config.mjs` to add an override section turning off `"no-console"` for `.agent/hooks/**/*.js`.

### Phase 3: Static Analysis & Validation
- [x] Run `eslint .` locally to ensure 0 errors.
- [x] Run `.github/workflows/scripts/shellcheck.sh` locally to ensure no JS/MD files are incorrectly scanned or failing.

### Phase 4: Proactive Code Review & Quality Gate
- [x] Perform a proactive code review of the unstaged diff using local guidelines (`github-copilot-review.instructions.md`).

### Phase 5: Upstream Sync & Developer Review Gateway
- [x] Synchronize with the upstream remote to ensure there are no branch conflicts.
- [x] Present the unstaged diff to the developer for IDE review.

### Phase 6: Authorized Commit & Push Gateway
- [ ] Receive explicit developer approval to stage and commit.
- [ ] Stage and commit the files.
- [ ] Push the commit to the remote repository.
