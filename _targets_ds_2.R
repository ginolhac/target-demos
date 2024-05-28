library(targets)
library(tarchetypes)

# load the tidyverse quietly for each target
# which each runs in a fresh R session
tar_option_set(packages = "tidyverse")

message("dynamic branching")

# Create fake files from datasaurus, one per dataset with:
# purrr::iwalk(
#   group_split(datasauRus::datasaurus_dozen, dataset),
#   \(x, y) write_tsv(x, glue::glue("data/dset_{y}.tsv"))
# )


list(
  # Reading multiple files
  # 1. track the different files
  tar_files_input(dset, fs::dir_ls("data", glob = "*.tsv")),
  # 2. read them using dynamic branching
  tar_target(ds, read_tsv(dset, show_col_types = FALSE),
             pattern = map(dset)),
  tar_target(summary_stat, summarise(ds, m_x = mean(x), m_y = mean(y)),
             pattern = map(ds)),
  tar_target(plots, ggplot(ds, aes(x, y)) +
               geom_point() +
               labs(title = unique(ds$dataset)),
             pattern = map(ds),
             iteration = "list"),
  tar_quarto(report, "ds2.qmd")
)


# Sys.setenv(TAR_PROJECT = "ds_dynamic")
# targets::tar_make()
