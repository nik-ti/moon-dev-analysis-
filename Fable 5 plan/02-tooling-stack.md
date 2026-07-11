# 02 — The Tooling Stack (researched, mid-2026)

The stack is chosen for a solo operator building with AI: boring, well-documented, Python-first tools that Claude Code already knows deeply, with an explicit upgrade path at each layer. Rule of thumb: **use the simplest tool that is honest at the current pipeline stage**, and only pay a learning-curve tax when a strategy has earned it by surviving the previous stage.

---

## A. Backtesting engines — a two-engine (plus one) policy

No single engine is right for both "screen 200 variants tonight" and "would this order actually have filled?" Use different engines per stage and accept the port cost — it's small when the AI writes the code.

| Engine | Role in the pipeline | Why |
|---|---|---|
| **[vectorbt](https://vectorbt.dev/)** (or VectorBT PRO) | **Stage 3 — coarse screen.** Parameter sweeps, variant races, large-universe scans. | NumPy/Numba-vectorized; tests thousands of parameter combinations in seconds. The fastest "does this even have alpha?" loop in Python. Its fill model is naive — never treat its numbers as deployable truth. |
| **[backtesting.py](https://github.com/kernc/backtesting.py)** | **Stage 4 — realistic backtest for simple strategies** (single-asset, bar-based, one-position-at-a-time). | Tiny, readable, event-driven-enough for bar-level strategies; trivially AI-generatable; the Moon Dev source material runs on it. Fine as the validation engine for most simple crypto strategies. |
| **[NautilusTrader](https://nautilustrader.io/)** | **Stage 4–5 for anything execution-sensitive** (intrabar logic, partial fills, order-book/latency-sensitive edges, multi-asset), and the live-parity path: the same strategy class runs in backtest and live. | Rust-core, event-driven, realistic fill simulation, first-class crypto adapters (including a documented [Tardis integration](https://nautilustrader.io/docs/latest/integrations/tardis/) for tick-level replay). The learning-curve tax is real — pay it only for strategies whose edge lives in execution. |
| **[freqtrade](https://www.freqtrade.io/)** | Optional alternative track for conventional crypto TA-style strategies. | Batteries-included: built-in backtesting → hyperopt → dry-run → live pipeline, Telegram control, connects to Hyperliquid and 100+ exchanges via CCXT. Opinionated; less flexible for weird edges, excellent for standard ones. |

**Analytics on top of any engine:** [quantstats](https://github.com/ranaroussi/quantstats) for tear sheets (Sharpe, Sortino, drawdown profiles, benchmark comparison). The robustness math that no engine gives you out of the box — deflated Sharpe, walk-forward orchestration, parameter-plateau maps, Monte Carlo resampling — is thin scripting on top (see `03-pipeline.md` Stage 5; the AI writes and maintains these as shared library code).

## B. Execution layer, per venue

| Venue | Primary tool | Notes |
|---|---|---|
| **Hyperliquid** (perps, the default crypto venue for this system) | Official [`hyperliquid-python-sdk`](https://github.com/hyperliquid-dex/hyperliquid-python-sdk) | Native sub-account support (one per bot — required by `05-risk-and-portfolio.md`). Rate limits are volume-based (~1 request per 1 USDC cumulative volume + a 10k buffer for new accounts); batch orders where possible. CCXT also has a `hyperliquid` adapter if you want uniformity. Testnet available — use it in Stage 6. |
| **CEX spot/perps** (Binance, Coinbase, Bybit, Kraken, OKX…) | [CCXT](https://github.com/ccxt/ccxt) | One unified API for 100+ exchanges: auth, rate-limiting, pagination, symbol normalization all handled. The default execution dependency for anything CEX. Install `coincurve` for fast signing. |
| **Polymarket** | Official [`py-clob-client`](https://github.com/Polymarket/py-clob-client) (Polymarket now also recommends its newer `py-sdk` for new projects) | Three services with separate rate limits: **CLOB** (trading, authed), **Gamma** (market discovery, public), **Data API** (analytics/history, public). Auth: your wallet key derives L2 API credentials once; trade with L1+L2 client. Also see [Polymarket Agents](https://github.com/Polymarket/agents) — official framework for AI-agent trading, worth mining for connector code. |
| **Kalshi** | Official REST/WebSocket API (regulated US venue; simple key auth) | Clean API; historical trades and OHLC per market via `/markets/{ticker}/history`. Being CFTC-regulated changes the market mix and the competition profile vs Polymarket. |
| **Cross-venue prediction markets** | [pmxt](https://www.pmxt.dev/) (CCXT-style unified API for Polymarket + Kalshi and others) | Useful specifically for cross-venue comparison scans (a real edge family — see `06-market-playbooks.md`). |

**Non-negotiable execution rules (wired into every bot template, every venue):** check for an existing position before entering; cancel stale orders before placing new ones; one position at a time per bot unless the spec explicitly says otherwise; stop-loss and take-profit attached at entry; kill switch reading a portfolio-level file/flag; leverage and size as top-of-file config; secrets only from `.env`.

## C. Data layer

The data plan per venue, cheapest-honest-option first:

**Crypto OHLCV (bars):**
- [Binance Vision](https://data.binance.vision/) — free bulk historical klines/trades for Binance markets; the default for deep bar history.
- Exchange REST APIs via CCXT (Coinbase, Bybit, etc.) — free, rate-limited; fine for a few years of 1h/1d bars. Pull the same series from 2 sources and cross-check row counts and a few spot values before trusting either (source-material habit worth keeping).
- [CryptoDataDownload](https://www.cryptodatadownload.com/) — free CSVs across 25+ exchanges, no login; convenient for quick starts.

**Crypto tick/order-book/derivatives data (only when a strategy has earned it):**
- [Tardis.dev](https://tardis.dev/) — the quality benchmark: tick-level L2/L3, trades, liquidations, funding, open interest across major venues; plugs directly into NautilusTrader. Paid; buy per-exchange/per-month slices for the specific validation you need rather than a blanket subscription.
- [CoinGlass API](https://www.coinglass.com/CryptoApi) — liquidations, funding, open interest, long/short ratios across 30+ exchanges including Hyperliquid; history back to ~2019. The affordable source for liquidation/positioning edge families.
- [CryptoHFTData](https://www.cryptohftdata.com/) and [Crypto Lake](https://crypto-lake.com/) — cheaper L2-snapshot/trades alternatives worth checking before paying Tardis prices.
- Hyperliquid's own API — recent trades, funding, and (limited) historical data free; its L1 is public so third-party archives keep improving.

**Prediction markets (the data problem is the moat here — see playbook):**
- Polymarket CLOB/Data APIs — free mid-price history and trades; **no free historical order-book depth**, which means most Polymarket backtests overstate live P&L. Backtest *logic* on mids, validate *execution* only in incubation.
- [PolyBackTest](https://polybacktest.com/) — paid historical Polymarket order-book depth at 1-min resolution (hundreds of millions of snapshots, including dead markets); [Marketlens](https://stratbase.ai/)-style tick archives exist too. Worth it only once a prediction-market strategy family has proven itself in incubation.
- Kalshi `/history` endpoints — free trade-level history and OHLC candles (no historical book depth).
- **Start your own recorder on day one.** A cron job snapshotting the books/prices of markets you care about costs nothing and compounds: in 6 months you own a private dataset for exactly the markets you trade. This is the single highest-ROI data move for prediction markets.

**Context/on-chain (for research, not signals, initially):** exchange announcement feeds, token-unlock calendars, [Dune](https://dune.com/) for on-chain queries, CoinGecko/CoinGlass for cross-sectional scans.

**Storage:** Parquet files + DuckDB for querying. No database server until you genuinely need one. A `data/` directory with a manifest (source, symbol, timeframe, date range, checksum, download date) that the AI maintains — stale or gap-ridden data silently corrupts every downstream stage, so the manifest check runs before every backtest.

## D. Infrastructure

| Concern | Tool | Notes |
|---|---|---|
| Runtime | Python 3.11+, one venv per workspace, `requirements.txt` pinned | Boring on purpose. |
| Bot hosting | Cheap VPS (Hetzner/DO/Vultr, $5–20/mo) reached by SSH | Develop and incubate locally first (you see errors immediately); migrate to VPS when stable. Latency to venue matters only for latency-family edges — then pick region accordingly (e.g. Tokyo for Hyperliquid-adjacent infra). |
| Process supervision | **PM2** (`pm2 start bot.py --name <bot>`, restart-on-crash, log capture) or systemd units | PM2's ecosystem file gives you the whole fleet in one declarative config; `pm2 save && pm2 startup` survives reboots. |
| Isolation | One OS user or at least one directory + one `.env` + one venue sub-account per bot | Blast-radius control, per `05-risk-and-portfolio.md`. |
| Monitoring | Each bot writes structured JSONL (every decision, order, fill, error) + a heartbeat file; a single watcher process tails the fleet | Alerts via Telegram bot (dead-simple HTTP API) for: heartbeat missed, error-rate spike, risk-limit approach, kill-switch trip. Grafana + Prometheus/InfluxDB is the nice-to-have upgrade, not the starting point. |
| Version control | Private GitHub repo for the factory; public repos never contain live strategies | Also your deployment mechanism: VPS pulls from git; no hand-edited code on the server, ever. |
| Secrets | `.env` per bot, gitignored; venue API keys **without withdrawal permission** wherever the venue supports scoped keys | The AI never sees or handles withdrawal-capable credentials. |

## E. The AI layer

- **Claude Code** (Max-tier subscription) is the factory's workforce: research, spec-writing, all coding, running the gauntlet, report generation, log analysis, ops. Configuration and division of labor in `04-autopilot-architecture.md`.
- **Subagents** for parallel variant racing and role separation (Scout / Architect / Skeptic / Risk Officer / Ops — definitions in `07-templates/agents/`). The Skeptic reviewing the Architect's work in a *fresh context* is load-bearing: the same context that produced a bug is the context least likely to find it.
- **Skills/`CLAUDE.md`** encode the house rules (cost models per venue, the numeric gates, the registry-logging requirement) so every session enforces them without re-prompting — template in `07-templates/CLAUDE.md`.
- **Scheduled headless runs** (cron on your machine or VPS invoking Claude Code non-interactively) drive the overnight research batches. The morning report is the AI's deliverable; the capital decision is yours.
- **MCP servers** where they remove friction (exchange data, GitHub); optional, not foundational.

## F. What to deliberately NOT use (yet)

- **ML-driven strategy discovery** (feature mining, deep learning on price data): maximal multiple-testing risk with minimal interpretability. Revisit only after the factory has 5+ live rule-based bots and a mature registry discipline.
- **HFT/colocation anything**: not winnable at solo-retail scale; the latency edge families in this plan are "seconds vs minutes," not microseconds.
- **Paid signal services, copy-trade products, or anyone else's bot**: structurally misaligned (they profit from subscriptions, not trading) and you can't audit sizing or shutdown behavior.
- **Kubernetes, microservices, message queues**: a fleet of 20 single-file bots under PM2 does not need them. Complexity is a failure mode, not a status symbol.

## Sources

- [The Python Backtesting Landscape (2026)](https://python.financial/) · [NautilusTrader vs Backtrader vs VectorBT](https://bullalert.ai/blog/best-python-backtest-engines-2026/) · [backtesting.py alternatives doc](https://github.com/kernc/backtesting.py/blob/master/doc/alternatives.md)
- [CCXT](https://github.com/ccxt/ccxt) · [Hyperliquid bot frameworks compared](https://coincodecap.com/best-hyperliquid-bot-frameworks-sdks-hummingbot-ccxt) · [Hyperliquid bots 2026 (Chainstack)](https://chainstack.com/hyperliquid-trading-bots-2026/) · [Freqtrade vs Hummingbot vs CCXT](https://trendrider.net/blog/freqtrade-vs-hummingbot-vs-ccxt-2026) · [Hummingbot](https://hummingbot.org/)
- [Polymarket docs](https://docs.polymarket.com/trading/overview) · [py-clob-client](https://github.com/Polymarket/py-clob-client) · [Polymarket Agents](https://github.com/Polymarket/agents) · [Polymarket API guide 2026](https://rekko.ai/docs/guides/polymarket-api-guide) · [pmxt](https://www.pmxt.dev/)
- [Tardis.dev](https://tardis.dev/) · [NautilusTrader Tardis integration](https://nautilustrader.io/docs/latest/integrations/tardis/) · [CoinGlass API](https://www.coinglass.com/CryptoApi) · [CryptoDataDownload](https://www.cryptodatadownload.com/) · [CryptoHFTData](https://www.cryptohftdata.com/) · [Crypto Lake](https://crypto-lake.com/) · [Data sourcing guide (Quant Arb)](https://www.algos.org/p/data-sourcing-the-guide)
- [PolyBackTest](https://polybacktest.com/) · [Backtesting Polymarket: the depth-data problem](https://zenhodl.net/blog/backtesting-polymarket-strategies-tools-datasets) · [Awesome Prediction Market Tools](https://github.com/aarora4/Awesome-Prediction-Market-Tools)
- [The Deflated Sharpe Ratio (Bailey & López de Prado)](https://www.davidhbailey.com/dhbpapers/deflated-sharpe.pdf) · [Backtest overfitting: comparison of OOS testing methods](https://www.sciencedirect.com/science/article/abs/pii/S0950705124011110) · [quantstats](https://github.com/ranaroussi/quantstats) · [awesome-quant](https://github.com/wilsonfreitas/awesome-quant)
