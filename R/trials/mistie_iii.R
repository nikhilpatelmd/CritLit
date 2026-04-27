# R/trials/mistie_iii.R
# MISTIE-III trial data. Uses `con` from seed.R's environment.
# Source: Hanley et al., The Lancet 2019. PMID: 30739747

# ── Trial record ──────────────────────────────────────────────────────────────
mistie_iii_trial <- tibble(
  trial_id = "mistie_iii",
  acronym = "MISTIE-III",
  title = "Efficacy and safety of minimally invasive surgery with thrombolysis in intracerebral haemorrhage evacuation (MISTIE III): a randomised, controlled, open-label, blinded endpoint phase 3 trial",
  date_published = ymd("2019-02-23"),
  journal = "The Lancet",
  doi = "10.1016/S0140-6736(19)30195-3",
  pmid = "30739747",
  trial_registration = "NCT01827046",
  funding_source = "NINDS, Genentech Inc.",
  pico = "In patients with supratentorial intracerebral hemorrhage, does minimally-invasive catheter evacuation of the hematoma followed by thrombolysis with alteplase improve functional outcome at 365 days when compared to standard medical management?",
  gist = "The MISTIE-III trial was a phase 3 study designed to test whether a novel technique—minimally invasive catheter evacuation of the clot combined with local thrombolysis (alteplase)—could improve long-term functional recovery in patients with moderate to large supratentorial ICH. Patients were randomized to receive the MISTIE procedure or standard medical care. At the primary endpoint of 365 days, the study found no statistically significant difference in the proportion of patients who achieved a good functional outcome (mRS 0-3). However, the procedure was successfully and safely adopted by surgeons, and the null result helped clarify the role of surgery in ICH, directly influencing the design of subsequent trials like ENRICH."
)

dbAppendTable(con, "trials", mistie_iii_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
mistie_iii_trial_tags <- tibble(
  trial_id = "mistie_iii",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "minimally_invasive_neurosurgery",
    "open_label",
    "blinded_endpoint"
  )
)

dbAppendTable(con, "trial_tags", mistie_iii_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
mistie_iii_links <- tibble(
  trial_id = "mistie_iii",
  url = "https://doi.org/10.1016/S0140-6736(19)30195-3",
  label = "Primary Publication",
  description = "Hanley et al. Lancet 2019",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", mistie_iii_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
# The pre-specified primary endpoint was dichotomous (mRS 0–3 at 365 days),
# but the full ordinal mRS distribution is reported in the paper and is what
# you'll want for Bayesian pooling with ENRICH and SWITCH. Both are registered
# here so the analysis layer can choose appropriately.
mistie_iii_outcomes <- tibble(
  outcome_id = c(
    "mistie_iii_mrs_binary_365d",
    "mistie_iii_mrs_ordinal_365d"
  ),
  trial_id = "mistie_iii",
  outcome_name = c(
    "mRS 0–3 at 365 days (dichotomous)",
    "mRS distribution at 365 days (ordinal)"
  ),
  outcome_type = c("dichotomous", "ordinal"),
  scale_name = "mRS",
  time_point = "365 days",
  is_primary = c(TRUE, FALSE),
  notes = c(
    "Pre-specified primary endpoint. Favorable = mRS 0–3.",
    "Full ordinal distribution — preferred for Bayesian pooling with ENRICH and SWITCH."
  )
)

dbAppendTable(con, "outcomes", mistie_iii_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# TODO: Verify dichotomous counts from Figure 2, and ordinal distribution from
# appendix, Hanley et al. Lancet 2019. Two separate inserts needed when ready:
# one to results_dichotomous, one to results_ordinal.
