# R/trials/mind.R
# MIND trial data. Uses `con` from seed.R's environment.
# Source: Arthur et al., JAMA Neurology 2025. PMID: 40892424
# Full name: Artemis in the Removal of Intracerebral Hemorrhage

# ── Trial record ──────────────────────────────────────────────────────────────
mind_trial <- tibble(
  trial_id = "mind",
  acronym = "MIND",
  title = "Minimally Invasive Surgery vs Medical Management Alone for Intracerebral Hemorrhage: The MIND Randomized Clinical Trial",
  date_published = ymd("2025-11-01"), # print issue date; online Sept 2, 2025
  journal = "JAMA Neurology",
  doi = "10.1001/jamaneurol.2025.3151",
  pmid = "40892424",
  trial_registration = "NCT03342664",
  funding_source = "Penumbra, Inc.", # manufacturer of Artemis device
  pico = "In patients with spontaneous supratentorial intracerebral hemorrhage, does minimally invasive hematoma evacuation improve functional outcomes at 180 days when compared to guideline-based medical management alone?",
  gist = "The MIND trial evaluated minimally invasive endoscopic hemorrhage evacuation using the Artemis Neuro Evacuation Device in patients with moderate-to-large (20–80 mL) spontaneous supratentorial ICH. The trial randomized 236 patients (2:1) to MIS within 72 hours plus medical management or medical management alone, but was stopped early after a feasibility analysis (prompted by the positive results of the [ENRICH](/study/enrich/) trial) determined a low probability of demonstrating superiority. The primary outcome of mRS at 180 days failed to show a significant benefit for MIS over medical management. Despite excellent technical performance (median ~81% volume reduction, 79% achieving residual volumes ≤15 mL), the functional benefit observed at 30 days did not persist at later time points."
)

dbAppendTable(con, "trials", mind_trial)

# ── Tags ──────────────────────────────────────────────────────────────────────
mind_trial_tags <- tibble(
  trial_id = "mind",
  tag_id = c(
    "intracerebral_hemorrhage",
    "neurosurgical_intervention",
    "minimally_invasive_neurosurgery",
    "open_label",
    "early_termination" # stopped early after ENRICH publication
  )
)

dbAppendTable(con, "trial_tags", mind_trial_tags)

# ── Links ─────────────────────────────────────────────────────────────────────
mind_links <- tibble(
  trial_id = "mind",
  url = "https://doi.org/10.1001/jamaneurol.2025.3151",
  label = "Primary Publication",
  description = "Arthur et al. JAMA Neurology 2025",
  link_type = "primary_publication"
)

dbAppendTable(con, "links", mind_links)

# ── Outcomes ──────────────────────────────────────────────────────────────────
# Primary outcome: ordinal mRS at 180 days — directly poolable with ENRICH
# and SWITCH once counts are verified. 2:1 randomization (154 MIS, 82 medical),
# so arm sizes are unequal unlike ENRICH. Trial stopped early after ENRICH
# publication; n=236 of a larger planned sample.
mind_outcomes <- tibble(
  outcome_id = "mind_mrs_180d",
  trial_id = "mind",
  outcome_name = "mRS at 180 days",
  outcome_type = "ordinal",
  scale_name = "mRS",
  time_point = "180 days",
  is_primary = TRUE,
  notes = paste0(
    "2:1 randomization (154 MIS, 82 medical management). ",
    "Stopped early after ENRICH publication and feasibility analysis. ",
    "ITT result neutral (OR 1.03). ",
    "Unequal arm sizes — account for this when specifying Bayesian likelihood."
  )
)

dbAppendTable(con, "outcomes", mind_outcomes)

# ── Results ───────────────────────────────────────────────────────────────────
# TODO: Verify mRS distribution from primary results table,
# Arthur et al. JAMA Neurology 2025. Note the unequal arm sizes:
#
# mind_mrs <- tibble(
#   outcome_id = "mind_mrs_180d",
#   trial_id   = "mind",
#   arm        = c(rep("intervention", 7), rep("control", 7)),
#   arm_label  = c(rep("Minimally Invasive Surgery", 7), rep("Medical Management", 7)),
#   level      = rep(0:6, 2),
#   count      = c(...),       # verify from paper
#   total_n    = c(rep(154L, 7), rep(82
