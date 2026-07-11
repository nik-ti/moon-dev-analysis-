# Strategy Spec — <slug>

- **Experiment ID:** EXP-YYYYMMDD-NN (register in `registry/experiments.csv` before any code)
- **Idea family:** <carry | flow | behavioral | latency | event | other> / <family-tag, e.g. `pm-longshot`, `hl-funding`>
- **Author:** Scout/Architect draft, <date>. **Skeptic section completed:** yes/no
- **Registry check:** prior trials in this family: <N> · family cooldown active? <no / until date>

## 1. Mechanism (the only section that matters if wrong)

**One paragraph:** what mispricing exists, and *who is on the other side losing money, and why do they keep doing it?* If this paragraph names a pattern but not a counterparty, the spec is not ready.

## 2. Venue & instrument

- Venue / instrument(s) / sub-account plan:
- Why this venue for this mechanism (see routing table, `06-market-playbooks.md` §E):

## 3. Rules (each must be one unambiguous sentence)

- **Entry:**
- **Exit (profit):**
- **Exit (stop):**
- **Exit (time-stop, mandatory):**
- **Position sizing at incubation:** ($5–25 notional)
- **Concurrency:** one position at a time unless justified here:

## 4. Parameters (hard limit 5; each needs a mechanism-based prior, not a searched value)

| Param | Prior range | Why this range follows from the mechanism |
|---|---|---|
| | | |

## 5. Data plan

- Datasets (source, timeframe, date range) + manifest entries:
- Training/holdout split (dates):
- Known data risks (gaps, survivorship, source disagreement):

## 6. Cost model

- Fees: · Spread assumption: · Slippage assumption: · Funding/carry:
- Basis for these numbers (venue schedule / playbook default / measured):

## 7. Capacity estimate

Rough ceiling before own-impact erodes edge, and the reasoning:

## 8. Pre-registered success bars (written NOW, binding later)

- Coarse screen (S3): standard gates per `03-pipeline.md` unless tightened here:
- Realistic backtest (S4): standard gates unless tightened here:
- Expected trades/year (must be ≥50 for the standard path):

## 9. Backtestability

- [ ] Standard path (S3→S5)
- [ ] Untestable-market exception — impossible because: <reason>. Offline proxies to be tested anyway: <list>. Extended incubation plan: <duration, trade count>.

## 10. Ways this is a mirage (Skeptic writes; ≥3 entries or it's a rubber stamp)

1.
2.
3.
