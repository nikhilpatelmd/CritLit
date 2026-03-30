# seed.R
# Orchestrator: creates schema, then sources per-trial insert scripts.
# Run this file to rebuild the database from scratch.

library(tidyverse)
library(duckdb)
library(DBI)

# ── Connection ────────────────────────────────────────────────────────────────
con <- dbConnect(duckdb::duckdb(), "critlit.duckdb")

# ── Schema ────────────────────────────────────────────────────────────────────
# We drop and recreate all tables on each run. This keeps seed.R as the single
# source of truth for structure. Per-trial scripts only do INSERT operations.

# Sequences are dropped independently — they're not FK-referenced, so order
# relative to tables doesn't strictly matter, but keeping them first is tidy.
dbExecute(con, "DROP SEQUENCE IF EXISTS link_id_seq")
dbExecute(con, "DROP SEQUENCE IF EXISTS result_id_seq")

# Drop in reverse dependency order to avoid FK constraint errors
dbExecute(con, "DROP TABLE IF EXISTS results_continuous")
dbExecute(con, "DROP TABLE IF EXISTS results_dichotomous")
dbExecute(con, "DROP TABLE IF EXISTS results_ordinal")
dbExecute(con, "DROP TABLE IF EXISTS outcomes")
dbExecute(con, "DROP TABLE IF EXISTS links")
dbExecute(con, "DROP TABLE IF EXISTS trial_tags")
dbExecute(con, "DROP TABLE IF EXISTS tags")
dbExecute(con, "DROP TABLE IF EXISTS trials")

# ── Sequences ─────────────────────────────────────────────────────────────────
# Auto-incrementing counters for surrogate PKs. DuckDB fills these in
# automatically when the column is omitted from an INSERT — meaning per-trial
# scripts never need to manage ID values themselves.
dbExecute(con, "CREATE SEQUENCE link_id_seq START 1")
dbExecute(con, "CREATE SEQUENCE result_id_seq START 1")

dbExecute(
  con,
  "
  CREATE TABLE trials (
    trial_id          VARCHAR PRIMARY KEY,
    acronym           VARCHAR NOT NULL,
    title             VARCHAR NOT NULL,
    date_published    DATE,
    journal           VARCHAR NOT NULL,
    doi               VARCHAR,
    pmid              VARCHAR,
    trial_registration VARCHAR,
    funding_source    VARCHAR
  )
"
)

# One row per unique tag concept. tag_type is constrained to our five-type taxonomy.
dbExecute(
  con,
  "
  CREATE TABLE tags (
    tag_id    VARCHAR PRIMARY KEY,  -- e.g. 'intracerebral_hemorrhage'
    tag_name  VARCHAR NOT NULL,     -- e.g. 'Intracerebral Hemorrhage'
    tag_type  VARCHAR NOT NULL CHECK (tag_type IN (
                'condition', 'topic', 'methodology', 'network', 'region'
              ))
  )
"
)

dbExecute(
  con,
  "
  CREATE TABLE trial_tags (
    trial_id  VARCHAR NOT NULL REFERENCES trials(trial_id),
    tag_id    VARCHAR NOT NULL REFERENCES tags(tag_id),
    PRIMARY KEY (trial_id, tag_id)
  )
"
)

dbExecute(
  con,
  "
  CREATE TABLE links (
    link_id     INTEGER DEFAULT nextval('link_id_seq') PRIMARY KEY,
    trial_id    VARCHAR NOT NULL REFERENCES trials(trial_id),
    url         VARCHAR NOT NULL,
    label       VARCHAR NOT NULL,
    description VARCHAR,
    link_type   VARCHAR CHECK (link_type IN (
                  'primary_publication', 'protocol', 'editorial',
                  'video_commentary', 'bayesian_reanalysis', 'other'
                ))
  )
"
)

