# Kazuma Okamoto — Plate Approach 2026

**Interactive Statcast plate approach analysis of Kazuma Okamoto's first 14 games with the Toronto Blue Jays. Built from real pitch-level coordinate data (266 pitches, 60 plate appearances) using Baseball Savant export data.**

[**View the live visualization**](https://scherrology-sys.github.io/okamoto-plate-approach/)

---

## What this is

A season-long interactive tracking project documenting how pitchers attack Kazuma Okamoto, and how he adjusts. This entry covers Games 1-14, March 27 through April 12, 2026.

---

## Key findings (through April 12)

**The evolution from the debut series:**

* First-pitch take rate dropped from 100% to **72%** across 60 plate appearances. He is engaging earlier, with 17 first-pitch swings now. The debut's full-take approach was intelligence gathering. The application has begun.

* Fastball contact remains elite. **98.4 avg exit velocity** on 4-seam contact. Two home runs at 110.4 and 107.7 EV. Multiple 100+ mph balls in play. When he squares up a heater, the result is damage.

* The debut's zero-swing rate on sliders and cutters is gone. He is swinging at both now. The problem is the whiff rates that came with engagement: **62% whiff on sliders, 75% whiff on cutters**. He found the pitch type; contact on it is the unresolved question.

* **35% strikeout rate** (21 K / 60 PA). The swing-and-miss against glove-side breaking balls is the driver. RHP sliders carry an 85.7% whiff rate; RHP cutters 83.3%.

* **6 walks**, 10% walk rate. The plate discipline foundation is intact even as he opens up on first pitches.

* **xwOBA .295** across 33 balls in play.

* Three GIDPs on sinkers down in the zone. Pitchers have a second sequence: heavy sinker below the belt to generate weak ground contact.

---

## The questions after 14 games

* Can he make contact on glove-side breaking balls before pitchers commit fully to that put-away sequence? His 0% whiff rate on sweepers in two-strike counts suggests he is capable of figuring out a pitch type mid-season.

* Will the GIDP pattern on sinkers hold? Three GIDPs in 60 PA is a meaningful signal that pitchers are willing to go low-and-heavy against him rather than always attacking the breaking ball vulnerability.

* Does the 35% K rate stabilize or climb? The fastball ceiling (two HRs, 98.4 avg EV on contact) makes the strikeouts tolerable if he can limit them. If the rate climbs, the contact quality ceiling becomes harder to reach.

---

## Tabs

| Tab | Description |
|-----|-------------|
| 01 · Hot Zones | All 266 pitches. Contact quality, whiff locations, outcome map across the zone. |
| 02 · First Pitch | All 60 first-pitch takes and swings. Take rate shift from 100% to 72% visualized. |
| 03 · vs Handedness | RHP vs LHP splits. Slider and cutter whiff zone from RHP. |
| 04 · Spray Chart | 33 balls in play. Pull tendency, GIDP locations, home run directions. |
| 05 · Pitch Arsenal | Full pitch-type breakdown: 9 pitch types, swing%, whiff%, exit velocity. |

---

## Files

| File | Description |
|------|-------------|
| `index.html` | Interactive visualization, self-contained, no server required |
| `README.md` | This file |

---

## Data source

Downloaded from [Baseball Savant](https://baseballsavant.mlb.com)

Filters: Batter = Okamoto, Kazuma (ID: 672960) · Season = 2026 · Regular season · Games 1-14 (through April 12, 2026)

---

## Pitch type coverage

| Pitch | Seen | Swing% | Whiff% |
|-------|------|--------|--------|
| 4-Seam Fastball | 72 | 54% | 33% |
| Sinker | 46 | 52% | 12% |
| Sweeper | 41 | 34% | 29% |
| Slider | 37 | 35% | 62% |
| Cutter | 29 | 28% | 75% |
| Changeup | 12 | 42% | 40% |
| Split-Finger | 11 | 36% | 50% |
| Curveball | 10 | 60% | 50% |
| Knuckle Curve | 7 | 43% | 33% |

---

## Part of a series

This is part of an ongoing series of interactive Statcast visualizations for Toronto Blue Jays hitters.

* [Vladimir Guerrero Jr. — Plate Approach 2024-2026](https://scherrology-sys.github.io/vlad-plate-approach)
* Kazuma Okamoto — Plate Approach 2026 (this project)

---

Analysis by Evan Scherr · [GitHub: scherrology-sys](https://github.com/scherrology-sys) · @scherrology
