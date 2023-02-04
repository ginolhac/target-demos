
facet_ds <- function(.data) {
  .data |> 
    ggplot(aes(x = x, y = y, colour = dataset)) +
    geom_point() +
    facet_wrap(~ dataset, ncol = 3)
}

anim_ds <- function(.data) {
  .data |> 
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
}
