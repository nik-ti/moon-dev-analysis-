# Workspace Setup

One-time setup. Do this before you run your first idea through the protocol in `02-your-protocol.md`.

## 1. Accounts & tools to get

| What | Why | Notes |
|---|---|---|
| **Claude Code** (you already have this — you're using it right now) | Primary build tool for backtests and bots | Moon Dev runs a $200/month Max-tier plan because he runs many parallel sub-agents (see §3 below on cost). Start on whatever plan you have; upgrade only once parallel dispatch is actually your bottleneck. |
| A **paper-trading or sandbox account** on whichever exchange/broker you plan to trade | Lets you dry-run against real live data with zero real capital at risk (Stage 3 step 1 of the protocol) | Most exchanges (Hyperliquid, Binance, Coinbase, Interactive Brokers) offer this. Don't skip straight to a live-funded account. |
| A **historical data source** | Needed for Stage 2 backtesting | Start with what your exchange's own API gives you for free. Don't pay for a proprietary data API until you've proven you'll actually use it — Moon Dev built his own API only after years of doing this manually. |
| **GitHub account** (free) | Version control + a record of what you tried and why | Even solo, this matters: it's how you avoid re-testing an idea you already killed six months ago. |
| **Python 3.11+** | Backtesting and bot execution | If you don't have it: `brew install python3` on macOS. |

## 2. Folder structure

Run `templates/setup-workspace.sh` (see that file) or create this by hand:

```
algo-trading/
├── CLAUDE.md                  # tells Claude Code your rules automatically — see below
├── .env                       # secrets, never committed to git
├── .gitignore                 # must include .env
├── research/
│   ├── graveyard.md           # one-line entries for every idea you killed and why
│   └── YYYY-MM-DD_<idea>/     # one folder per idea, created fresh each time
│       ├── thesis.md
│       ├── backtest-summary.md
│       └── incubation-log.md
├── lib/                       # shared reusable code (exchange wrappers, indicators, account helpers)
├── backtests/                 # backtest engine + reusable backtest scripts
├── bots/                      # live-running bot code, one subfolder per bot
│   └── <bot-name>/
│       ├── bot.py
│       ├── config.py          # leverage, size, stop-loss etc. as editable variables — never hardcoded inline
│       └── README.md
└── docs/
    └── strategies-live.md     # index of what's currently incubating/scaled, and why
```

Why this shape, specifically (pulled straight from the source material):
- **`research/YYYY-MM-DD_<idea>/`** — dated batch folders are how Moon Dev keeps a night of parallel-agent output traceable later. Don't reuse folders across ideas.
- **`graveyard.md`** — a one-line log of every killed idea and why. This is what stops you from re-testing the same bad idea twice, and it's the single easiest habit to skip and regret skipping.
- **`lib/` copied into `bots/<bot-name>/`, not imported by reference, when a bot goes to incubation** — Moon Dev's own team explicitly calls this out as a good call ("I copied rather than moved the nice funks... good call"): once a bot is live, you don't want a change to shared code silently changing a strategy that's already trading. Copy the version you tested, freeze it.
- **`config.py` per bot** — leverage, position size, stop-loss %, and kill-switch threshold live as named variables at the top of the file, never buried inline in logic. This is what let Moon Dev say "leverage 2x isolated" as a one-line change instead of a code review.
- **`.env`** — every API key and private key lives here, never in a script. Add `.env` to `.gitignore` on day one, before you put a single real key in it.

## 3. `CLAUDE.md` — bake the protocol into your workspace

Claude Code automatically reads a `CLAUDE.md` file in your project root at the start of every session. Copy `templates/CLAUDE.md` into your `algo-trading/` root. It encodes:
- The RBI discipline (Claude will remind you, and itself, to not skip stages)
- The risk-management non-negotiables (stop-loss, kill switch, position-check-before-entry) as things Claude should always include when building a bot, without you having to re-specify them every time
- The folder conventions above, so Claude puts new work in the right place automatically

This is the single highest-leverage setup step: it means every future Claude Code session in this workspace already knows your rules, instead of you re-explaining them in every prompt.

## 4. Python environment

```bash
cd algo-trading
python3 -m venv .venv
source .venv/bin/activate
pip install backtesting pandas numpy python-dotenv requests
```

Add the exchange SDK(s) you actually need once you pick a venue (e.g. `pip install ccxt` for a broad exchange wrapper, or a venue-specific SDK). Don't install everything up front — add dependencies as the protocol actually calls for them.

## 5. Cost awareness

Running many parallel Claude Code sub-agents (Stage 2's "launch 5 agents" pattern) burns tokens fast — Moon Dev mentions running out of credits after 6 parallel batches in one session. Two implications for you:
- Start with 2-3 parallel agents per dispatch, not Moon Dev's 36, until you have a feel for your own usage.
- Reserve large parallel dispatches for Stage 2 (backtesting variants), where the value of racing many ideas is highest — not for routine debugging, where one focused session is usually enough.

## 6. First-run checklist

- [ ] Folder structure created
- [ ] `CLAUDE.md` in place
- [ ] `.env` created and gitignored, empty for now
- [ ] Python venv created, core packages installed
- [ ] Paper-trading account created on your chosen venue
- [ ] Git repo initialized, first commit made (structure + CLAUDE.md, no secrets)
- [ ] You've read `02-your-protocol.md` once end to end

Once all boxes are checked, start your first idea folder under `research/` and begin Stage 1.
