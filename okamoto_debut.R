# =============================================================================
# Kazuma Okamoto — MLB Debut Series Plate Approach Analysis
# Statcast pitch-level data, Games 1–3, March 27–29, 2026
#
# Author: Evan Scherr
# Data:   Baseball Savant via baseballr package
#         Batter: Kazuma Okamoto (Statcast ID: 808967)
#         Date range: 2026-03-27 to 2026-03-29
#         Game type: Regular season
#
# Output: JSON coordinate files consumed by index.html (okamoto-debut)
#         Summary statistics tables
#
# Dependencies: baseballr, dplyr, jsonlite, tidyr
# =============================================================================

library(baseballr)
library(dplyr)
library(jsonlite)
library(tidyr)


# =============================================================================
# 1. PULL DATA FROM STATCAST
# =============================================================================

# Okamoto's Statcast ID: 808967
# Pulling his debut series — Games 1 through 3

df <- statcast_search_batters(
  start_date = "2026-03-27",
  end_date   = "2026-03-29",
  batterid   = 808967
)

cat("Rows loaded:", nrow(df), "\n")
cat("Date range:", format(min(df$game_date)), "to", format(max(df$game_date)), "\n")
cat("Total pitches:", nrow(df), "\n")
cat("At-bats:", length(unique(df$at_bat_number)), "\n")


# =============================================================================
# 2. CLASSIFY PITCH OUTCOMES
# =============================================================================

swing_types <- c("swinging_strike", "foul", "foul_tip",
                 "hit_into_play", "swinging_strike_blocked")

take_types  <- c("ball", "called_strike", "blocked_ball",
                 "automatic_ball", "automatic_strike")

pitch_families <- c(
  "4-Seam Fastball" = "Fastball",
  "Sinker"          = "Fastball",
  "Cutter"          = "Fastball",
  "Slider"          = "Breaking",
  "Sweeper"         = "Breaking",
  "Curveball"       = "Breaking",
  "Knuckle Curve"   = "Breaking",
  "Changeup"        = "Offspeed",
  "Split-Finger"    = "Offspeed"
)

df <- df |>
  mutate(
    is_swing     = description %in% swing_types,
    is_take      = description %in% take_types,
    pitch_family = recode(pitch_name, !!!pitch_families, .default = "Other"),

    # Out-of-zone using batter-specific sz_top / sz_bot
    out_of_zone  = (abs(plate_x) > 0.831) |
                   (plate_z < sz_bot)      |
                   (plate_z > sz_top)
  )


# =============================================================================
# 3. SUMMARY STATISTICS
# =============================================================================

# --- 3a. Overall plate discipline ---
cat("\n--- Overall Plate Discipline ---\n")
df |>
  summarise(
    total_pitches  = n(),
    swing_pct      = round(mean(is_swing) * 100, 1),
    chase_pct      = round(mean(is_swing[out_of_zone], na.rm = TRUE) * 100, 1),
    zone_swing_pct = round(mean(is_swing[!out_of_zone], na.rm = TRUE) * 100, 1),
    whiff_pct      = round(
      sum(description %in% c("swinging_strike", "swinging_strike_blocked")) /
      sum(is_swing) * 100, 1),
    avg_ev         = round(mean(launch_speed, na.rm = TRUE), 1)
  ) |>
  print()


# --- 3b. First-pitch behaviour ---
cat("\n--- First Pitch Summary ---\n")
df |>
  filter(balls == 0, strikes == 0) |>
  summarise(
    total_fp         = n(),
    fp_swing_pct     = round(mean(is_swing) * 100, 1),
    fp_take_pct      = round(mean(is_take) * 100, 1),
    fp_called_strike = sum(description == "called_strike"),
    fp_cs_pct        = round(fp_called_strike / total_fp * 100, 1),
    fp_ball_pct      = round(sum(description == "ball") / total_fp * 100, 1)
  ) |>
  print()


# --- 3c. Pitch type breakdown ---
cat("\n--- Pitch Type Breakdown ---\n")
df |>
  filter(!is.na(pitch_name)) |>
  group_by(pitch_name, pitch_family) |>
  summarise(
    n             = n(),
    swing_pct     = round(mean(is_swing) * 100, 1),
    whiff_pct     = round(
      sum(description %in% c("swinging_strike", "swinging_strike_blocked")) /
      sum(is_swing) * 100, 1),
    avg_ev        = round(mean(launch_speed[is_swing], na.rm = TRUE), 1),
    .groups       = "drop"
  ) |>
  arrange(desc(n)) |>
  print()


# --- 3d. vs RHP vs LHP splits ---
cat("\n--- Handedness Splits ---\n")
df |>
  group_by(p_throws) |>
  summarise(
    n          = n(),
    swing_pct  = round(mean(is_swing) * 100, 1),
    chase_pct  = round(mean(is_swing[out_of_zone], na.rm = TRUE) * 100, 1),
    whiff_pct  = round(
      sum(description %in% c("swinging_strike", "swinging_strike_blocked")) /
      sum(is_swing) * 100, 1),
    .groups    = "drop"
  ) |>
  print()


