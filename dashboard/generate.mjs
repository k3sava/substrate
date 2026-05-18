#!/usr/bin/env node
// Static dashboard generator for substrate.
//
// Reads goals/ledger.md, the active skill inventory, and the routine list,
// then emits dashboard/build/index.html — a single-page operator view
// (active goals + skill list + principles + last-run timestamps).
//
// Re-run after any goal-state change. Static HTML; no client runtime.

import fs from 'node:fs/promises'
import path from 'node:path'

const ROOT = process.env.SUBSTRATE_ROOT || path.resolve(path.dirname(new URL(import.meta.url).pathname), '..')
const OUT = path.join(ROOT, 'dashboard/build/index.html')
const VERSION = (await fs.readFile(path.join(ROOT, 'VERSION'), 'utf8')).trim()

await fs.mkdir(path.dirname(OUT), { recursive: true })

async function readMaybe(rel) {
  try { return await fs.readFile(path.join(ROOT, rel), 'utf8') }
  catch { return null }
}

async function listSkills() {
  const dir = path.join(ROOT, 'skills')
  const entries = await fs.readdir(dir, { withFileTypes: true })
  return entries.filter(e => e.isDirectory()).map(e => e.name).sort()
}

async function listRoutines() {
  const dir = path.join(ROOT, 'routines')
  const entries = await fs.readdir(dir, { withFileTypes: true })
  return entries.filter(e => e.isFile() && e.name.endsWith('.md')).map(e => e.name.replace(/\.md$/, '')).sort()
}

const skills = await listSkills()
const routines = await listRoutines()
const ledger = await readMaybe('goals/ledger.md')
const principles = await readMaybe('PRINCIPLES.md')

const hasRealLedger = ledger && !/status:\s*template/.test(ledger)
const ledgerNote = hasRealLedger
  ? '<em>Ledger present.</em>'
  : '<em>Ledger is the v1.0 template. Replace the placeholders with your goals.</em>'

const html = `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>substrate dashboard · v${VERSION}</title>
<style>
  body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; font-size: 14px; line-height: 1.5; color: #1C1917; background: #FAFAF9; margin: 0; padding: 24px; max-width: 1100px; margin: 0 auto; }
  h1 { font-family: 'Newsreader', Georgia, serif; font-weight: 500; font-size: 1.8rem; letter-spacing: -.01em; margin: 24px 0 4px; }
  h2 { font-family: 'Newsreader', Georgia, serif; font-weight: 500; font-size: 1.2rem; letter-spacing: -.01em; margin: 28px 0 8px; }
  .meta { font-family: 'JetBrains Mono', monospace; font-size: .76rem; color: #78716C; margin-bottom: 20px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 10px; }
  .card { background: #fff; border: 1px solid #E7E5E4; border-radius: 10px; padding: 12px 16px; }
  .card h3 { font-family: 'JetBrains Mono', monospace; font-size: .78rem; text-transform: lowercase; letter-spacing: .04em; color: #C2410C; margin: 0 0 6px; }
  .card .body { font-size: .92rem; color: #44403C; }
  ul { list-style: none; padding: 0; margin: 0; }
  ul li { padding: 4px 0; border-bottom: 1px dashed #E7E5E4; font-family: 'JetBrains Mono', monospace; font-size: .82rem; color: #44403C; }
  ul li:last-child { border: 0; }
  code { font-family: 'JetBrains Mono', monospace; font-size: .82rem; background: #F5F5F4; padding: 1px 6px; border-radius: 4px; }
  footer { margin-top: 36px; padding-top: 14px; border-top: 1px solid #E7E5E4; font-family: 'JetBrains Mono', monospace; font-size: .72rem; color: #78716C; }
</style>
</head>
<body>
<h1>substrate</h1>
<div class="meta">v${VERSION} · ${skills.length} skills · ${routines.length} routines · regenerated ${new Date().toISOString()}</div>

<h2>Goals</h2>
<div class="card"><div class="body">${ledgerNote} See <code>goals/ledger.md</code> for the canonical list and <code>goals/why-this-matters.yaml</code> for the per-goal narrative.</div></div>

<h2>Skills</h2>
<div class="grid">
${skills.map(s => `  <div class="card"><h3>${s}</h3><div class="body"><code>bin/substrate ${s} --help</code></div></div>`).join('\n')}
</div>

<h2>Routines</h2>
<ul>
${routines.map(r => `  <li>${r}</li>`).join('\n')}
</ul>

<h2>Principles</h2>
<div class="card"><div class="body">Read <code>PRINCIPLES.md</code> — eight rules in order. The slowest layer to change.</div></div>

<footer>
substrate · MIT · <a href="https://github.com/k3sava/substrate" style="color:inherit">github.com/k3sava/substrate</a>
</footer>
</body>
</html>
`

await fs.writeFile(OUT, html)
console.log(`[dashboard] wrote ${OUT} (${html.length.toLocaleString()} bytes; ${skills.length} skills, ${routines.length} routines)`)
