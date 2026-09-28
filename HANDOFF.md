# Handoff notes

Built 2026-09-27 in one session as a novel CWNA study aid. This file records intent and open ideas so another Claude session can continue without the original conversation.

## The idea

"Learn by turning the knobs." Most exam tools are flashcards. CWNA is heavy on numbers that follow from a handful of formulas (dB math, path loss, PHY rate, channel centre frequencies, IFS timing). Spectrum Dojo makes every one of those a live simulator, then generates exam questions from the simulators so the answer key is never fixed. The static bank covers the conceptual material the simulators cannot.

## Design

- Palette: neutral warm grey ground, teal / violet / amber for the three bands (2.4 / 5 / 6 GHz). Semantic green / red / gold for correct, wrong and warning. Both light and dark themes.
- Type: Chakra Petch for display and tab labels (technical, squared), IBM Plex Sans body, IBM Plex Mono for numbers, frequencies and formulas.
- Layout: sticky header with a mastery bar and a horizontally scrolling tab strip; content in a 1180px column; panels stack to one column below about 600px. Spectrum maps scroll horizontally on narrow screens.

## Verified so far

- Scripts pass `node --check`.
- Page loads with no console errors in the desktop browser pane; all tabs render at load.
- Spot-checked formulas: VHT MCS 9 80 MHz 1 SS short GI = 433.3 Mbps; HE MCS 11 80 MHz 1 SS = 600.5 Mbps; EHT MCS 13 320 MHz 1 SS = 2882 Mbps; HT MCS 7 20 MHz = 65 Mbps; legacy 54 Mbps.

## Added on 2026-09-27 (second pass)

- Glossary tab with 199 searchable terms.
- Cleaner background: flat warm off-white ground (#EFEEE8), soft paper panels (#F8F7F2) with hairline borders and soft shadows. Ambient glows were tried and removed at Tobi's request; keep the ground flat.
- Progress sync panel (copy code, import and merge) and missed-questions review.
- PWA: manifest, icons, network-first service worker; `serve.sh` for LAN access.
- Reference: full-width PHYs and data rates table computed from `D.phys`.
- Rate calc: client throughput matrix (streams × width), device presets, efficiency slider for estimated real throughput.

## Not yet done

- **Offline mode does not work yet, and the cause is known.** Service workers require a secure origin (`https://` or `localhost`). The Home Hub serves the app over plain `http://MindKraftMBP.local:8080/dojo/`, so Safari on iPhone and iPad refuses to register `sw.js`. Tested 2026-09-27: Add to Home Screen works, but tapping the icon while offline shows a blank page. The desktop browser pane showed the same failure as "An unknown error occurred when fetching the script". Nothing in the app is broken; it only needs an HTTPS host. The plan is below.

## Plan: publish on GitHub Pages (agreed with Tobi, to be done from the Mac mini with the personal Claude and personal GitHub account)

Why GitHub Pages: free, HTTPS, reachable at home and away, and the app holds no personal data (quiz progress stays in each device's browser). Tobi chose this over Tailscale and over local HTTPS on the hub.

Steps, run from this folder while `gh` is signed in to the personal GitHub account (`gh auth status` to check, `gh auth login` if not):

```bash
cd ~/Documents/AI/Apps/spectrum-dojo && git init && git add -A && git commit -m "Spectrum Dojo" && gh repo create spectrum-dojo --public --source=. --push
```

```bash
gh api -X POST repos/{owner}/spectrum-dojo/pages -f build_type=legacy -f 'source[branch]=main' -f 'source[path]=/'
```

Then:

1. Wait a minute and open `https://<username>.github.io/spectrum-dojo/` in Safari on each device. Confirm in the desktop browser console that `navigator.serviceWorker.getRegistrations()` returns one registration.
2. On iPhone and iPad: Safari, Share, Add to Home Screen, open it once online. Then test with Airplane Mode on: the app must load.
3. Update `README.md` (replace the LAN address as the primary way to install with the Pages URL; keep the hub address for home use) and `../hub/apps.json` (change the Dojo entry's `url` or description so the hub card links to the Pages URL, or keep both).
4. Future updates: edit `index.html`, bump `CACHE` in `sw.js` (v1 to v2 and so on) so installed devices refresh, then `git commit` and `git push`. Pages redeploys automatically.

Notes for the personal Claude:

- `.claude/launch.json` and `serve.sh` are local-only helpers and are fine to commit; nothing in this folder is secret.
- If the repository must be private, GitHub Pages on private repos needs a paid plan; a public repo is the intended path.
- Do not add analytics or third-party scripts; the offline cache and the CWNA content are the whole product.

- No hands-on click-through of every interaction on a phone-width viewport.
- Quiz bank is 281 questions (rf 40, ant 26, reg 35, proto 59, arch 37, sec 32, val 25, tsh 27), 18 of them multi-select. Exam mode is weighted by `D.weights`. Next quality step: add a one-line reason why each wrong option is wrong (a `w:[...]` array per question) and show it after answering.

## Ideas for next iterations

1. **Site survey sandbox**: a floor plan canvas where APs are placed with channel and power; show co-channel contention and the 1/6/11 or 5 GHz reuse pattern, then ask "which AP causes CCI to AP 3?".
2. **CSMA/CA timeline animation**: horizontal time axis with DIFS, backoff slots, SIFS and ACK drawn to scale per PHY, with two contending stations.
3. **OFDMA RU planner**: drag clients onto 26/52/106/242-tone RUs inside a 20/40/80 MHz channel.
4. **Antenna pattern viewer**: azimuth and elevation polar plots for dipole, patch, sector and dish with adjustable gain, showing the −3 dB beamwidth.
5. **Capture reader**: paste a text summary of a frame exchange (or Wireshark export) and have the tool identify the frame types and state machine transitions.
6. **Export progress as a file or QR code** to make the device-to-device move quicker than copy and paste.
7. **Hosted sync**: if the app is ever published as a Claude Artifact with a database capability, progress could sync across devices without the code.
