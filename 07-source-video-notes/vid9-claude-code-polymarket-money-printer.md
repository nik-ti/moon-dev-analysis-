# Video 9: "Claude Code + Polymarket = My New Favorite Money Printer"

**URL:** https://youtu.be/8pVxVBNrsPE
**Duration:** ~128 min · **Channel:** Moon Dev (private Zoom call recording)
**This is the richest video in the set — explicitly names and walks through the full RBI framework while live-building 4 bots.**

---

# Moon Dev — "Claude Code + Polymarket = My New Favorite Money Printer" — Extracted Process

## 1. Tools & Stack
- **AI coding**: Claude Code — his primary and only coding tool ("I'm using the regular cloud code," not open-source, [01:59:31]). Runs **six Claude Code instances simultaneously** ([01:28:26], [00:54:53]) for parallel bot-building, backtesting, and web tasks. ChatGPT mentioned only as the historical trigger (dropped 2022, two years into his manual coding journey, [01:12:28]).
- **Prediction markets**: Polymarket (main focus, ~15 bots built there), Kalshi (newly expanding into it).
- **Exchanges (past)**: BitMEX, Phemex (30-40x leverage, where he got "cooked" manually, [01:09:53]). Hyperliquid also referenced for non-Polymarket bots.
- **Data/APIs**: ESPN API (free — WTA tennis scores, NBA quarter status, cricket innings status, [00:18:56], [01:30:00]); Kalshi API (trades/markets/events endpoints, [00:34:34]); Moon Dev's own API (18 months of liquidation + Hyperliquid data, [01:39:07]).
- **Platform**: Moon Dev app (backtest button, historical data downloads, 15-min bar data), Discord (Quant Elite = code-drop section), GitHub (trading-bot repo w/ 100+ backtests & templates, separate AI-agents/"swarm agent" repo), Vercel noted (used by a Kalshi competitor), Stripe (payments).

## 2. The RBI Framework (Research → Backtest → Incubate)
Verbatim: *"The process of automating your trading starts with the research of trading strategies. Then you backtest those strategies to see if they actually work in the past. If they do, they're not guaranteed, but they're much more likely to work in the future."* [00:17:51, repeated 01:15:21]
- **Research**: books (Market Wizards series), Google Scholar, podcasts (Chat With Traders), YouTube, and — critically — watching his own whale/trade scanners for what markets are liquid ("This is how I do discovery," [00:32:52]).
- **Backtest**: run on his app with a click; used heavily for stocks/futures/crypto/hyperliquid where data is cheap. Explicitly **skipped for most Polymarket bots** — "It's a little hard to backtest on Polymarket" [00:17:06], "for Polymarket, really I'm not backtesting much" [00:37:46].
- **Incubate**: when backtesting isn't feasible, deploy live with tiny real size instead. *"You come up with the idea, backtest it if you can, and then incubate it with small size, something that's not going to keep me up at night."* [01:01:06]
- Daily self-check: *"I have three options. I'm either researching, I'm backtesting, or I'm incubating."* [01:18:19]

## 3. How He Prompts Claude Code
He treats Claude Code as a collaborator he addresses by voice/text and refers to as "her/she." Examples used live:
- Kickoff/explain: *"Can you go ahead and shortly and concisely explain my tennis bot idea so the audience can understand it?"* [00:11:38] (same pattern for cricket [00:59:25], NBA [01:28:32], Kalshi scanner [00:30:37]).
- Bulk backtest generation: *"I want you to look at our last five backtests and then I want you to build — use what's good in them — and then do a capitulation type strategy. So you're looking for a volume spike with open high low close volume data. Build five, use five agents."* [01:18:39]
- Non-trading side tasks (same session, same tool): rebuilding his sales page — *"go ahead and look at moondev.com/lucky... make that Easter theme, don't make it too lame... it's a male audience so don't make it too pink"* [00:28:04-00:28:41]; small UI fix — *"when it's over 24 hours, I want it to show days as well. When it's under 24 hours, we'll only show hours"* [01:04:44]; scheduling — *"schedule that to close on Monday at midnight Pacific time"* [01:07:18].
- Review style is conversational/light-touch: he states the desired behavior in plain English, watches the diff/output, and issues a follow-up correction rather than reading code line-by-line himself.

