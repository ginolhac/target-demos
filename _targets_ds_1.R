library(targets)
library(tarchetypes) # for tar_url() and tar_render()

# load the tidyverse quietly for each target
# which each runs in a fresh R session
tar_option_set(packages = "tidyverse")

list(
  # track if distant file has changed
  tar_url(ds_file, "https://raw.githubusercontent.com/jumpingrivers/datasauRus/main/inst/extdata/DatasaurusDozen-Long.tsv"),
  tar_target(ds, read_tsv(ds_file)),
  tar_target(all_facets,
             ds |> 
               ggplot(aes(x = x, y = y, colour = dataset)) +
               geom_point() +
               facet_wrap(~ dataset, ncol = 3)),
  # animation is worth caching  ~ 1 min
  tar_target(anim, {
    ds |> 
      ggplot(aes(x = x, y = y)) +
      geom_point() +
      # transition will be made using the dataset column
      transition_states(dataset, transition_length = 5, state_length = 2) +
      # for a firework effect!
      shadow_wake(wake_length = 0.05) +
      labs(title = "dataset: {closest_state}") +
      theme_void(14) +
      theme(legend.position = "none") -> ds_anim
    # more frames to slow down the animation
    animate(ds_anim, nframes = 500, fps = 10, renderer = gifski_renderer())
  }, packages = c("ggplot2", "gganimate", "gifski")),
  tar_file(gif, {
    anim_save("ds.gif", animation = anim, title_frame = TRUE)
    # anim_save returns NULL, we need to get the file output path
    "ds.gif"},
             packages = c("gganimate")),
  tar_render(report, "ds1.Rmd")
)


# Sys.setenv(TAR_PROJECT = "ds_linear")
# targets::tar_make()
