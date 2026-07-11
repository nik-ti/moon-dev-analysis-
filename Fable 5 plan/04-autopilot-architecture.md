# 04 — The Autopilot Architecture (Claude Code as the Workforce)

This file turns the pipeline into something that runs while you sleep. The design principle: **the AI is the entire staff of a small quant shop — researcher, developer, QA, risk, and ops — and you are the portfolio manager.** The staff works on schedule, produces auditable artifacts, and never controls capital.

---

## 1. Workspace layout

One private git repo, structured so any Claude Code session can orient itself in seconds:

```
trading-factory/
├── CLAUDE.md                  # house rules — the single most leveraged file (template in 07-templates/)
├── .claude/
│   └── agents/                # subagent definitions (below; templates in 07-templates/agents/)
├── ideas/
│   ├── inbox.md               # Stage 1 raw intake
│   └── graveyard.md           # every killed idea + reason — Scout reads this to avoid retreads
├── specs/                     # Stage 2 artifacts: YYYY-MM-DD_<slug>.md
├── experiments/               # one folder per experiment ID: screen, backtest, robustness report
├── registry/
│   └── experiments.csv        # THE experiment registry — every trial ever run (schema in 07-templates/)
├── lib/                       # shared, tested code: data loaders, cost models, gauntlet harness,
│                              #   venue clients, bot skeleton, risk checks — copied INTO bots at deploy
├── data/
│   ├── manifest.md            # source, range, checksum, freshness per dataset
│   └── ...                    # parquet files
├── strategies/
│   ├── incubating/<bot>/      # self-contained: bot.py, config.py, .env(.example), scorecard.md, logs/
│   ├── live/<bot>/
│   └── retired/<bot>/         # + postmortem.md
├── ops/
│   ├── morning-report/        # dated reports from the overnight batch
│   ├── weekly-review/         # dated weekly reviews
│   └── decisions.md           # your decision journal: every gate approval/rejection, one line + reason
└── recorder/                  # the always-on market-data recorder (prediction-market books etc.)
```

Two conventions that matter: **experiments are append-only** (never edit a past report — write a new experiment) and **bots are self-contained** (shared `lib/` code is *copied* into a bot's folder at deploy time and pinned, so a `lib/` improvement can never silently change a live bot's behavior; bots pick up lib changes only via an explicit redeploy).

## 2. `CLAUDE.md` — the constitution

Full template in `07-templates/CLAUDE.md`. It encodes, so that every session obeys without re-prompting:

- The pipeline stages and numeric gates (from `03-pipeline.md`) — so no session ever "helpfully" skips one.
- The registry rule: *every* backtest run, however casual, appends a row to `registry/experiments.csv` before results are reported.
- The data-split policy: holdout windows are named per-dataset in `data/manifest.md` and are **never** read except by the gauntlet harness's holdout step.
- Cost-model defaults per venue (the numbers in `06-market-playbooks.md`).
- The risk invariants every generated bot must contain (position-check-before-entry, cancel-before-place, SL/TP at entry, kill-switch file check, size/leverage as config, `.env` secrets).
- What the AI must never do: place orders above incubation size, change a live bot's parameters in place, touch withdrawal-capable credentials, mark its own gauntlet as passed without the Skeptic's fresh-context review.

## 3. The five subagents

Role separation isn't theater — it fixes a real failure mode. A single context that researched an idea, wrote the code, and ran the test *wants* the idea to work; fresh-context review is the cheapest independent check available. Definitions live in `.claude/agents/` (templates in `07-templates/agents/`):

| Agent | Role | Invoked | Key constraint |
|---|---|---|---|
| **Scout** | Stage 1–2: scans idea sources, drafts specs, checks graveyard + registry for retreads | Nightly batch + on demand | Must name the counterparty (who loses and why) or discard; never writes strategy code |
| **Architect** | Stages 3–4: builds screens and backtests, dispatches parallel variant races, writes live bots from validated specs | Overnight batch + on demand | Every run logged to registry; builds only from a registered spec; never grades its own work |
| **Skeptic** | Adversarial review: code review for look-ahead/bias sins (Stage 4), "ways this is a mirage" section of every spec, worry-note on every robustness report | After every Architect deliverable, **always in a fresh context** | Paid to kill things: its success metric is bugs found, not strategies passed; cannot edit code, only report |
| **Risk Officer** | Portfolio layer: correlation of a candidate with the live fleet, risk-budget accounting, scaling-request reports, weekly portfolio heat check | Human gates + weekly | Read-only on strategy code; sole author of scaling-request reports; applies `05-risk-and-portfolio.md` mechanically |
| **Ops** | Stage 6–8: dry-run supervision, deploys (git → VPS → PM2), log summarization, incident write-ups, drafts the morning report and weekly review | Daily + on incident | Can restart/descale/kill bots per pre-written rules; can never increase size or deploy a new bot without a logged human approval |

