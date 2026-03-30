# R/trials/enrich.R
# Source: 10.1056/NEJMoa2308440

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
# Tags must already exist in the tags table (inserted by an earlier script or
# a shared tags setup block). trial_tags just links this trial to them.

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
  link_id = 1L,
  trial_id = "enrich",
  url = "https://doi.org/10.1056/NEJMoa2308440",
  label = "Primary Publication",
  description = "Pradilla et al. NEJM 2024",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", enrich_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
enrich_outcomes <- tibble(
  outcome_id = c("enrich_mrs_180d"),
  trial_id = "enrich",
  outcome_name = c("mRS at 180 days"),
  outcome_type = c("ordinal"),
  scale_name = c("mRS"),
  time_point = c("180 days"),
  is_primary = c(TRUE),
  notes = c(
    "Utility-weighted mRS used as primary analysis; raw distribution stored here"
  )
)

dbAppendTable(con, "outcomes", enrich_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# Ordinal mRS distribution, one row per arm per score level.
# Source: Table 2, Pradilla et al. NEJM 2024

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
  ), # Medical (n=150)
  total_n = 150L
) %>%
  mutate(result_id = row_number()) # simple integer PK

dbAppendTable(con, "results_ordinal", enrich_mrs)
