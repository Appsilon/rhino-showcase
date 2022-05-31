box::use(
  app/logic/stats
)

shiny::shinyApp(
  ui = shiny.stats::shiny_stats_ui(),
  server = shiny.stats::shiny_stats_server(
    get_user = stats$get_user,
    db_credentials = stats$db_credentials
  )
)
