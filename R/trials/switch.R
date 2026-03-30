# R/trials/switch.R
# SWITCH trial data. Uses `con` from seed.R's environment.
# Source: Wollenweber et al., The Lancet 2024. PMID: 38761811

# ── Trial record ──────────────────────────────────────────────────────────────
switch_trial <- tibble(
  trial_id = "switch",
  acronym = "SWITCH",
  title = "Decompressive craniectomy plus best medical treatment versus best medical treatment alone for spontaneous severe deep supratentorial intracerebral haemorrhage",
  date_published = ymd("2024-05-18"),
  journal = "The Lancet",
  doi = "10.1016/S0140-6736(24)00702-5",
  pmid = "38761811",
  trial_registration = "NCT02258919",
  funding_source = "Swiss National Science Foundation, Swiss Heart Foundation, Inselspital Stiftung, and Boehringer Ingelheim"
)

dbAppendTable(con, "trials", switch_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
switch_trial_tags <- tibble(
  trial_id = "switch",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "decompressive_craniectomy",
    "early_termination"
  )
)

dbAppendTable(con, "trial_tags", switch_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
switch_links <- tibble(
  trial_id = "switch",
  url = "https://doi.org/10.1016/S0140-6736(24)00702-5",
  label = "Primary Publication",
  description = "Wollenweber et al. Lancet 2024",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", switch_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
# Primary outcome: ordinal mRS at 180 days — directly poolable with ENRICH
# once counts are verified. The early termination (n=201 of planned 340) is
# noted here so downstream models can account for the reduced precision.
switch_outcomes <- tibble(
  outcome_id = "switch_mrs_180d",
  trial_id = "switch",
  outcome_name = "mRS at 180 days",
  outcome_type = "ordinal",
  scale_name = "mRS",
  time_point = "180 days",
  is_primary = TRUE,
  notes = "Trial stopped early (n=201 of planned 340). Interpret precision with caution."
)

dbAppendTable(con, "outcomes", switch_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# TODO: Verify mRS distribution from primary results table,
# Wollenweber et al. Lancet 2024. Structure mirrors enrich.R when ready:
#
# switch_mrs <- tibble(
#   outcome_id = "switch_mrs_180d",
#   trial_id   = "switch",
#   arm        = c(rep("intervention", 7), rep("control", 7)),
#   arm_label  = c(rep("Decompressive Craniectomy", 7), rep("Best Medical Treatment", 7)),
#   level      = rep(0:6, 2),
#   count      = c(...),  # verify from paper
#   total_n    = NA_integer_
# )
# dbAppendTable(con, "results_ordinal", switch_mrs)
