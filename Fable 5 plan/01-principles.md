# 01 — Principles

These are the beliefs the system is built on. Every rule in the pipeline traces back to one of these. If you find yourself wanting to break a pipeline rule, come back here and check which principle you're about to violate — then decide with your eyes open.

---

## 1. An edge is a mechanism, not a pattern

A tradable edge is a *reason someone else systematically loses money to you*. Real, durable examples of the category (not recommendations):

- **Structural flows**: forced sellers (liquidations, fund rebalancing, option hedging flows) who must transact regardless of price. You provide liquidity to someone who can't wait.
- **Risk transfer**: you get paid for holding risk others don't want (funding-rate carry, basis, volatility selling). The payment is real; the tail risk is too.
- **Behavioral bias**: longshot bias in prediction markets, lottery-ticket demand in low-price tokens, disposition-effect selling. Persistent because it's human nature, but capacity-limited.
- **Attention/latency gaps**: markets too small or too new for serious players — stale quotes on a Polymarket longtail market, mispriced cross-listings between Kalshi and Polymarket and sportsbooks. Big % edges, tiny capacity.
- **Information-processing speed**: reacting to public data (a sports score, an on-chain event, an unlock schedule) faster or more systematically than the marginal participant.

A pattern in the data ("BTC goes up on Tuesdays") with no mechanism behind it is noise until proven otherwise, and the burden of proof is on the pattern. The single question that filters most bad ideas in five seconds: **"Who is on the other side of this trade, and why do they keep doing it?"** No answer → no spec → nothing enters the pipeline. This question is Stage 2's first gate.

## 2. Expectancy × frequency × capacity — not win rate, not headline return

The only three numbers that determine what a strategy is worth:

```
value ≈ expectancy per trade × trades per year × deployable capital
        (after fees & slippage)                  (before your own impact kills the edge)
```

Consequences you must actually internalize:

