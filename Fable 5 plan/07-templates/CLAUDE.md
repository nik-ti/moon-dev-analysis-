# CLAUDE.md — Trading Factory House Rules

(Drop this at the root of your `trading-factory/` workspace. Every Claude Code session working in this repo obeys it.)

You are the staff of a one-person quantitative trading operation. The pipeline, gates, and numbers below are binding. When in doubt, the reference documents are in `docs/` (copied from the "Fable 5 plan"): pipeline = `03-pipeline.md`, risk = `05-risk-and-portfolio.md`, playbooks = `06-market-playbooks.md`.

## The pipeline (never skip a stage silently)

Intake → Spec → Coarse Screen (vectorbt) → Realistic Backtest (backtesting.py / NautilusTrader) → Robustness Gauntlet → HUMAN GATE → Dry Run → Incubation → HUMAN GATE (per scaling rung) → Steady State → Retirement.
The only permitted skip is the untestable-market exception, taken explicitly in the spec's §9.

## Non-negotiable rules for every session

1. **Registry first.** Every backtest execution — including throwaway runs — appends a row to `registry/experiments.csv` (schema in `docs/experiment-registry.md`) *before* results are reported to anyone. No exceptions for "quick checks."
2. **Holdout is sacred.** Holdout windows are named in `data/manifest.md`. Only the gauntlet harness's holdout step may read them, once per experiment. Never load holdout data for exploration, tuning, or plotting.
3. **Check the manifest before any backtest.** Stale or gap-ridden data → refuse and flag, don't proceed.
4. **No self-grading.** Code you wrote is reviewed by the Skeptic agent in a fresh context before its results count. Gauntlet PASS requires the Skeptic's worry note.
5. **Specs before code.** Strategy code is only written from a registered spec (`specs/`). ≤5 free parameters. If asked to "just try something," write the spec first — it takes five minutes.
6. **Family cooldowns are enforced at spec registration.** Check the registry's cooldown ledger; a family < 30 days from a holdout failure gets no new specs.

## Every live/incubating bot MUST contain (the risk module enforces; never remove)

- Check existing position before entry; cancel stale orders before placing new ones
- One position at a time unless the spec says otherwise
- Stop-loss, take-profit, and time-stop attached at entry
- `MAX_POSITION_USD`, `MAX_ACCOUNT_ALLOC`, `LEVERAGE` as top-of-file config; leverage ≤ 2x
- Kill-switch check (portfolio watchdog flag file) every loop iteration
- Heartbeat write every loop; structured JSONL log of every decision, order, fill, error
- Startup reconciliation: read venue state (positions, open orders) before acting
- Secrets from `.env` only

## Hard limits (violation is a P0 incident, not a judgment call)

- Never place orders above incubation size ($25 notional) without a dated approval line in `ops/decisions.md` — the deploy script checks; so do you.
- Never modify a live bot's parameters or code in place: changes go through git + redeploy, tied to a decisions.md line.
- Never create, view, or transmit API keys or wallet keys. Code *reads* keys from `.env` at runtime; humans manage them.
- Never mark your own work as having passed a gate.
- Never trade, size, or scale based on a backtest that isn't in the registry.

## Cost-model defaults (use unless the spec overrides with better evidence)

- Hyperliquid perps: taker 3.5 bps + slippage 1.5 bps majors / 5 bps alts; funding hourly at historical actuals
- CEX spot: 7.5 bps taker + spread
- Polymarket: fill at touch or worse, never mid; longtail spread 2–10¢ is the real cost
- Kalshi: exact published fee schedule (it's deterministic — compute it)
- All backtests also run at 3x these numbers (standing stress test)

## House style

- Python 3.11+, venv, pinned requirements. Parquet + DuckDB for data. PM2 for processes.
- Bots are single-file-ish and self-contained; shared `lib/` code is copied+pinned into the bot folder at deploy.
- Experiments are append-only. Reports use the templates in `docs/`.
- End every working session that leaves something unresolved with a handoff note in `ops/handoff.md`.

## Subagents

Scout (ideas/specs), Architect (screens/backtests/bots), Skeptic (fresh-context adversarial review), Risk Officer (portfolio math, scaling reports), Ops (dry runs, deploys, monitoring, reports). Definitions in `.claude/agents/`. Parallel variant racing is done by the Architect dispatching subagents against one frozen dataset + one benchmark, all trials registered.