## 4. Workspace / Repo Structure
- Organized **by market, then by sport**: a `sports` folder containing files like `tennis.py`, `cricket.py`; a lowercase `kalshi` folder for the Kalshi scanner ([00:31:04]); NBA and other sport folders alongside.
- **Multi-account system** via env vars because Polymarket has no native sub-accounts: `OG account private key ENV`, then `account2`, `account3`, `account4` [00:19:26], letting him test multiple ideas in parallel without cross-contamination.
- Runs bots **locally first** ("I like to run them on the computer to start because then I can see errors") then **scales onto cloud servers** via SSH ([00:27:41], "SSH moon dash"); bots sometimes die from VPN toggling and need manual restarts.
- At any time he has roughly **15 different bots incubating** on-screen simultaneously [01:22:19].
- Distribution: finished bot code gets pasted into Discord's "Quant Elite" code channel with a plain-language title (e.g., "WTA tennis Polymarket trading bot," "Kalshi whale scanner") — this is his versioning/sharing system, not a formal repo workflow shown on camera.

## 5. Validation Criteria
**Not covered with hard numeric thresholds in this video.** He gives no explicit win-rate/drawdown/sample-size bar for graduating a backtest. The one concrete data point is dismissive, not a threshold: a MACD-histogram-reversal backtest that "lost 88% of its money" is called "probably a trash strategy" [00:48:50]. For Polymarket specifically, he states he bypasses backtesting criteria entirely and substitutes small live-size incubation as the validation step.

## 6. Risk Management / Position Sizing
- Universal starting size across all four bots: **$5 per stink bid** (occasionally $10) — deliberately kept small precisely because these ideas are unbacktested [01:30:18], [01:31:53].
- Stink-bid discount: **30% below current market price** on the favorite, in every sport (tennis, cricket, NBA) [00:14:35], [01:00:12].
- Refresh cycle: **every 15 minutes** — cancel-then-repost.
- Explicit checklist item: *"check to see if there's already a position, and make sure to cancel all orders before opening a new one"* [00:17:19-00:17:40] — cited as a common beginner mistake that "drains your whole account."
- Timing filters per sport act as risk cutoffs: tennis has no stated cutoff shown; cricket cancels all bids once the second innings ("the chase") starts [01:00:46]; NBA cancels once Q3/second half starts [01:29:34] — logic being volatility/panic-selling is highest early, so exposure is closed before uncertainty drops.

## 7. Deployment / Going Live
"Incubate" = run the strategy live with real (tiny) capital as a substitute for backtesting, watched on his own screen for errors before moving to a server. No fixed incubation time window is stated — it's open-ended ("always incubating on the screen") and graduates to scaling only "if it does do well over time," at which point he deploys it to a cloud server and "never look[s] at it... so I don't tinker" [01:32:15]. Monitoring is informal: visual dashboards (positions, PnL) rather than automated alerting.

## 8. Philosophy Quotes
- *"The process of automating your trading starts with the research of trading strategies."* [00:25:20]
- *"If everybody's doing something one way, don't do that."* (attributed to Jim Simons, repeated throughout) [00:10:54]
- *"There's something called alpha decay... if there's a million dollars in the corner and I tell 50,000 people, how long is that million dollars going to be there?"* [00:59:50]
- *"I'm not a believer in running somebody else's bot."* [00:34:52]
- *"Start with tiny size... this is the process I'm teaching you today."* [00:17:44]
- *"Either stop trading or automate it, cuz it's the only way."* [02:01:41]
- *"You come up with the idea, backtest it if you can, and then incubate it with small size, something that's not going to keep me up at night."* [01:01:06]

## 9. Pitfalls / Lessons
- His first real bot: *"I built a bot and I lost all my money cuz I didn't have a system... I just put 10K in and just went to zero"* [00:25:26] — no research, no backtest, no incubation step.
- Duplicate-order bug: bots that don't check for an existing position before ordering "just puts in another order and another order... and you drain your whole account" [00:16:21] — hence the cancel-before-refresh rule.
- Leverage warning: *"using 30, 40x leverage, you won't win ever"* [01:15:45].
- Deliberately withholds exact scaled strategies from public code drops to avoid alpha decay/crowding — shares the idea, not the production iteration [01:02:55].
- Sports-bot cutoffs (WTA vs ATP volatility, cricket innings, NBA halves) were guessed heuristically, not backtested — he flags this openly ("Is that right or wrong? I don't know") [00:13:29], [01:29:36].

**Note on scope**: the "cultish scanner" teased at the intro appears to be the Kalshi whale scanner segment (large-trade detector), not a separately named build — no distinct "cultish" bot is demoed later in the transcript.
