# Project instructions for Claude Code

This is an algo-trading research workspace following the Research → Backtest → Incubate (RBI)
protocol. Full detail lives in the parent guide (`02-your-protocol.md`, `05-validation-and-risk-rules.md`,
`06-pitfalls-checklist.md`) — if those files aren't in this repo, ask the user for them.

## Rules you must always apply, without being re-asked

**Never skip stages.** If asked to build a live bot for an idea that hasn't been through a
documented backtest (or an explicit, written reason why it can't be backtested), say so and
ask whether to do the backtest first.

**Every bot you build must include, by default, unless the user explicitly says otherwise:**
- A stop-loss and take-profit on every position, set at entry
- A portfolio-level kill switch (default: shut down if equity draws down more than 50% from
  session start, unless the user specifies a different threshold)
- A check for an existing position before opening a new one
- Cancellation of stale/outstanding orders before placing a new one
- Leverage and position size as named, editable variables in a `config.py` (or equivalent),
  never hardcoded inline in trading logic
- Logging of every order, fill, error, and restart to a file

**Before building anything non-trivial, propose a plan first and wait for confirmation** rather
than building immediately — especially for anything touching a live bot's infrastructure.

**When asked to test more than one variant of an idea, default to launching parallel sub-agents**
(one per variant) rather than testing them sequentially, and report back a comparison table
(return, Sharpe, max drawdown, trade count, vs. buy-and-hold benchmark).

**Treat extreme backtest returns as a red flag, not a win.** If a backtest returns triple-digit
percentages or more, proactively suggest a fee-stress test (3x fees) and an out-of-sample /
cross-asset check before presenting the result as promising.

**Always benchmark strategy returns against buy-and-hold over the identical period** when
reporting backtest results.

**Before restarting, redeploying, or modifying infrastructure that a live/incubating bot
depends on, write a short migration/impact note first** and confirm no open positions will be
affected, rather than proceeding straight to the change.

**If closing a session with unresolved work, offer to write a short handoff summary** so the
next session can pick up context quickly.

## Folder conventions

- `research/YYYY-MM-DD_<idea-slug>/` — one folder per idea. Contains `thesis.md`,
  `backtest-summary.md`, `incubation-log.md`. Create new dated folders for new ideas rather
  than reusing old ones.
- `research/graveyard.md` — append a one-line entry for every idea that fails validation, with
  the reason. Check this before starting research on a new idea to avoid repeating a killed one.
- `lib/` — shared reusable code (exchange wrappers, indicators, account helpers). When a bot
  goes from backtest to incubation, **copy** the relevant code from `lib/` into the bot's own
  folder rather than importing it live, so a later change to `lib/` can't silently alter a bot
  that's already trading.
- `bots/<bot-name>/` — one folder per live/incubating bot, self-contained, with its own
  `config.py` for size/leverage/risk variables.
- `docs/strategies-live.md` — keep this updated with what's currently incubating or scaled, and
  why, whenever a bot's status changes.

## What NOT to do

- Don't suggest running someone else's published bot or "signal service" strategy as-is.
- Don't recommend high leverage (above ~2x) for anything still in incubation.
- Don't present a backtest result without its buy-and-hold benchmark alongside it.
- Don't skip writing `thesis.md` before building a backtest — the mechanism must be stated
  before the code.
