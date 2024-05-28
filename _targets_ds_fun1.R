library(targets)
library(tarchetypes) # for tar_url() and tar_render()
tar_source() # equivalent to source("R/*.R")
# load the tidyverse quietly for each target
# which each runs in a fresh R session
tar_option_set(packages = "tidyverse")

message("No branching with sourcing")

list(
  # track if distant file has changed
  tar_url(ds_file, "https://raw.githubusercontent.com/jumpingrivers/datasauRus/main/inst/extdata/DatasaurusDozen-Long.tsv"),
  tar_target(ds, read_tsv(ds_file, show_col_types = FALSE)),
  tar_target(all_facets, facet_ds(ds)),
  # animation is worth caching  ~ 1 min
  tar_target(anim, anim_ds(ds), 
             packages = c("ggplot2", "gganimate", "gifski")),
  tar_file(gif, {
    anim_save("ds.gif", animation = anim, title_frame = TRUE)
    # anim_save returns NULL, we need to get the file output path
    "ds.gif"},
             packages = c("gganimate")),
  tar_quarto(report, "ds1.qmd")
)


# Sys.setenv(TAR_PROJECT = "ds_fun_linear")
# targets::tar_make()
