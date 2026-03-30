# Kazuma Okamoto — MLB Debut Series Plate Approach

> *100% first-pitch take rate. A 420 ft homer on pitch 2 of an AB. And some early questions about how pitchers will attack him.*

**[→ View the live visualization](https://scherrology-sys.github.io/okamoto-debut/)**

---

## What this is

An interactive Statcast plate approach analysis of Kazuma Okamoto's MLB debut series with the Toronto Blue Jays — Games 1–3, March 27–29, 2026. Built from real pitch-level coordinate data (60 pitches, 14 at-bats) using Baseball Savant export data.

## Key findings

- **100% first-pitch take rate** across all 14 at-bats in the debut series
- **Fastball contact is elite** — 99.8 avg exit velocity, 110.4 EV home run, 420 ft, Game 3
- **Zero swings on sliders and cutters** — 10 sliders, 5 cutters thrown, not one swing
- **Changeup vulnerability emerging** — 75% swing rate, 67% whiff, pitches 13+ inches off the outer edge from LHP
- **Curveball vulnerability emerging** — 67% whiff rate on curves below the strike zone from RHP
- **xBA .371** — underlying contact quality is strong despite 4 strikeouts

## The questions

60 pitches is a whisper, not a verdict. But some patterns are forming worth tracking:

- Is the zero-swing rate on sliders discipline or unfamiliarity with MLB breaking balls?
- Will LHP target the arm-side changeup earlier in the count once they confirm the vulnerability?
- Can he adjust to curveballs buried below the zone from RHP?

This visualization is the first entry in a season-long tracking project. The goal is to document how pitchers attack Jays hitters, and then watch how those hitters adjust.

## Tabs

| Tab | Description |
|-----|-------------|
| 01 · Hot Zones | Contact quality and whiff locations across all 60 pitches |
| 02 · First Pitch Takes | All 14 first-pitch takes, colored by ball/called strike |
| 03 · vs Handedness | RHP vs LHP splits, changeup and curveball vulnerability map |
| 04 · Spray Chart | Balls in play by location with exit velocity, Statcast hc_x/hc_y coordinates |
| 05 · Pitch Arsenal | Full pitch-type breakdown, swing%, whiff%, exit velocity |

## Files

| File | Description |
|------|-------------|
| `index.html` | Interactive visualization, self-contained, no server required |

## Data source

Downloaded from [Baseball Savant](https://baseballsavant.mlb.com/statcast_search)
Filters: Batter = Okamoto, Kazuma (ID: 808967) · Season = 2026 · Regular season · Games 1–3

## Part of a series

This is part of an ongoing series of interactive Statcast visualizations for Toronto Blue Jays hitters.

- [Vladimir Guerrero Jr. — Plate Approach 2024–2026](https://scherrology-sys.github.io/vlad-plate-approach/)

---

*Analysis by Evan Scherr · [GitHub](https://github.com/scherrology-sys)*
