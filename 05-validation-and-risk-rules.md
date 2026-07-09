# Validation & Risk Rules

The concrete numeric bar, consolidated from `01-master-report.md` §4-5 into two checklists you actually run against every idea. Don't skip items because the strategy "feels" right — the entire point of this checklist is to override the feeling.

## A. Backtest validation checklist (Stage 2 gate)

A strategy does **not** proceed to Incubate unless it clears these. If it fails any item, either fix a genuine flaw in the rule (not by curve-fitting to the test set) or kill it and log it in `research/graveyard.md`.

- [ ] **Sharpe ratio** is in a believable range (roughly 1.5–4.5). Below that, it's probably not a real edge. *Above* that, be more suspicious, not less — extremely high Sharpe is usually overfitting, not skill.
- [ ] **Return-to-drawdown ratio is at least 2:1.** If max drawdown is 20%, total return should be at least 40% over the same test period.
- [ ] **Benchmarked against buy-and-hold over the identical period.** A strategy that underperforms buy-and-hold is only worth it if it meaningfully cuts drawdown and market-exposure time. A strategy that "beats" buy-and-hold with similar or worse drawdown is not automatically good — check whether the outperformance survives the fee-stress test below.
- [ ] **Survives a 3x fee-stress test.** Re-run the same backtest with trading costs tripled. If the edge disappears, it was fee-arbitrage on your assumptions, not a real edge.
- [ ] **Survives out-of-sample / cross-asset transfer.** Freeze the parameters and test on a period or a related asset the strategy wasn't tuned on. If Sharpe collapses out-of-sample, the in-sample number was curve-fit.
- [ ] **Enough trades to mean something.** A handful of trades in the backtest is not a sample size — you're looking at noise. Be explicit in your `backtest-summary.md` about how many trades and how many distinct market regimes the test period actually covers.
- [ ] **Extreme returns get extra scrutiny, not extra excitement.** Triple-digit-percent annualized returns should trigger the checks above harder, not a decision to skip them because the number is exciting.

## B. Risk management checklist (must be true before ANY real capital, even incubation size)

- [ ] **Position size for incubation is trivial** — $5-$10 notional, or your venue's minimum, whichever is smaller. Not "small for me" — genuinely small enough that being wrong doesn't matter financially or emotionally.
- [ ] **Leverage starts low** (1x-2x) and is a named, editable config variable — never hardcoded inline in the trading logic.
- [ ] **Every position has a stop-loss and take-profit set at entry**, not added later. No bot goes live without both.
- [ ] **A portfolio-level kill switch exists** — the bot shuts itself down entirely if account equity draws down past a threshold you set in advance (Moon Dev's example: ±50%). This is a backstop against your own strategy logic being wrong in a way you didn't anticipate.
- [ ] **One position at a time per bot** — no stacking or hedging within a single strategy unless that's the explicit, tested design.
- [ ] **The bot checks for an existing position before opening a new one, and cancels stale orders before placing new ones.** This is called out explicitly as the most common beginner bug — skipping this check is how a bot silently drains an account by stacking duplicate orders.
- [ ] **Each bot/strategy trades from an isolated sub-account or wallet** where the venue supports it, so one bot's bug can't touch another bot's capital.
- [ ] **A pre-written scale/kill decision rule exists before incubation starts** — write down, before you see any live results, how long incubation runs and what "doing well" means numerically. Deciding this after seeing the results is how you rationalize a bad outcome into "just needs more time."

## C. When you're allowed to scale size

Only after **all** of:
1. Backtest validation checklist cleared (or explicitly and honestly skipped because the market can't be backtested, with that reasoning documented).
2. Dry run completed with zero real orders, confirming the plumbing works.
3. Incubation ran for the pre-written duration and cleared the pre-written bar.
4. `incubation-log.md` shows no unresolved bugs (duplicate orders, stuck positions, silent errors).

Scale in increments, watching each increment before the next — not in one jump from incubation size to your intended final size.
