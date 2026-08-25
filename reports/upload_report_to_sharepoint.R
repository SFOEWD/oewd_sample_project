library(Microsoft365R)

file_to_upload <- Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES")
new_sp_reports_dir <- targets::tar_read(wfc_monthly_reports_dir, store = here::here("_targets"))
sp <- get_sharepoint_site("SHAREPOINT_SITE")
sp_docs <- sp$get_drive("Documents")

sp_docs$upload_file(
  src = here::here("reports", file_to_upload), # tar_quarto() outputs to proj root
  dest = fs::path(new_sp_reports_dir, basename(file_to_upload))
)
