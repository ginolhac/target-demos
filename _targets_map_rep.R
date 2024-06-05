library(targets)
library(tarchetypes) # for tar_map_rep()

message("tar_map_rep")

values <- tidyr::expand_grid(
  folders = c("data/lines", "data/circles", "data/others"),
  files = 1:2) |> 
  dplyr::mutate(names =  fs::path_file(folders) # -> c("lines", "circles", "others")
)

read_ds_tsv <- function(folders, files) {
  readr::read_tsv(glue::glue("{folders}/dset_{files}.tsv"), 
                  show_col_types = FALSE)
}

tar_map_rep(
  dset,
  command = read_ds_tsv(folders, files),
  values = values,
  names = tidyselect::any_of("names"),
  batches = 1
)
  


# Sys.setenv(TAR_PROJECT = "ds_map_rep")
# targets::tar_make()
