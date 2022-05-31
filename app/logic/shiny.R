box::use(
  shiny,
)

#' @export
event_reactive_val <- function(...) {
  value <- shiny$reactiveVal(...)
  counter <- shiny$reactiveVal(0)
  wrapper <- shiny$eventReactive(counter(), value())
  function(new_value) {
    if (!missing(new_value)) {
      counter(counter() + 1)
      value(new_value)
    }
    wrapper()
  }
}
