# Video 1: "Fable 5 is BACK Trading Better Than Ever"

**URL:** https://youtu.be/mRHzwlsU_s0
**Duration:** ~104 min · **Channel:** Moon Dev
**Type:** Livestream — market watching + live infra debugging, not a strategy-building tutorial.
**Note:** Auto-captions consistently mis-transcribe "Claude"/"Claude Code" as "Fable"/"cloud code."

---

# "Fable 5 is BACK Trading Better Than Ever" — Transcript Analysis

**Important context finding:** This video is atypical for the channel's usual "build a strategy" format. It's ~70% live market-watching/chat banter, ~20% live debugging of a real bug in his custom trading app with Claude Code, and ~10% a course sales pitch. There is **no RBI framework walkthrough, no strategy-building session, and no backtest metrics discussion** in this particular video — it's a livestream, not a tutorial. Note: auto-captions consistently mangle "Claude" as "**Fable**" and "Claude Code" as "**cloud code**" throughout (confirmed by the literal Anthropic safeguards announcement he reads aloud at 00:08:55–00:09:25, which name-drops "Opus 4.8" — this is Anthropic's real model-update copy, mis-transcribed). He also refers to Claude Code as "she/her" — it's his personified, voice-driven coding assistant.

## 1. Tools & stack
- **Claude Code** ("Fable 5"/"cloud code") — his primary dev tool, used via voice dictation while multitasking (00:00:00, 00:08:19).
- **Opus 4.8** — fallback model Anthropic routes flagged requests to (00:09:21-25).
- **"Frugal Claude" plugin** — viewer-recommended plugin to cut token spend, he endorses it (00:08:01-05).
- **Moon Dev App** — his own "vibe coded" Electron desktop app that wraps Claude Code with a multi-tab terminal manager for running bots (01:01:10-14, "of course it's ghetto... it's vibe coded. By me.").
- **Python** — bots run via `cd` into repo + `python <file>.py` (01:26:08-11).
- **GitHub** — two repos: "trading bot GitHub" and "AI agents GitHub" (01:32:37-44).
- **Exchanges/data**: Hyperliquid (fartcoin, 10x max leverage noted, 00:21:36-40), Binance (order-book buy/sell data), Axiom (Solana trading terminal), Soul Scan (Solana token scanner), Polymarket (he still actively trades it), ES1/SPY futures feeds.
- **Moon Dev API** — his own liquidation-data API (2 years of data), positioned as worth "$900/month" elsewhere (01:29:31-37).
- **$200/month** spent on AI credits total (01:42:57).

## 2. Named frameworks/methodologies
Not covered in this video. No mention of "RBI" or any named repeatable process. The only process language is generic: "test your own stuff... get rid of the trash" (00:30:02-05).

## 3. How he prompts/talks to the AI
Fully conversational/voice-driven, treating Claude Code like a remote engineer:
- He states an observed symptom + his own hypothesis, then hands off: *"Can you double confirm this because I'm on my computer I'm not able to see this and this would make a lot of sense because... you know, I'm watching these bots live trade..."* (00:46:07-40).
- He explicitly gates action before building: *"Don't build it yet, but um... explain it to me if we can do it"* (01:08:26-28), then after seeing the plan: *"Yes, do piece one through three. Let me know when you're done with it."* (01:10:54-58).
- He **bluntly rejects wrong diagnoses**: *"That's not it, bro... Nah, blood. It's not it. That's not the answer because I'm looking through all the tabs and they are not there."* (01:00:19-33) — pushes the AI to keep digging rather than accept a plausible-sounding but unverified fix.
- Before any risky action (restarting an app with live bot positions), he demands explicit verification: *"Confirm with the all three bots are fully off. No hedging on this one. I checked every angle, okay."* (01:23:06-10).
- **Session handoff practice**: since restarting Claude Code wipes its memory, he manually copies its summary of the fix into a note before closing: *"I'll need to send it back to you so you can be up to date."* (01:12:53-01:13:00, "session handoff here").

## 4. Workspace/repo structure
- Custom **Electron app ("Moon Dev App")** hosts multiple terminal tabs, each running a separate live bot process (PTYs) — described as his home-grown alternative to plug-and-play bot dashboards (00:59:08, 01:00:00-19).
- Routine to restart/scale a bot: copy repo path → `cd` into it → `python <bot>.py` in a terminal tab (01:25:53-01:26:11).
- Bug found live: terminal PTYs live in Electron's **main process** and survive renderer reloads; the saved-tabs file doesn't persist terminal IDs, so app restarts spawn new tabs while old bot processes keep running invisibly ("zombies"/"orphaned PTYs") — diagnosed via `main.js` and `terminal.js` (01:04:20-01:06:59).
- Fix applied live: make app quit actually kill all PTYs, and kill on renderer reload too (01:09:14-01:10:54).
- No mention of cron jobs or multi-agent orchestration in this video.

## 5. Validation criteria
Not covered in this video with concrete metrics. Only a general filter is stated: *"Backtest. Get rid of all the trash. Test with small size."* (00:30:02-05). He references a bot's "7-day" and "30-day" look "great"/"good" (00:26:42-48) without disclosing numbers.

## 6. Risk management / position sizing
Not covered in detail. Only "test with small size" (00:30:05) and "I'm going to scale that one bot" incrementally once it's "cooking" (00:43:29-37) — i.e., gradual position-size scaling for bots showing live results, no stop-loss/drawdown rules given.

## 7. Deployment / going live
Not covered in this video (no paper-trading/incubation discussion). He does show live monitoring of already-deployed bots and confirming they're truly stopped before restarting infrastructure (01:23:06-10).

## 8. Philosophy quotes
- "Plug and play is impossible because then my edge deteriorates when somebody with big cash comes through." (00:27:42-46)
- "I believe code is great equalizer." (~00:32:32-34, paraphrase area near 00:53)
- "Trading should not be fun. Gambling is fun, right? So if you're having fun trading, like, you're kind of gambling." (01:28:13-18)
- "The stuff I built last year helps me build today. It actually compounds while trading by hand just does not compound." (01:34:10-14)
- "Money is simply a tool... it's simply a tool to open up things you don't know." (01:35:12-17)

## 9. Pitfalls/lessons
- **Architecture lesson from the live bug**: "Never run long-lived bots inside app tabs because any restart orphans them" — his own Claude-Code-diagnosed takeaway (01:07:37-39).
- Vibe-coded tools will have bugs: "Of course it's ghetto... it's vibe coded." (01:01:10-14)
- Don't trust an AI's first diagnosis on infra bugs affecting live capital — verify before restarting anything that could kill open positions (01:00:19-33, 01:23:06-10).
- Beginners shouldn't expect "plug and play" bots to work — copying others' exact strategies causes alpha decay (00:27:33-46, 00:29:00-10).
