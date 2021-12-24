library(progressr)
handlers(global = TRUE)
handlers("progress")

seek_seed <- function(seed, size, message) {
  set.seed(seed)
  text <- sample(letters, size = size, replace = TRUE) |>
    paste(collapse = "")
  if (text == message) {
    opt <- options(show.error.messages = FALSE)
    on.exit(options(opt))
    message(paste("Success! Seed:", seed))
    stop()
  }
}

iterate_seeds <- function(.seeds, .message) {
  size <- nchar(.message)
  p <- progressor(along = .seeds)
  lapply(.seeds, function(x) {
    seek_seed(x, size = size, message = .message)
    p()
  })
  invisible(NULL)
}

test_seed <- function(seed, choices, message) {
  set.seed(seed)
  sample(choices, size = nchar(message), replace = TRUE) |>
    paste(collapse = "") |>
    stringr::str_to_title()
}

# iterate_seeds(0:100, "a")
# test_seed(16, letters, "x")
# 
# iterate_seeds(0:1e4, "ab")
# test_seed(234, letters, "xx")
