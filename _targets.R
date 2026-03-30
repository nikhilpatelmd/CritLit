# _targets.R
# Pipeline definition for CritLit.
# Run tar_make() to execute; tar_visnetwork() to visualize the graph.

library(targets)

# Load the build function into the pipeline's environment.
# tar_source() is targets' preferred alternative to source() here —
# it loads all .R files in a directory, but a direct source() call
# is fine for a single file.
source("R/functions/build_database.R")

# Tell targets which packages every target's code will need.
# This is equivalent to library() calls, but scoped to the pipeline.
tar_option_set(
  packages = c("tidyverse", "duckdb", "DBI")
)

# The pipeline is defined as a list of tar_target() calls.
# targets reads this list to build the dependency graph.
list(
  # Track seed.R as a file. If the schema changes (e.g. you add a column),
  # this target's hash changes, which cascades to invalidate `database`.
  tar_target(
    name = seed_script,
    command = "R/seed.R",
    format = "file"
  ),

  # Track tags.R as a file. Adding or renaming a tag invalidates `database`.
  tar_target(
    name = tags_script,
    command = "R/setup/tags.R",
    format = "file"
  ),

  # Track all trial scripts as a group of files.
  # list.files() runs at pipeline-build time, not at tar_make() time —
  # so new files in R/trials/ are picked up automatically on the next run.
  tar_target(
    name = trial_scripts,
    command = list.files("R/trials", pattern = "\\.R$", full.names = TRUE),
    format = "file"
  ),

  # Build the database. This is the main target.
  # It depends on the three file targets above — if any of them change,
  # this target is invalidated and the database is rebuilt from scratch.
  # format = "file" means targets tracks the .duckdb file's hash,
  # not an R object.
  tar_target(
    name = database,
    command = build_database(seed_script, tags_script, trial_scripts),
    format = "file"
  )
)
