# Compound Engineering

**Parallel Claude Code workflow orchestrator for building features faster with multiple AI agents.**

Compound Engineering inverts traditional development (80% coding, 20% planning) to **80% planning/review, 20% execution** - resulting in higher quality code with fewer iterations.

## What It Does

Spins up a tmux session with 6 specialized Claude Code instances working in parallel:

| Window | Role | Responsibility |
|--------|------|----------------|
| 1 | **Orchestrator** | Interactive command center |
| 2 | **Planner** | Creates PLAN.md with architecture, tasks, contracts |
| 3 | **Backend** | Implements API, services, database code |
| 4 | **Frontend** | Implements React components, hooks, UI |
| 5 | **Tests** | Writes unit, integration, and E2E tests |
| 6 | **Reviewer** | Reviews all changes, runs tests, validates |

## The Workflow

```
Plan → Implement (parallel) → Review → Refine → Compound → PR
        ↑                                          ↓
        └──────────────────────────────────────────┘
                    (learnings feed back)
```

1. **Plan** - Architect designs the feature, creates task files
2. **Implement** - Backend, Frontend, Tests workers execute in parallel
3. **Review** - Reviewer runs tests, checks quality, gives PASS/FAIL
4. **Refine** - If FAIL, workers fix issues based on review
5. **Compound** - Extract learnings, document patterns
6. **PR** - Auto-commit and create pull request

## Features

- **Phase-based commits** - Auto-commits at each workflow phase with conventional commit messages
- **Automatic branch creation** - Creates `compound/YYYYMMDD-feature-slug` branches
- **Interactive orchestrator** - Real-time status display with keyboard controls
- **Signal-based coordination** - Workers communicate via `.workflow/signals/` files
- **Review gating** - Code must pass review before PR creation

## Requirements

- [Bun](https://bun.sh) runtime
- [tmux](https://github.com/tmux/tmux)
- [Claude Code](https://claude.com/code) CLI
- [GitHub CLI](https://cli.github.com) (for PR creation)
- Git

## Installation

### Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/compound-engineering/main/install.sh | bash
```

### Manual Install

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/compound-engineering.git
cd compound-engineering

# Make scripts executable
chmod +x orchestrate.ts compound-start.sh

# Optional: Add to PATH
echo 'export PATH="$PATH:$HOME/compound-engineering"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

### Starting a Session

```bash
# Navigate to your project
cd ~/my-project

# Start the compound engineering session
~/compound-engineering/compound-start.sh

# Or if added to PATH:
compound-start.sh
```

This creates a tmux session with all windows pre-configured.

### Orchestrator Commands

Once in the orchestrator (Window 1), use these keys:

| Key | Action |
|-----|--------|
| `P` | Plan approved → dispatch implementation workers |
| `R` | Dispatch review |
| `F` | Dispatch refine (after review FAIL) |
| `C` | Dispatch compound (after review PASS) |
| `G` | Push to remote and create PR |
| `K` | Manual commit checkpoint |
| `S` | Refresh status |
| `N` | Clear and start new feature |
| `Q` | Quit orchestrator |

### Tmux Navigation

```
Ctrl+b 1  → Orchestrator (command center)
Ctrl+b 2  → Plan window (architect)
Ctrl+b 3  → Backend window
Ctrl+b 4  → Frontend window
Ctrl+b 5  → Tests window
Ctrl+b 6  → Review window
Ctrl+b d  → Detach (session keeps running)
```

Re-attach: `tmux attach -t ce-dev`

## Workflow Directory Structure

The orchestrator creates a `.workflow/` directory in your project:

```
.workflow/
├── PLAN.md           # Feature plan (created by Planner)
├── REVIEW.md         # Review results (created by Reviewer)
├── contracts/        # Shared TypeScript interfaces
│   └── types.ts
├── tasks/            # Worker task files
│   ├── backend.md
│   ├── frontend.md
│   └── tests.md
├── signals/          # Coordination signals
│   ├── plan.done
│   ├── backend.done
│   ├── frontend.done
│   └── tests.done
└── state.json        # Current workflow state
```

**Note:** `.workflow/` is excluded from git commits.

## Commit Flow

Commits happen automatically at workflow phase transitions:

```
Planning Complete  →  docs(plan): {feature-name}
                      + Creates branch: compound/YYYYMMDD-{slug}

Implementation Complete  →  feat: {feature-name}

Refine Complete  →  fix: review feedback for {feature-name}
(repeats if multiple cycles)
```

## Templates

The `templates/` directory contains example files:

- `PLAN-example.md` - Example plan document
- `task-file.md` - Template for worker task files

## Philosophy

Traditional development accumulates technical debt. Compound engineering inverts this:

| Traditional | Compound |
|-------------|----------|
| Code first, plan later | Plan thoroughly, code efficiently |
| Review as formality | Review as quality gate |
| Knowledge in heads | Knowledge in documentation |
| Each feature harder | Each feature easier |

## Troubleshooting

### Session already exists
```bash
tmux kill-session -t ce-dev
```

### Workers not responding
Check if Claude is running in each window. Re-dispatch with the appropriate key (`P`, `R`, `F`).

### Git errors on PR creation
Ensure you have:
- GitHub CLI authenticated: `gh auth login`
- Remote configured: `git remote -v`
- Commits to push: `git log main..HEAD`

## License

MIT
