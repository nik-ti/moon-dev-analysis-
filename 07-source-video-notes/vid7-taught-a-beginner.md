# Video 7: "I Taught a Beginner to Build a Trading Bot With Claude (Here's What Happened)"

**URL:** https://youtu.be/RKku3SLPsQ4
**Duration:** ~58 min · **Channel:** Moon Dev
**This is the single most useful video in the set — a clear step-by-step beginner walkthrough of the full RBI process.**

---

# Moon Dev — "I Taught a Beginner to Build a Trading Bot With Claude" — Analysis

## 1. Tools & Stack
- **Claude Code** — primary coding agent ("if you don't have Claude Code installed yet, that's the one thing you need to do right now," 00:38:04). Runs multiple instances simultaneously, and dispatches **parallel sub-agents** ("launch five agents," "launch agent for each," recurring throughout).
- **Cursor** — opened alongside Claude Code to browse/verify folders (00:17:06, "opening cursor here").
- **Moon Dev API** (mundave.com/docs) — his own proprietary Hyperliquid data layer: OHLCV data, liquidation history, "positions near liquidation" snapshots. Given free to Zoom/private-community members as an API key pasted in chat (00:09:52).
- **Data sources compared side-by-side**: Moon Dev API, raw **Hyperliquid API**, and **Coinbase API** — all three pulled in parallel for the same token/timeframe to see "which is the most robust" / has the most data (00:15:38–00:16:11). Result: Coinbase won with 11,000 bars (3.8 months) (00:37:38).
- **Exchange/execution**: "Extended Exchange" (a perps DEX) — bot built against its infra using a library referred to as "nice funks" (likely "nice_funcs", his own reusable trading-function module) plus an "easy account" abstraction (account 1/2/3). Also references Pacifica and a "cross exchange" GitHub repo of prior bots.
- **Backtesting**: Python `backtesting` library (implied — "I want you to use backtesting... you have a ton of back tests in there that you can understand how to back test and how to set it up," 00:20:16-ish and 00:38 area). Metrics generated: return %, Sharpe, Sortino, max drawdown, win %, exposure time.
- Also mentioned in passing: TradingView, Discord community, Google Scholar, books (a curated "book list").

## 2. Named Framework: RBI (Research → Backtest → Incubate)
Stated explicitly and repeatedly (00:11:11, 00:19:40): **"Research, back test, and then incubate. I will always, always, always be doing these three steps."**
- **R — Research**: Come up with an idea by watching markets, reading papers/books, group chats, or a personal whiteboard of ideas ("I have a whiteboard behind me with a ton of ideas," 00:13:05). No code yet — just articulate the thesis (here: fade/scalp between Hyperliquid liquidation clusters on the HYPE token, later evolved into a MACD-crossover + liquidation-enhanced strategy).
- **B — Backtest**: Pull historical OHLCV + liquidation data via agents, build a backtest folder, run the idea against past data, compare metrics. "Back testing is the process of seeing if something works in the past... it's really just filtering out the trash" (00:04:00–00:05:15).
- **I — Incubate**: Deploy the passing strategy live with tiny real capital (~$10) before scaling. "It is a bot, but it's incubating with small size" (00:04:52). Distinct from paper trading — real money, real fills, tiny size.

## 3. How He Prompts Claude Code (verbatim examples)
- Exploration prompt: *"Please go explore my extended exchange infrastructure that I have and give me any bots that I have built already for extended exchange."* (00:17:22)
- Data-pull with folder naming baked in: *"Can you go ahead and try to use the Mundev API in order to get 15 minute data for this token... pull it directly into the back testing folder. Call it [X]. Go ahead and get as much data as you can from the Mundev API... also get it from the Hyperliquid API itself... and also get it from the Coinbase API... We should have three data sets. I want to see which is the most robust... go do all three. Launch agent for each."* (00:15:02–00:16:08)
- Fully spec'd bot-build prompt (dictated like a spec sheet): 15-min SMA + std-dev bands, 2 std-dev entry, opposite-side exit, long or short, pull in liquidation-proximity data, capitulation logic ("buying the lows when somebody big just gets knocked out"), threshold ($300k position size), one trade at a time, fixed stop-loss/take-profit, emergency stop at ±50%, leverage=10 as a top-of-file variable, loop-until-filled entries, cancel-all-orders-before-new-order, 15-second polling loop (00:23:29–00:26:49).
- Iteration prompts constantly say **"launch five agents"** to test variants in parallel (e.g., 00:28:47, 00:40:05, 00:41:04, 00:57:09) — parallel agentic exploration is core to his workflow, not sequential single-shot prompting.
- Review/correction example: noticed an anomalous positive drawdown number, asked *"How is that positive? ... What's going on here? Short and concise."* — Claude explained it was a column-alignment display issue, not a real bug (00:51:17–00:52:53). Shows he sanity-checks metrics rather than trusting them blindly.
- Also has Claude write explainer content for him, e.g. asking it to explain alpha decay "short and concise to somebody who is a trader but does not necessarily know" (00:41:57) — using the AI as a teaching/writing tool, not just a coder.

