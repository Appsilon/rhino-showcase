box::use(
  shiny[...],
  shiny.semantic[create_modal, modal],
)

create_image_path <- function(path) {
  base_path <- "static/img/"
  sprintf(
    fmt = "../%s/%s",
    base_path,
    path
  )
}

topic_section <- function(header,
                          description) {
  div(
    h4(class = "about-header", header),
    div(
      class = "about-descr",
      description
    )
  )
}

tag <- function(tag_string, hyperlink) {
  div(
    class = "tag-item",
    icon("link"),
    a(
      href = hyperlink,
      target = "_blank",
      rel = "noopener noreferrer",
      tag_string
    )
  )
}

card <- function(href_link,
                 img_link,
                 card_header,
                 card_text) {
  div(
    class = "card-package",
    a(
      class = "card-img",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      img(
        src = img_link,
        alt = card_header
      )
    ),
    div(
      class = "card-heading",
      card_header
    ),
    div(
      class = "card-content",
      card_text
    ),
    a(
      class = "card-footer",
      href = href_link,
      target = "_blank",
      rel = "noopener noreferrer",
      "Learn more"
    )
  )
}

empty_card <- function() {
  div(
    class = "card-empty",
    a(
      href = "https://shiny.tools/#rhino",
      target = "_blank",
      rel = "noopener noreferrer",
      shiny::icon("arrow-circle-right"),
      div(
        class = "card-empty-caption",
        "More Appsilon Technologies"
      )
    )
  )
}

appsilon <- function() {
  div(
    class = "appsilon-card",
    div(
      class = "appsilon-pic",
      a(
        href = "https://appsilon.com/",
        target = "_blank",
        rel = "noopener noreferrer",
        img(
          src = create_image_path("appsilon-logo.png"),
          alt = "Appsilon"
        )
      )
    ),
    div(
      class = "appsilon-summary",
      "We create, maintain, and develop Shiny applications
      for enterprise customers all over the world. Appsilon
      provides scalability, security, and modern UI/UX with
      custom R packages that native Shiny apps do not provide.
      Our team is among the world's foremost experts in R Shiny
      and has made a variety of Shiny innovations over the
      years. Appsilon is a proud Posit Full Service
      Certified Partner."
    )
  )
}

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      id = "info",
      class = "info",
      shiny::icon("info-circle")
    ),
    tags$script(
      HTML(
        sprintf(
          fmt = "$('#info').click(() => {
            Shiny.setInputValue('%s', 'event', { priority: 'event'})
          })",
          ns("open_modal")
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$open_modal, {
      create_modal(
        modal(
          id = "main_about_page",
          header = "Olympic Games",
          div(
            class = "modal-dialog",
            div(
              class = "about-section",
              topic_section(
                header = "About the project",
                description = "This dashboard showcases the possibilities of Rhino
              package when used with sass, js and shiny.semantic ui."
              ),
              topic_section(
                header = "Dataset Info",
                description = "This dataset summarises Olympic Medals by country
                name, region, year and ranking etc... If you want to dive deeper
                into the dataset please visit the links below."
              ),
              div(
                class = "about-tag",
                tag(
                  tag_string = "kaggle dataset",
                  hyperlink = paste0(
                    "https://www.kaggle.com/datasets/heesoo37/",
                    "120-years-of-olympic-history-athletes-and-results"
                  )
                ),
                tag(
                  tag_string = "olympic website",
                  hyperlink = "https://olympics.com/en/sports/"
                )
              ),
              hr(),
              div(
                h4(
                  class = "about-header",
                  "Powered by"
                ),
                div(
                  class = "card-section",
                  card(
                    href_link = "https://appsilon.github.io/shiny.semantic/",
                    img_link = create_image_path("shiny-semantic.png"),
                    card_header = "shiny.semantic",
                    card_text = "Shiny Semantic is a package developed by
                  appsilon for the R community. With this library it is
                  easy to wrap Shiny with Fomantic UI (previously
                  Semantic). Add a few simple lines of code to give
                  your UI a fresh, modern and highly interactive look."
                  ),
                  card(
                    href_link = "https://appsilon.github.io/rhino/",
                    img_link = create_image_path("rhino.png"),
                    card_header = "rhino",
                    card_text = "Rhino allows you to create Shiny apps The Appsilon
                  Way - like a fullstack software engineer. Apply best
                  software engineering practices, modularize your code,
                  test it well, make UI beautiful, and think about
                  user adoption from the very beginning. Rhino is an opinionated
                  framework with a focus on software engineering practices
                  and development tools."
                  ),
                  empty_card()
                )
              ),
              appsilon()
            )
          )
        )
      )
    })
  })
}
