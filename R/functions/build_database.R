# R/functions/build_database.R
# Wraps seed.R's logic as a function so targets can call it.
# Returns the path to the .duckdb file so targets can track it as a file output.
#
# The arguments aren't used inside the function body — they're here
# purely so that targets sees the dependency. When any of these files
# change on disk, targets knows to invalidate this target and re-run.
# This is a common targets pattern called "file tracking via argument passing."

build_database <- function(seed_script, tags_script, trial_scripts) {
  # source() runs seed.R exactly as you would manually.
  # seed.R handles the connection, schema teardown/rebuild, tags, and trials.
  source(seed_script)

  # Return the database path. format = "file" in _targets.R means targets
  # will hash this file's contents and detect if it has changed.
  "critlit.duckdb"
}
