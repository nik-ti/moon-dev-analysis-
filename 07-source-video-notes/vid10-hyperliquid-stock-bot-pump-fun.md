# Video 10: "Claude Code Built Me a Hyperliquid Stock Bot & Exposed Pump Fun"

**URL:** https://youtu.be/PdmdT0uMGj8
**Duration:** ~182 min · **Channel:** Moon Dev (private Zoom call recording)

---

# Moon Dev — "Claude Code Built Me a Hyperliquid Stock Bot & Exposed Pump Fun" — Analysis

Note: this is a casual private-Zoom stream. The actual bot-build is compressed into a few exchanges (~[00:43]–[02:05]) while Claude Code works in the background; most screen time is website cleanup, meme-coin browsing, and stock research using Claude as a research analyst.

## 1. Tools & Stack
- **Claude Code** — anthropomorphized as "she/her," referred to as "shorty" (opening line "these Claude Codes here" is a mis-transcription of "Claude Code")
- **Hyperliquid** (app.hyperliquid.xyz) + **HIP-3** — permissionless perp markets enabling on-chain stock trading (TSLA, AMZN, NVDA, INTC, MSTR, HOOD, GOOG, AMD, SNDK, ORCL, BABA, EWY, plus oil, Brent oil, S&P, silver); up to 20x leverage on commodities noted [02:07]
- **Pump.fun** (Solana launchpad) — subject of the buyback investigation
- **Birdeye API** — Solana token data, gets rejected while on VPN [01:04:49]
- **Flipside Crypto** — mentioned as a past tool for blockchain analysis, not used live [01:03:34]
- **TradingView**, **Polymarket** (with Pi Club SDK), **PM2** (process manager, "eight workers" vs single-worker saturation [00:07:28]), **watchdog config**, **IP-API** (geolocation for click tracking, cached 24h LRU/IP), **Coinbase API** (source for /data page), **OBS** (Apple VT H.264 hardware encoder swap to fix stream crashes [00:32–00:34]), **SSH** to a VPS ("moon dash")
- His platform: **moondev.com/arena** (price-prediction competition), **/docs**, **/api**, **/game** (deprecated this session)

## 2. Framework & Build Steps
No named methodology (no "RBI" mentioned in this video). The HIP-3 TSLA bot build [00:43–02:05]:
1. Status check: *"can you tell me the status on the Hyperliquid HIP-3 stuff? Like what do we have built already?"* [00:43:14]
2. Explicit spec: *"build me a bot here that... a just simple SMA bot just to prove that that works. Stop loss, take profit, 5% both sides... Should be able to control the leverage. Let's say put 2x leverage there."* [00:43:33]
3. Stated purpose: *"I just want to kind of stress test to see where our GitHub is when it comes to HIP-3"* — i.e., testing existing plumbing, not greenfield build
4. Claude reports back [02:04:24]: confirms prior 15-min SMA strategies exist for SP500/scanner; calls plumbing "standalone proven"; says building HIP-3 bot is a "30-minute copy-paste job"; flags risky pieces as symbol resolution, price decimals, leverage; confirms "Leverage 2x isolated" and SL/TP built
5. Dry run: *"Dry run test mid at 373.29, 129 candles. Computing no crossover, okay."* — validated end-to-end plumbing, no live capital deployed on stream

**Pump Fun exposure** [01:15–01:33]: He notices Pump.fun's price isn't rising despite buybacks (unlike Hyperliquid). Prompt: *"launch two agents on it, and give me back a full report."* [01:16:25] Findings: buybacks are **real** (90% confidence — the two published wallets hold ~126B pump vs. claimed 125B), but insiders are **dumping into them** (80-85% confidence). Ecosystem/community unlock (~600k–1.2M/day) exceeds the ~$750k-1M/day buyback. He then asks Claude to model the **July 12, 2026 cliff** through year-end; the model shows 82.5B tokens (23% of circulating supply) unlock in a single day, buybacks lose net every month except December 2026, and the program only wins structurally around Q2 2027 if Pump.fun revenue holds at $30M/month.