## 4. Workspace/Repo Structure
- A dedicated **"back testing" folder**, with idea-specific subfolders named live during the session (e.g., "hype momentum," renamed from a placeholder — he has Claude create the folder name from the idea itself).
- New strategy work gets dropped into a dated folder, e.g. **"June"** folder for the live incubation bot (00:27:40), with shared library code ("nice funks") **copied, not moved**, into it so folders stay self-contained (00:53:58–00:54:15 — Claude explicitly called out "I copied rather than moved the nice funks... good call").
- Existing library of prior bots lives in a separate "cross exchange" GitHub repo he has Claude search for reusable pieces ("easy py," "easy account 1/2/3" abstraction) before building new.
- API keys handled via his own API service (Moon Dev API key), pasted directly to community members — no explicit `.env` walkthrough shown in this video.

## 5. Validation Criteria (backtest judging)
- Core rule stated explicitly: **"I like to see double the return to a drawdown... I want ROI to be much bigger than the drawdown. Double. Double, bro."** (00:38:44–00:39:11)
- Compares Sharpe vs. Sortino (notes Sortino is often preferred for crypto due to its asymmetric penalty, ~00:52:05).
- Always benchmarks against **buy-and-hold** — "nothing beats buy and hold on these strategies" (00:54:44); a strategy is worth it only if it gives up a small amount of return (e.g., "10-12 points") for a materially smaller drawdown (30%→16%) and less market exposure time (100%→81%) (00:55:44 onward).
- Treats 3 months of data as thin ("there's something called regimes... you can argue this that it's not going to be enough data for sure, but again, put your money where your mouth is," 00:35:59) — acknowledges the limitation rather than pretending it's robust.
- Explicit stance: back testing over-optimization is not the point — "back testing is only a confidence game... just because it worked in the past does not mean it's going to work in the future" (00:36:15–00:36:37).

## 6. Risk Management / Position Sizing
- Incubation size: **~$10 margin**, 10x leverage as a top-of-file variable (00:27:01-ish, "$10 margin... $10 times the 10x leverage").
- Fixed **stop-loss and take-profit** required on every bot, plus an **emergency kill level at ±50%** (00:25:59–00:26:07).
- One trade at a time — no stacking/hedging inside a single bot.
- Always cancel outstanding orders before submitting new ones; check position status before every new entry; loop every 15 seconds continuously (00:26:12–00:27:26 checklist: "risk controls will be number one... check P&L each time through... must cancel all orders before opening... make sure decimals are set up correctly... while true that runs every 15 seconds").
- "Never run anybody else's bot. If you run anybody else's [bot], you're cooked" — because you don't know their hedging, sizing, or when they'll turn it off (00:20:46–00:21:07).

## 7. Deployment / Going Live
- No paper-trading step emphasized — he explicitly argues **incubation with tiny real capital beats months of paper trading/robustness testing**: "You can debate about paper trading... but you can't debate the incubation stage. If I put real money into a real bot while everybody else is paying 6-12 months robustness testing... I'm cooking you" (00:36:44–00:37:19).
- Live monitoring shown directly: multiple bots already running and incubating on-screen (Solana bot, Polymarket bot) while he builds the new one — implying he watches live P&L/behavior rather than a formal dashboard process.
- States he will not let the demoed HYPE bot "run forever" on stream / isn't revealing the final tuned strategy publicly (00:53:46–00:53:53), reinforcing the alpha-decay lesson from section 9.

## 8. Philosophy Quotes
- "The process of automating your trading, the process of algo trading starts with research of trading strategies." (00:03:47)
- "Back testing is only a confidence game. It's like seeing, okay, does this work in the past?" (00:36:15)
- "You can't debate the incubation stage." (00:36:47)
- "Nobody's going to hand you a free money printer... Edge isn't a permanent property of a strategy. It's a temporary mispricing. The market is actively trying to close [it]." (00:42:53–00:45:04)
- "I would rather discipline — do what you hate to do but do it like you love [it] in the market." (00:55:32, on drawdown tolerance)

## 9. Pitfalls / Lessons Called Out
- His own origin mistake: spent 6 months learning to code, built a bot with no research/backtest/incubate process, and **lost $10,000** (00:02:56–00:03:00) — "I thought I had a good strategy. I put it into a bot. It didn't work. It wasn't a good strategy" (00:03:56).
- **Never run someone else's bot / bought "signal" bots** — you don't know their hedges, sizing, or when they'll shut it off; ties to the extended **alpha decay** explanation (crowded strategies get arbitraged away; sellers profit from subscriptions, not trading; backtests shown by sellers are "either curve fit, look ahead bias, or run on a regime that no longer exists," 00:44:10–00:44:19).
- Data-quality trap: noticed an impossible "positive drawdown" figure mid-session and stopped to interrogate the AI's output rather than accepting it — turned out to be a column-alignment rendering bug, not a real result (00:51:17–00:52:58) — a concrete lesson to sanity-check AI-reported metrics.
- Regime risk flagged honestly: 3 months of data / a "capitulation" idea using live position/liquidation data has **no historical equivalent** ("there's no past data on seeing people's positions... this idea is going to be heavily based on incubation... this is kind of a ghetto way to do this," 00:29:43–00:30:18) — he's transparent that not everything can be rigorously backtested, and incubation covers that gap.
- General beginner caution acknowledged: "I understand this is way too fast for somebody new" (00:21:55) — pace/parallel-agent workflow is advanced; he flags it rather than pretending it's beginner-paced.

**Note:** This video is a live/sales-hybrid stream (Zoom pitch, "Memorial Day sale" promo, community upsell) interwoven with the actual teaching — the RBI content above is the substantive, reusable part; promotional segments were excluded except where they reveal tooling (e.g., the Moon Dev API access model).
