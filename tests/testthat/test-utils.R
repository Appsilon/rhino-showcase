options(box.path = getwd())

box::use(
  shiny[testServer],
  checkmate[...],
  testthat[...],
)

box::use(
  app/logic/utils[
    loading_screen,
    make_dropdown,
    update_timeline_colors,
    customize_axes,
    add_medal_trace,
    add_podium_bar,
    make_flag_data,
    make_flags,
    update_podium_flags,
    reset_podium_flags
  ]
)

# loading_screen
test_that("loading_screen: invalid param 'text' is handled", {
  wrong_params <- c("", 123, NA, NaN, Inf, NULL)
  expect_error(loading_screen(text = wrong_params, bkg_color = "white"))
  expect_error(loading_screen(text = "", bkg_color = "white"))
  expect_error(loading_screen(text = NA, bkg_color = "white"))
  expect_error(loading_screen(text = NaN, bkg_color = "white"))
  expect_error(loading_screen(text = NULL, bkg_color = "white"))
  expect_error(loading_screen(text = Inf, bkg_color = "white"))
})

test_that("loading_screen: invalid param 'bkg_color' is handled", {
  wrong_params <- c("", 123, NA, NaN, Inf, NULL)
  expect_error(loading_screen(text = "Loading...", bkg_color = wrong_params))
  expect_error(loading_screen(text = "Loading...", bkg_color = ""))
  expect_error(loading_screen(text = "Loading...", bkg_color = NA))
  expect_error(loading_screen(text = "Loading...", bkg_color = NaN))
  expect_error(loading_screen(text = "Loading...", bkg_color = NULL))
  expect_error(loading_screen(text = "Loading...", bkg_color = Inf))
})

# make_dropdown
# update_timeline_colors
# customize_axes
# add_medal_trace
# add_podium_bar
# make_flag_data
# make_flags
# update_podium_flags
# reset_podium_flags
