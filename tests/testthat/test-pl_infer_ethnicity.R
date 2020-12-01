test_that("pl_infer_ethnicity() returns data.frame", {
  expect_true(is.data.frame(pl_infer_ethnicity(pl_betas)))
})

test_that("pl_infer_ethnicity() works when some CpGs missing", {
  pl_betas_missing_cpgs <- pl_betas[1:1500,]
  expect_true(is.data.frame(pl_infer_ethnicity(pl_betas_missing_cpgs)))
})

test_that("pl_infer_ethnicity() output contains all columns", {
  output_colnames <- names(pl_infer_ethnicity(pl_betas))
  expect_true(
    all(
      c("Predicted_ethnicity_nothresh", "Predicted_ethnicity",
        "Prob_African", "Prob_Asian", "Prob_Caucasian", "Highest_Prob") %in%
        output_colnames))
})

test_that("pl_infer_ethnicity() returns probabilities that sum to 1", {
  sums <- pl_infer_ethnicity(pl_betas) %>%
    dplyr::mutate(sum_of_prob = Prob_African + Prob_Asian + Prob_Caucasian) %>%
    pull(sum_of_prob)
  expect_equal(sums, rep(1, 24))
})

