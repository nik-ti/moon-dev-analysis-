# Backtest Summary: <idea name>

**Date:** <YYYY-MM-DD>
**Rule tested:** <exact entry/exit rule>
**Data:** <asset, timeframe, date range, source>

## Results

| Metric | Value |
|---|---|
| Total return | |
| Buy-and-hold return (same period) | |
| Sharpe ratio | |
| Max drawdown | |
| Number of trades | |
| Win rate | |
| Exposure time | |

## Stress tests

| Test | Result | Pass/fail |
|---|---|---|
| 3x fees | | |
| Out-of-sample period | | |
| Cross-asset transfer (if applicable) | | |

## Validation checklist (see 05-validation-and-risk-rules.md §A)

- [ ] Sharpe in believable range (1.5–4.5)
- [ ] Return : drawdown ≥ 2:1
- [ ] Beats or meaningfully improves on buy-and-hold risk-adjusted
- [ ] Survives 3x fee stress test
- [ ] Survives out-of-sample / cross-asset check
- [ ] Enough trades / regimes to be meaningful (state count and regimes covered below)

## Regime / sample-size honesty
How many trades, how many distinct market regimes does this test period actually cover? Be honest here even if it weakens the result.

## Decision
- [ ] Pass → proceed to Stage 3 (Incubate)
- [ ] Fail → log in `research/graveyard.md` with reason, stop here

## Caveats
Anything that should make you trust this result less than the headline numbers suggest.
