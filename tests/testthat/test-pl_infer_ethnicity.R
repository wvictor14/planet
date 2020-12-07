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
    dplyr::pull(sum_of_prob)
  expect_equal(sums, rep(1, 24))
})

test_that("pl_infer_ethnicity(pl_betas) returns expected probabilities", {
  probs <- pl_infer_ethnicity(pl_betas[,1:3]) %>%
    dplyr::select(contains('Prob_')) %>%
    as.matrix()
  
  probs_expected <-
    tibble::tribble(
      ~Prob_African , ~Prob_Asian, ~Prob_Caucasian,
      0.0033076887, 0.0163799892, 0.9803123,
      0.0007717106, 0.0005143346, 0.9987140,
      0.0008060942, 0.0006992472, 0.9984947
    ) %>%
    as.matrix()
  
  expect_equal(probs, probs_expected, tolerance = 1e-7)
})
