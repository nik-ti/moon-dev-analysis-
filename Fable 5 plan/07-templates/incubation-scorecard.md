# Incubation Scorecard — <bot> (EXP-YYYYMMDD-NN)

## Pre-registration (write BEFORE the first live order; this section is immutable once trading starts)

- **Start date:** · **Size:** $___ notional · **Sub-account/wallet:**
- **Duration:** ___ weeks AND ≥ ___ trades, whichever is later (default 4–8w/30; untestable-exception: 2x/50)
- **Pass bar (binding):**
  - Zero unresolved execution bugs
  - Realized cost per trade ≤ 1.5 × modeled ($___ modeled)
  - Signal-match ≥ 95% (live actions vs backtest logic replayed on same data)
  - Cumulative live P&L above Monte Carlo 10th percentile for the same trade count
- **Early-kill triggers:** duplicate/unintended order · position without stop · drawdown > $___ · silent failure > ___h
- **Human approval line in `ops/decisions.md`:** <date, quote>

## Weekly log (Ops fills)

| Week | Trades | P&L | Realized cost/trade (vs model) | Signal-match | Bugs/incidents | Notes |
|---|---|---|---|---|---|---|
| 1 | | | | | | |

## Incidents (every one, however small)

| Date | What happened | Root cause | Fix | Recurrence risk |
|---|---|---|---|---|

## Final decision (at pre-registered end date, not before, not after)

- Trades: ___ · P&L: ___ · MC percentile of P&L: ___ · Cost ratio: ___ · Signal-match: ___%
- **Decision: SCALE (→ ladder rung 1, needs Human Gate #2) / EXTEND (only if trade count not reached) / KILL**
- Reasoning (2–3 sentences, written by you, not the AI):
- If KILL → move to `strategies/retired/`, write postmortem, log family insight to `ideas/graveyard.md`.
