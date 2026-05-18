# Substrate learnings layer

Daily ingest output from research digests. Each entry is one day of operator-applicable insights, what someone in the field discovered, tried, broke, or shipped, filtered to the items that should change Substrate itself (a skill, a principle, a piece of knowledge).

## Layout

- `raw/YYYY-MM-DD.md`, verbatim digest as it arrived from the upstream pipeline. Treated as source-of-truth, never edited.
- `YYYY-MM-DD.md`, extracted substrate-applicables: structured summary of which skills, principles, or knowledge layers the digest suggests changing.
- `proposals/YYYY-MM-DD-<slug>.md`, high-confidence proposals filed for human-in-loop approval. Merge into `skills/`, `PRINCIPLES.md`, or `knowledge/` when approved.

## Source

The reference upstream is the operator's own research / digest pipeline. Substrate's contract:

> A digest is a dated markdown file. Each insight has an `apply-to:` tag listing which downstream systems should change. Items tagged `apply-to: substrate` are extracted by `bin/substrate ingest-digests` into this folder.

The OSS framework is digest-shape-agnostic. Anyone running Substrate plugs their own digest source via the `SUBSTRATE_DIGEST_DIR` env var.

## How the loop closes

1. Daily cron runs `bin/substrate ingest-digests --since yesterday`.
2. Raw digests land in `raw/`.
3. The extract step (LLM-driven) pulls substrate-applicables into `YYYY-MM-DD.md`.
4. Items above the high-confidence threshold get filed as `proposals/YYYY-MM-DD-<slug>.md` and an issue opens on the local repo.
5. Operator reviews. Approved proposals merge into the relevant layer.
6. Substrate's own skills get sharper, principles tighten where they should, knowledge stays fresh.

The system never silently mutates skills or principles. The `learnings` layer is staging for human approval, not the merge itself.

