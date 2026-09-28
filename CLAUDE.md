# Spectrum Dojo, guide for Claude

Purpose: a personal CWNA exam trainer and general Wi-Fi learning tool for Tobi. Single-file static web app. Keep it that way: no build tooling, no framework, no external scripts. Google Fonts is the only external resource and must degrade gracefully.

## File layout

- `manifest.webmanifest`, `sw.js`, `icon.svg`, `icon-180.png`, `icon-512.png`: Progressive Web App files. The service worker is network-first with cache fallback and registers only over http/https. Bump `CACHE` in `sw.js` when a change must reach installed devices immediately.
- LAN hosting is done by the Home Hub in `../hub` (`apps.json` mounts this folder at `/dojo/` on port 8080, run by launchd). `serve.sh` and `.claude/launch.json` are a standalone fallback on port 8081. All asset paths in `index.html`, `manifest.webmanifest` and `sw.js` are relative so the app works at `/dojo/` or at the root.

- `index.html`, the whole app. Three regions in order:
  1. `<style>`: CSS. Colour tokens live on `:root` (light, the default). Dark tokens are redefined under `:root[data-theme="dark"]` and, for the Auto option, under `@media (prefers-color-scheme: dark)` guarded by `:root[data-theme="auto"]`. The theme is Light unless the user picks Dark or Auto in the header switch; the choice is saved as `sd:theme` and applied by an inline script in `<head>` before first paint. Tobi asked for a clean off-white look by default, so do not make the page follow the OS dark setting automatically. Never hard-code a colour in a component rule; use the tokens. Band colours: `--b24` teal, `--b5` violet, `--b6` amber.
  2. First `<script>` (DATA): the `D` object. All Wi-Fi facts live here and nowhere else.
  3. Second `<script>` (APP): rendering and interaction, one block per tab, in the same order as the tabs.
- `README.md`, user-facing description.
- `HANDOFF.md`, design intent and ideas not yet built.

## Data model (`D`)

- `D.mcs`: MCS 0 to 13 as `[modulation, bitsPerSubcarrier, codingLabel, codingRate]`. `D.legacyMcs` is the 802.11a/g fixed-rate table.
- `D.phys`: per PHY (`ag`, `n`, `ac`, `ax`, `be`): `widths` maps channel width in MHz to data subcarrier count, `maxMcs`, `maxSS`, `tdft` (µs), `gi` (µs options). The rate calculator and the "PHY rate" math generator both read this.
- `D.gens`: one object per generation for the Generations tab. Fields are rendered by label list in `renderGens()`.
- `D.bands`: `'24'`, `'5'`, `'6'` with frequency `range`, allowed `widths`, and bullet `notes`. Channel lists, centre frequency formulas, UNII segmentation and bonded-group logic are functions in the APP script (`chList`, `centre`, `segment`, `group`, `isPSC`).
- `D.flows`: ladder diagrams. Each has `parts` (columns) and `steps`. A step is either an arrow `{f, t, l, n}` (from index, to index, label, note) or a note `{k:'note', p, l, n}` placed under participant `p`.
- `D.domains`: the eight CWNA domain keys and display names: `rf`, `ant`, `reg`, `proto`, `arch`, `sec`, `val`, `tsh`.
- `D.glossCats` and `D.gloss`: the Glossary tab. Each entry is `[term, subtitle, category, definition]` or `[term, category, definition]` (three-element form when there is no subtitle). Categories must be keys of `D.glossCats`. `[[Term]]` inside a definition renders as a link that searches for that term.
- `D.bank`: quiz questions `{d, q, o:[4 options], a: correctIndex, e: explanation}`. Select-all-that-apply questions add `m:true` and make `a` an array of correct indices. `D.weights` holds the approximate CWNA blueprint percentages per domain; exam mode allocates its 60 slots proportionally (`start('exam')`), replacing 3 RF and 2 regulatory slots with generated problems. IDs are assigned by array index at load (`q0`, `q1`, ...), so **append new questions at the end**; inserting in the middle shifts IDs and scrambles saved progress.

## Adding content

- New quiz question: append to `D.bank`. Keep four options, one correct, and an explanation that teaches the discriminator, not just restates the answer.
- New generated problem type: add an entry to `M.types` in the APP script with `name` and `gen()` returning `{q, unit, ans, tol, sol}`. Add its key to the list inside `genQ()` if it should also appear as multiple choice in exams.
- New frame flow: append to `D.flows`.
- New glossary term: append to `D.gloss` with a valid category key.
- Client presets for the throughput matrix live in `C.presets` (name, description, phy, ss, width, mcs). The matrix (`renderClient`) reads the same `R` state as the rate calculator and is re-rendered from `renderRate`.
- New reference card: append a `[title, html]` pair to `refs`.

## Storage

`store.get/set` wrap `localStorage` with try/catch; keys are prefixed `sd:`. Progress can be exported and imported as JSON through the sync panel (`exportProg` / `importProg`); imports merge by keeping the record with the higher `seen` count. Saved: `prog` (Leitner state per question id: `box`, `seen`, `right`, `due`), `streak`, `best`, `tab`. Leitner boxes 0 to 3 with due intervals 0, 1, 3, 7 days. Mastery in the header counts questions in box 2 or higher.

## Conventions

- British English in UI copy. No em dashes.
- Accuracy over volume. Every fact in `D` should be defensible against the CWNA study guide. When unsure, phrase as a rule of thumb and say so in the explanation.
- Do not add a build step or split into modules unless Tobi asks. The single file is deliberate so it can be opened from a USB stick or phone.
- If publishing as a Claude Artifact: strip the outer `<!doctype>`, `<html>`, `<head>`, `<body>` tags first (the publisher adds its own skeleton), and also remove the manifest, apple-touch-icon and icon `<link>` tags plus the `serviceWorker` registration block, or publish `sw.js`, `manifest.webmanifest` and the icons alongside via the `files` parameter.

## Hosting status

Served on the LAN by the Home Hub over plain HTTP, which is why offline mode (service worker) does not work yet. The agreed next step is GitHub Pages from Tobi's personal account; the exact commands and follow-up checks are in `HANDOFF.md`. Read that section before touching hosting.

## Quick checks

Syntax check the scripts without a browser:

```bash
python3 -c "import re;s=open('index.html').read();open('/tmp/sd.js','w').write('\n'.join(re.findall(r'<script>(.*?)</script>',s,re.S)))" && node --check /tmp/sd.js
```

Then open `index.html` in a browser and click through every tab; all tabs render at load, so a clean console on load covers most regressions.
