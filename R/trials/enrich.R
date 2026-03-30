# R/trials/enrich.R
# ENRICH trial data. Uses `con` from seed.R's environment.
# Source: Pradilla et al., NEJM 2024. PMID: 38598795

# ── Trial record ──────────────────────────────────────────────────────────────
enrich_trial <- tibble(
  trial_id = "enrich",
  acronym = "ENRICH",
  title = "Trial of Early Minimally Invasive Removal of Intracerebral Hemorrhage",
  date_published = ymd("2024-04-10"),
  journal = "New England Journal of Medicine",
  doi = "10.1056/NEJMoa2308440",
  pmid = "38598795",
  trial_registration = "NCT02880878",
  funding_source = "Nico Corporation"
)

dbAppendTable(con, "trials", enrich_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
enrich_trial_tags <- tibble(
  trial_id = "enrich",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "minimally_invasive_neurosurgery"
  )
)

dbAppendTable(con, "trial_tags", enrich_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
enrich_links <- tibble(
  trial_id = "enrich",
  url = "https://doi.org/10.1056/NEJMoa2308440",
  label = "Primary Publication",
  description = "Pradilla et al. NEJM 2024",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", enrich_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
enrich_outcomes <- tibble(
  outcome_id = "enrich_mrs_180d",
  trial_id = "enrich",
  outcome_name = "mRS at 180 days",
  outcome_type = "ordinal",
  scale_name = "mRS",
  time_point = "180 days",
  is_primary = TRUE,
  notes = "Utility-weighted mRS used as primary analysis; raw ordinal distribution stored here."
)

dbAppendTable(con, "outcomes", enrich_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# Counts verified against Table 2, Pradilla et al. NEJM 2024.
# result_id omitted — filled automatically by DuckDB sequence.
enrich_mrs <- tibble(
  outcome_id = "enrich_mrs_180d",
  trial_id = "enrich",
  arm = c(rep("intervention", 7), rep("control", 7)),
  arm_label = c(rep("MIPS", 7), rep("Medical Management", 7)),
  level = rep(0:6, 2),
  count = c(
    3,
    17,
    44,
    27,
    21,
    16,
    22, # MIPS (n=150)
    2,
    11,
    42,
    33,
    17,
    18,
    27
  ), # Medical Management (n=150)
  total_n = 150L
)

dbAppendTable(con, "results_ordinal", enrich_mrs)
