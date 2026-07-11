# Experiment Registry — schema and rules

`registry/experiments.csv` is the factory's memory and the statistical conscience of the whole system. The Deflated Sharpe gate (Stage 5) is only as honest as this file is complete.

## The one rule

**Every backtest run appends a row — including throwaway runs, failed variants, and "just curious" checks.** A run that isn't logged is a run that silently lowers the evidentiary bar for every future strategy in its family. The gauntlet harness cross-checks artifact counts against registry rows and hard-fails on mismatch.

## Schema (`registry/experiments.csv`)

| Column | Content |
|---|---|
| `run_id` | RUN-YYYYMMDD-#### (unique per backtest execution) |
| `experiment_id` | EXP-YYYYMMDD-NN (groups runs; one per spec) |
| `family` | idea-family tag (e.g. `hl-funding`, `pm-longshot`) — the DSR trial count aggregates on this |
| `date` | run timestamp |
| `stage` | S3-screen / S4-realistic / S5-gauntlet / S5-holdout |
| `engine` | vectorbt / backtesting.py / nautilus |
| `dataset` | manifest key + date range |
| `window` | training / holdout |
| `params` | JSON of parameter values |
| `n_trades` | |
| `sharpe_net` | after costs |
| `ret_over_maxdd` | |
| `costs_multiplier` | 1x / 3x |
| `result` | pass / fail / info |
| `notes` | one line |

## Derived views the weekly review reports

- Trials per family (all-time and trailing 30d) → the N feeding each family's DSR
- Families under cooldown (holdout failures < 30 days old) — new specs in these families are rejected at registration
- Pass rates per stage (calibrates the throughput expectations in `03-pipeline.md`)
- Runs-without-registry-rows anomalies (must be zero)

## Cooldown ledger (appended on every holdout failure)

| family | failed experiment | holdout failed on | cooldown until |
|---|---|---|---|
