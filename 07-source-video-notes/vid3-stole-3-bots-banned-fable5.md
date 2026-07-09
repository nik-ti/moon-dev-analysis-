# Video 3: "I Stole 3 Bots From Banned FABLE 5 Before They Killed It (+3,101%)"

**URL:** https://youtu.be/QRmk5YMIsFQ
**Duration:** ~58 min · **Channel:** Moon Dev

---

# Moon Dev Transcript Analysis: "I Stole 3 Bots From Banned FABLE 5"

## 1. Tools & Stack
- **AI models**: "Fable 5" (Anthropic model, described as "the smartest AI yet," used with a persona named "Mundev"/personified as "she"), Claude "Opus 4.8" on "X high" reasoning effort ("Cloud Max," 00:03:58–04:04), Grok (referenced sarcastically by chat, not used by him), ChatGPT/deep research capability invoked for a news fact-check (00:26:52).
- **Coding tool**: Cursor (00:42:02 "opening cursor").
- **Exchange/broker**: Hyperliquid (HL) — used sub-accounts for live execution; also lists Binance, Extended, Hyperliquid, Interactive Brokers as supported connections in his GitHub (00:05:40).
- **Data**: His own "Moon Dev API" (mundev.com/docs) providing liquidation data, candles, order book, size decimals — built specifically to avoid HL rate limits (429 errors) by running his own Hyperliquid node (00:47:53–00:48:50).
- **Infra**: A cloud server running 24/7 for the bots (00:53:29).
- **Repo**: A public GitHub ("Moon Dev Trading Bots") with example bots organized by exchange/strategy folders; new/proprietary bots are deliberately NOT pushed there.

## 2. Named Framework
**"RBI" — Research, Backtest, Incubate** (explicitly named at 00:56:40: "RBI system for algo trading. That's what I follow.")
- **Research**: Come up with an idea from proprietary data (2 years of collected liquidation data). "Essentially come up with idea... then back test those ideas" (00:00:52).
- **Backtest**: Test the idea against historical data to filter out "trash" ideas: "probably the idea that you're trading by hand is trash. So you should back test it to see if it actually works" (00:01:49). Followed by robustness testing (see §5).
- **Incubate**: "Build a bot out small size and scale slowly" (00:02:02) — run live with minimal capital ($10) before scaling.

## 3. Prompting Style
He talks to the AI conversationally, giving high-level intent plus explicit constraints, then iterates. Key verbatim prompt fragments:
- "I want you to go through these. You have this GitHub... pick the absolute top three ideas that we should build into bots. The ones with the best chance of being not overfit and working the best." (00:02:44–03:00)
- "I really like you to think about this deeply. Look through the stats, look through the robustness test." (00:03:05)
- "Just make it so I can just run it with a Python file. No flags or anything like that. Um, simple." (00:10:15)
- "put two variables actually... market entry... Set that to a true or false though because I would like to test it true and false." (00:11:00) — iteratively refining a spec (market vs. limit orders) live.
- "Let's go ahead and just put this in a subfolder inside of the stat ARB folder because then... it will already have access to the uh multiple sub accounts." (00:16:45) — steering the agent's file placement for infra reuse.
- Correcting errors: "I am getting this error here... I assume this error is for all of them. Please fix it for all three. Thank you." (00:47:17)
- "Are you able to offload some of this to Moondav API mundave.com/docs and maybe print out the full error so we can fix it?" (00:49:59) — points the agent to his own documented API instead of the rate-limited exchange API.
- The AI narrates its own process back to him ("Let me read the three key documents... let me study all the infrastructure first" 00:19:57–00:23:24), which he watches and lets run largely unattended.

## 4. Workspace/Repo Structure
- Repo organized by exchange → strategy-type folders (e.g., "bot section," "Hyperliquid," breakout scanner, momentum DCA, multi-scanner examples) (00:05:33–06:17).
- New proprietary bots are placed in a "subfolder inside the stat ARB folder" specifically because that folder already has wiring to master keys and sub-accounts (00:16:45–00:19:40).
- Secrets/private keys live in a `.env`, never in code (00:09:40, 00:20:04 "moving secrets into a ignored EMV").
- Each of the 3 bots runs on its own Hyperliquid **sub-account** (named informally "Gazi," "Cope," "Licks") for isolation (00:08:56–00:41:24; account names at 00:52:31–00:57:55).
- New/best bots deliberately withheld from the public GitHub to prevent "plug-and-play" copying (00:18:13–00:18:38).

