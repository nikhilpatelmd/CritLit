# R/setup/tags.R
# Canonical tag registry for CritLit.
# Sourced by seed.R before any per-trial scripts, because trial_tags
# references this table via a foreign key.
#
# To add a new tag: add a row to the appropriate tibble below.
# tag_id is derived automatically from tag_name, so you only need
# to specify tag_name and tag_type.
#
# Derivation rule: lowercase, spaces → underscores, special chars removed.
# e.g. "Utility-Weighted mRS" → "utilityweighted_mrs" ... so for hyphenated
# names you may want to add a manual str_replace step, or just use clean names.

# ── Define tags by type ───────────────────────────────────────────────────────
# Keeping each type in its own tibble makes it easy to scan and extend.
# They'll be combined into a single table before writing to the database.

conditions <- tibble(
  tag_name = c(
    "Intracerebral Hemorrhage",
    "Subarachnoid Hemorrhage",
    "Acute Ischemic Stroke",
    "Intraventricular Hemorrhage",
    "Sepsis"
  ),
  tag_type = "condition"
)

topics <- tibble(
  tag_name = c(
    "Neurosurgical Intervention",
    "Minimally Invasive Neurosurgery",
    "Craniotomy",
    "Decompressive Craniectomy",
    "Intraventricular Thrombolysis",
    "Hematoma Evacuation",
    "Mechanical Thrombectomy",
    "Intravenous Thrombolytics"
  ),
  tag_type = "topic"
)

methodology <- tibble(
  tag_name = c(
    "Ordinal Outcome",
    "Utility-Weighted mRS",
    "Early Termination",
    "Open Label",
    "Blinded Endpoint"
  ),
  tag_type = "methodology"
)

networks <- tibble(
  tag_name = c(
    "NINDS"
  ),
  tag_type = "network"
)

regions <- tibble(
  tag_name = c(
    "North America",
    "Europe",
    "International"
  ),
  tag_type = "region"
)

# ── Combine and derive tag_id ─────────────────────────────────────────────────
# bind_rows() stacks all five tibbles into one, then we derive tag_id in a
# single mutate() pass so the rule is defined exactly once in one place.

tags <- bind_rows(conditions, topics, methodology, networks, regions) |>
  mutate(
    tag_id = tag_name |>
      str_to_lower() |>
      str_replace_all("[^a-z0-9]+", "_") |> # any run of non-alphanumeric chars → single underscore
      str_remove("_$") |> # trim any trailing underscore
      str_remove("^_") # trim any leading underscore
  ) |>
  select(tag_id, tag_name, tag_type) # reorder to match the table schema

# ── Write to database ─────────────────────────────────────────────────────────
dbAppendTable(con, "tags", tags)
