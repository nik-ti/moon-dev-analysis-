# Video 8: "Claude Code Found a 2,610% Trading Strategy While I Slept (Anchored VWAP)"

**URL:** https://youtu.be/RH52FuSbEpI
**Duration:** ~11 min · **Channel:** Moon Dev

---

## Trading Strategy Video Analysis — "Claude Code Found a 2,610% Strategy" (Moon Dev)

**1. Tools & Stack**
- **Claude Code** (auto-captioned as "Quad Code" throughout — confirmed via explicit reference "Claude code sub agents" [07:39-07:44]) is the only AI tool named/shown.
- Custom **Claude Code sub-agents**: he has built "eight sub agents on Claude" [07:32], including a dedicated **backtesting sub-agent / "back test architect"** [07:28-07:56] — a trigger word ("backtest") invokes it.
- Data: crypto only — BTC and ETH, across 5-minute, 6-hour, and 1-day timeframes [08:22-08:34]. No specific data vendor or broker/exchange named.
- Zoom is used for his paid community, not part of the technical stack.
- No mention of Cursor, ChatGPT, or other coding tools.

**2. "While I Slept" / Anchored VWAP Framework**
Despite the title, the transcript shows a **live, real-time session**, not an actual overnight unattended run — he watches two agents work for several minutes ("she's been sitting here for 6 minutes, 5 minutes" [02:03]), running "10 different back tests at one time" [00:27]. No overnight/unattended scheduling detail is described in this transcript.
- **Anchored VWAP (AVWAP)**: volume-weighted average price calculated from a chosen anchor point (swing high/low, earnings, FOMC, IPO date, trend start) rather than resetting each session like standard VWAP [00:49-03:03]. Formula sums from the anchor bar forward. Acts as dynamic support/resistance; price above = buyers in control, below = sellers in control [02:33-02:37]. Credited to trader Brian Shannon [03:46].
- Process: research → backtest → incubate (launch bot to confirm live) [05:49-05:53].

**3. Prompting Style**
Conversational, high-level, iterative — not a single fixed prompt is shown verbatim, but the flow is:
- "come up with ideas, see if they work in the past... Back testing helps get rid of all the trash." [00:36-01:24]
- After reviewing initial results: **"if you know that it's a trailing anchor, go ahead and test five new based off of that those new findings. And also, let me know when the other back tests are done."** [06:34-06:42]
- Agent responds and self-directs: "Good call. That's exactly the right correction. Launching a new agent now with the AVWAP as a trailing anchor behind the position instead of the trigger exit." [07:19-07:28]
This shows a loop: give a hypothesis → let sub-agents run parallel backtests → review stats → give a natural-language correction → agent launches a new test round autonomously.

**4. Workspace/Repo Structure**
Not covered in detail — no folder paths, filenames, or repo layout shown. Results are reviewed as agent-reported summary stats (return %, drawdown %, Sharpe) organized informally into "rounds" (pure AVWAP → AVWAP + liquidation combos → trailing AVWAP + liquidation).

**5. Validation Criteria**
No walk-forward or formal out-of-sample split is mentioned. His stated safeguard is comparing against a **buy-and-hold "base"** benchmark and a live-incubation stage:
- "AVWAP, all five hurt verse base... it got hurt, but it's at 2,610%. And this base is 32,000." [05:12-05:35] — i.e., the headline 2,610% actually **underperformed** a 32,000% buy-and-hold baseline.
- "these have to be confirmed in the future. That's why I follow a process of research, back test, and then incubate." [05:47-05:53]

**6. Risk Management / Position Sizing**
Not covered beyond drawdown figures reported per strategy (e.g., "222% with a 12% drawdown" [05:40-05:45]). No stop-loss or sizing rules discussed.

**7. Deployment / Going Live**
Only the general "incubate" step: "I go ahead and launch a bot to see if it actually works in the future" [05:53-05:57]. No paper-trading duration, monitoring, or alerting detail given.

**8. Philosophy Quotes**
- "Working in the past is nice, but it's just filtering out the trash." [05:57-06:01]
- "So, just searching through the trash like a little garbage man, okay?" [01:26-01:29]
- "They might work in the future, but it's not guaranteed." [01:19-01:22]
- "I didn't know how to code, either. But once you get to Cloud Code, you're not going to have to code anymore." [09:47-09:53]

**9. Pitfalls/Lessons**
- Headline 2,610% return actually **lost to the 32,000% buy-and-hold base** [05:12-05:35] — a reminder that raw returns without a benchmark are misleading.
- A "primary" AVWAP variant on ETH 5-min lost **-94%** [08:22].
- Best standalone AVWAP (2,610%, Sharpe 2.59) **did not improve** his existing liquidation-based strategies when combined — "they actually all flopped... negative, negative, negative" versus base returns of 872/774/684% [10:52-11:05]. Lesson: a strategy that looks strong in isolation can still hurt an already-profitable system when stacked.
