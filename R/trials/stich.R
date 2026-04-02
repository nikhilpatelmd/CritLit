# R/trials/stich.R
# STICH trial data. Uses `con` from seed.R's environment.
# Source: Mendelow et al., The Lancet 2005. PMID: 15680453

# ── Trial record ──────────────────────────────────────────────────────────────
stich_trial <- tibble(
  trial_id = "stich",
  acronym = "STICH",
  title = "Early surgery versus initial conservative treatment in patients with spontaneous supratentorial intracerebral haematomas in the International Surgical Trial in Intracerebral Haemorrhage (STICH): a randomised trial",
  date_published = ymd("2005-01-29"),
  journal = "The Lancet",
  doi = "10.1016/S0140-6736(05)17826-X",
  pmid = "15680453",
  trial_registration = "ISRCTN19976990",
  funding_source = NA_character_,
  pico = "In patients with spontaneous supratentorial intracerebral hemorrhage, does a strategy of early surgical hematoma evacuation improve functional outcomes at 180 days when compared to initial medical management?",
  gist = "The original STICH trial was a pivotal international randomized controlled trial designed to determine the overall role of surgical hematoma evacuation via open craniotomy in patients with spontaneous supratentorial ICH. The study randomized 1033 patients to either a policy of early surgery or initial conservative medical treatment. The primary analysis found no statistically significant overall benefit for the policy of early surgery on the primary outcome of favorable functional status (Glasgow Outcome Scale) at 6 months. However, prespecified subgroup analyses hinted at a potential benefit for patients with superficial/lobar ICH and those with a mid-range Glasgow Coma Score (9–12), which spurred the subsequent STICH-II trial to investigate the lobar subgroup further."
)

dbAppendTable(con, "trials", stich_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
stich_trial_tags <- tibble(
  trial_id = "stich",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "craniotomy"
  )
)

dbAppendTable(con, "trial_tags", stich_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
stich_links <- tibble(
  trial_id = "stich",
  url = "https://doi.org/10.1016/S0140-6736(05)17826-X",
  label = "Primary Publication",
  description = "Mendelow et al. Lancet 2005",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", stich_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
# Primary outcome: favorable vs. unfavorable on the Glasgow Outcome Scale (GOS)
# at 6 months. Favorable = GOS 4–5. Note that this is a binary collapse of an
# ordinal scale — it cannot be pooled directly with the ordinal mRS distributions
# from ENRICH, SWITCH, or MISTIE-III without additional modeling assumptions.
stich_outcomes <- tibble(
  outcome_id = "stich_gos_6m",
  trial_id = "stich",
  outcome_name = "Favorable outcome on GOS at 6 months",
  outcome_type = "dichotomous",
  scale_name = "GOS",
  time_point = "6 months",
  is_primary = TRUE,
  notes = "Favorable defined as GOS 4–5. Binary collapse of ordinal scale."
)

dbAppendTable(con, "outcomes", stich_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# TODO: Verify event counts from Table 3, Mendelow et al. Lancet 2005.
#
# stich_results <- tibble(
#   outcome_id = "stich_gos_6m",
#   trial_id   = "stich",
#   arm        = c("intervention", "control"),
#   arm_label  = c("Early Surgery", "Initial Conservative Treatment"),
#   events     = c(NA_integer_, NA_integer_),  # favorable GOS outcomes
#   total_n    = c(NA_integer_, NA_integer_)
# )
# dbAppendTable(con, "results_dichotomous", stich_results)
