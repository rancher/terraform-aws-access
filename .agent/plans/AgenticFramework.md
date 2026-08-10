# Specification: Agentic Programming Framework

**Executed Date:** pending
**Amended Date:** 2026-08-06
**Purpose:** Define the authoritative architecture, routing, configurations, and scripts for the cross-platform AI agentic framework within this repository.

This specification serves as the long-lived architectural blueprint for maintaining a unified environment where multiple AI platforms (GitHub Copilot, Claude, and Gemini) share a single set of operational instructions, coding standards, and tooling skills.

---

## 1. Core Architecture & Routing

To prevent configuration drift and fragmented behavior across different IDE assistants, the repository implements a strict **single source of truth** pattern. All entry point files redirect the AI assistant to the master instructions file (`AGENTS.md`) at the repository root.

```
       [ Gemini ]       [ Claude ]       [ GitHub Copilot ]
           │                │                    │
           ▼                ▼                    ▼
      [ GEMINI.md ]    [ CLAUDE.md ]   [ .github/copilot-instructions.md ]
           │                │                    │
           └────────────────┼────────────────────┘
                            │ (Redirects to)
                            ▼
                      [ AGENTS.md ]
                            │
               ┌────────────┴────────────┐
               ▼                         ▼
      [ .agent/rules/ ]         [ .agent/skills/ ]
      Language Standards        Operational Scripts
```

### 1.1 Entry Point Definitions

*   **`GEMINI.md`**: Directs Gemini CLI to the root `AGENTS.md`.
*   **`CLAUDE.md`**: Configures Claude's system prompts to prioritize `AGENTS.md`.
*   **`.github/copilot-instructions.md`**: Directs GitHub Copilot's repository indexer to adhere to the standards in `AGENTS.md`.

### 1.2 The Master Instructions File (`AGENTS.md`)

Located at the repository root, `AGENTS.md` is the absolute source of truth. It defines:
1.  **Environment Directives**: The system configuration and toolchains (e.g., Nix shell, path resolution, test harnesses).
2.  **Agent Personas**: The behavior, skepticism levels, and communication styles tailored to each platform.
3.  **Planning Protocols**: Mandatory planning requirements for all development sessions.
4.  **Directory Mapping**: Rules for resolving subdirectories under the `.agent/` folder.
5.  **Language Standards**: Exact file path mappings to specialized rules files (e.g., Go, Terraform, Shell).

---

## 2. Directory Structure Mapping

All agentic capabilities, standards, scripts, and logs are housed in the root `.agent/` directory, structured as follows:

*   **`rules/`**: Language-specific and tool-specific coding standards (e.g., `go.instructions.md`, `terraform.instructions.md`).
*   **`skills/`**: Executable helper scripts that extend agent capabilities (e.g., git synchronization, log fetching, PR creation).
*   **`workflows/`**: Strict step-by-step procedures for complex tasks (e.g., standard development cycle, troubleshooting CI/CD).
*   **`plans/`**: Long-lived architectural specifications and active development plans (such as this document).
*   **`output-styles/`**: Guidelines for formatting agent responses.
*   **`agent-memory/`**: Persistent notes and workspace-specific learnings.
*   **`hooks/`**: Execution interceptors and security policies (e.g., blocking unauthorized remote pushes, enforcing planning-first rules).

---

## 3. Tooling & Scripting Specifications (`.agent/skills/`)

All custom scripts inside `.agent/skills/` are designed to be environment-aware and robust. They MUST comply with the following standards:

### 3.1 Default Repository References
To prevent operational errors, every script that targets a GitHub repository must dynamically detect the local repository's name from git remote configurations (`origin` or `upstream`). If detection fails, the default fallback must be the active repository: `rancher/terraform-aws-access`.

Specific defaults:
1.  **`pull-ci-logs.sh`**: Fetches GitHub Actions logs. Default repository: `rancher/terraform-aws-access`.
2.  **`create-pr.sh`**: Submits a Pull Request. Default upstream target repository: `rancher/terraform-aws-access`.
3.  **`get-pr-comments.sh`**: Retrieves PR discussions. Default target repository fallback: `rancher/terraform-aws-access`.

### 3.2 Script Quality and Safety
*   Must use `set -euo pipefail` for strict error handling.
*   Must be validated by `shellcheck` to ensure no syntax or formatting issues.
*   Must be marked executable (`chmod +x`).

---

## 4. Execution Hooks & Security Policies (`.agent/hooks/`)

To guarantee strict compliance with workspace security directives and the standard development process, the framework utilizes execution interceptors/hooks:

*   **`block-rancher-git.js`**: Intercepts git commands; blocks remote-interacting operations (push/pull/fetch) targeting upstream Rancher-owned remotes to prevent accidental leaks or direct changes on canonical branches.
*   **`check-context.sh`**: Monitored context threshold controller; prevents token accumulation beyond safe limits (e.g., 200,000 tokens) to preserve slot context performance.
*   **`enforce-planning.js`**: Enforces the "plan-first" protocol by blocking file-modifying tools (like `write_file` or `replace` on non-agent configurations) unless an active/modified plan file under `.agent/plans/` is staged or tracked in git status.
*   **`startup-context.sh`**: Session initializer; automatically compiles and injects system mandates (`AGENTS.md` and `development-process.md`) directly into the agent's startup context.

---

## Implementation Checklist

### Phase 1: File Verification & Original Setup (Completed)
- [x] Create entry point files (`GEMINI.md`, `CLAUDE.md`, `.github/copilot-instructions.md`).
- [x] Establish the root `AGENTS.md` master instructions.
- [x] Scaffold `.agent/` subdirectories (`rules/`, `skills/`, `workflows/`, `plans/`, `output-styles/`, `agent-memory/`, `hooks/`).
- [x] Grant execution permissions (+x) to original scripts.
- [x] Run `shellcheck` and project-wide spell checks.

### Phase 2: Repository Reference Alignment (Active)
- [x] Correct hardcoded repository references in `CLAUDE.md`.
- [x] Align default fallback repository in `.agent/skills/pull-ci-logs.sh` to `rancher/terraform-aws-access`.
- [x] Align default fallback repository in `.agent/skills/create-pr.sh` to `rancher/terraform-aws-access`.
- [x] Align default fallback repository in `.agent/skills/get-pr-comments.sh` to `rancher/terraform-aws-access`.
- [x] Run `shellcheck` on all modified scripts to verify quality and formatting.

### Phase 3: Verification & Developer Review Gateway
- [x] Verify script syntax/execution with a local syntax check or dry run.
- [ ] Present the final unstaged diff to the developer in the chat for direct IDE review.
- [x] Sync local branch with upstream `main` using `git-sync.sh`.
- [ ] Commit the changes using a non-bumping conventional type (e.g., `ci: align copied agentic script default repos`).
- [ ] Generate a Draft PR on GitHub using `.agent/skills/create-pr.sh --draft` and notify the developer.
