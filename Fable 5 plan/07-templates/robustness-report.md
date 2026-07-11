# Robustness Report — EXP-YYYYMMDD-NN <slug>

- **Date / engine / dataset (with manifest checksums):**
- **Variant under test:** (params frozen as of this report)
- **Registry trial count for this idea family at test time:** N = ___ (input to DSR)

## Baseline (training window, realistic engine — from Stage 4)

| Metric | Value | Gate | Pass? |
|---|---|---|---|
| Net Sharpe | | ≥ 1.5 | |
| Return / MaxDD | | ≥ 2.0 | |
| Trades | | ≥ 100 | |
| vs Buy & Hold | | not dominated; role stated | |
| Skeptic code review | | 0 unresolved look-ahead findings | |

## The gauntlet

### 1. Walk-forward
Segments: ___ · WF efficiency (OOW/IW): ___ (gate ≥ 0.5) · % segments profitable: ___ (gate ≥ 60%) → **PASS/FAIL**

### 2. Parameter plateau
Perturbation ±20–30% per param. Worst neighbor retains ___% of peak Sharpe (gate ≥ 50%). Attach heatmap. → **PASS/FAIL**

### 3. Cost stress (3x)
Sharpe at 3x: ___ (gate > 0) · Return/MaxDD at 3x: ___ (gate ≥ 1) → **PASS/FAIL**

### 4. Cross-asset transfer (or written skip reason)
Sibling asset: ___ · OOS Sharpe: ___ = ___% of in-sample (gate ≥ 50%) → **PASS/FAIL/SKIPPED because ___**

### 5. Monte Carlo (1,000 resamples + ±1 bar entry jitter)
5th-pct total return: ___ (gate > 0) · 95th-pct MaxDD: ___ (gate: survivable at intended risk budget: yes/no) → **PASS/FAIL**

### 6. Deflated Sharpe Ratio
Trials N = ___ · skew ___ · kurtosis ___ · DSR = ___ (gate: ≥ 95% confidence Sharpe ≠ best-of-N luck) → **PASS/FAIL**

## Holdout (touched ONCE; result binding)

Window: ___ · Net Sharpe: ___ (gates: ≥ 50% of training Sharpe AND ≥ 0.75) → **PASS/FAIL**

> On FAIL: experiment closed, family cooldown 30 days from today (registry updated). No re-tweak.

## Verdict

**Overall: PASS / FAIL.**

## Skeptic's worry note (mandatory, one paragraph)

What would still worry me about deploying this even though it passed:

## Risk Officer addendum (for Human Gate #1)

- Proposed incubation size/venue/sub-account:
- Correlation guess vs current fleet (basis):
- Portfolio heat after adding (vs caps in `05` §7):
