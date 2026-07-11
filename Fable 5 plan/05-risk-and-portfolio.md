# 05 — Risk & Portfolio Layer

Per-bot risk rules keep one bot from blowing itself up. This file adds the layer the source material mostly lacked: the rules that keep the *fleet* from blowing up the account — sizing, scaling, correlation, and the automatic responses to drawdown. Everything here is mechanical on purpose: computed by the Risk Officer agent, enforced by the shared risk module, decided (where a decision is needed) by you in the journal.

---

## 1. Capital structure

Split trading capital into named buckets, rebalanced monthly, never borrowed between:

| Bucket | Share | Purpose |
|---|---|---|
| **Reserve** | 40–50% | Not connected to any venue. The reason a bad month is survivable. |
| **Deployed** | 40–50% | Spread across live bots per the risk-budget rules below. |
| **Incubation** | ~5% | Funds all incubating bots. Expected to be lost slowly as tuition; the cheapest education in trading. |
| **Ops float** | ~5% | Data subscriptions, VPS, incidental costs — trading P&L and business costs kept visibly separate. |

## 2. Per-bot sizing: fractional Kelly with a hard cap

For each validated strategy, size from measured edge, then cap aggressively because every input is estimated with error:

1. Estimate full-Kelly fraction from the backtest+incubation trade distribution (win rate, payoff ratio — or expectancy/variance for continuous P&L).
2. Take **quarter-Kelly** (0.25×). Overbetting a mis-estimated edge is ruin; underbetting is merely slower — the asymmetry means you always round down.
3. Apply the hard caps, whichever binds first:
   - **Per-bot risk budget:** a bot may risk at most **1% of deployed capital** per trade (stop-distance × size), and hold at most **10% of deployed capital** as position notional. Leverage starts ≤ 2x, only ever raised as an explicit spec change through the pipeline.
   - **Capacity cap** from the spec: never above the size at which your own execution plausibly erodes the measured edge (thin-market bots hit this long before Kelly does).
   - **Untestable-market discount:** strategies that entered via the untestable-market exception cap at **half** the normal per-bot budget, permanently.

## 3. The scaling ladder (each rung = human gate #2)

From incubation size to full size in ~4 multiplicative steps, e.g. $10 → $40 → $160 → $640 → budget/capacity cap. Per rung:

- Minimum **2–4 weeks and ≥20 trades** at the current rung before requesting the next.
- Advance only if the rung's live results sit inside the expectation bands (cumulative P&L above Monte Carlo 25th percentile for that trade count; realized costs ≤ 1.5x modeled; zero unresolved execution bugs).
- **Slippage is re-measured at every rung** — size is the thing that changes it. Cost drift as size grows is the leading indicator of a capacity ceiling; hitting it is a *finding*, not a failure: cap the bot there and move on.
- One rung at a time, one bot at a time per venue (don't scale two bots into the same book the same week — you can't attribute the cost changes).

## 4. Portfolio heat: the rules above the bots

Computed by the Risk Officer weekly and before any scaling approval:

- **Aggregate open risk cap:** sum over bots of (per-trade risk × max concurrent positions) ≤ **6% of deployed capital**. New bots don't get funded past this — something must retire or descale first.
- **Correlation cap:** pairwise correlation of daily returns between live bots is estimated (once ≥ 30 shared live days). Any pair sustained > 0.6 is treated as **one bot** for risk-budget purposes (their budgets merge). Ten momentum bots on ten coins is one bet — this rule makes the accounting say so.
- **Edge-family concentration:** no single edge family (carry, flow, behavioral, latency — tag every spec) above **40%** of deployed capital.
- **Venue concentration:** no single venue above **50%** of deployed capital (venue risk — outage, rule change, insolvency, regulatory action — is real and uninsurable at this scale). Prediction-market venues combined ≤ 30% while your evidence there is incubation-heavy.

## 5. Drawdown response: automatic, graduated, pre-written

Per bot (enforced by the bot's own risk module):
- Hard stop-loss + take-profit at entry, always; a time-stop always exists (no position without a maximum holding period).
- Bot-level drawdown tripwire: live drawdown beyond the Monte Carlo 95th percentile for its trade count → bot **auto-descales one rung** and flags for review. A second breach after descaling → auto-halt, kill/keep decision goes to you.

Portfolio level (enforced by the independent watchdog, per `04-autopilot-architecture.md` §6):
- Deployed-capital drawdown **−10% from high-water mark** → fleet-wide descale one rung, no new deploys until recovered or reviewed.
- **−20%** → flatten and halt everything, full-stop review before any restart. This is the kill switch: dumb, separate, and never argued with. (The source material's ±50% example is far too loose for a fleet — by −50% the lesson has already cost more than it teaches.)
- Any single day where fleet P&L is worse than the worst backtested day across all bots combined → automatic same-day review flag; something is correlated that wasn't supposed to be.

## 6. Operational risk rules

- **One bot = one sub-account/wallet = one `.env` = one PM2 process.** No shared keys, no shared balances. Blast radius is always one bot.
- **No-withdrawal API keys** wherever the venue supports scoping. On-chain venues (Polymarket, Hyperliquid) use a dedicated hot wallet per bot holding only that bot's allocation; sweeps to the reserve wallet are manual, by you.
- **Deploys only from git via the deploy script** (which checks for the decision-journal approval line). No hand-edited code on the VPS; a diff between the repo and the server is an incident.
- **Every bot answers a heartbeat**; a missed heartbeat pages you. A bot you can't observe is a bot that's off — unobserved-but-running is the forbidden state.
- **Restart safety:** every bot must be safe to kill and restart at any moment (reconciles venue state on startup: open positions, open orders, then resumes). PM2 will restart bots at 3am without asking you; write them accordingly.
- **Monthly key & permission audit** (Ops drafts, you verify): what keys exist, what they can do, when last rotated.

## 7. The numbers on one page

| Rule | Value |
|---|---|
| Kelly fraction | 0.25× full Kelly, then caps |
| Per-trade risk per bot | ≤ 1% of deployed capital |
| Per-bot notional | ≤ 10% of deployed capital |
| Starting leverage | ≤ 2x |
| Aggregate open risk | ≤ 6% of deployed capital |
| Pairwise bot correlation treated-as-one threshold | > 0.6 |
| Edge-family cap | ≤ 40% of deployed |
| Venue cap | ≤ 50% of deployed (prediction venues combined ≤ 30% initially) |
| Untestable-market bot cap | ½ normal budget |
| Scaling rung | ~4× per step, ≥ 2–4 weeks & ≥ 20 trades each, human-gated |
| Bot auto-descale | live DD > MC 95th percentile |
| Fleet descale | −10% from HWM |
| Fleet halt (kill switch) | −20% from HWM, independent watchdog |
| Incubation size | $5–25 notional |

These numbers are defaults, not physics. Change them if you have a reason — but change them in this file, in a commit, *before* the situation they govern, never in the middle of it.
