test_that("pl_infer_age() complains when no CpGs found", {
  expect_error(pl_infer_age(data.frame(1:3, 4:6)))
  expect_error(pl_infer_age(pl_betas[1:500,], type = 'RPC'))
  
  # 2:700 = 344/558
  expect_warning(pl_infer_age(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'RPC'))
  # 2:700 = 337/546
  expect_warning(pl_infer_age(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'CPC'))
  # 2:700 = 243/395
  expect_warning(pl_infer_age(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'RRPC'))
})

test_that("pl_infer_age() returns correct number of samples", {
  expect_equal(length(pl_infer_age(pl_betas)), ncol(pl_betas))
})

test_that("pl_infer_age() returns numeric vector", {
  expect_true(is.vector(pl_infer_age(pl_betas)))
  expect_true(is.numeric(pl_infer_age(pl_betas)))
})

test_that("pl_infer_age() returns sensible gestational ages", {
  expect_true(all(pl_infer_age(pl_betas) < 50))
  expect_true(all(pl_infer_age(pl_betas) > 0))
})
