# Master Report: How "Moon Dev" Uses AI to Develop Trading Strategies

**Source:** 10 videos from the Moon Dev YouTube channel, analyzed in full via transcript (auto-captions, so "Claude"/"Claude Code" is frequently mis-transcribed as "Fable"/"Fable 5"/"cloud code" — corrected below). Total runtime analyzed: ~7.5 hours.
**Method:** Downloaded full transcripts with `yt-dlp`, read every video end-to-end, cross-referenced for repeated patterns.

This is not a collection of one-off tricks. Across all 10 videos, the same skeleton repeats: a named 3-stage framework, a specific way of delegating to AI, a specific set of numeric thresholds for deciding if a strategy is real, and a specific risk-scaling ritual before real money goes in. That skeleton is what's worth stealing — not any individual strategy (he explicitly and repeatedly says not to copy his strategies).

---

## 1. The core framework: RBI — Research, Backtest, Incubate

Stated explicitly and near-identically in videos 2, 3, 7, 8, 9 (his most-repeated line, quoted directly):

> "The process of automating your trading starts with the research of trading strategies. Then you backtest those strategies to see if they actually work in the past. If they do, they're not guaranteed, but they're much more likely to work in the future." (video 9, 00:17:51 / video 7, 00:11:11)

**R — Research.** Not code yet. Sources he actually cites: his own live scanners/dashboards (whale-tracking, liquidation data — "this is how I do discovery"), books (the *Market Wizards* series, a curated book list), Google Scholar, podcasts (*Chat With Traders*), Discord/community chat, and a physical whiteboard of ideas. The research question is always "what's the mechanism", not "what's the pattern" — e.g. liquidation cascades, order-flow imbalance, whale copy-trading, prediction-market mispricing from insider unlock schedules.

**B — Backtest.** Run the idea against historical data using a Python `backtesting` setup, with his own proprietary data API (`moondev.com/api`) plus raw exchange APIs as cross-checks. Explicitly framed as a filter, not a proof: "Back testing is only a confidence game... just because it worked in the past does not mean it's going to work in the future" (video 7, 00:36:15). Where backtesting isn't possible (most prediction-market bots — Polymarket has no clean historical order book), he **skips straight to Incubate with tiny size** instead (video 9, 00:37:46, 01:01:06).

**I — Incubate.** Deploy live with real but trivial capital ($5–$10, sometimes $10 margin at 10x leverage) before scaling. This is not paper trading — he's explicit that paper trading is weaker than this step: "You can debate about paper trading... but you can't debate the incubation stage. If I put real money into a real bot while everybody else is paying 6-12 months robustness testing... I'm cooking you" (video 7, 00:36:44). Scaling only happens "if it does do well over time" (video 9).

He also frames his whole day around these three buckets: *"I have three options. I'm either researching, I'm backtesting, or I'm incubating."* (video 9, 01:18:19)

---

## 2. The AI stack

| Layer | Tool | Notes |
|---|---|---|
| Primary coding agent | **Claude Code** | Paid $200/month (Max-tier) subscription (video 6, 2, 9). Used conversationally/by voice dictation, not by hand-typing code. |
| Secondary editor | **Cursor** | Used for quick browsing/verifying file structure, not primary build tool. |
| Backtesting engine | Python `backtesting` library | Custom Claude Code sub-agent ("backtest architect") trained on his own house style/formula, invoked by a trigger word ("backtest") (video 2, 8). |
| Proprietary data layer | **Moon Dev API** (`moondev.com/api`, `/docs`) | 18–24 months of liquidation data, OHLCV, order book, built specifically to dodge exchange rate limits (429 errors) by running his own node. |
| Cross-check data sources | Raw exchange APIs (Hyperliquid, Coinbase, ESPN for sports, Kalshi) | He explicitly pulls the *same* data from 2-3 sources in parallel and picks the most robust ("which is the most robust... Coinbase won with 11,000 bars"). |
| Execution venues | Hyperliquid (perps/stocks via HIP-3), Polymarket, Kalshi, Extended Exchange | Sub-accounts per bot for isolation. |
| Infra | Own VPS via SSH, PM2 process manager, a self-built Electron desktop app wrapping multiple terminal tabs for running bots | |
| Version control | GitHub — public teaching repo (deliberately incomplete/example-only) + private repo with 70–100+ real bots | |

---

## 3. How he actually talks to the AI (this is the highest-leverage pattern to copy)

He does **not** write detailed code specs by hand. He dictates in plain conversational English, but every prompt has the same underlying shape:

**A. The parallel dispatch pattern.** Instead of asking for one strategy, he asks Claude Code to spin up multiple sub-agents that each independently try a variant, then report back and compete:

