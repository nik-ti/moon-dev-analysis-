# Video 6: "36 Polymarket Agents Trading is Unfair."

**URL:** https://youtu.be/JaA__oWgjwo
**Duration:** ~21 min · **Channel:** Moon Dev

---

# "36 Polymarket Agents — Trading is Unfair" — Process Breakdown

## 1. Tools & Stack
- **Claude Code** — sole AI tool, run as **6 parallel sessions/tabs**, each spawning 6 internal sub-agents (36 total) [00:00:00, 00:01:50-58]. He pays **$200/month** (Claude subscription) [00:04:11-15].
- **Polymarket** — the trading platform/exchange itself.
- **Polymarket GitHub repo** — his own private codebase of "70+ bots" already built/tested [00:04:27-40, 00:08:35-37].
- **Polymarket Smart Whales scanner** — his own wallet-tracking tool, references a "39k profitable wallet list" [00:00:57-59, 00:16:31-32].
- **UMA oracle** (transcribed as "Yuma") — resolution oracle referenced for an "oracle front-run" strategy [00:14:31-41].
- **Pinnacle / Betfair** — sportsbook no-vig lines used as a fair-value reference [00:09:13-14].
- **CME FedWatch** — fair-value source for Fed-decision markets [00:17:19-21].
- **BLS/Fed data releases** (CPI, jobs, FOMC) — machine-readable source for scheduled-print sniping [00:08:53-14:59].
- **Kashi** — mentioned but explicitly *not* integrated (no cross-venue arb capability yet) [00:16:29-32].
- **moondev.com/roadmap** — his own paid ($5/day Zoom) content hub where all this code/ideas get shared [00:00:17-19, 09:32-42, 21:05-07].

## 2. Named Framework / Multi-Agent Architecture
No formal name beyond "the roadmap" process: **research → backtest → incubate small → scale**. Note: Polymarket can't be backtested, so incubation with small size substitutes [00:01:06-22]. The 36-agent structure is literally **6 Claude Code sessions × 6 sub-agents each = 36** — he calls out the coincidence: "6 by 6 equals 36. And today is 6/6" [00:13:55-14:02]. Each of the 6 sessions gets the identical prompt, and each session's top-level Claude Code instance launches 6 of its own sub-agents to each independently mine the codebase and propose one best idea, then report back "six total great ideas" per session [00:03:00-03:04]. Orchestration is manual/parallel browser or terminal tabs — no cron/queue system shown for the ideation phase itself.

## 3. Prompting Style
Verbatim prompt sent identically to all 6 sessions [00:02:28-03:04]:
> "I want you to go through my Polymarket files here and look at the ideas that I've tried so far. And I want you to launch six different agents in order to come up with the absolute best idea they have for Polymarket building out a bot that could generate alpha. So, we've built a ton of bots here on Polymarket. You can see all of them in this directory. So, you just need to launch six agents to each come up with their absolute best one, and then you send me back six total great ideas that I can then attack in order to build bots and see if they work in the future."

Style: short, conversational, delegates orchestration ("launch six agents") to Claude Code itself rather than manually spinning up each one. He copy-pastes the same prompt across tabs, occasionally catching mistakes ("Did I send this to the wrong directory? I did." [00:04:16-18]).

## 4. Workspace / Repo Structure
- Single "Polymarket" directory/GitHub repo containing all 70+ prior bots plus "key idea strategy docs" that agents read first [00:04:24-27].
- No mention of cron jobs, agent folders, or monitoring dashboards in this video — this session is purely ideation, not deployment orchestration.

## 5. Validation Criteria
Purely manual triage against his own domain knowledge/constraints, not a formal scoring rubric (though agents self-report confidence, e.g. "confidence eight out of 10" [00:09:14], "confidence 7 out of 10" [00:15:34]). He rejects ideas for concrete infra/knowledge gaps: "NBA season's almost over" [00:07:22-23], "I don't have call sheet set up" [00:07:44-45], "I don't have Kashi set up" [00:16:29-32], "I don't know tennis well enough" [00:14:29-31]. Accepted ideas get copied into a running notes doc he keeps building on ("This gold, I have it here. I'm just going to keep adding to this" [00:19:11-16]).

## 6. Risk Management / Position Sizing
Not covered in detail — only the general incubation principle: "you don't want to be like me and just launch a bot right away... you then incubate with small size" [00:01:12-22]. No specific stop-loss or capital-allocation numbers given.

## 7. Deployment / Going Live
Not covered in this video — session ends at idea-triage stage; live deployment mechanics referenced only via the external "roadmap"/Zoom content [00:00:17-19, 21:03-07].

## 8. Philosophy Quotes
- "I like to kind of spam AI. Why not? I'm paying 200 bucks a month, might as well." [00:04:11-15]
- "If you can't fly, run. If you can't run, walk. If you can't walk, crawl, but by all means keep moving." [00:07:51-08:07]
- "I give away all my alpha. So, I have to go find more alpha... it's like putting a little fire into my booty." [00:05:11-42]
- "None of this is financial advice... they're not plug-and-play, that's for sure." [00:05:53-58]
- "Don't plug and play anything. Put in your own ideas." [00:09:59-10:01]

## 9. Pitfalls / Lessons
- Warns against his own past mistake of launching bots without incubation [00:01:12-15].
- Sent a prompt to the wrong directory by accident, had to redo it [00:04:16-20].
- Flags several of his own live bots as risky: "5-minute Polymarket bots... those are sketch, but be careful" [00:09:53-57].
- No cross-venue arbitrage possible without Kashi integration; multi-outcome markets lack the two-sided arb that two-way markets have [00:11:02-04, 16:29-32]. Video title's "unfair" framing isn't explicitly explained in-transcript — implied to mean 36 parallel AI agents mining a 70-bot proprietary codebase gives him an asymmetric idea-generation edge over manual traders.
