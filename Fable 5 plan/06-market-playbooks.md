# 06 — Market Playbooks

Per-venue field guides: which edge families realistically exist there for a solo operator, what data you need, the execution traps, honest cost models for backtesting, and what is backtestable vs incubate-only. These are *maps of where to hunt* — none of them is a strategy, and every idea from here still walks the full pipeline.

---

## A. Crypto perpetuals (Hyperliquid as default venue)

**Why perps as the default:** deep liquidity, native short-selling, funding data is public, sub-accounts for isolation, testnet for dry runs, good SDK. The 24/7 market also means your bots amortize better than in market-hours venues.

**Edge families worth hunting (roughly in order of tractability for this system):**
- **Funding-rate carry / funding extremes:** collect funding while hedged, or fade positioning extremes (extreme funding = crowded side, historically mean-reverting). Data: funding history (venue API, CoinGlass). Fully backtestable. The classic failure mode: the carry is real but the tail (squeeze against you) eats it — Monte Carlo on the tail matters more than the mean.
- **Liquidation-cascade reversion:** cascades overshoot; providing liquidity into forced selling is a genuine structural edge. Data: liquidation feeds (CoinGlass; venue). Backtestable at bar level, execution-sensitive at fill level (NautilusTrader tier).
- **Basis/spread between venues or between perp and spot:** unglamorous, capacity-limited, real. Needs simultaneous multi-venue data; watch transfer/settlement frictions — they *are* the cost model.
- **Volatility-regime filters on trend/breakout systems:** vanilla momentum with regime awareness. The most crowded family — expect modest Sharpe, demand strong robustness results, and beware that most "improvements" are curve-fits.
- **New-listing dynamics:** predictable flows around listings/delistings on both the listed asset and its ecosystem. Small samples — respect the trade-count gates.

**Cost model for backtests (update quarterly from your own fills):** taker ~2.5–4.5 bps + slippage (assume ≥ 1–2 bps majors at small size, several× that for alts); maker rebates exist but assume zero fill-rate advantage until incubation proves your queue position. Funding is P&L, not a footnote — always included at actual historical rates.

**Traps:** volume-based API rate limits (batch orders); alt-perp books are far thinner than the chart suggests; weekend liquidity droughts; funding prints every hour on HL (not 8h — a ported CEX backtest with 8h funding is silently wrong).

## B. Crypto spot (CEXs via CCXT)

Mostly a *simpler-is-safer* venue: no funding, no liquidation risk on the position itself, custody risk instead. Edge families: cross-exchange price gaps (mostly gone at retail latency, except long-tail pairs), accumulation/mean-reversion systems benchmarked honestly against buy-and-hold (the bar B&H sets in spot is brutal in bull regimes — most spot strategies earn their keep by cutting drawdown/exposure, not by out-returning), and event-driven flows (unlocks, index/ETF rebalances). Fully backtestable with free data (Binance Vision depth of history is the asset). Cost model: 5–10 bps taker at retail tiers + spread. Trap: survivorship — build universes from *historical* listings, not today's top-100.

## C. Polymarket

The most interesting hunting ground for this system precisely because serious quant capital largely can't/won't bother (crypto rails, jurisdiction constraints (US restricted until recently), position limits on many markets, weird instruments), while flow is heavily retail/narrative-driven. Small, real, capacity-limited edges.

