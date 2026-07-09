# Video 4: "Polymarket's Biggest Cheat Code"

**URL:** https://youtu.be/GtY19Ft3dm0
**Duration:** ~11 min · **Channel:** Moon Dev

---

# "Polymarket's Biggest Cheat Code" — Process Breakdown

## 1. Tools & Stack
- **Polymarket** — the prediction market platform itself (Activity tab referenced as the "amateur" tool at 00:01:09).
- **Cursor** — his code editor, explicitly opened on screen ("let's go ahead and say open the cursor here," 00:10:08–00:10:13). No Claude Code usage is shown or named in this particular video.
- His own custom tool: **"Polymarket Whale" / "Polymarket Smart Whale Scanner"** (00:10:02–00:10:08) — a dashboard built on Polymarket's data/API that shows live trades plus each trader's P&L (daily/weekly/monthly/yearly).
- Distribution: his **moondawg.com/roadmap** site, "Code from videos" section, where the scanner's code is posted (paywalled at "$5" for non-Zoom attendees, free for live Zoom members) (00:09:48–00:10:52).

## 2. Named Framework / The "Cheat Code"
No formal named methodology, but the cheat code is described concretely: he built two capabilities separately — (a) a way to identify which Polymarket wallets are actually profitable, and (b) a way to see all large trades — then **merged them into one scanner** (00:00:18–00:01:00). This filters out "bumps" (noise/small, low-signal trades that dominate the raw Activity tab, 00:01:07–00:01:18) and surfaces only large trades made by wallets with proven profitability across multiple timeframes. He explicitly states he is **not copy-trading** — he uses the scanner to **reverse-engineer** what edge a profitable trader has in a given market category, then **builds his own automated bot** to replicate that edge independently (00:01:53–00:02:11, 00:08:30–00:08:35).

## 3. Prompting / Talking to AI
Not covered in this video — he opens Cursor at the very end only to scroll through already-written code; no live prompting, no Claude Code session, no verbal instructions to an AI model are shown.

## 4. Workspace / Repo Structure
Minimal detail: a public roadmap site (moondawg.com/roadmap) organized by "Code from videos," where each video's build is posted. Live Zoom attendees get code free/first. No folder structure, cron jobs, or multi-agent setup are shown, though he floats the idea of adding a filtering layer: "I can put a little human verification in between it. You want to put some AI stuff in there? Sure." (00:08:24–00:08:27) — suggesting a future agentic filter on top of the scanner, not yet built.

## 5. Validation Criteria
He validates a trader's signal by checking **P&L across multiple timeframes** (today/7-day/monthly/yearly) before trusting it — e.g., rejects a trader who's up today but "down bad on the weekly": "Get him out of here" (00:08:42–00:08:45). He also checks whether the trader's activity is concentrated in a specific niche (tennis, Counter-Strike, eSports) as a sign of a repeatable, learnable edge rather than luck (00:03:42–00:03:48, 00:07:36–00:07:43). He self-corrects mid-analysis rather than trusting numbers blindly: "He's printing... Take that back. He's not printing." (00:05:50–00:05:59).

## 6. Risk Management / Position Sizing
Not detailed with numbers. Only a category-level rule: he personally **avoids trading sports and crypto markets** on Polymarket because he already has "plenty of exposure to crypto" elsewhere (00:08:47–00:08:57) — a portfolio-concentration/diversification consideration, not a stop-loss or sizing rule.

## 7. Deployment / Going Live
Barely covered. He references already having "a bot that trades tennis" live (00:05:01–00:05:05) built from this same reverse-engineering process, and states intent to build a new bot around "stock prediction" markets he just discovered via the scanner (00:09:34–00:09:43). No paper-trading/incubation/monitoring process is described in this video.

## 8. Philosophy Quotes
- "I believe AI is a great equalizer... AI allows everybody to code." (00:02:02–00:02:09)
- "This is just such a better way to find ideas than just like trying to think of them yourself." (00:05:59–00:06:03)
- "There's unlimited markets to trade. So unlimited ideas. Meaning you can play this game forever." (00:06:49–00:06:57)
- "I'm not copy trading either." (00:02:18–00:02:20)
- On grit vs. talent: "You might be smarter than me... but if we get on the treadmill together... you're getting off first, or I'm going to die. It's really that simple." (00:02:36–00:02:52)

## 9. Pitfalls / Lessons
- Warns against watching Polymarket's raw Activity tab and copy-trading obvious "bumps" — that's what amateurs do (00:01:07–00:01:18, 00:02:13–00:02:20).
- High recent P&L can be misleading: several "smart" wallets he inspects are simply buying near-resolved markets at 97–99 cents (essentially riskless, providing exit liquidity), not real predictive edge (00:01:21–00:01:46, 00:05:19–00:05:47) — a caution against mistaking low-risk arbitrage for skill.
- He catches and corrects his own live misread of a trader's performance, modeling skepticism toward raw dashboard numbers (00:05:50–00:05:59).
