# 03 — The Pipeline: 8 Stages, Hard Gates

This is the assembly line. Every idea enters at Stage 1 and either exits at a gate (→ graveyard, with reason logged) or reaches Stage 8. **No stage may be skipped silently.** The only permitted skip is Stage 4–5 for genuinely unbacktestable markets, taken explicitly in writing (see "the untestable-market exception" at the end).

Each stage lists: who does the work (AI or human), the artifact it must produce, and the gate to pass. The artifacts are the system — if the artifact doesn't exist, the stage didn't happen.

```
S1 Intake → S2 Spec → S3 Coarse Screen → S4 Realistic Backtest → S5 Robustness Gauntlet
   → [HUMAN GATE] → S6 Dry Run → S7 Incubation → [HUMAN GATE] → S8 Scale & Steady State → Retire
```

Cumulative survival expectation, so you calibrate emotionally: of 100 ideas entering S1, expect roughly 40 to produce a spec, 10 to pass the coarse screen, 3–5 to survive the gauntlet, 2–3 to clear incubation, and 1–2 to earn scaled capital. **A 95%+ kill rate is the system working, not failing.**

---

## Stage 1 — Intake (AI, continuous)

Ideas are raw material; collect them promiscuously, filter them ruthlessly *later*. Sources the Scout agent works through on schedule: funding/basis dashboards, liquidation data, venue announcements and rule changes, token-unlock calendars, new-listing calendars, prediction-market catalogs (Gamma API scans for volume/spread anomalies), papers (SSRN/arXiv q-fin), practitioner writing, and — highest value — **your own observed anomalies** ("this market always seems slow to update after X").

- **Artifact:** one entry per idea in `ideas/inbox.md`: 2–4 sentences — the observation, the suspected mechanism, the venue.
- **Gate (5-second test):** can you name *who loses money to this and why they keep doing it*? No → discard immediately. Yes → promote to Stage 2.

## Stage 2 — Specification (AI drafts, human skims)

Turn the idea into a falsifiable, implementable document **before any code**. The Architect fills the template in `07-templates/strategy-spec.md`:

mechanism & counterparty · venue & instrument · exact entry rule · exact exit rule (including time-stop) · parameters (each with a *prior* range justified by the mechanism, not by search) · data required & its source · cost model (venue fees + spread + slippage estimate) · capacity estimate · **pre-registered success bar for the backtest** · known ways this could be a mirage (the Skeptic writes this section).

- **Artifact:** `specs/YYYY-MM-DD_<slug>.md`, registered in the experiment registry with a new experiment ID and its idea-family tag.
- **Gate:** entry and exit each expressible in one unambiguous sentence; ≤5 free parameters (hard limit — more requires written justification and raises the S5 bar); expected trade frequency ≥50/year on available history (below that, statistical validation is impossible — route to the untestable-market exception or discard).

## Stage 3 — Coarse Screen (AI, fully automated, overnight)

Cheap triage in vectorbt on **training data only** (see the data-split policy below). This is where parallel variant racing happens: the Architect dispatches subagents to test the spec's variants/parameter priors against the same frozen dataset and benchmark.

Screen contents: run all variants over training window · naive costs at 1x and 3x · buy-and-hold benchmark on the same window · trade count · quick parameter sweep across the prior ranges.

- **Artifact:** `experiments/<id>/screen-report.md` — comparison table of all variants, each variant's row logged to the registry (every variant is a trial; this is what keeps Stage 5's deflated-Sharpe honest).
- **Gate (any variant must show):** net Sharpe ≥ 1.0 at 1x costs · ≥100 trades in the training window · return/max-drawdown ≥ 1.5 · not strictly dominated by buy-and-hold (worse return AND worse drawdown AND similar exposure = dominated) · edge does not vanish at 3x costs (Sharpe may degrade, must stay > 0).
- Fail → graveyard with reason. Pass → the best 1–2 variants (not five) proceed.

## Stage 4 — Realistic Backtest (AI builds, Skeptic reviews)

