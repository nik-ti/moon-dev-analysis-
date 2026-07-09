# Pitfalls Checklist

Specific mistakes called out across the 10 source videos — by Moon Dev about his own history, or caught live on stream. Read this once now, then again after your first few incubation cycles when you're more likely to recognize yourself in one of these.

## Process pitfalls

- **Skipping straight to building a bot with no research or backtest.** This is the exact mistake that cost the channel's own creator his first $10,000 — "I put 10K in and just went to zero." The entire RBI discipline in `02-your-protocol.md` exists specifically to prevent this one failure mode. If you notice yourself wanting to skip Stage 1 or 2 because an idea "feels obviously right," that feeling is the risk, not a reason to skip the check.
- **Debugging a failing backtest until it passes.** If a strategy fails validation, the correct move is to kill it or revisit the mechanism — not to tweak parameters against the same test data until the numbers look good. That's curve-fitting with extra steps.
- **Treating a good backtest as proof instead of a filter.** "Back testing is only a confidence game" — it screens out obviously bad ideas, it doesn't validate a good one. Only incubation with real capital tells you that.
- **Deciding scale/kill after seeing the results instead of before.** Write your bar down before incubation starts (see `05-validation-and-risk-rules.md` §B). Post-hoc bars always end up rationalizing whatever happened.

## AI-collaboration pitfalls

- **Accepting the AI's first explanation for a bug without verifying it.** A "positive drawdown" number turned out to be a display bug, not a real one — caught only because it was interrogated instead of accepted. When something looks wrong, ask the AI to verify against the actual source (file, log, API response), not to re-explain in different words.
- **Trusting a documentation summary over the real API.** A caption/doc summarizer hallucinated capabilities that the real API didn't have — caught by probing the live API directly. If a claim about a tool or API matters, verify it against the tool itself once.
- **Accepting a plausible-sounding fix on infrastructure that affects live capital without independent verification.** Before restarting anything that could touch open positions, confirm state directly yourself (or have the AI show you direct evidence), not just accept "should be fixed now."
- **Not writing a session handoff note before closing an unresolved session.** The AI doesn't remember previous sessions — if you close one mid-problem without a summary, you pay the cost of re-establishing context next time.
- **Running huge parallel-agent dispatches routinely.** Burns budget fast (the source ran out of credits after 6 parallel batches in one sitting). Reserve large fan-out for Stage 2 variant-racing, not for routine work.

## Data & validation pitfalls

- **Trusting a single data source without cross-checking.** Pull the same data from 2-3 sources when it matters (this is how a stale/cached API was caught returning silently wrong results — "impossible" zero trades for 25 seconds, actually a caching bug, not a quiet market).
- **Getting excited about extreme returns instead of suspicious.** 624,000% and 100,000%+ return figures are treated as near-certain overfitting, not wins. If a backtest number seems too good, the correct reaction is more scrutiny, not more confidence.
- **Reporting a return without a benchmark.** A 2,610% strategy result was actually *weak* — it underperformed a 32,000% buy-and-hold over the same window. A return number with no comparison point is close to meaningless.
- **Trusting a strategy tuned on thin data or a single market regime.** Be explicit and honest in writing about how many trades and how many distinct regimes your backtest period actually covers, rather than implicitly assuming more data confidence than you have.

## Risk & execution pitfalls

- **No check for an existing position before placing a new order.** Called out as the most common beginner bug — a bot that skips this check will stack duplicate orders and can drain an account. This must be in the bot spec from the first prompt (see the `bot-build-spec` template), not added after an incident.
- **High leverage on an unproven strategy.** "30, 40x leverage, you won't win ever" — leverage should scale up only after a strategy has proven itself at low leverage and small size, never before.
- **Running someone else's bot or "signal service."** You don't know their real sizing, their hedges, or when they'll quietly turn it off — and sellers of signal bots typically profit from subscriptions, not from the trading itself. If you can't run the strategy's own Research → Backtest → Incubate loop yourself, you don't actually understand its risk.
- **Publishing or sharing your live, scaled strategy.** Whatever edge you find decays as more capital chases it — this is *why* the source material shares process and teaching examples but never live production parameters. Treat your own successful strategies the same way: process is shareable, live parameters are not.
