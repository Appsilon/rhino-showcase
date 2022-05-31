box::use(
  shiny, shiny[tags],
  shiny.router[make_router, route, route_link],
)
box::use(
  app/logic/stats,
  app/view[map, modal],
)

menu <- tags$ul(
  tags$li(tags$a(href = route_link("/"), "Map")),
  tags$li(tags$a(href = route_link("modal"), "Modal"))
)

router <- make_router(
  route("/", map$ui("map"), function() map$server("map")),
  route("modal", modal$ui("modal"), function() modal$server("modal"))
)

#' @export
ui <- shiny$bootstrapPage(
  menu,
  router$ui
)

#' @export
server <- function(input, output, session) {
  stats$initialize()
  router$server(input, output, session)
}
