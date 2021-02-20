test_that("Check if files and dirs exist", {
  tmpdir <- file.path(tempdir(), "test_proj")
  dir.create(tmpdir)
  setwd(tmpdir)
  routinize_proj(tmpdir)
  expect_true(
    all(
      dir.exists(file.path(tmpdir, c("data", "src", "doc", "ext", "output")))
    )
  )
  expect_true(
    all(
      dir.exists(file.path(tmpdir, file.path("src", "R"))),
      dir.exists(file.path(tmpdir, file.path("src", "Stata"))),
      dir.exists(file.path(tmpdir, file.path("output", "figures"))),
      dir.exists(file.path(tmpdir, file.path("output", "tables")))
    )
  )
  expect_true(
    all(
      file.exists(file.path(tmpdir, c("Dockerfile", "Makefile", ".Rprofile")))
    )
  )
  unlink(tmpdir, recursive = TRUE)
})