# The outcomes registry: defines WHAT an outcome is, independent of its data.
# This is the table that lets you link the 'same' outcome across trials for meta-analysis.
dbExecute(
  con,
  "
  CREATE TABLE outcomes (
    outcome_id    VARCHAR PRIMARY KEY,  -- e.g. 'enrich_mrs_90d'
    trial_id      VARCHAR NOT NULL REFERENCES trials(trial_id),
    outcome_name  VARCHAR NOT NULL,     -- e.g. 'mRS at 90 days'
    outcome_type  VARCHAR NOT NULL CHECK (outcome_type IN (
                    'ordinal', 'dichotomous', 'continuous'
                  )),
    scale_name    VARCHAR,              -- e.g. 'mRS', 'NIHSS', 'GOS'
    time_point    VARCHAR,              -- e.g. '90 days', '180 days'
    is_primary    BOOLEAN DEFAULT FALSE,
    notes         VARCHAR
  )
"
)

# Ordinal results: one row per arm per level (e.g. one row per mRS score per group)
dbExecute(
  con,
  "
  CREATE TABLE results_ordinal (
    result_id  INTEGER DEFAULT nextval('result_id_seq') PRIMARY KEY,
    outcome_id  VARCHAR NOT NULL REFERENCES outcomes(outcome_id),
    trial_id    VARCHAR NOT NULL REFERENCES trials(trial_id),
    arm         VARCHAR NOT NULL CHECK (arm IN ('intervention', 'control')),
    arm_label   VARCHAR NOT NULL,  -- e.g. 'MIPS', 'Medical Management'
    level       INTEGER NOT NULL,  -- e.g. 0, 1, 2, 3, 4, 5, 6 for mRS
    count       INTEGER NOT NULL,
    total_n     INTEGER NOT NULL
  )
"
)

# Dichotomous results: one row per arm
dbExecute(
  con,
  "
  CREATE TABLE results_dichotomous (
    result_id  INTEGER DEFAULT nextval('result_id_seq') PRIMARY KEY,
    outcome_id  VARCHAR NOT NULL REFERENCES outcomes(outcome_id),
    trial_id    VARCHAR NOT NULL REFERENCES trials(trial_id),
    arm         VARCHAR NOT NULL CHECK (arm IN ('intervention', 'control')),
    arm_label   VARCHAR NOT NULL,
    events      INTEGER NOT NULL,
    total_n     INTEGER NOT NULL
  )
"
)

# Continuous results: one row per arm
# ci_lower/ci_upper are optional -- useful when SD must be back-calculated from CIs
dbExecute(
  con,
  "
  CREATE TABLE results_continuous (
    result_id  INTEGER DEFAULT nextval('result_id_seq') PRIMARY KEY,
    outcome_id  VARCHAR NOT NULL REFERENCES outcomes(outcome_id),
    trial_id    VARCHAR NOT NULL REFERENCES trials(trial_id),
    arm         VARCHAR NOT NULL CHECK (arm IN ('intervention', 'control')),
    arm_label   VARCHAR NOT NULL,
    mean        DOUBLE,
    sd          DOUBLE,
    n           INTEGER NOT NULL,
    ci_lower    DOUBLE,
    ci_upper    DOUBLE
  )
"
)

# ── Per-trial data ─────────────────────────────────────────────────────────────

# Source tags first — trial scripts reference these via foreign keys,
# so they must exist in the database before any trial is inserted.
source("R/setup/tags.R")

# list.files() discovers all .R scripts in R/trials/ alphabetically.
# walk() is the purrr equivalent of lapply() for side effects — we're
# sourcing each script for what it *does* (writes to DuckDB), not for
# any value it returns. Think of it as "do this for each item."
list.files(path = "R/trials", pattern = "\\.R$", full.names = TRUE) |>
  walk(source)

# ── Done ───────────────────────────────────────────────────────────────────────
dbDisconnect(con, shutdown = TRUE)
message("Database rebuilt successfully.")