## 5. Validation Criteria
- Robustness tests cited (00:02:29 "add a sample test, walk forward, etc.") including: cross-agent transfer with frozen params in a period where buy-and-hold lost money; testing a BTC-tuned strategy on ETH/SOL it never saw; out-of-sample walk-forward where out-of-sample Sharpe exceeds in-sample Sharpe; "cost survival of 3x commissions" (0.1% round trip ×3 = 0.3%) (00:06:43–00:08:55).
- Reported metrics: Sharpe ratios of 3.78, 4.16, 3.16, 5.36; backtest returns of 3,100%, 7,000–7,900%, 1,400% (00:00:26–00:00:40); chosen bots had out-of-sample results of 53%, 89% (Sharpe 5.92), and Sharpe 4.62 (00:07:35–00:07:56).
- Selection logic: least likely to be overfit, ranked "strongest to weakest" evidence; flagged that transaction cost/spread on "cascade bars" (32% flat single-print bars) was the family-wide weakness, not overfitting (00:06:43–00:08:47).

## 6. Risk Management / Position Sizing
- Start every new bot at **$10 position size** (the exchange minimum) — "I always use $10 size" (00:41:12, 00:14:44–00:14:50).
- No leverage to start ("no leverage," leverage set as a variable, "none to start") (00:04:20, 00:13:29).
- Market orders = true initially (fast scalping); toggle to limit orders (replace every 15 seconds, "chase" entry/exit) as a testable variable (00:10:39–00:11:23).
- Checklist requirements: check P&L at start of each run, only enter if no existing position, cancel all floating orders before placing new ones, correct decimal/size handling, and a resilient scheduler loop that restarts after outages (00:44:37–00:44:44, 00:13:29–00:14:44).
- Scale slowly if it works; kill if it doesn't ("If they are trash, I'll turn them off. If they're good, I'll keep them going. I'll scale them up." 00:56:32).

## 7. Deployment / Going Live
- All three bots built, "fully tested on live data with zero orders placed" as a dry run before going live (00:39:53–00:40:00, 00:56:59 "dry run is clean across the board").
- Went live same session with $10 across 3 sub-accounts (balances noted: 32.88, 84, 83, 52) (00:40:59–00:41:18).
- No formal alerting/monitoring system mentioned beyond manually watching P&L per run and being willing to kill underperformers.

## 8. Philosophy Quotes
- "The process I follow is research, back test, and then incubate." (00:03:08)
- "Just because it worked in the past doesn't mean it's going to work in the future." (00:00:19 / 00:14:50)
- "I believe AI is a great equalizer. I'm just going to put everything out that I find. Let everybody else cop about it." (00:04:57)
- "You have to in a business like this just keep making things better... because that's what everyone else is trying to do." (00:04:11)
- "Nobody's going to give you a million dollars... Use your brain, please." (00:11:49–00:12:12)

## 9. Pitfalls / Lessons / "Banned" Context
- Warns repeatedly against "plug-and-play" — running his shared example bots verbatim: "If you run somebody else's strategy, you're going to lose money. I promise you." (00:27:23–00:28:26) He frames his public GitHub as teaching examples only, not deployable alpha.
- Real bug encountered live: error caused by bot being placed in a subfolder; fixed by having the agent debug and offload calls to his own rate-limit-friendly API instead of hitting Hyperliquid directly (429 errors) (00:47:17–00:50:13).
- "Banned"/"killed it" context (00:22:19–00:25:16, per his AI's summarized research, presented as claim not verified fact): Anthropic's "Fable 5" and sibling "Mythos 5" were suspended by the US government 3–4 days after a June 9 launch. Trigger: Amazon (an Anthropic investor) allegedly ran a red-team jailbreak test showing Fable 5 could be manipulated to output cyberattack-relevant info, escalated to the White House; Anthropic was given ~90 minutes to pull both models over export-control/national-security concerns. He notes Anthropic's CEO reportedly refused the government's fix demands, escalating to the ban, and that the community "resurrected" Fable 5's behavior on top of 4.8 via leaked system prompts. He treats this as separate from the routine June 15 deprecation of Sonnet 4/Opus 4 from the API. Lesson drawn: he preserved the model's strategy output as static code/readmes before the model was pulled, so the strategies could still be rebuilt/run without needing the banned model again.

**Editor's note on this last section:** this "ban" story is relayed by the creator as something his AI's research summarized, not independently verified news — treat it as unverified color, not a fact to rely on. It has no bearing on the actual RBI process/workflow, which is what this workspace is built around.