# --- 3e. Changeup and curveball vulnerability ---
cat("\n--- Changeup & Curveball Detail ---\n")
df |>
  filter(pitch_name %in% c("Changeup", "Curveball")) |>
  select(pitch_name, p_throws, balls, strikes, description,
         plate_x, plate_z, release_speed, launch_speed, events) |>
  mutate(
    count    = paste0(balls, "-", strikes),
    off_edge = round(plate_x, 3),
    off_zone = round(plate_z, 3)
  ) |>
  print()


# --- 3f. Contact quality ---
cat("\n--- Contact Quality (balls in play) ---\n")
df |>
  filter(description == "hit_into_play") |>
  select(pitch_name, launch_speed, launch_angle, bb_type,
         events, hc_x, hc_y) |>
  arrange(desc(launch_speed)) |>
  print()


# --- 3g. Expected stats ---
cat("\n--- Expected Stats ---\n")
cat("xBA (avg):", round(mean(df$estimated_ba_using_speedangle, na.rm = TRUE), 3), "\n")
cat("xwOBA:    ", round(sum(df$woba_value, na.rm = TRUE) /
                         sum(df$woba_denom, na.rm = TRUE), 3), "\n")


# =============================================================================
# 4. BUILD COORDINATE DATASETS FOR VISUALIZATION
# =============================================================================

coords <- function(subdf) {
  clean <- subdf |> filter(!is.na(plate_x), !is.na(plate_z))
  list(
    x = round(clean$plate_x, 4),
    z = round(clean$plate_z, 4)
  )
}

sz_top_avg <- round(mean(df$sz_top, na.rm = TRUE), 4)
sz_bot_avg <- round(mean(df$sz_bot, na.rm = TRUE), 4)

# Subset datasets
fp_takes  <- df |> filter(balls == 0, strikes == 0, is_take)
fp_swings <- df |> filter(balls == 0, strikes == 0, is_swing)
all_takes  <- df |> filter(is_take)
all_swings <- df |> filter(is_swing)
contact    <- df |> filter(description == "hit_into_play")
whiffs     <- df |> filter(description %in% c("swinging_strike",
                                               "swinging_strike_blocked"))

# Home run location
hr <- df |> filter(events == "home_run")
hr_loc <- list(
  x = round(hr$plate_x[1], 4),
  z = round(hr$plate_z[1], 4)
)

# Spray chart (hc_x / hc_y)
bip <- df |>
  filter(description == "hit_into_play") |>
  filter(!is.na(hc_x), !is.na(hc_y))

spray <- list(
  hc_x    = round(bip$hc_x, 1),
  hc_y    = round(bip$hc_y, 1),
  ev      = round(bip$launch_speed, 1),
  la      = round(bip$launch_angle, 1),
  events  = bip$events,
  bb_type = bip$bb_type,
  pitch   = bip$pitch_name
)

# vs RHP / vs LHP coordinate splits
splits <- lapply(c("R", "L"), function(hand) {
  sub     <- df |> filter(p_throws == hand)
  sw_sub  <- sub |> filter(is_swing)
  list(
    total      = nrow(sub),
    swing_pct  = round(mean(sub$is_swing) * 100, 1),
    coords     = coords(sub),
    swing_coords = coords(sw_sub)
  )
}) |> setNames(c("vsRHP", "vsLHP"))

# Changeup / Curveball detail for vulnerability map
offspeed_detail <- df |>
  filter(pitch_name %in% c("Changeup", "Curveball"),
         !is.na(plate_x), !is.na(plate_z)) |>
  mutate(count = paste0(balls, "-", strikes)) |>
  select(pitch = pitch_name, count, desc = description,
         plate_x, plate_z, velo = release_speed, hand = p_throws,
         event = events) |>
  mutate(
    plate_x = round(plate_x, 3),
    plate_z = round(plate_z, 3),
    velo    = round(velo, 1)
  ) |>
  as.list() |>
  (\(x) lapply(seq_len(nrow(
    df |> filter(pitch_name %in% c("Changeup","Curveball"), !is.na(plate_x))
  )), function(i) lapply(x, `[[`, i)))()


# =============================================================================
# 5. EXPORT JSON
# =============================================================================

main_export <- list(
  sz_top      = sz_top_avg,
  sz_bot      = sz_bot_avg,
  stand       = "R",
  all_takes   = coords(all_takes),
  all_swings  = coords(all_swings),
  fp_takes    = coords(fp_takes),
  contact     = coords(contact),
  whiffs      = coords(whiffs),
  hr_loc      = hr_loc,
  spray       = spray,
  splits      = splits,
  offspeed    = offspeed_detail
)

write(toJSON(main_export, auto_unbox = TRUE, digits = 4),
      "okamoto2.json")

cat("\n✓ JSON written: okamoto2.json\n")
cat("  Feed into index.html (okamoto-debut repo)\n")


# =============================================================================
# 6. REPRODUCIBILITY NOTE
# =============================================================================
#
# To update this analysis as the season progresses:
#   1. Extend the end_date in the statcast_search_batters() call
#   2. Re-run the script
#   3. Replace okamoto2.json alongside index.html in the GitHub repo
#
# The HTML visualization reads the JSON at runtime.
# No other changes needed to the visualization file.
#
# To pull the full 2026 season as it accumulates:
#   df <- statcast_search_batters(
#     start_date = "2026-03-27",
#     end_date   = Sys.Date(),
#     batterid   = 808967
#   )
#
# Session info:
cat("\n--- Session Info ---\n")
sessionInfo()