> "I want you to go ahead and launch five agents here to look through those June 10th folders... have five different agents each find five new backtests and keep going until they beat these three above." (video 2, 01:45)

> "launch six different agents in order to come up with the absolute best idea they have for Polymarket building out a bot that could generate alpha... you just need to launch six agents to each come up with their absolute best one, and then you send me back six total great ideas." (video 6, 02:28)

He ran this at up to **36 parallel sub-agents simultaneously** (6 terminal sessions × 6 sub-agents each) in one sitting. This is the single most repeated structural move across every video — he almost never asks for one answer, he asks for N competing answers and picks winners.

**B. Grounding before dispatch.** Before launching parallel agents, he explicitly gives them the exact benchmark to beat, not just a vague goal:

> "let me grab the exact data paths and benchmark configurations from the three live winners. So each agent works against the same real data and knows exactly what number to beat." (video 2, 03:25)

**C. Full spec dictated as a checklist, not a paragraph.** For a full bot build (video 7, 00:23:29–00:26:49) his live dictated spec included, in order: entry logic (SMA + std-dev bands, 2 std-dev threshold), directionality (long or short), an extra data signal (liquidation proximity), a sizing threshold ($300k position size filter), one-trade-at-a-time constraint, fixed stop-loss/take-profit, an emergency kill switch at ±50%, leverage as a top-of-file editable variable, a polling loop interval (15 seconds), and "cancel all orders before opening a new one." This is effectively a checklist template he re-dictates for every new bot (see the Prompt Library and templates in this workspace).

**D. Gate before building.** For anything non-trivial he separates "explain the plan" from "build it":

> "Don't build it yet, but um... explain it to me if we can do it" — then after reviewing the plan — "Yes, do piece one through three. Let me know when you're done with it." (video 1, 01:08:26 / 01:10:54)

**E. Rejects wrong diagnoses bluntly, demands re-verification** rather than accepting a plausible-sounding fix:

> "That's not it, bro... Nah, blood. It's not it. That's not the answer because I'm looking through all the tabs and they are not there." (video 1, 01:00:19)

**F. Sanity-checks the AI's own reported numbers** instead of trusting them — caught an "impossible" positive drawdown figure and made Claude explain it before moving on (turned out to be a display bug, not a real bug) (video 7, 00:51:17). Also caught a data source silently returning zero live trades for 25 seconds and treated that as a bug signal, not a quiet market (video 5, 00:18:52).

**G. Uses the AI as an analyst/writer, not just a coder** — asks it to explain a strategy "in three sentences or less in layman's terms" for the audience, draft documentation "like you're talking to the documentation team," and run open-ended research tasks ("launch two agents on it, and give me back a full report") on non-code questions like whether a crypto project's buybacks are real (video 10).

**H. Session handoff discipline.** Because restarting Claude Code wipes its memory, before closing a session on an unresolved issue he has it write a summary note to carry into the next session (video 1, 01:12:53).

---

## 4. Validation criteria — the actual numeric bar

This is where most beginners fail: they either accept any backtest that "looks good" or reject everything as overfit. His stated thresholds, collected verbatim across videos:

- **Sharpe ratio** as the primary quality filter — cites 3.65–4.69 as "really good" (video 2, 05:24). Values much higher than that get treated with more suspicion, not more excitement.
- **Return-to-drawdown ratio**: "I like to see double the return to a drawdown... I want ROI to be much bigger than the drawdown. Double. Double, bro." (video 7, 00:38:44)
- **Extreme returns are a red flag, not a win**: "These are probably overfit up here at 624,000% return, but 1,000% return, that's great." (video 2, 00:34) A 2,610% AVWAP result was flagged as *weak* because it lost to a 32,000% buy-and-hold baseline over the same period (video 8, 05:12) — never trust a headline return without a benchmark.
- **Always benchmark against buy-and-hold.** "nothing beats buy and hold on these strategies" — a strategy only earns its keep if it trades away a small amount of return for a much bigger cut in drawdown and market-exposure time (video 7, 00:54:44–00:55:44, example: giving up 10-12 points of return to cut drawdown 30%→16% and exposure 100%→81%).
- **Fee-stress test**: re-run the backtest at 3x the real trading fee. A strategy that survives is preferred over one with a higher raw return that doesn't: "When we tripled the trading fees, it still made 576% while your current best only made 206%." (video 2, 10:39)
- **Out-of-sample / walk-forward / cross-asset transfer**: test a strategy tuned on one asset (e.g. BTC) against an asset it's never seen (ETH, SOL) with frozen parameters, and check that out-of-sample Sharpe doesn't collapse relative to in-sample (video 3, 00:02:29–00:08:55).
- **Sample size / regime honesty**: he openly flags when a dataset is too thin to trust ("there's something called regimes... it's not going to be enough data for sure, but put your money where your mouth is" — video 7, 00:35:59) rather than pretending 3 months of data proves anything.

