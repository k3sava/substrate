---
title: how context flows
status: active
last_updated: 2026-05-04
---

# How context flows

The system has three places information lives: signals (raw, incoming), context (canonical, slow), and drafts (downstream, ephemeral). The flow between them is one-directional — signals propose patches to context; context grounds drafts; drafts don't write back to context except through the closing step.

## The pipe

```
[ signals ] ──→ [ signal-analyst ] ──→ [ patch proposal ]
                                              │
                                       (human approval)
                                              │
                                              ▼
[ context ] ←──────────────────────────────────┘
     │
     │ (read by)
     ▼
[ skill + goal contract ] ──→ [ draft ]
                                  │
                          (pre-publish check)
                                  │
                                  ▼
                                ship
                                  │
                       (resolution + outcome)
                                  │
                                  ▼
                       context update on close
```

## Three rules of context flow

### 1. Signals never write directly

A signal can be a sales call note, a review, a competitor's pricing page, a search-trend dump. None of these write to the context layer. They go through the signal-analyst step, which proposes a patch. A human approves before the context updates.

This is the gate that protects the context from one-off noise.

### 2. The context is read-only at draft time

When a skill generates a draft, the context it reads doesn't change during generation. The skill is a function of (context snapshot, goal contract). If two operators run the same skill against the same context and goal, they get the same draft.

This is what makes the accuracy score meaningful — the context is the same across runs, so differences in outcome reflect operator taste and goal calibration, not context drift.

### 3. The closing step is the only post-publish writeback

After a goal resolves, the closing step writes back to context. The context update reflects what the resolution actually taught: if the position layer said one thing and the resolution said another, the position layer gets a patch.

This is the only path from "draft published" to "context changed."

## Why this matters

The system's promise — that context compounds — depends on context being authoritative. If signals could write straight to context, the context would track the latest noise. If drafts could rewrite context mid-flight, the context would track whatever the operator wanted to be true.

The one-directional flow protects the substrate from both failure modes.

## Where each layer lives

Context layers live in `<project>/01-position.md` through `<project>/10-strategy.md`, plus the index at `<project>/00-INDEX.md`. Drafts live in `<project>/drafts/<goal-id>/`. Resolved drafts move to `<project>/shipped/<date>/`. Signals live in `<project>/signals/inbox/` until the signal-analyst processes them, then move to `<project>/signals/processed/<date>/`.
