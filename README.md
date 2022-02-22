# Shiny Template Showcase - Olympic History Map
This app is based on [shiny-template](https://github.com/Appsilon/shiny-template).
It is meant to be a showcase of the template features
and a place for code/configuration which is not used often enough to be added to the template itself.

## Prerequisites
This is an application built in [Shiny](https://shiny.rstudio.com/).
To run it, make sure you have R (>= 4.0.0) installed.
For JavaScript and Sass development you'll also need
[Node.js](https://nodejs.org/en/download/) (>= 14.0.0)
and [yarn](https://classic.yarnpkg.com/en/docs/install) (>= 1.22.0).

## Dependencies
Run `renv::restore(clean = TRUE)` to synchronize the project library with the lockfile
when you initially clone the repo or switch branches.
Run `yarn --cwd tools/node` to install Node dependencies.

## Data
Application-ready data is included in `app/data`.
However, if you want to generate this data from raw sources, run `source("./scripts/generate_data.R")`

## Running
To run the app, use `Rscript -e 'shiny::runApp(launch.browser = TRUE)'`.

## Deployment
You can use the RStudio GUI to deploy the app to RStudio Connect or shinyapps.io.
You only need to include the following files:
`.Rprofile`, `dependencies.R`, `app.R`, and `app/` directory.

### Docker
The application can also be packaged as a Docker container using `rocker/shiny` as a
base image.

To build the image locally, execute:
```bash
docker build -t shiny-example .
```

To run the container, execute:
```bash
docker run -ti -p 3838:3838 shiny-example
```

The application should be available under `localhost:3838` on your local
workstation.

## Development
This project uses [renv](https://rstudio.github.io/renv/) to manage R package dependencies.
To add/remove packages, edit the `dependencies.R` file and run the following commands:
```r
renv::install() # Install added packages
renv::snapshot() # Update the lockfile
renv::restore(clean = TRUE) # Uninstall removed packages
```

The following tools are available:
* `tools/lint-r`: lint R sources in `app/modules`
* `tools/lint-js [--fix]`: lint JavaScript sources in `app/js`
* `tools/lint-sass [--fix]`: lint Sass sources in `app/styles`
* `tools/style`: reformat R files according to the tidyverse styleguide
  using [styler](https://github.com/r-lib/styler)
* `tools/unit-test`: run unit tests
* `tools/e2e-test`: run end-to-end tests
* `tools/coverage`: generate a unit test coverage report
* `tools/build-js [--watch]`: build JavaScript
* `tools/build-sass [--watch]`: build Sass

### Validation, linters and pull-requests

We want to provide high quality code. For this reason we are using several
[pre-commit hooks](.pre-commit-config.yaml) and [GitHub Actions
workflow](.github/workflows/precommit.yaml). A pull-request to the `master`
branch will trigger these validations and lints automatically. Please check your
code before you will create pull-requests.

Before you can run hooks, you need to have the `pre-commit` package manager
[installed](https://pre-commit.com#install).

```bash
pip install pre-commit
pre-commit install
```

If you are going to enforce [Conventional
Commits](https://www.conventionalcommits.org/) commit message style on the title
you will also need to
[install](https://jorisroovers.com/gitlint/#getting-started) `gitlint`.

```bash
pip install gitlint
```

You then need to install the pre-commit hook like so:
```bash
pre-commit install --hook-type commit-msg
```

> It's important that you run `pre-commit install --hook-type commit-msg`, even
> if you've already used `pre-commit install` before. `pre-commit install` does
> not install `commit-msg` hooks by default!

To manually trigger gitlint using `pre-commit` for your last commit message, use the following command:
```sh
pre-commit run gitlint --hook-stage commit-msg --commit-msg-filename .git/COMMIT_EDITMSG
```

In case you want to change gitlint's behavior, you should either use a `.gitlint` file
(see [Configuration](https://jorisroovers.com/gitlint/configuration)) or modify the gitlint invocation in
your `.pre-commit-config.yaml` file like so:
```yaml
-   repo: https://github.com/jorisroovers/gitlint
    rev:  # Fill in a tag / sha here
    hooks:
    -   id: gitlint
        args: [--contrib=CT1, --msg-filename]
```

See [pre-commit documentation](https://pre-commit.com/) and [GitHub Actions
documentation](https://docs.github.com/en/actions) for further details.
