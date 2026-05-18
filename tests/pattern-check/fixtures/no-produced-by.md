---
title: An asset with no produced_by — Gates 7+8 should skip
asset_type: external-customer
last_updated: 2026-05-08
substrate_consumed:
  - clients/example/BRIEF.md
---

# A draft with no produced_by

This asset deliberately omits the `produced_by` frontmatter key. Gates 9 and 10 should skip because there is no skill to enforce against. Gates 1-6 will still run (and will fail because this fixture is not real customer substrate), but the test only inspects the Gate 9 + 10 skip path.

## Body

Some draft prose.