## 3. How He Prompts Claude Code
Conversational, run-on dictation, always ends with "Thank you." Examples: *"give me the top three because maybe I can remove a couple of them"* [00:01:51]; *"Now, will this resolve everything so we don't have to restart 10,000 times?"* [00:18:08]; *"I want you to go ahead and build a migration MD and then send me back that file path because I will refer to this"* [01:51:47]. He verifies claims manually rather than trusting blindly — after deprecating `/game`, he visits the URL himself: *"This page has been retired. Beautiful."* [00:35:03]. When SSH breaks mid-task he doesn't panic, just waits: *"I break it a lot... just go ahead and look into that for me. See if it's done yet"* [00:27:53]. He uses parallel sub-agents for research ("launch two agents"; *"I got agents for this... sub agent sick. I love sub agents, bro."* [01:04:29]) and calls out weak output honestly: *"I mean, that was a weak analysis, gang"* [01:22:20].

## 4. Workspace/Repo Structure
Single GitHub repo holding: HIP-3/TSLA bot, 15-min SMA strategies, SP500 scanner, Polymarket bots, Solana copy-trader, token-holder-analysis sub-agents. Backend+frontend for moondev.com, PM2-managed processes, a 5-minute "fetch all" data job, CSV data files (`liquidations_master.csv` 2.16GB, `OI.csv`, `graveyard_percentage_persistent.csv`) that Claude mapped by dependency before deletion [00:20:52]. Server reached via SSH; watchdog config for restart monitoring.

## 5. Validation Criteria
Loose in this video: "stress test" the infra rather than backtest metrics. Validation = Claude's confidence statement + a dry run against live mid-price/candle data checking for a crossover signal. No Sharpe/win-rate/drawdown thresholds discussed.

## 6. Risk Management / Position Sizing
Only concrete numbers given: **5% stop loss and take profit both sides**, **2x isolated leverage** on the TSLA SMA bot [00:43:35–02:05:03]. No broader capital-allocation or portfolio-level risk rules covered.

## 7. Deployment / Going Live
Not deeply covered — the TSLA bot stays at "dry run" stage on stream. Elsewhere he references bots running continuously via PM2 that go dark when he travels ("they've literally been off for a day or two" [01:43:51]). Shows deployment discipline around a Polymarket SDK breaking change (April 28 cutover): builds a written migration plan, wraps collateral (PUSD) in advance without going live yet — "parallel prep, not hot swap" [01:47:15].

## 8. Philosophy Quotes
- *"I honestly don't think you should be trading by hand"* [00:13:57]
- *"When dev sells against buyers, we used to call that a scam."* [01:29:13]
- *"I like when crypto is cooked because everybody's out of money... you get all the tourists out of here."* [01:36:47]
- *"I just locked in 4 hours a day, dude. I just build systems for crypto 4 hours a day, and it helped people through the bear market."* [01:37:07]
- *"Adapt. You got to adapt, bro. Are you cooked if you can't adapt?"* [02:22:54]
- *"You got to optimize for fun, bro. Cuz then it's not even work."* [02:45:24]
- *"I'll never quit crypto... never never ever ever."* [01:34:35]

## 9. Pitfalls/Lessons
- 2.16GB CSV file and unbounded single-worker API caused stalls/restarts — fixed by moving to 8 workers and deprecating unused data pages [00:07:28]
- OBS CPU encoding overloaded and killed the stream; fixed with hardware (Apple VT H.264) encoder + lower preset [00:32:10–00:34:03]
- VPN blocked Birdeye API calls, breaking token-analysis sub-agents until he disconnected [01:04:49]
- **Pump Fun lesson (core cautionary finding)**: a "buyback" is not automatically bullish — verify on-chain wallet balances match claims, but more importantly model the vesting/unlock schedule. Pump.fun's buyback is being used as exit liquidity for insiders/ecosystem holders (unlocks outpace buyback), unlike Hyperliquid, whose team is fully locked/has no VCs, making every buyback pure net demand. The July 12, 2026 unlock cliff (23% of supply in one day) is flagged as the real test of the thesis.