- A 40%-win-rate strategy with 3:1 payoffs beats a 70%-win-rate strategy with 1:2 payoffs. Win rate is a psychological comfort metric, not a quality metric.
- A brilliant edge that fires 6 times a year is nearly untestable (you'll never reach statistical significance) and nearly worthless to a small account. Prefer higher-frequency edges early: more trades = faster validation = faster compounding of *knowledge*, which is the real asset.
- Capacity is a first-class question from day one. Estimate it in every spec: roughly, how much can you deploy before your own orders move the price more than your expectancy per trade? A stale-quote sniper on Polymarket longtails might make 20%/month on $500 and 0%/month on $50,000. That's still worth running — as one small bot in a fleet — but never confuse it with a scalable edge.
- Headline return without its denominator (drawdown, exposure time, capacity) is marketing, not measurement.

## 3. Alpha decays; the factory doesn't

Every edge is a temporary mispricing that the market is actively closing — competitors find it, the flow you exploited dries up, the venue changes its rules. Planning assumption: **a retail-accessible edge has a useful half-life of months to a couple of years.** Therefore:

- The pipeline's throughput (validated strategies per month) matters more than any single strategy's performance.
- Retirement is a *scheduled, normal* pipeline stage (Stage 8), not an admission of failure. Every live bot has pre-written decay tripwires: rolling live Sharpe, slippage drift, fill-rate deterioration.
- Never fall in love. The correct emotional relationship to a live bot is the one a farmer has with a crop, not the one a founder has with a startup.
- Never publish, share, or discuss a live edge. Alpha decay is accelerated by every person who learns the trade. (This is also why you should be structurally skeptical of any edge someone *sells* you.)

## 4. The multiple-testing problem is THE failure mode of an AI-powered factory

This is the most important principle in the file, because it's the one the AI tooling makes *worse*, not better.

If you test enough random strategies, some will show beautiful backtests by pure luck. The math is brutal: test 100 garbage strategies and the best one will likely show an in-sample Sharpe above 2. Moon Dev's "1,215 strategies tested" style of mass search is exactly the regime where this bites hardest. An AI that runs 500 backtests overnight is a machine for manufacturing false positives *unless every trial is counted*.

The discipline that keeps you honest:

- **Every backtest run gets logged to the experiment registry** (`07-templates/experiment-registry.md`) — including, *especially*, the failures. The registry's trial count per idea-family is an input to validation, not trivia.
- **The bar rises with the number of trials.** The Deflated Sharpe Ratio (Bailey & López de Prado) exists precisely for this: it asks "given how many things you tried, and the skew/kurtosis of returns, is this Sharpe still distinguishable from luck?" The gauntlet (Stage 5) computes it against the registry's trial count.
- **Selection happens in-sample; judgment happens out-of-sample.** Parameter tuning, variant racing, and cherry-picking all happen on the training window only. The holdout window is touched exactly once per strategy, at the end, and the result is binding. A strategy that fails its holdout doesn't get "one more tweak" — that tweak converts your holdout into training data. It goes to the graveyard, and the *idea family* gets a cooldown before any related variant may be tested (see `03-pipeline.md`).
- **Prefer fewer parameters.** Every free parameter is a degree of freedom for overfitting. A 2-parameter strategy that clears the gauntlet is worth more than a 9-parameter strategy with a better backtest, essentially always.

## 5. Costs are the strategy

At retail scale, most "edges" are transfers from you to the exchange, discovered in reverse. Fees, spread, slippage, and funding are not a haircut on the strategy — for anything trading more than a few times a week, they *are* the strategy's main opponent.

- Model costs pessimistically from the first backtest: taker fees + expected spread + a slippage estimate, per venue (see `06-market-playbooks.md` for realistic per-venue numbers).
- The 3x fee-stress test (inherited from the source analysis, kept as a hard gate): a strategy that dies at 3x costs was a cost-model artifact, not an edge.
- Slippage is measured, not assumed, during incubation: modeled-vs-realized cost per trade is a first-class scorecard metric, and drift in it is a retirement tripwire for live bots.
- Prefer maker over taker wherever the strategy allows it. On thin markets (Polymarket longtails), the *spread itself* is often the edge — which means backtests using mid-prices are fiction. Mark this explicitly in any spec for a thin market.

## 6. Run a portfolio of small bots, not a search for The One

The target end-state is 5–20 small live strategies across venues and edge families, each individually modest, collectively meaningful:

- Diversification across *edge families* (carry, flow, behavioral, latency) matters more than across assets. Ten momentum bots on ten coins is one bet.
- Every bot gets an isolated sub-account/wallet and an independent risk budget. One bot's bug or blowup is an expensive lesson, never a catastrophe.
- Portfolio-level risk (correlation caps, aggregate drawdown limits, auto-descaling) is a separate layer above per-bot risk — see `05-risk-and-portfolio.md`.
- Small edges that don't scale are *features* of this design, not bugs: they're less competed precisely because funds can't be bothered. A fleet of ten $2k-capacity bots each making 5%/month is a serious operation.

## 7. Live reality outranks every backtest

A backtest is a filter that removes obviously bad ideas. It cannot prove a good one — only live capital can, because only live capital experiences real latency, real fills, real venue outages, and your own real bugs. Hence:

- Incubation with trivial real size ($5–25) is mandatory and is *the* actual test. Everything before it is triage. (Paper trading is a weaker substitute — it lies about fills — but the dry-run stage does use it briefly to test plumbing.)
- During incubation you are primarily hunting **execution bugs and cost-model errors**, not P&L. A flat-P&L bot with clean execution is a pass; a profitable bot with a duplicate-order bug is a fail.
- Where honest backtesting is impossible (most prediction-market microstructure edges — no free historical depth), skip to incubation *deliberately and in writing*, with size held at the floor for longer. Never quietly.

## 8. Process discipline is the edge that doesn't decay

Every rule in this system is written down *before* the situation it governs (scale/kill bars before incubation starts, retirement tripwires before going live, holdout policy before the first backtest). This isn't bureaucracy — it's the only known defense against the trader's real enemy, which is post-hoc rationalization by a mind looking at a P&L number.

The system's paperwork (specs, scorecards, registry, decision journal) is deliberately cheap to produce — the AI writes nearly all of it — and non-negotiable to skip. If it isn't written down, it didn't happen; if the bar wasn't written before the result, the bar doesn't count.

Finally: **the operator is a component with a failure rate.** Schedule the human work (one 15-minute morning gate, one weekly review), automate the rest, and keep incubation sizes genuinely trivial so that no single decision ever feels big enough to agonize over. Boredom, not drawdown, is what kills most solo operations — the factory is designed so the *interesting* work (new ideas) is always the next thing in the queue.