Rebuild the surviving variant in the validation engine (backtesting.py for simple bar strategies; NautilusTrader if the edge is execution-sensitive — the spec says which). Realistic costs: actual venue fee tier, conservative slippage, funding payments for perps, borrow costs if any. Position sizing as it will actually run live. Then the **Skeptic reviews the code in a fresh context** hunting the classic sins: look-ahead (using bar close for a decision made intrabar), survivorship bias in the universe, silent data gaps, fill assumptions the venue can't deliver, PnL computed on mid-prices in a wide-spread market.

- **Artifact:** `experiments/<id>/backtest/` — code, config, quantstats tear sheet, and the Skeptic's signed-off review note. Logged to registry.
- **Gate:** net Sharpe ≥ 1.5 · return/maxDD ≥ 2.0 · ≥100 trades · beats or justifiably complements buy-and-hold (a strategy may underperform B&H return if it cuts drawdown/exposure enough to be worth capital — say so explicitly) · Skeptic sign-off with zero unresolved look-ahead findings. **Suspicion bands:** in-sample Sharpe > 4 or triple-digit monthly returns trigger mandatory extra scrutiny, not celebration.

## Stage 5 — Robustness Gauntlet (AI, fully automated; the stage that separates this system from amateur hour)

Six tests, run as a standard harness (shared library code the AI maintains), producing one report. **Data-split policy, fixed for the whole factory:** every dataset is split once into training (~70%, Stages 3–4 and all tuning), and holdout (~30%, most recent data, touched exactly once here, result binding).

1. **Walk-forward analysis** (training window only): rolling re-fit/re-test segments. Pass: walk-forward efficiency (out-of-window performance ÷ in-window performance) ≥ 0.5, and profitable in ≥ 60% of segments.
2. **Parameter-plateau map:** perturb each parameter ±20–30% around the chosen value. Pass: performance degrades smoothly (neighbors retain ≥ 50% of peak Sharpe). A needle-sharp peak = curve-fit = fail, regardless of how good the peak looks.
3. **Fee/slippage stress:** 3x costs (already sampled at S3, now on the realistic engine). Pass: Sharpe > 0 and return/maxDD ≥ 1.
4. **Cross-asset / cross-market transfer** (where a related instrument exists): frozen parameters on an asset never used in development (tuned on BTC → test ETH/SOL). Pass: out-of-sample Sharpe ≥ 50% of in-sample. (Skip with written reason where no sensible sibling exists.)
5. **Monte Carlo resampling:** bootstrap/shuffle trade sequence 1,000×; also randomize entry timing by ±1 bar. Pass: 5th-percentile total return > 0, and 95th-percentile max drawdown survivable under the intended risk budget.
6. **Deflated Sharpe Ratio** against the registry's trial count for this idea family (all variants ever tested, including failures — this is why the registry exists). Pass: DSR indicates the Sharpe is distinguishable from the best-of-N luck at 95% confidence.

Then, and only then: **one run on the holdout window.** Pass: holdout net Sharpe ≥ 50% of training Sharpe and > 0.75 absolute.

- **Artifact:** `experiments/<id>/robustness-report.md` (template in `07-templates/`), every test's numbers filled in, an overall PASS/FAIL, and the Skeptic's one-paragraph "what would still worry me" note.
- **Gate:** all six tests + holdout pass. **A holdout failure is final for this experiment** — no re-tweak-and-retest; the idea family enters a 30-day cooldown before any related spec may be registered (this is the anti-holdout-mining rule; the registry enforces the cooldown).

## ⛔ HUMAN GATE #1 — capital approval (you, ~10 minutes)

You read the spec, the robustness report, and the Skeptic's worry note. You are not re-checking arithmetic (the artifacts are the audit trail); you are asking the three questions only a human should answer: *Do I believe the mechanism? Is the worst case in the Monte Carlo tolerable? Do I want this in the portfolio* (correlation with existing bots — the Risk Officer's report states it)? Approve → S6. Reject → graveyard with your reason written down (your rejection reasons are data too).

## Stage 6 — Dry Run (AI builds the live bot, ~2–5 days runtime)

The live bot is built from the spec (bot skeleton in `07-templates/`, house rules from `02-tooling-stack.md` §B wired in), pointed at the live venue with **order placement disabled** (log-what-would-have-happened mode) — on testnet first where the venue has one. You're testing plumbing: symbol resolution, decimals/precision, order sizing math, reconnect handling, error paths, heartbeat, kill-switch wiring, alerting.

