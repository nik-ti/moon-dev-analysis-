# Video 5: "Polymarket AI Agent That Stalks PROFITABLE whales"

**URL:** https://youtu.be/v21_H4K5FoI
**Duration:** ~26 min · **Channel:** Moon Dev

---

# Moon Dev — "Polymarket AI Agent That Stalks PROFITABLE Whales" — Process Breakdown

## 1. Tools & Stack
- **Claude Code** — primary build tool ("I'm going to use Cloud Code as as always" [00:01:32])
- **Cursor** — opened briefly near the end to edit docs/roadmap ("opening cursor here" [00:23:23])
- **Moon Dev API** (`api.moondev.com`) — his own hosted API, docs at moondev.com/docs; supplies the "profitable traders" list
- **Polymarket public activity feed / websocket** — live trade data with proxy wallet addresses (Polymarket's own feed, not Moon Dev's)
- **Python** — script execution ("Python, run it" [00:07:35], [00:22:51])
- **SSH into his own server** ("SSH HL node," described as "this big ass server that I'm cooking on" [00:13:38]-[00:14:43]) — runs services continuously
- **GitHub** — examples repo he updates with the final code [00:21:46]

## 2. Architecture — "Smart Money Whale Scanner"
No single named methodology in this video besides a general reference to his **"RBI system"** for algo trading (mentioned only in passing on the roadmap page [00:06:29], not elaborated here). The concrete build:
- **Two data sources combined**: (a) Moon Dev API's profitable-traders list, built by two internal discovery scanners — a "5-minute markets scanner" and a "trending scanner" that pulls the top 50 markets by 24h volume, filtering for traders with P&L "300 plus" [00:03:15]-[00:03:27], [00:15:24]-[00:15:31]; (b) Polymarket's own live activity feed/websocket, which has no P&L filter but exposes real-time buys with wallet addresses.
- **Logic**: watch live feed for buys above a dollar threshold; cross-reference the buyer's wallet against the profitable-traders list; if matched, tag with a "brain" emoji as "smart money" [00:12:11]-[00:12:17], [00:19:09]-[00:19:14].
- **Critical bug found live**: initial build polled Polymarket's REST API, which returned stale/cached data (showed zero trades for 25 seconds, which he flagged as "impossible" [00:18:52]-[00:18:59]). Fixed by switching to the websocket feed — validated with "451 in 15 seconds, truly real-time" [00:18:53]-[00:18:58], later "861 trades" in a 20-second test [00:19:56]-[00:20:03].
- Final feature: a "smart-only" toggle to filter the feed down to only tagged smart-money buys [00:09:59]-[00:10:13], [00:23:26]-[00:23:40].

## 3. How He Prompts Claude Code
Casual, conversational, spec-by-talking. Example opening prompt [00:01:54]-[00:02:30]: *"What I want you to do is to go ahead and use that API in order to build out this scanner. Essentially, what it will do [is] print out in the terminal all of the new big buyers... it'll run in a loop... There should be a parameter up top of what dollar amount [to start at]... you'll hit the API every 5 seconds on a loop. Okay, go ahead and check that out. You should have the Moondev API key already in the ENV."*
- Asks Claude to **explain its own findings** before building further: *"Can you look at the moon[dev] API here?... how do you derive those Polymarket traders? Does that use the live feed... Go ahead and explain that to me"* [00:14:04]-[00:14:23].
- When stuck, asks Claude to diagnose rather than guessing himself: *"it's been 20 scans with no outputs yet... can you explain this process and how it works? Should I just keep waiting?"* [00:14:52]-[00:15:07].
- Feeds Claude example code from his own roadmap when it's stuck [00:18:01]-[00:18:08].
- Accepts/rejects AI-suggested features conversationally ("smart-only toggle" suggested by Claude [00:09:59]-[00:10:13]; he says "Nah, I like that idea though" then later implements it himself [00:23:26]).
- Explicitly asks Claude to draft documentation "like you're talking to the documentation team" [00:23:58]-[00:24:06].

## 4. Workspace/Repo Structure
- `moondev.com/roadmap`: master library — RBI system, book list, and prior bot code (Polymarket hyperliquidation stat-arb bot, Polymarket 5-min bot, Polymarket redemption bot, Polymarket weather scanner, Polymarket whale scanner) [00:06:15]-[00:07:00].
- `moondev.com/docs`: live API documentation he updates after each build.
- Runs services persistently on his own server via SSH so the whale scanner is "in there at all times" and callable anytime [00:13:47]-[00:14:01].
- Storage math discussed explicitly: "~400 bytes at 5,000 trades per day... 2 megabytes [a busy day], ~700 megabytes over the year" [00:19:37]-[00:19:52].
- Final script saved and renamed ("Poly Market smart money whales"), kept running on-screen continuously next to HL trending/news dashboards [00:22:34]-[00:24:39].

## 5. Validation Criteria
Whale = buy over a dollar threshold (tuned live: $2000 → $1000 → $500 → back to $2000 → $3000, purely to force test data through [00:02:20]-[00:22:05]). "Smart money" = wallet also present on Moon Dev's profitable-traders list (P&L 300+, "real and confirmed"). Validated by watching live output match expectation: *"caught smart money dropping 108k on Coast Juk"* [00:09:54]-[00:09:58].

## 6. Risk Management / Position Sizing
Not covered in this video — no execution/copy-trading logic, only detection/tagging.

## 7. Deployment / Going Live
No formal paper-trading or incubation period shown; he runs the finished scanner immediately as a live terminal dashboard on his monitor. No alerting mechanism beyond terminal print statements.

## 8. Philosophy Quotes
- "Don't try this at home... if you do try it at home, make sure to do your own thing... bring your own ideas always." [00:01:11]-[00:01:21]
- "I verified this by probing the real API rather than trusting the doc summarizer, which was hallucinating." [00:08:23]-[00:08:28]
- "If you're not optimizing everything, you're crazy. AI could do everything for you." [00:25:08]-[00:25:12]
- "I don't care if a whale is trading. I want to see if they're a smart money whale, yes or no." [00:25:44]-[00:25:50]
- "We must keep going. If you can't fly, run. If you can't run, walk. If you can't walk, crawl. But by all means, keep moving." [00:26:04]-[00:26:22]

## 9. Pitfalls/Lessons
- Trusted an AI "doc summarizer" that hallucinated API capabilities — had to manually probe the real API to verify [00:08:16]-[00:08:28].
- Used the wrong data source first (cached REST polling) which silently produced zero results; caught it because zero trades across all of Polymarket in 25 seconds was implausible, then switched to websocket [00:18:52]-[00:19:05].
- Threshold tuning was pure live trial-and-error, not pre-planned.
