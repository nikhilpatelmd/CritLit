# R/trials/stich_ii.R
# STICH-II trial data. Uses `con` from seed.R's environment.
# Source: Mendelow et al., The Lancet 2013. PMID: 23726393

# ── Trial record ──────────────────────────────────────────────────────────────
stich_ii_trial <- tibble(
  trial_id = "stich_ii",
  acronym = "STICH-II",
  title = "Early surgery versus initial conservative treatment in patients with spontaneous supratentorial lobar intracerebral haematomas (STICH II): a randomised trial",
  date_published = ymd("2013-08-03"),
  journal = "The Lancet",
  doi = "10.1016/S0140-6736(13)60986-1",
  pmid = "23726393",
  trial_registration = "ISRCTN22153967",
  funding_source = "UK Medical Research Council",
  pico = "In patients with supratentorial lobar intracerebral hemorrhage, does early hematoma evacuation improve functional outcomes at 6 months when compared to initial medical management?",
  gist = "The STICH II trial was conducted to test the hypothesis that early open surgical evacuation of intracerebral hemorrhage (ICH) might benefit a specific subgroup: conscious patients with superficial lobar hematomas. This international randomized trial compared early surgical evacuation (within 12 hours of randomization) to initial conservative medical treatment. The primary outcome, a favorable result on the Extended Glasgow Outcome Scale (GOSE) at 6 months, showed no statistically significant difference between the two groups. While the trial confirmed that early surgery did not increase death or disability, it failed to demonstrate clear efficacy for the routine use of craniotomy in this specific patient population, reinforcing the challenge of surgical management for ICH."
)

dbAppendTable(con, "trials", stich_ii_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
stich_ii_trial_tags <- tibble(
  trial_id = "stich_ii",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "craniotomy"
  )
)

dbAppendTable(con, "trial_tags", stich_ii_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
stich_ii_links <- tibble(
  trial_id = "stich_ii",
  url = "https://doi.org/10.1016/S0140-6736(13)60986-1",
  label = "Primary Publication",
  description = "Mendelow et al. Lancet 2013",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", stich_ii_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
# Primary outcome: favorable vs. unfavorable on the Extended Glasgow Outcome
# Scale (GOSE) at 6 months. Favorable = GOSE 5–8. Same pooling caveat applies
# as with STICH: binary collapse, not directly poolable with ordinal mRS trials.
stich_ii_outcomes <- tibble(
  outcome_id = "stich_ii_gose_6m",
  trial_id = "stich_ii",
  outcome_name = "Favorable outcome on GOSE at 6 months",
  outcome_type = "dichotomous",
  scale_name = "GOSE",
  time_point = "6 months",
  is_primary = TRUE,
  notes = "Favorable defined as GOSE 5–8. Binary collapse of ordinal scale."
)

dbAppendTable(con, "outcomes", stich_ii_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# TODO: Verify event counts from primary results table, Mendelow et al. 2013.
#
# stich_ii_results <- tibble(
#   outcome_id = "stich_ii_gose_6m",
#   trial_id   = "stich_ii",
#   arm        = c("intervention", "control"),
#   arm_label  = c("Early Surgery", "Initial Conservative Treatment"),
#   events     = c(NA_integer_, NA_integer_),
#   total_n    = c(NA_integer_, NA_integer_)
# )
# dbAppendTable(con, "results_dichotomous", stich_ii_results)
