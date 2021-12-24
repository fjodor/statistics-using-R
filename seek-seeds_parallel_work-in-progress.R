library(parallel)
library(progressr)

handlers(global = TRUE)
handlers("progress")

seek_seed <- function(seed, size, message) {
  set.seed(seed)
  text <- sample(letters, size = size, replace = TRUE) |>
    paste(collapse = "")
  ifelse(text == message, TRUE, FALSE)
}

iterate_seeds <- function(cl, .seeds, .message) {
  size <- nchar(.message)
  p <- progressor(along = .seeds)
  clusterApply(cl, .seeds, function(x) {
    res <- seek_seed(x, size = size, message = .message)
    p()
    if (res) stop(paste("Success: Seed:", x))
      # opt <- options(show.error.messages = FALSE)
      # on.exit(options(opt))
      # message(paste("Success! Seed:", x))
      # stop()
    # }
  })
  invisible(NULL)
}

test_seed <- function(seed, choices, message) {
  set.seed(seed)
  sample(choices, size = nchar(message), replace = TRUE) |>
    paste(collapse = "") |>
    stringr::str_to_title()
}

# Hyperthreading did not pay off, so disable

# bench::mark(
#   par_hyper = iterate_seeds_p(cl_hyper, 0:1e4, "abc"),
#   par_physical = iterate_seeds_p(cl_physical, 0:1e4, "abc"),
#   sequential = iterate_seeds(0:1e4, "abc")
# )

cl <- makeCluster(parallelly::availableCores(omit = 1, logical = FALSE))
clusterExport(cl, "seek_seed")

# A quick test
iterate_seeds(cl, 1:1e3, "ab")
test_seed(234, letters, "xx")
# 
# stopCluster(cl)

# A real test

library(parallel)
library(progressr)

cl <- makeCluster(parallelly::availableCores(omit = 1, logical = FALSE))
clusterExport(cl, "seek_seed")
iterate_seeds(cl, 0:1e5, "merry")
stopCluster(cl)