---

## 5. Risk management — the actual numbers

- **Incubation size: $5–$10 per position**, occasionally $10 margin at 10x leverage — deliberately kept trivial *because* the strategy is still unproven.
- **No/low leverage to start.** "using 30, 40x leverage, you won't win ever" (video 9). Leverage is exposed as a top-of-file config variable, not hardcoded, and starts near 1x-2x.
- **Hard stop-loss and take-profit on every single bot** — a repeated concrete example is 5%/5% both sides.
- **Emergency kill switch** at a portfolio-level threshold — his stated example is ±50%.
- **One trade at a time per bot** — no stacking/hedging inside a single strategy.
- **Always cancel outstanding orders before submitting a new one, and always check for an existing position before entering** — called out explicitly as the #1 beginner bug: a bot that doesn't check for an existing position "just puts in another order and another order... and drains your whole account" (video 9, 00:16:21).
- **Isolated sub-accounts per bot/strategy** so one bot's failure can't cross-contaminate another's capital.

---

## 6. Workspace structure he actually uses

- Repo organized **by exchange/market → strategy type** (e.g. a `sports` folder with `tennis.py`, `cricket.py`; a `hyperliquid` folder; a `kalshi` folder).
- **Dated batch folders** for research sessions (e.g. "June 10th folder") so a night of parallel-agent output is traceable later.
- Shared library code (his `nice_funcs`-style reusable trading functions, account abstractions) gets **copied, not moved**, into each new strategy folder so folders stay self-contained and portable.
- Secrets live in `.env`, never hardcoded — confirmed multiple times ("moving secrets into a gitignored env").
- Runs bots **locally first** (to see errors directly) then migrates to a **VPS via SSH** once stable, managed by **PM2** for restart-on-crash reliability.
- Deliberately does **not** push his best/current bots to the public GitHub — the public repo is teaching material only, to prevent his live edge from being copy-traded into alpha decay.

---

## 7. Deployment ritual

1. Backtest passes the numeric bar above (or is skipped if untestable, e.g. most prediction-market bots).
2. Dry run — connect to the live venue, feed it live data, confirm the plumbing (order placement, decimals, symbol resolution) works with **zero orders actually placed**.
3. Go live with incubation-size capital ($5–$10), watched manually on-screen for bugs.
4. If it performs over time, scale size gradually. If it doesn't, kill it — no sunk-cost attachment.
5. Once trusted, move it to the VPS and deliberately stop watching it closely ("so I don't tinker").

---

## 8. Philosophy — the mental model underneath the mechanics

- **"AI is a great equalizer... I would rather teach you how to fish for the rest of your life."** — his stated reason for showing process, not handing over strategies.
- **"Edge isn't a permanent property of a strategy. It's a temporary mispricing. The market is actively trying to close it."** — this is why he never publishes his live, scaled strategies, only the process and example/teaching bots.
- **"Nobody's going to hand you a free money printer."** / **"Never run somebody else's bot"** — running a stranger's bot means you don't know their sizing, hedges, or when they'll quietly turn it off; sellers of "signal bots" profit from subscriptions, not trading.
- **"Back testing is only a confidence game."** — a backtest filters out obviously-bad ideas; it does not prove a good one. Only incubation with real capital does that.
- **"Either stop trading or automate it, cuz it's the only way."** — manual discretionary trading is explicitly framed as the thing to graduate away from, not a skill to perfect.
- His own origin story, told twice for emphasis: he lost his first $10,000 by building a bot with **no research, no backtest, no incubation** — "I put 10K in and just went to zero." The entire RBI discipline exists as the fix for that one mistake.

---

## 9. Honest limitations of this source material

- Several videos (1, 9, 10) are livestreams/private-Zoom recordings, not tutorials — a lot of runtime is market commentary, course sales pitches, and off-topic chat. The signal above was extracted from the substantive segments only.
- He never discloses his actual scaled/live strategies or their real position sizes at scale — by design, to avoid alpha decay. What's copyable is the *process*, not any specific edge.
- No video shows a rigorous walk-forward/Monte-Carlo overfitting framework in full technical detail — robustness testing is referenced as a category ("I would want to go ahead and do robustness tests next") more often than it's demonstrated step by step.
- Several strategy-specific "edges" (sports-bot cutoff timing, stink-bid discount %) are admitted to be heuristic guesses, not backtested — he's transparent about this, but it means not everything in his examples should be copied as-is.
