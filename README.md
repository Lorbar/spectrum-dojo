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

**At home (same Wi-Fi):** the Home Hub in `../hub` already serves this folder at **http://MindKraftMBP.local:8080/dojo/** (or `http://10.0.0.172:8080/dojo/`). It starts at login through launchd, so nothing needs running by hand. See `../hub/README.md`.

If the hub is not running, the standalone script serves this folder alone on port 8081 and prints the address:

```bash
./serve.sh
```

On iPhone or iPad open the address in Safari, tap Share, then **Add to Home Screen**. This gives you an icon, but over plain `http://` the browser will not install the offline cache (service workers need HTTPS). Offline use therefore needs the GitHub Pages step described in `HANDOFF.md`; once the app is at its `https://` address, install from there instead and it will keep working with no connection.

**Away from home and offline:** the app must be hosted over HTTPS. Decided plan: GitHub Pages, to be set up from the personal GitHub account (steps in `HANDOFF.md`). Other options considered:

1. **GitHub Pages** (chosen): free, HTTPS, public URL, no personal data in the app. The address becomes `https://<user>.github.io/spectrum-dojo/`.
2. **Tailscale** with `tailscale serve` gives the Mac an HTTPS address that works anywhere, but the Mac must stay on.
3. **Local HTTPS on the hub** with `mkcert` works offline at home only and needs the certificate trusted on every device.
4. **Claude Artifact** gives a private link but runs in a sandbox that does not support offline caching.

Progress is stored per browser. Use **Move progress to another device** in Quiz arena to copy the code from one device and import it on another; imports merge.

## Progress storage

Quiz progress, math streak and last tab are saved in the browser's `localStorage` under keys prefixed `sd:`. Nothing leaves the machine. "Reset progress" in Quiz arena clears the Leitner state (two clicks to confirm).

## Accuracy note

Content is written against CWNA-level material (CWNA-108/109 era). Regulatory details such as UNII-4 and 6 GHz power classes vary by country and change over time. Verify anything regulatory against the current CWNP exam objectives at cwnp.com before exam day.

See `CLAUDE.md` for the code layout and how to extend the question bank, flows and generators.
