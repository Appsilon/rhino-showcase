box::use(
  shiny[...],
  shiny.semantic[
    button,
    card,
    cards,
    create_modal,
    header,
    icon,
    modal,
    segment,
    show_modal,
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$i(
      id = ns("about_button"),
      class = "info circle icon large"
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$about_button, {
      create_modal(
        modal(
          id = "about_modal",
          title = "About Section",
          header = "About Section",
          content = div(
            class = "ui vertical segment",
            div(
              class = "ui grid",
              div(
                class = "two column row",
                div(
                  class = "left floated column",
                  tags$img(
                    class = "ui segment four wide small left floated image",
                    src = "static/img/appsilon-logo.png"
                  )
                ),
                div(
                  class = "right floated column",
                  p(
                    class = "ui twelve wide",
                    "We create, maintain, and develop Shiny applications for
                    enterprise customers all over the world. Appsilon provides
                    scalability, security, and modern UI/UX with custom R
                    packages that native Shiny apps do not provide. Our team is
                    among the world’s foremost experts in R Shiny and has made
                    a variety of Shiny innovations over the years. Appsilon is
                    a proud RStudio (Posit) Full Service Certified Partner."
                  )
                )
              )
            ),
            div(
              class = "ui horizontal divider"
            ),
            div(
              class = "ui grid",
              div(
                class = "two column row",
                div(
                  class = "left floated column",
                  p(
                    class = "ui twelve wide",
                    "Shiny Semantic is a package developed by appsilon for 
                    the R community. With this library it is easy to wrap 
                    Shiny with Fomantic UI (previously Semantic). Add a 
                    few simple lines of code to give your UI a fresh, 
                    modern and highly interactive look."
                  )
                ),
                div(
                  class = "right floated column",
                  tags$img(
                    class = "ui four wide segment small floated right image",
                    src = "static/img/shiny-semantic.png"
                  )
                )
              )
            ),
            div(
              class = "ui horizontal divider"
            ),
            div(
              class = "ui grid",
              div(
                class = "two column row",
                div(
                  class = "left floated column",
                  tags$img(
                    class = "ui segment four wide small left floated image",
                    src = "static/img/rhino.png"
                  )
                ),
                div(
                  class = "right floated column",
                  p(
                    class = "ui twelve wide",
                    "Rhino allows you to create Shiny apps The Appsilon 
                    Way - like a fullstack software engineer. Apply best 
                    software engineering practices, modularize your code, 
                    test it well, make UI beautiful, and think about 
                    user adoption from the very beginning. Rhino is an opinionated 
                    framework with a focus on software engineering practices 
                    and development tools."
                  )
                )
              )
            ),
            div(
              class = "ui horizontal divider"
            )
          ),
          footer = "Developed with  💕 by Appsilon"
        )
      )
    })
  })
}
