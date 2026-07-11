# Fable 5 Plan — A Framework for Developing Trading Algos on Near-Autopilot

This folder is the **operating system** for a one-person algo-trading operation. Where the rest of this repo analyzes how Moon Dev works, this folder is the upgraded, opinionated system you actually run: a strategy factory where AI does ~90% of the work (research, coding, backtesting, robustness testing, reporting, monitoring) and you do the ~10% that must stay human — capital decisions and kill decisions.

**The core thesis:** individual strategies are disposable; the *factory* is the asset. Any single edge decays. A pipeline that reliably manufactures, validates, incubates, and retires edges — cheaply and in parallel — compounds forever. Everything in this folder is designed to make the marginal cost of testing one more idea as close to zero as possible, while making it *structurally impossible* to deploy an unvalidated idea with real size.

## Read in this order

1. **[01-principles.md](01-principles.md)** — the non-negotiable beliefs the whole system is built on: what an edge actually is, why expectancy and capacity matter more than win rate, why the multiple-testing problem is *the* silent killer of an AI-powered factory, and the portfolio-of-bots mindset.
2. **[02-tooling-stack.md](02-tooling-stack.md)** — the researched 2026 tool stack: which backtesting engines to use at which stage (vectorbt → backtesting.py / NautilusTrader), execution SDKs per venue (CCXT, Hyperliquid SDK, py-clob-client, Kalshi), data sources (free and paid), analytics, infra, and the AI layer.
3. **[03-pipeline.md](03-pipeline.md)** — the assembly line itself: 8 stages from idea intake to retirement, each with explicit entry criteria, exit criteria, numeric gates, and the artifact it must produce. This is the heart of the system.
4. **[04-autopilot-architecture.md](04-autopilot-architecture.md)** — how to make the pipeline run itself with Claude Code: repo layout, `CLAUDE.md`, five specialized subagents (Scout, Architect, Skeptic, Risk Officer, Ops), scheduled overnight research batches, the experiment registry, and the short list of decisions that stay human.
5. **[05-risk-and-portfolio.md](05-risk-and-portfolio.md)** — sizing (fractional Kelly with a hard cap), the scaling ladder, per-bot and portfolio-level kill switches, correlation limits, and automatic de-scaling on drawdown.
6. **[06-market-playbooks.md](06-market-playbooks.md)** — venue-specific playbooks: crypto perps (Hyperliquid), crypto spot, Polymarket, Kalshi — the edge families that actually exist in each, the data you need, the execution traps, and what's realistically backtestable vs. incubate-only.
7. **[07-templates/](07-templates/)** — the paperwork the factory runs on: strategy spec, robustness report, incubation scorecard, weekly ops review, experiment registry schema, subagent definitions, and a drop-in `CLAUDE.md` for your trading workspace.

## The operating loop, in one diagram

```
                        ┌─────────────────────────────────────────────┐
                        │              OVERNIGHT (AI, unattended)      │
                        │                                             │
  idea sources ──────►  │  S1 Intake → S2 Spec → S3 Coarse Screen     │
  (scanners, funding,   │        → S4 Realistic Backtest              │
   research feeds,      │        → S5 Robustness Gauntlet             │
   your own notes)      │                                             │
                        └───────────────────┬─────────────────────────┘
                                            │ morning report:
                                            │ ranked survivors + full audit trail
                                            ▼
                        ┌─────────────────────────────────────────────┐
                        │              HUMAN GATE (you, ~15 min/day)   │
                        │  approve → S6 Dry Run → S7 Incubate ($5-25) │
                        │  reject  → graveyard, with reason logged    │
                        └───────────────────┬─────────────────────────┘
                                            │ scorecard clears pre-written bar
                                            ▼
                        ┌─────────────────────────────────────────────┐
                        │              LIVE (AI-monitored)             │
                        │  S8 Scale ladder → steady state → retire    │
                        │  auto-descale on drawdown, kill on breach   │
                        └─────────────────────────────────────────────┘
```

## What "almost on autopilot" means here — precisely

Automated (AI/cron, no human in the loop):
- Idea generation, literature/data research, hypothesis writing
- All coding: backtests, live bots, monitoring, dashboards
- Running the coarse screen and the full robustness gauntlet
- Logging every experiment to the registry (this is what keeps the statistics honest)
- Live monitoring, alerting, log summarization, weekly review drafts
- Killing a bot that breaches its pre-written risk limits

Human-only (deliberately, forever):
1. **Capital gates** — approving any transition that increases real money at risk (start incubation, each rung of the scaling ladder).
2. **Kill/keep judgment calls** — when a bot is inside its limits but underperforming, the scorecard recommends and you decide.
3. **New-venue onboarding** — first connection of the system to any new exchange/market with real keys.
4. **Withdrawal/transfer of funds** — the AI never holds the ability to move money out of trading accounts.

That split is not a limitation to engineer away. It is the design. An AI that can research, build, and validate at near-zero marginal cost *and* deploy capital without a human gate is a machine for automating your own blowup.

## Relationship to the Moon Dev analysis in this repo

The RBI skeleton (Research → Backtest → Incubate) survives intact — it's correct. This plan upgrades it in five places where a solo trader with 2026 AI tooling can do materially better than the source material:

1. **A formal robustness gauntlet** (walk-forward, parameter-plateau, Monte Carlo, deflated Sharpe) replaces ad-hoc "robustness tests next" hand-waving — see `03-pipeline.md` Stage 5.
2. **An experiment registry that counts every trial**, because an AI that can run 500 backtests a night makes the multiple-testing problem 100x worse than it was for a human — see `01-principles.md` §4.
3. **Two-engine backtesting** (vectorized screen, then event-driven validation) instead of one engine for everything.
4. **Scheduled autonomy** — the factory runs nightly on cron, not when you feel like prompting — see `04-autopilot-architecture.md`.
5. **A portfolio layer** — correlation caps, risk budgets, and auto-descaling across the whole fleet of bots, not just per-bot stop-losses.

## Start here

```bash
# one-time setup
mkdir -p ~/trading-factory && cd ~/trading-factory
python3 -m venv .venv && source .venv/bin/activate
pip install vectorbt backtesting quantstats pandas numpy ccxt python-dotenv requests websockets

# copy the workspace skeleton
cp -r "path/to/this/repo/Fable 5 plan/07-templates" ./templates
cp ./templates/CLAUDE.md ./CLAUDE.md
mkdir -p ideas specs experiments strategies/{screening,validated,incubating,live,retired} registry ops
```

Then read `03-pipeline.md` end to end once, set up the subagents from `04-autopilot-architecture.md`, and feed the factory its first three ideas.