**Structural facts that create the edge families:**
- Binary outcome tokens priced 0–1; **price = implied probability**, so every mispricing is a calibration claim you can sometimes test against base rates.
- **Longshot bias is documented and persistent** in prediction markets: low-probability outcomes trade rich (people buy lottery tickets), near-certain outcomes trade slightly cheap. Family: systematically sell the longtail / buy the near-certain, sized tiny per market, diversified across many markets. Partially backtestable from resolution history (Gamma/Data APIs give outcomes and mid-price history) — this is the rare prediction-market family you *can* validate offline at the logic level.
- **Stale quotes on longtail markets:** hundreds of low-attention markets reprice slowly after relevant public news (scores, announcements, data releases). Family: watch the primary source, trade the lag. Incubate-only (the edge is execution against thin books — exactly what mid-price backtests can't see).
- **Resolution mechanics:** markets resolve on precise written criteria; retail trades the vibe, the contract pays the letter. Reading the resolution source better than the crowd is a durable, manual-ish edge that can seed semi-automated strategies. Also: near-resolution convergence trades (the last cents of a decided market) — real carry, but tail risk is resolution disputes; size accordingly.
- **Cross-venue divergence:** the same event priced on Polymarket, Kalshi, and sportsbooks. True riskless arb is rare after fees/friction (and both books at the touch are thin — depth-weighted comparison only), but persistent divergence is a *signal* for directional positioning on the cheaper venue. `pmxt`-style unified APIs make the scan cheap to run continuously.
- **Whale/copy-flow:** positions are on-chain (Polygon) and readable; large-wallet behavior is analyzable. Treat as a research signal (Scout input), not a strategy — copy-trading unaudited wallets violates the never-run-someone-else's-bot principle.

**The data reality (drives the whole validation plan):** free APIs give mid-price history and trades but **no historical order-book depth** — so execution-sensitive backtests overstate P&L, always. Paid depth archives (PolyBackTest and similar) exist; buy them only after a family survives incubation. **Run your own book recorder from day one** (cron + CLOB API snapshots of markets in your categories) — after 6 months you own exactly the depth data you need, and almost nobody else has it. That recorder is plausibly the single best investment in this whole playbook.

**Cost model:** no trading fee on most markets currently, but the spread *is* the fee — on longtails it's often 2–10 cents wide, i.e. enormous relative to edge; model fills at the touch or worse, never at mid. Gas ≈ negligible (Polygon), but account for USDC bridging friction in capacity math. Watch for fee-structure changes — venue rules are young and mobile, and a fee introduction can kill a family overnight (that's a pre-written retirement tripwire).

**Traps:** position limits per market on some markets; resolution/oracle (UMA) dispute risk is a real tail on "sure things"; many markets are one-sided (you can't always exit — a "liquid" entry can be an illiquid exit; time-stops must account for hold-to-resolution as the worst case); L2 credential handling (wallet key custody rules from `05` apply doubly).

## D. Kalshi

The regulated (CFTC) US cousin. Different market mix (economics data, weather, rates, awards — plus sports/elections), different crowd, KYC'd USD rails. Edge families rhyme with Polymarket (longshot bias, stale repricing after data releases, cross-venue divergence vs Polymarket/sportsbooks — Kalshi-vs-Polymarket on the *same* event is the cleanest divergence pair available). Backtestability slightly better on trades (`/history` endpoints, trade-level granularity), still no historical depth — same recorder-from-day-one prescription. Costs: explicit per-contract fee schedule (roughly cents-level, concentrated near 50/50 pricing) — model it exactly; it's published. Regulatory posture is an *advantage* for longevity but the venue can delist categories; venue-rule tripwires apply. A US operator should treat Kalshi as the compliance-safe default for prediction-market strategies.

## E. Choosing where a new idea goes (routing table)

| If the idea is… | Route to | Why |
|---|---|---|
| Price/derivatives signal on liquid majors | Hyperliquid perps | Best data + shortability + isolation |
| Long-horizon accumulation / low-frequency | CEX spot | Simplicity; funding drag doesn't apply |
| Probability-calibration or news-lag on events | Polymarket (Kalshi if US-regulatory-sensitive or the event is a US data release) | The inefficiency lives there |
| Same-event cross-venue divergence | Both prediction venues + reference odds | The scan is the strategy |
| Requires tick-level execution edge on crypto | Park it | Until NautilusTrader-tier validation + Tardis data are justified by prior wins |

## F. Standing venue tripwires (all bots, all venues — wired into monitoring)

- Venue announces fee/rule/limit change touching your mechanism → bot to review state automatically.
- Venue solvency/withdrawal anomalies in the news → descale venue exposure the same day; reserve bucket exists precisely for the day this fires.
- Your fills' realized cost drifts > 2x model at unchanged size → capacity or regime change; halt scaling, investigate.
- A strategy's counterparty flow visibly dries up (liquidation volumes collapse, longtail market count shrinks, spread compresses) → the *edge's food supply* is the leading indicator; review before P&L confirms it.
