box::use(
  testthat[...],
  waiter[waiter_preloader],
  shiny[img, div, tagList],
  shiny.semantic[dropdown_input],
)

box::use(
  app/logic/utils[
    loading_screen,
    make_dropdown,
  ]
)

# loading_screen --------------------------------------------------------------
test_that("loading_screen: invalid param 'text' is handled", {
  expect_error(loading_screen(text = "", bkg_color = "white"))
  expect_error(loading_screen(text = c("white", "red"), bkg_color = "white"))
  expect_error(loading_screen(text = 123, bkg_color = "white"))
  expect_error(loading_screen(text = NA, bkg_color = "white"))
  expect_error(loading_screen(text = NaN, bkg_color = "white"))
  expect_error(loading_screen(text = NULL, bkg_color = "white"))
  expect_error(loading_screen(text = Inf, bkg_color = "white"))
})

test_that("loading_screen: invalid param 'bkg_color' is handled", {
  expect_error(loading_screen(text = "Loading...", bkg_color = ""))
  expect_error(loading_screen(text = "Loading...", bkg_color = c("white", "red")))
  expect_error(loading_screen(text = "Loading...", bkg_color = 123))
  expect_error(loading_screen(text = "Loading...", bkg_color = NA))
  expect_error(loading_screen(text = "Loading...", bkg_color = NaN))
  expect_error(loading_screen(text = "Loading...", bkg_color = NULL))
  expect_error(loading_screen(text = "Loading...", bkg_color = Inf))
})

test_that("loading_screen: returns expected outcome", {
  example_preloader <- waiter_preloader(
    html = tagList(
      img(src = "static/logo.png", width = "350"),
      div(class = "load-text", "Loading...")
    ),
    color = "white"
  )

  expect_equal(
    loading_screen(text = "Loading...", bkg_color = "white"), example_preloader
  )
})

# make_dropdown ---------------------------------------------------------------
test_that("make_dropdown: invalid param 'input_id' is handled", {
  expect_error(make_dropdown(input_id = "", text = "Choose a letter:", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = c("x", "y"), text = "Choose a letter:", choices = c("A", "B"))) # nolint
  expect_error(make_dropdown(input_id = 123, text = "Choose a letter:", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = NA, text = "Choose a letter:", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = NaN, text = "Choose a letter:", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = NULL, text = "Choose a letter:", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = Inf, text = "Choose a letter:", choices = c("A", "B")))
})

test_that("make_dropdown: invalid param 'text' is handled", {
  expect_error(make_dropdown(input_id = "input_a", text = "", choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = c("x", "y"), choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = 123, choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = NA, choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = NaN, choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = NULL, choices = c("A", "B")))
  expect_error(make_dropdown(input_id = "input_a", text = Inf, choices = c("A", "B")))
})

test_that("make_dropdown: invalid param 'choices' is handled", {
  expect_error(make_dropdown(input_id = "input_a", text = "Choose a letter:", choices = NA))
  expect_error(make_dropdown(input_id = "input_a", text = "Choose a letter:", choices = NaN))
  expect_error(make_dropdown(input_id = "input_a", text = "Choose a letter:", choices = c(NA, NA))) # nolint
  expect_error(make_dropdown(input_id = "input_a", text = "Choose a letter:", choices = c("A", "A"))) #nolint
})

test_that("make_dropdown: returns expected outcome", {
  example_dropdown <- div(
    class = "column",
    dropdown_input(
      input_id = "input_letter",
      default_text = "Choose a letter:",
      type = "fluid search selection",
      choices =  c("a", "b")
    )
  )

  expect_equal(
    make_dropdown(
      input_id = "input_letter",
      text = "Choose a letter:",
      choices = c("a", "b")
    ),
    example_dropdown
  )
})

# update_timeline_colors
# customize_axes
# add_medal_trace
# add_podium_bar
# make_flag_data
# make_flags
# update_podium_flags
# reset_podium_flags
