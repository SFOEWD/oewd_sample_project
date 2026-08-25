library(targets)
library(tarchetypes)
library(sqltargets)

tar_option_set(
  format = "qs",
  memory = "transient",
  packages = c(
    "dplyr",
    "purrr",
    "quarto",
    "Microsoft365R",
    "DBI",
    "odbc",
    "gt",
    "ggplot2"
  )
)

tar_source()

tar_udp <- purrr::partial(tar_sql, params = query_params)

tar_source()

tar_plan(
  # Query Snowflake
  tar_udp(data_from_snowflake, "sql/sample_query.sql"),
  # Render HTML report, upload to SharePoint
  tar_quarto(
    sample_report,
    path = "reports/sample_report.qmd",
    quiet = FALSE
  )
)
