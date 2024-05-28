library(targets)
library(tarchetypes) # for tar_map()

# load the tidyverse quietly for each target
tar_option_set(packages = "tidyverse")

message("Static nested")

# a folder for the subfolders and 
values <- tibble::tibble(
  folders = c("data/lines", "data/circles", "data/others"),
  names =  fs::path_file(folders) # -> c("lines", "circles", "others")
)

# tar_map() generates R expressions, and substitute the desired 'values'
mapped <- tar_map(
  values = values,
  names = "names", # to avoid targets reporting "files_data.lines"
  # special pair of targets
  # readr is in charge of the aggregation (bind_rows())
  tar_file_read(files, fs::dir_ls(folders, glob = "*tsv"), read_tsv(file = !!.x, show_col_types = FALSE)),
  # nested tar_map
  tar_map(
    values = list(funs = c("mean", "sd")),
    tar_target(summary, summarise(files, x_sum = funs(x), y_sum = funs(y)))
  )
)

mcombined <- tar_combine(mean_combine, 
                         # tarchetypes helper to select all averages 
                         tar_select_targets(mapped, contains("_mean_")),
                         # .x placeholder all matching targets
                         # !!! unquote-splice operator
                         command = bind_rows(!!!.x, .id = "set"))

scombined <- tar_combine(sd_combine, 
                         # tarchetypes helper to select all averages 
                         tar_select_targets(mapped, contains("_sd_")),
                         # .x placeholder all matching targets
                         # !!! unquote-splice operator
                         command = bind_rows(!!!.x, .id = "set"))

combi <- tar_combine(stats, mcombined, scombined)

list(mapped, mcombined, scombined, combi)

# Sys.setenv(TAR_PROJECT = "ds_nested_static")
# targets::tar_make()
