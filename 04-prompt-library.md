# Prompt Library

Copy-paste starting points for talking to Claude Code at each stage of the protocol. These are modeled directly on the verbatim prompt patterns found across the 10 source videos (see `01-master-report.md` §3) — the structure matters more than the exact wording: **state the mechanism, give explicit constraints, ask for a plan before a build on anything non-trivial, and dispatch multiple variants in parallel instead of one at a time.**

Fill in the `<...>` placeholders. Everything else can be used close to verbatim.

---

## Stage 1 — Research

### `research-ideation`
```
I have an idea for a trading strategy. Here's the mechanism I think creates the
edge: <your one-paragraph thesis from thesis.md>.

Before we write any code: sanity-check this mechanism. Does it make sense who's
on the other side of this trade losing money to it? Then propose 3-5 concrete,
testable rule variants of this idea — each one should be a precise entry/exit
rule I could hand to someone else and they'd implement it the same way I would.
Don't build anything yet, just explain the plan.
```

### `data-source-comparison`
```
I need historical <timeframe> data for <asset/market> to backtest an idea.
Pull the same data from <source A>, <source B>, and <source C> in parallel and
tell me which one is most robust — most bars, fewest gaps, cleanest format.
Launch an agent for each source and report back a comparison.
```

---

## Stage 2 — Backtest

### `backtest-request`
```
I want to backtest this rule: <precise entry/exit rule from Stage 1>.

Use the backtesting setup in /backtests. Data: <asset, timeframe, date range>.
Report back: total return, Sharpe ratio, max drawdown, number of trades, win
rate, and exposure time. Also run a buy-and-hold benchmark over the exact same
period so I can compare.
```

### `parallel-variant-dispatch`
*(This is the single highest-leverage prompt in the whole library — use it whenever you have more than one variant worth testing.)*
```
I have <N> variants of this strategy I want to test: <list each variant briefly>.

Launch <N> agents, one per variant, each running the backtest independently
against the same data and the same benchmark. When they're done, report back a
comparison table: return, Sharpe, max drawdown, trade count, and how each did
against buy-and-hold. Tell me which variant(s) look worth taking further and
which look overfit.
```

### `robustness-stress-test`
*(Run this on anything that passed the first backtest, before you believe it.)*
```
This strategy passed its first backtest: <summary/metrics>.

Now stress-test it:
1. Re-run with trading fees tripled from the base assumption.
2. Re-run on an out-of-sample period we haven't looked at yet, and on a
   different but related asset if one exists (e.g. tuned on BTC, test on ETH)
   with the exact same parameters, unchanged.
3. Tell me if the out-of-sample Sharpe holds up relative to the in-sample
   Sharpe, or collapses.
Flag anything that looks like it only works because of curve-fitting or
lucky sample selection.
```

### `metric-sanity-check`
*(Use whenever a number looks surprisingly good or just weird.)*
```
This result looks <surprising/too good/off>: <the specific number>.
Before I trust it — explain exactly how this number was calculated, step by
step, and double check it isn't a display bug, a look-ahead bias, or a
data leak. Short and concise.
```

---

## Stage 3 — Incubate

### `bot-build-spec`
*(The full checklist-style spec — dictate all of this in one prompt, matching Moon Dev's pattern of specifying constraints up front rather than iterating on missing ones later.)*
```
Build a live trading bot for this strategy: <rule from the passing backtest>.

Requirements:
- Entry/exit logic: <exact rule>
- Position size: $<amount> notional to start (incubation size, not final size)
- Leverage: <N>x, isolated, and make it an editable variable at the top of
  the config file — not hardcoded in the logic
- Stop-loss: <N>% and take-profit: <N>%, both required on every position
- Emergency kill switch: stop the bot entirely if account equity draws down
  more than <N>% from when it started
- One position at a time — no stacking
- Before placing any new order: check whether a position already exists, and
  cancel any outstanding orders first
- Poll/check every <N> seconds
- Log every order, fill, error, and restart to a file I can review later

Put this in /bots/<bot-name>/ with its own config.py for the variables above.
Copy any shared code from /lib into this folder rather than importing it, so
this bot is self-contained once it's live.
```

### `dry-run-verification`
```
Before we risk any real capital: connect this bot to <venue>'s live data feed
with real market data, but do not place any actual orders. Confirm symbol
resolution, price/size decimals, and order-construction logic all work
correctly. Show me the dry-run output.
```

### `deployment-migration-doc`
*(Use before any infra change that could affect a bot that's already live — mirrors Moon Dev's practice of writing a migration plan before touching working infrastructure.)*
```
I need to change <infra/dependency/API> that my live bot(s) depend on. Before
touching anything: write a migration plan as a markdown file — what changes,
what could break, and how we roll it out without disrupting bots that are
already running. Don't make the change yet, just the plan.
```

### `plain-english-explainer`
*(Useful for keeping your own docs honest, and for explaining a strategy to someone else without leaking the exact parameters.)*
```
Explain this strategy in three sentences or less, in plain English, to someone
who trades but isn't a programmer. Don't include the exact thresholds or
parameters — just the mechanism.
```

---

## Session hygiene

### `session-handoff`
*(Run this before closing a session with unresolved work — Claude Code doesn't remember previous sessions.)*
```
Before I close this session: write a short handoff note — what we were doing,
what's unresolved, and what the next step should be — so I can paste it back
in to pick up where we left off.
```

### `debug-verify-not-guess`
*(Use when Claude's first fix attempt doesn't sit right — don't accept a plausible-sounding explanation without verification.)*
```
That explanation doesn't match what I'm seeing: <what you actually observe>.
Don't guess — go verify directly against <the actual file/log/API response>
before proposing a fix again.
```
