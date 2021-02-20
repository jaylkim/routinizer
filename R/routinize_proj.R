#' Data Analysis Project Template
#'
#' This function is not supposed to be used explicitly.
#' Rstudio will invoke this function when you create a new project
#' using the New Project Wizard of Rstudio.
#'
#' Although it is not meant to be used explicitly,
#' users may use it when they want to create a structured project manually
#' (e.g. with \code{\link[usethis]{create_project}}.)
#'
#' @param path The absolute path to the project.
#' @param check_git If \code{TRUE}, create a git repository.
#' @param check_docker If \code{TRUE}, create Dockerfile.
#' @param docker_from A base docker image. By default, it uses rocker/verse:latest.
#' @param check_make If \code{TRUE}, create Makefile.
#'
#' @return It returns nothing.
#'
#' @examples
#' \dontrun{
#' routinize_proj("path/to/example_proj")
#' }
#'
#'
#' @import cli
#' @export
#' @section Reference:
#' \url{https://github.com/aaronpeikert/reproducible-research}
routinize_proj <-
  function(
    path,
    check_git = TRUE,
    check_docker = TRUE,
    docker_from = "rocker/verse:latest",
    check_make = TRUE
  ) {

  # Create the project dir

  dir.create(path, recursive = TRUE, showWarnings = FALSE)

  # Create .Rprofile

  if (check_make) {
    if (check_docker) {
      cont_make <-
        c(
          "cli_h1('Running make targets')",
          "cli_h2('Rebuilding the Docker image')",
          "cat(system2('make', 'build', stdout = TRUE, stderr = TRUE), sep = '\\n')",
          "cli_h2('Re-running the analysis on the Docker container')",
          "cat(system2('make', args = c('run', 'DOCKER=TRUE'), stdout = TRUE, stderr = TRUE), sep = '\\n')"
        )
    } else {
      cont_make <-
        c(
          "cli_h1('Running make targets')",
          "cli_h2('Re-running the analysis on your local machine')",
          "cat(system2('make', 'run'), sep = '\\n')"
        )
    }
  } else {
    cont_make <- ""
  }

  if (check_git) {
    cont_git <-
      c(
        "cli_h1('Making a git commit')",
        "cat(system2('git', 'init', stdout = TRUE, stderr = TRUE), sep = '\\n')",
        "cat(system2('git', args = c('add', '-A'), stdout = TRUE, stderr = TRUE), sep = '\\n')",
        "msg <- paste0('\"Rebuild the project ', Sys.time(), '\"')",
        paste0("cat(system2('git', c('commit', '-m', ", "msg", "), stdout = TRUE, stderr = TRUE), sep = '\\n')"),
        "cat(system2('git', args = c('branch', '-M', 'main'), stdout = TRUE, stderr = TRUE), sep = '\\n')"
      )
  } else {
    cont_git <- ""
  }

  contents <-
    c(
      "library(cli)",
      "",
      "cli_h1('Initiating the project')",
      "",
      cont_make,
      cont_git,
      "rm(msg)",
      "detach(package:cli)"
    )

  writeLines(contents, con = file.path(path, ".Rprofile"))


  # Create directories

  dir.create(file.path(path, "data"))
  dir.create(file.path(path, "src", "R"), recursive = TRUE)
  dir.create(file.path(path, "src", "stata"), recursive = TRUE)
  dir.create(file.path(path, "doc"))
  dir.create(file.path(path, "ext"))
  dir.create(file.path(path, "output", "figures"), recursive = TRUE)
  dir.create(file.path(path, "output", "tables"), recursive = TRUE)


  # Create Makefile

  if (check_make) {

    tryCatch(
      system2("make", args = "-v", stdout = NULL),
      warning = function(w) {
        cli::cli_alert_warning("make not found. Install it before setting any targets.")
      }
    )
    contents <-
      c(
        "project := $(notdir $(CURDIR))",
        "",
        "ifeq ($(DOCKER), TRUE)",
        "\trun := docker run --rm -v $(CURDIR):/home/rstudio $(project)",
        "\tcurdir_container = /home/rstudio",
        "endif",
        "",
        "build: Dockerfile",
        "\t@echo Nothing to build yet",
        "",
        "run:",
        "\t@echo Nothing to run yet"
      )

    writeLines(contents, con = file.path(path, "Makefile"))

  }

  # Create Dockerfile

  if (check_docker) {

    tryCatch(
      system2("docker", args = "-v", stdout = NULL),
      warning = function(w) {
        cli::cli_alert_warning("docker not found. Install it before building an image.")
      }
    )
    contents <-
      c(
        paste0("FROM ", docker_from),
        "WORKDIR /home/rstudio"
      )

    writeLines(contents, con = file.path(path, "Dockerfile"))

  }

  # Make a git repo

  if (check_git) {

    tryCatch(
      system2("git", args = "--version", stdout = NULL),
      warning = function(w) {
        cli::cli_alert_warning("git not found. Install it before creating a repo.")
      }
    )

  }

}
