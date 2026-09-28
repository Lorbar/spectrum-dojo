# Spectrum Dojo

A self-contained CWNA study tool. One HTML page plus a manifest, a service worker and icons so it installs as an app on phones and tablets. No build step, no framework, no dependencies beyond Google Fonts (which fall back to system fonts offline).

**Open it:** double-click `index.html`, or run `./serve.sh` to serve it on your network (needed for install and offline use).

## What is inside

| Tab | What it does |
|---|---|
| Spectrum | Interactive 2.4 / 5 / 6 GHz channel maps. Click a channel for centre frequency, UNII segment, DFS status, PSC status and the bonded group at 20 to 320 MHz. |
| Generations | Wi-Fi legacy through Wi-Fi 7 on a timeline. Pick two to compare PHY, widths, modulation, streams, rates, subcarriers and symbol timing. |
| Rate calc | PHY data-rate calculator. Pick PHY, width, MCS, spatial streams and guard interval; the formula is shown with the numbers plugged in, plus a full MCS table for that configuration. |
| RF math | Infinite generated drills: mW to dBm and back (rule of 10s and 3s), EIRP, free space path loss, link budget, SNR, the 6 dB distance rule, channel centre frequencies, dB to ratio, PHY rate. Every problem has a worked solution. |
| Frame flow | Step-through ladder diagrams: passive and active scanning, Open System auth and association, WPA2 4-way handshake, 802.1X/EAP, WPA3 SAE, CSMA/CA with RTS/CTS, 802.11r fast transition. |
| Quiz arena | About 280 CWNA-style questions across the eight exam domains, including select-all-that-apply and scenario questions, with spaced repetition (three Leitner boxes), a per-domain accuracy heatmap, domain drills, and a 60-question 90-minute exam simulation that samples by the CWNA domain weights and mixes in generated math questions. Includes a missed-questions review and a progress code for moving progress between devices. |
| Glossary | About 200 searchable terms across PHY, MAC, RF, architecture, security, roaming, regulatory and survey categories. Type to filter by term, abbreviation or definition text. |
| Reference | PHY and data-rate table (per amendment: bands, widths, top MCS, streams, single-stream rate at each width, spec maximum), timing table, MCS table, subcarrier table, band table, amendment list, security matrix, RF formulas, design numbers. |

## Use it on your phone, iPad or another laptop

**Anywhere, online or offline:** **https://lorbar.github.io/spectrum-dojo/** — hosted free on GitHub Pages, HTTPS, works away from home. On iPhone or iPad open it in Safari, tap Share, then **Add to Home Screen** while online once; after that it keeps working in Airplane Mode (service workers need HTTPS to install, which is why this address is the one to install from).

**At home (same Wi-Fi):** the Home Hub in `../hub` also serves this folder at **http://server.local:8080/dojo/** (or the Mac's current LAN IP, see `../URLS.txt`). It starts at login through launchd. See `../hub/README.md`. This copy is plain HTTP, so offline install does not work from it — use the GitHub Pages address above for that.

If neither is running, the standalone script serves this folder alone on port 8081 and prints the address:

```bash
./serve.sh
```

**Publishing an update:** edit `index.html`, bump `CACHE` in `sw.js` so installed devices refresh, then from this folder:

```bash
git add -A && git commit -m "..." && git push
```

GitHub Pages redeploys automatically within about a minute.

Progress is stored per browser. Use **Move progress to another device** in Quiz arena to copy the code from one device and import it on another; imports merge.

## Progress storage

Quiz progress, math streak and last tab are saved in the browser's `localStorage` under keys prefixed `sd:`. Nothing leaves the machine. "Reset progress" in Quiz arena clears the Leitner state (two clicks to confirm).

## Accuracy note

Content is written against CWNA-level material (CWNA-108/109 era). Regulatory details such as UNII-4 and 6 GHz power classes vary by country and change over time. Verify anything regulatory against the current CWNP exam objectives at cwnp.com before exam day.

See `CLAUDE.md` for the code layout and how to extend the question bank, flows and generators.
