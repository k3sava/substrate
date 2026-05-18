# Substrate copy rules (generic)

Agent-facing rules for any agent generating, editing, or reviewing copy that ships from substrate. Each rule lists the rule itself, the reasoning, and how to apply it.

These rules are intentionally generic. Per-client overrides live at `clients/<client>/brand-voice/`. When a per-client rule contradicts a generic rule, the per-client rule wins.

---

## 1. No em dashes in body copy

**Rule:** Do not use em dashes (the `—` character) in body copy of any draft, email, or deliverable.

**Why:** LLMs default to em dashes; readers recognize the pattern. Substituting periods, commas, colons, semicolons, or rewrites produces tighter prose.

**How to apply:** Before finalizing any draft, search for `—` and replace each instance with the right punctuation: a period to split into two sentences, a comma for a light pause, a colon for a list or explanation, a semicolon for related clauses, or a rewrite. Never blanket find-replace; pick the right fix per case. Section headers may use em dashes; the rule applies to body paragraphs.

---

## 2. Disambiguate AI agents from human roles

**Rule (layered):**
- **Humans:** sales / support / CS people are titled by their role ("rep", "SDR", "AE", "CSM", "specialist"). Avoid "agent" or "agents" for humans in customer-facing copy.
- **Product:** when an AI product is canonically named "X Agent", use the canonical name on first reference, then shorten in continuing context.
- **Internal-only:** internal code names and code symbols (component names, function names) are exempt; they must not appear in customer-facing copy.

**Why:** Mixing "agents" for humans and AI in the same paragraph confuses the reader. Picking a stable convention per role lets the prose stay readable.

**How to apply:**
1. Before shipping any draft, grep for `\bagent(s)?\b` and decide for each match: AI product (keep) or human (replace with role).
2. First reference to the AI product uses its canonical name. Subsequent references can shorten once context is established.
3. In drafts that mix human + AI references in the same section, use clearly disambiguating wording.

---

## 3. No forced line breaks in body or deck text

**Rule:** Do not use `\n` in body copy, deck sentences, or feature intros. Only use intentional breaks in H1 / H2 headlines where the two-line structure is a deliberate design choice.

**Why:** Forced breaks fight reflow at different viewport widths and create awkward orphans.

**How to apply:** Headlines may use `\n`. Hero body, problem body, features deck, feature intros, kickers stay as continuous text. Let the container width handle wrap.

---

## 4. Match copy to actual product behavior

**Rule:** When the user experience is manual, do not write copy that implies automation. When automatic, do not under-describe.

**Why:** Aspirational claims about feature behavior produce trust loss when buyers try the product.

**How to apply:** Before writing any product behavior claim, verify against the client's `clients/<client>/product-knowledge/`. If the source says "manual", write copy that frames it as manual. If the source says "automatic", say so. Same caution for any other feature where the user experience and the copy could diverge.

---

## 5. Pullquote and nearby stats must come from the same customer

**Rule:** When a landing page places a customer pullquote beside numeric stats in the same band or section, every stat in that block must belong to the same customer as the quote.

**Why:** Mixing customer attributions inside a single proof band reads as bait-and-switch and erodes trust.

**How to apply:** Before shipping any pullquote block with stats, check that the attribution name matches the source on every stat. If the featured customer doesn't have enough data points, either swap the quote to a customer that does, or drop to a single stat.

---

## 6. Verify every proper noun against its source

**Rule:** Customer names, company names, product names must be verified against source URLs or documents before use in copy.

**Why:** Misspelled or misformatted proper nouns ship as errors. Recurring failure mode.

**How to apply:** Before writing any proper noun, verify against (1) the client's `clients/<client>/positioning/allowed-claims.md`, (2) the case-study URL slug on the client's site, or (3) the original draft document. If none of those are available, flag it as unverified rather than guessing.

---

## 7. Fact-check against primary sources, not summaries

**Rule:** When reviewing claims, check the primary source (live page, help article, pricing page, product spec) before flagging or accepting. Summary docs (`product-knowledge.md`) are convenience artifacts; their caveats can be incomplete or stale.

**Why:** Reviewing from summaries produces both false positives (flagging claims that are valid) and false negatives (passing claims that are wrong).

**How to apply:**
1. Before flagging a claim, check the live source. If it's there, it's reusable.
2. Before citing a summary caveat, check the actual source page. Summaries can be over-conservative.
3. For feature names, search the substrate with multiple patterns before claiming something doesn't exist.
4. Live pages, help docs, pricing = ground truth. Summary = convenience.

---

## 8. Page copy line discipline

**Rule:**
- Headlines: one line. If it wraps, rewrite shorter.
- Body / subtext: two lines max. Break the trailing sentence into its own paragraph if needed.
- Bullets: one line each. No wrapping.
- Subtext under section headers: must fit one line at 1440px. Widen max-width if needed.
- CTAs: Title Case, always.

**Why:** Consistent line discipline makes the page look intentional, not auto-generated.

**How to apply:** Before deploying any page, check every text element at 1440px against these rules. If body is 3+ lines, split or rewrite. If a headline wraps, shorten it.

---

## 9. Homepage is platform, product pages are product-specific

**Rule:** Homepage and product pages serve different purposes and must look and feel different. Avoid sharing hero-area components between them.

- Homepage: platform story, all audiences. Structure: Hero → Logos → Testimonials → Problem → Solution → Integrations → Security → Updates → CTA.
- Product pages: product-specific. Lead with product experience (audio, demos, interactive proof). Feature sections describe that product only.

**Why:** Sharing components causes the homepage and product pages to read as the same page.

**How to apply:** Before building a homepage, check that no section in the first 3 folds is reused from a product page.

---

## 10. Show the product before selling

**Rule:** On product pages, show the product working before explaining features. Interactive demos, audio panels, live screenshots go directly after the hero. Feature descriptions come after the visitor has experienced the product.

**Why:** Don't tell visitors it works; let them hear or see it. Then explain. The first interactive moment lands before any text-based selling.

**How to apply:** On any product page, section 2 (right after hero) is experiential proof. Feature sections start at section 3 or later.

---

## 11. Product pages are decision journeys, not feature tours

**Rule:** Every section answers the buyer's next question in scroll order. Sequence matters more than completeness.

1. "Is this for me?" — Hero reframes for the buyer's situation.
2. "What will it do for my numbers?" — 3 KPIs the buyer tracks (directional).
3. "Can it handle my scenarios?" — Workflow examples with the actual interaction shape.
4. "Will this be another silo?" — Platform section: one config, integrated.
5. "Is the experience real?" — Differentiator framed for the buyer's concern.
6. "Is it safe?" — Enterprise / security.
7. "What about my specific worry?" — FAQ on persona-specific objections.
8. "What else?" — Curated adjacent use cases.

**Why:** Question-ordered scrolls convert. Feature-listed scrolls don't.

**How to apply:**
- Before writing any section, ask "what is the buyer wondering RIGHT NOW?"
- KPI bullets map to metrics the buyer sees in their dashboard.
- Skip sections the buyer would not ask about at that point.
