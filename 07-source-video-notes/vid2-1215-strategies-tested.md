# Video 2: "Fable 5 Tested Over 1,215 Trading Strategies (Here's What Works)"

**URL:** https://youtu.be/iW2Y4tMGjec
**Duration:** ~13 min · **Channel:** Moon Dev

---

# Fable 5 Video Analysis — Moon Dev's Trading Bot Development Process

## 1. Tools & Stack
- **Fable 5** — the AI coding agent/model he runs in what appears to be a Claude Code-like terminal interface; central tool of the video (00:00, 00:13-00:16)
- **Claude Code** — explicitly named as the platform enabling sub-agents: "If you know about Cloud [Claude] Code, you're able to make these sub agents" (04:55-04:57)
- **Multiple terminals** running Fable 5 in parallel — "5 different agents up here... 5 different agents down here" (04:39-04:50)
- **Moon Dev API** (moondev.com/docs) — proprietary data source, includes liquidation data (04:05-04:08, 09:42-09:47)
- **GitHub** — results pushed here, restricted to course members (10:14-10:33)
- **$200/month plan** — his Claude subscription tier (02:47-02:48)
- No specific mention of a broker/exchange, Cursor, or ChatGPT in this video.

## 2. Named Framework: RBI
Explicitly named: "This is the RBI system" (04:12). Stages in his own words:
- **Research** — "simply research ideas" / "I got an idea, liquidations" (00:53, 05:30-05:32)
- **Backtest** — "back test those ideas... see if they work in the past" (00:55, 05:32-05:36). "If they work in the past, they're not guaranteed to work in the future, but they're much more likely." (05:37-05:40)
- **Incubate** — "build a bot with small size... $10 size" and "let them run" (01:12-01:13, 05:41-05:45)

## 3. How He Prompts the AI
He gives a single narrated prompt, repeated verbatim across multiple terminal instances:
> "I want you to go ahead and launch five agents here to look through those June 10th folders... those are what we did Fable 5 on. I want you to do the same thing here, but go deeper. And then use the 1,366 different backtests we have to learn different ideas that you can apply to this... have five different agents each find five new backtests and keep going until they beat these three above." (01:45-02:31)

Before launching, he grounds the agent in real data: "let me grab the exact data paths and benchmark configurations from the three live winners. So each agent works against the same real data and knows exactly what number to beat." (03:25-03:39)

Follow-up prompt after results: "for the top three strategies, please go ahead and explain them in three sentences or less in layman's terms" (06:42-06:47), then a final instruction: "please push all of this to GitHub." (12:16-12:20)

Style: conversational, addresses the agent ("Model, let's do it again" 02:12-02:14), gives it a target to beat rather than a spec to follow, and treats it as a semi-autonomous collaborator rather than a code-completion tool.

## 4. Workspace/Repo Structure
- **Sub-agent architecture**: he has a custom Claude Code sub-agent called "**backtest architect**" — "I built a backtest architect that essentially knows how to backtest for me... she follows [my specific backtesting formula] as well." (04:25-04:57)
- **Dated folders**: results organized by date, e.g. "June 10th folders" (01:49-01:52), "June folders" (01:35-01:37)
- **Parallel multi-agent, multi-terminal batch testing**: 5 agents × 2 terminal runs = 10 agents this session, each spawning 5 new backtests → up to 25 new tests per batch, on top of the existing 1,366. Previously ran it "like six times" but ran out of Claude credits (02:43-02:48)
- Run time: one full batch took **34-37 minutes** (07:27-07:34)

## 5. Validation Criteria
- **Sharpe ratio** is his primary quality filter — cites 3.75, 3.89, 3.65, 4.53, 4.69, 4.67 as "really good" (05:24-05:27)
- **Return %** as headline number but treated skeptically at extremes — "These are probably overfit up here at 624,000% return, but 1,000% return, that's great." (00:34-00:39)
- **Drawdown** — "pretty low" mentioned as a pass condition (07:30)
- **Overfitting flags**: high nominal returns (4,783%, 2,450%) trigger "Probably some over-fitting going on. I would want to go ahead and do robustness tests next." (07:16-07:18) — robustness testing is his next-step filter, though not detailed further
- **Fee-stress test**: "When we tripled the trading fees, it still made 576% while your current best only made 206%." — resilience under higher costs used as a differentiator (10:39-10:48)
- Filtering out of the large pool: only "three out of the thousands" (01:35-01:37) get promoted to live incubation, chosen by live/incubated performance, not backtest alone.

## 6. Risk Management / Position Sizing
- Incubation starts with **very small size ("$10 size")** before scaling (05:44-05:45)
- After incubation, winners get scaled: "Two of them did well, one of them did great. I'm scaling one of them." (05:48-05:53)
- No stop-loss %, leverage, or portfolio allocation rules given — not covered in detail.

## 7. Deployment / Going Live
- Three-stage funnel: backtest → small-size ($10) live incubation → scale winners
- "back testing is a good indicator of what worked in the past, but the past is not necessarily the future" — hence live incubation is mandatory before trusting a strategy (01:40-01:47)
- Fable 5 was down 2 weeks prior; of 3 incubated bots, "one of these three bots is absolutely printing" (01:15-01:20)

## 8. Philosophy Quotes
- "Nothing is plug-and-play. I'm not going to tell you exactly which bot to run." (05:53-05:57)
- "I would rather teach you how to fish for the rest of your life." (05:57-06:01)
- "We all know that back testing is a good indicator of what worked in the past, but the past is not necessarily the future." (01:40-01:45)
- "Please go ahead and cook harder." (01:28-01:30)
- "Everything I do I share live." (03:59-04:01)

## 9. Pitfalls/Lessons
- Extreme returns (100,000%+, 624,000%) are red flags for overfitting, not wins (00:33-00:37)
- Ran out of Claude credits doing 6 parallel batches previously — a real resource constraint (02:43-02:48)
- Public backlash after prior video: "People were like, 'Oh, overfit, yada yada.'" — prompted him to add the incubation stage as validation beyond backtesting (01:07-01:13)
- What separated winners: strategies that held up under **tripled fees** and had fewer, higher-conviction trades ("Fewer high-conviction trades, which is exactly why it holds up well when fees go up" — 12:07-12:11) outperformed higher-frequency, higher-nominal-return strategies.

**Note**: The transcript consistently says "1,366" backtests, not "1,215" as in the video title — likely the title reflects an earlier/different count than what's shown on screen in this recording.
