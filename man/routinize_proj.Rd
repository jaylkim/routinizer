% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/routinize_proj.R
\name{routinize_proj}
\alias{routinize_proj}
\title{Data Analysis Project Template}
\usage{
routinize_proj(
  path,
  check_git = TRUE,
  check_docker = TRUE,
  docker_from = "rocker/verse:latest",
  check_make = TRUE
)
}
\arguments{
\item{path}{The absolute path to the project.}

\item{check_git}{If \code{TRUE}, create a git repository.}

\item{check_docker}{If \code{TRUE}, create Dockerfile.}

\item{docker_from}{A base docker image. By default, it uses rocker/verse:latest.}

\item{check_make}{If \code{TRUE}, create Makefile.}
}
\value{
It returns nothing.
}
\description{
This function is not supposed to be used explicitly.
Rstudio will invoke this function when you create a new project
using the New Project Wizard of Rstudio.
}
\details{
Although it is not meant to be used explicitly,
users may use it when they want to create a structured project manually
(e.g. with \code{\link[usethis]{create_project}}.)
}
\section{Reference}{

\url{https://github.com/aaronpeikert/reproducible-research}
}

\examples{
\dontrun{
routinize_proj("path/to/example_proj")
}


}
