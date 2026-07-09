# Algo Trading + AI Workspace

Built from a full transcript analysis of 10 videos (~7.5 hours) from the **Moon Dev** YouTube channel, an algo-trading creator who builds trading bots almost entirely by directing Claude Code. The channel turns out to have a genuinely repeatable system underneath the individual videos — this workspace extracts that system and turns it into something you can actually run yourself, not just read about.

## Read in this order

1. **[01-master-report.md](01-master-report.md)** — the full analysis: the RBI framework, his AI stack, how he actually prompts Claude Code, his validation thresholds, risk rules, workspace structure, deployment ritual, and philosophy. Read this once fully — everything else in this folder is built from it.
2. **[02-your-protocol.md](02-your-protocol.md)** — the same framework turned into a step-by-step procedure you run for every new trading idea: Research → Backtest → Incubate, with exit criteria for each stage.
3. **[03-workspace-setup.md](03-workspace-setup.md)** — one-time setup: accounts, folder structure, `CLAUDE.md`, Python environment. Do this before your first idea.
4. **[04-prompt-library.md](04-prompt-library.md)** — copy-paste prompt templates for every stage of the protocol, modeled directly on his verbatim prompting patterns (especially the parallel multi-agent dispatch pattern — the single highest-leverage habit in the whole system).
5. **[05-validation-and-risk-rules.md](05-validation-and-risk-rules.md)** — the concrete numeric bar a strategy has to clear before it gets real capital, and the risk rules that must be true before any capital at all.
6. **[06-pitfalls-checklist.md](06-pitfalls-checklist.md)** — specific mistakes called out across the videos, grouped by category (process, AI collaboration, data/validation, risk/execution).
7. **[07-source-video-notes/](07-source-video-notes/)** — per-video detailed extraction with timestamps, for when you want to go back to the primary source on a specific claim.

## Get started

```bash
bash templates/setup-workspace.sh ~/Documents/Projects/algo-trading
cd ~/Documents/Projects/algo-trading
python3 -m venv .venv && source .venv/bin/activate
pip install backtesting pandas numpy python-dotenv requests
```

Then open `02-your-protocol.md`, pick a trading idea you actually believe in, and start Stage 0.

## The one-paragraph version, if you read nothing else

His whole system is: **never build a bot before backtesting it, never trust a backtest without benchmarking it against buy-and-hold and stress-testing it at 3x fees, never risk more than trivial capital until it's proven itself live, and never talk to Claude Code as a one-shot code generator — talk to it as a collaborator you dispatch in parallel across multiple competing variants, whose output you verify rather than accept.** Everything in this folder is that idea made concrete and actionable.

## What this workspace deliberately does NOT give you

No specific trading strategy, no specific edge, no signal to copy. That's intentional and matches the source material's own repeated warning: "nothing is plug-and-play," edge decays the moment it's shared widely, and the value here is the *process*, not any one person's live parameters. Bring your own thesis.
