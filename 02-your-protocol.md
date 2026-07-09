# Your Protocol: Research → Backtest → Incubate (adapted for a beginner working solo with Claude)

This is the RBI framework from `01-master-report.md`, turned into an actual step-by-step procedure you run every time you want to test a new trading idea. Print this out or pin it — this is the loop you repeat forever.

**Ground rule, non-negotiable:** never skip a stage, and never let real capital touch a strategy that hasn't been through all three. This single rule is the difference between Moon Dev's system and the mistake that cost him his first $10,000 (see `01-master-report.md` §8).

---

## Stage 0 — Before you start a new idea

- Confirm your workspace is set up (`03-workspace-setup.md`). Do this once, not per-idea.
- Open a new dated folder for this idea: `research/YYYY-MM-DD_<idea-slug>/`. Everything about this idea lives here.
- Write a one-paragraph **thesis** in `thesis.md` inside that folder before you touch code: what's the mechanism you think creates the edge? Not "price goes up after X pattern" — *why* would that be true, and who is on the other side of the trade losing money to it? If you can't answer that, you don't have a thesis yet, you have a pattern you noticed. Go back to Research.

## Stage 1 — Research

**Goal:** turn a vague hunch into a specific, testable rule.

1. Write down the mechanism (Stage 0 thesis).
2. Convert it into precise, testable conditions: what data do you need (price, volume, order book, liquidations, whale wallets, macro releases)? What exact trigger fires an entry? What exact trigger fires an exit?
3. Use the `research-ideation` prompt in `04-prompt-library.md` to have Claude Code sanity-check the mechanism and propose 3-5 concrete rule variants — don't just have it write code yet.
4. Pick the variant(s) worth backtesting. If you have real doubt between 2-3 versions, don't debate it in your head — carry all of them into Stage 2 and let the data decide (this is Moon Dev's "launch N agents" move — see below).

**Exit criteria for Stage 1:** you can write the entry/exit rule in one unambiguous sentence a stranger could implement without asking you a clarifying question.

## Stage 2 — Backtest

**Goal:** filter out ideas that don't survive contact with historical data. A pass here is not proof — it's just "not obviously trash."

1. Use the `backtest-request` prompt template to have Claude Code build (or reuse) a backtest for your rule against real historical data.
2. If you're testing multiple rule variants from Stage 1, use the **parallel-agent dispatch pattern** (`04-prompt-library.md` → `parallel-variant-dispatch`): ask Claude Code to launch several sub-agents, each testing one variant, and report back a comparison table. This is the single highest-leverage habit in the whole system — don't test ideas one at a time when you can race several at once.
3. Run every result through the checklist in `05-validation-and-risk-rules.md` before you get excited about any number. In particular:
   - Compare against buy-and-hold over the same period. A strategy that "returns" less than buy-and-hold but with much lower drawdown can still be worth it — a strategy that returns more than buy-and-hold with similar or higher drawdown usually isn't.
   - Treat huge returns as a red flag, not a win. Ask Claude to re-run at 3x fees and on an out-of-sample asset/period before you believe it.
4. If it fails, don't debug it into passing — that's how you curve-fit. Kill it and go back to Stage 1 with a different mechanism, or note it in `research/graveyard.md` and move on.
5. If it passes, write a short `backtest-summary.md` in the idea folder: the rule, the metrics, the benchmark comparison, and any caveats (thin data, single-regime, etc.) — be honest about the caveats now, in writing, before you're emotionally attached to the result.

**Exit criteria for Stage 2:** a written summary with metrics that clear the bar in `05-validation-and-risk-rules.md`, or an explicit decision to skip backtesting (see below) with a documented reason.

**When to skip straight to Incubate:** some markets can't be meaningfully backtested (thin historical order-book data, prediction markets, brand-new venues). If that's true for your idea, say so explicitly in writing, and go to Stage 3 with the smallest possible size. Don't quietly skip backtesting because it's inconvenient — only skip it when it's genuinely not possible, and document why.

## Stage 3 — Incubate

**Goal:** find out if the edge survives contact with live, real conditions (latency, slippage, your own execution bugs) — with money small enough that being wrong doesn't matter.

1. **Dry run first.** Connect the strategy to the live venue with real data but zero orders placed. Confirm order sizing, decimals, symbol resolution, and error handling all work before any capital is at risk.
2. **Go live with trivial size.** $5-$10 notional, or the exchange minimum, whichever is smaller. See `05-validation-and-risk-rules.md` for the full risk checklist (stop-loss, kill switch, position-check-before-entry) that must be wired in before this step, not after.
3. **Watch it manually** for the first stretch — don't walk away yet. You're watching for bugs (duplicate orders, wrong-side fills, stuck positions), not for the P&L to be impressive. A correct bot that's flat is a success at this stage; a profitable bot with a duplicate-order bug is a disaster waiting to happen.
4. **Log everything.** Every trade, every error, every restart, in `incubation-log.md` inside the idea folder. You will need this later to decide whether to scale or kill.
5. **Decide, in writing, before you start:** how long does incubation run before you make a scale/kill decision, and what does "doing well" mean numerically? Don't decide this after you see the results — decide it now, in Stage 3 step 0, so you're not rationalizing after the fact.
6. **Scale or kill.** If it cleared your pre-written bar, increase size in increments, watching each increment before the next. If it didn't, kill it — no sunk cost. Either way, write the outcome in `incubation-log.md` and archive the idea folder.

**Exit criteria for Stage 3:** a written scale/kill decision with the reasoning, logged before you touch size again.

---

## The loop

```
Stage 0 (thesis) → Stage 1 (Research) → Stage 2 (Backtest) → Stage 3 (Incubate) → repeat
                                              ↓ fail
                                        graveyard.md, back to Stage 1
```

Run this loop on a schedule, not sporadically — Moon Dev's own framing of a working day is "I'm either researching, backtesting, or incubating" (`01-master-report.md` §1). Pick which of the three you're doing before you sit down, rather than drifting.