- **Artifact:** `strategies/incubating/<bot>/dryrun-log.md` — including at least one deliberately induced failure (kill the network, feed a bad symbol) and the bot's observed response.
- **Gate:** ≥48h continuous dry run, zero unhandled exceptions, would-have-traded log matches expectation on manual spot-check of ≥5 signals, kill switch fires when tripped in test.

## Stage 7 — Incubation (real money, trivial size; the actual test)

$5–25 notional per position, venue minimum where higher. Isolated sub-account, funded with only the incubation budget. **Before it starts** you write the scale/kill bar into the scorecard (`07-templates/incubation-scorecard.md`): duration (default: 4–8 weeks *and* ≥30 trades, whichever is later), what "pass" means numerically, and what triggers an early kill.

What's actually being measured (in order of importance): (1) execution correctness — duplicate orders, stuck positions, unexpected states; (2) **realized vs modeled costs** — slippage per trade against the backtest's assumption; (3) signal-match — live entries/exits match what the backtest logic would have done on the same data; (4) P&L direction — last, because at 30 trades it's mostly noise, but persistent sharp divergence from backtest expectation is a red flag regardless of sample size.

- **Artifact:** the completed scorecard + full JSONL trade log, summarized weekly by Ops into the weekly review.
- **Gate (pre-written, binding):** zero unresolved execution bugs · realized costs ≤ 1.5x modeled · live signal-match ≥ 95% · live expectancy not catastrophically below backtest (formally: cumulative live P&L above the 10th percentile of the Monte Carlo distribution for the same trade count).

## ⛔ HUMAN GATE #2 — scaling approval (you, per rung)

Scaling follows the ladder in `05-risk-and-portfolio.md` (roughly 1x → 4x → 4x → capacity/risk-budget cap, each rung ≥ 2–4 weeks with performance inside expectation bands). **Every rung is a human approval.** The Risk Officer's report accompanies each request: current portfolio heat, correlation of this bot's returns with the rest of the fleet, and the updated worst-case.

## Stage 8 — Steady State & Retirement (AI monitors, tripwires pre-written)

Live bots run on the VPS under PM2, watched by the monitoring layer, reviewed weekly. Each bot goes live with **retirement tripwires written in advance**: rolling 60–90-day live Sharpe below X · realized cost drift > 2x modeled · drawdown beyond the Monte Carlo 95th percentile · venue rule change touching the mechanism · fill-rate/queue-position deterioration (for maker strategies). Tripwire hit → bot auto-descales to incubation size and flags for your kill/keep decision. Retired bots' post-mortems (`strategies/retired/<bot>/postmortem.md`) are Scout input — a decayed edge often points at where the flow went.

---

## The untestable-market exception (mostly prediction markets)

Where honest backtesting is impossible — typically no historical order-book depth, and the edge *is* execution against thin books — Stages 4–5 are replaced, never silently skipped:

1. The spec must say explicitly: "backtest impossible because X; validation plan is Y."
2. Whatever *can* be tested offline, is: resolution-history base rates via the Data API/Gamma history, mid-price behavior, category-level calibration (e.g. longshot bias by market category).
3. Stage 6–7 lengthen: incubation at floor size runs ≥ 2x longer and needs ≥ 50 trades, because incubation is carrying the entire evidentiary burden.
4. Scaling caps lower, permanently: an edge you couldn't backtest never earns more than half the risk budget of one you could (see `05-risk-and-portfolio.md`).
5. **Start recording data on day one** (own book-snapshot recorder, per `02-tooling-stack.md` §C) so the *next* strategy in this family has 6 months of private depth data and can graduate to the normal path.

## Throughput targets (what "the factory is running" means)

- Intake: ~10–20 ideas/week entering S1 (mostly automated Scout output + your notes).
- 2–4 specs/week reaching S2; every spec screened within 48h (overnight batches).
- 1–2 full gauntlet runs/month; 1–2 bots in incubation at all times once ramped.
- Your time: ~15 min/day (morning report + gates) + one 60–90 min weekly review. If it's taking more, automate the excess; if it's taking less, check that you're actually reading the artifacts before approving.