The **parallel dispatch pattern** (the source material's highest-leverage habit) lives inside the Architect's stage-3 procedure: N subagents, one variant each, identical frozen dataset, identical cost model, explicit benchmark to beat, results merged into one comparison table — and *every* variant logged as a trial in the registry, which is the discipline the source material lacked.

## 4. The scheduled runs

Cron (local machine or VPS) invoking Claude Code headlessly. Each job's prompt is a one-liner because the procedure lives in `CLAUDE.md` and the agent definitions.

| Schedule | Job | Output |
|---|---|---|
| Nightly ~02:00 | **Research batch**: Scout processes inbox + scans sources → up to 2 new specs; Architect screens any unscreened specs (parallel variants); gauntlet runs for any Stage-5-ready experiment | `ops/morning-report/YYYY-MM-DD.md` — ranked candidates, gate results, registry deltas, and an explicit "decisions awaiting you" list |
| Every 6h | **Fleet check**: Ops reads all bot heartbeats/logs, flags anomalies, summarizes | Alert (Telegram) only if something needs you; silence = healthy |
| Continuous | **Recorder**: snapshot prediction-market books / funding / target-market data | `data/` parquet, manifest updated |
| Weekly (Sun) | **Weekly review draft**: Ops + Risk Officer compile fleet P&L vs expectation, cost drift, tripwire proximity, incubation scorecards, registry stats (trials this week, family cooldowns), Scout's top ideas | `ops/weekly-review/YYYY-MM-DD.md` for your 60–90 min review |
| Monthly | **Decay audit**: rolling live-vs-backtest divergence per bot; retirement recommendations | Section in weekly review |

Your morning ritual (~15 min): read the morning report → for each "decision awaiting," write one line in `ops/decisions.md` (approve/reject + why) → done. The factory reads `decisions.md` and proceeds. **The decision journal is the interface between you and the autopilot** — everything else is the machine talking to itself.

## 5. Session discipline (for interactive work)

- **Plan-then-build gate**, always: "explain the plan, don't build yet" → review → "build steps 1–3." Cheap insurance against 45 minutes of confidently wrong work.
- **Ground before dispatch**: parallel agents get exact file paths, the frozen dataset, the cost model, and the number to beat — never a vague goal.
- **Verify reported numbers**: when a result looks odd (positive drawdown, zero trades in an active market, too-good Sharpe), make the AI explain the number from the raw logs before accepting it. Silence and zeros are bug signals, not calm.
- **Session handoff**: any session ending with unresolved work writes a handoff note (`ops/handoff.md`) — state, hypotheses ruled out, next step — so the next session doesn't re-derive it.
- **Blunt rejection is fine and useful**: when the AI's diagnosis contradicts what you can see, say so plainly and demand re-verification from primary evidence (logs, raw data), not a new plausible theory.

## 6. Hard limits — what stays human, mechanically enforced

Not policy preferences; wire them so violation is *impossible*, not discouraged:

1. **Capital gates**: incubation start and every scaling rung require a dated line in `ops/decisions.md` written by you. Ops checks for it before any deploy/resize; the deploy script literally greps for the approval line.
2. **Key custody**: API keys are created by you, scoped **no-withdrawal** wherever the venue supports it, and live only in per-bot `.env` files on the VPS. The AI writes code that *reads* keys; it never generates, views, or transmits them.
3. **Size ceilings in code**: every bot's config has `MAX_POSITION_USD` and `MAX_ACCOUNT_ALLOC` constants; the shared risk module refuses orders above them; changing them is a git commit that the deploy checklist ties to a decision-journal line.
4. **Kill switch above the AI**: the portfolio kill switch (equity floor per `05-risk-and-portfolio.md`) is a dumb, separate watchdog process — it reads account equity via API and flattens/halts the fleet if breached. It is deliberately too simple for anyone, human or AI, to talk it out of firing.
5. **New venues**: first live connection to any new exchange is done by you interactively, on testnet first.

## 7. Failure modes of the autopilot itself — and their tripwires

| Failure mode | Symptom | Tripwire |
|---|---|---|
| Registry rot (trials run but not logged) | DSR becomes flattery | Gauntlet harness cross-checks registry row count vs experiment artifacts; mismatch = hard fail |
| Skeptic capture (review becomes rubber stamp) | Zero findings across many reviews | Weekly review tracks Skeptic finding-rate; sustained zero triggers you to spot-audit one experiment yourself |
| Spec drift (live bot no longer matches spec) | Signal-match metric decays | Signal-match is a standing incubation + steady-state metric; < 95% flags |
| Silent data staleness | Backtests on stale/gappy data | Manifest freshness check runs before every backtest; stale = refuse |
| Approval fatigue (you rubber-stamp gates) | Decision journal entries become "ok" | Journal template forces one sentence of *reason*; weekly review samples your own past decisions |
| Cost creep (subscriptions, VPS, data) | Fixed costs exceed small-fleet P&L | Weekly review includes a one-line burn number vs trailing 30-day fleet P&L |

The meta-rule: the autopilot is itself a system under test. Its artifacts (reports, registry, journal) are designed so that a future you — or a fresh AI session — can audit any decision in minutes. If an audit ever becomes hard, that's a P0 bug in the factory, ahead of any strategy work.
