# Quickstart

Clone substrate and stand up your first client team in under 30 minutes. Designed for a new operator (PMM, GTM, marketing lead) who has never run substrate before.


## What you'll have at the end

- The substrate CLI on your PATH.
- A bootstrapped `clients/<your-product>/` folder with the 10-layer context scaffold.
- A `BRIEF.md` you've filled in for your team.
- A first asset (landing page draft, positioning statement, or ad brief) that has passed the `pre-publish-check` gate.

## Step 1: install (2 min)

```bash
git clone https://github.com/k3sava/substrate.git
cd substrate
export PATH="$PWD/bin:$PATH"

# Optional: persist PATH
echo "export PATH=\"$PWD/bin:\$PATH\"" >> ~/.zshrc
```

Verify:

```bash
substrate --version
substrate --list
```

You should see a list of 70+ skills.

## Step 2: bootstrap your client (5 min)

Pick a slug for your product or team. Kebab-case, short, stable.

```bash
substrate-bootstrap-prospect <your-slug> \
  --lp https://your-product.com \
  --reviews https://www.g2.com/products/your-product \
  --pricing https://your-product.com/pricing
```

This creates `clients/<your-slug>/` with:

- `BRIEF.md` — the operator-filled brief (positioning hypothesis, ICP cut, top three bets). **Fill this before running any skill.**
- `competitors.yaml` and `verticals.yaml` — pre-seeded from `templates/`. Edit for your context.
- `positioning/`, `icp/`, `voc/`, `competitive/`, `market-context/`, `product-knowledge/`, `brand-voice/`, `conversion-narrative/`, `strategy/`, `diagnostics/` — the 10 context layers, empty and waiting.
- `00-INDEX.md` — an agent-readable map of the above.

Have a look at [`clients/example-client/`](clients/example-client/) for a fully populated example with fake data. Use it as a reference for what your own client folder should look like once it's filled in.

## Step 3: fill the BRIEF (10 min)

```bash
$EDITOR clients/<your-slug>/BRIEF.md
```

The brief is the load-bearing input every skill reads first. The template prompts for:

- Product one-liner
- Target buyer (role, vertical, company stage)
- Top three bets you're testing this quarter
- What you already know about positioning (hypothesis, not gospel)
- What you don't yet know (the gaps substrate will help you close)

Substrate skills refuse on a stale or empty BRIEF. Trust the refusal; it means the upstream input isn't ready yet.

## Step 4: edit per-client config (5 min)

```bash
$EDITOR clients/<your-slug>/competitors.yaml
$EDITOR clients/<your-slug>/verticals.yaml
```

- `competitors.yaml` lists the named competitors plus status-quo alternatives (Excel, in-house build, do-nothing) the AEO and competitive-scout skills need.
- `verticals.yaml` lists the vertical slugs the per-vertical AEO pass and persona fragments key off.

Both pre-seeded from `templates/competitors-example.yaml` and `templates/verticals-example.yaml`. Replace the example entries with yours.

## Step 5: sketch positioning (5 min)

```bash
$EDITOR clients/<your-slug>/positioning/01-canonical.md
```

A one-page draft. Doesn't need to be polished. `positioning-forge` will sharpen it later.

## Step 6: run your first gate (3 min)

Write any draft (a landing page hero, a paragraph, a positioning sentence) to `/tmp/draft.md`:

```bash
cat > /tmp/draft.md <<'EOF'
---
produced_by: positioning-forge
client: <your-slug>
---
# Hero
Outcome-led headline goes here.

The supporting paragraph explains who it's for, what changes, and why now. Every claim cites a path under clients/<your-slug>/.
EOF

substrate pre-publish-check /tmp/draft.md --client <your-slug>
```

The gate runs voice, citation, refusal-pattern, claim-verify, pattern-applied (Gate 9), and contradiction-position-logged (Gate 10) checks. You'll see PASS, WARN, or FAIL per gate with a remediation line for each.

## Step 7: run an end-to-end orchestration (optional)

If you want to spend a full week getting substrate populated:

```bash
$EDITOR routines/new-client-onboarding-week-1.md
```

Day 1 through day 5, step by step. By Friday you have positioning, status-quo competitor map, narrative spine, messaging matrix, one customer-facing artifact, and a 90-day roadmap with three calibrated goals.

## What to read next

- [`README.md`](README.md) — the wider picture (8 layers, surfaces, orchestrations).
- [`PRINCIPLES.md`](PRINCIPLES.md) — the nine rules every skill enforces.
- [`DOCTRINE.md`](DOCTRINE.md) — the posture a team takes when running substrate.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how to PR a skill, pattern, persona, or routine back.
- [`clients/example-client/`](clients/example-client/) — what a populated client folder looks like.

## Troubleshooting

**Skill refuses with "substrate-gap".** A required-read is missing. The refusal message names the file. Fill it and retry.

**Gate 9 / Gate 10 fail.** Your draft frontmatter has `produced_by: <skill>` but the body doesn't evidence the patterns the skill declares, or it names a contradiction without logging the position and rationale. Read the named pattern's `## Implication` section and either rewrite the draft or remove the `produced_by` frontmatter (for non-customer-facing drafts).

**`substrate --list` shows fewer skills than expected.** Check `bin/` is on your PATH and that you ran `chmod +x bin/*` if you copied the repo across machines.

**You want to stand up substrate for a client team.** Follow this Quickstart from their machine. The bootstrap command and 5-day orchestration (`new-client-onboarding-week-1`) are the starting points.
