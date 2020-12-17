test_that("predictAge() complains when no CpGs found", {
  expect_error(predictAge(data.frame(1:3, 4:6)))
  expect_error(predictAge(pl_betas[1:500,], type = 'RPC'))
  
  # 2:700 = 344/558
  expect_warning(predictAge(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'RPC'))
  # 2:700 = 337/546
  expect_warning(predictAge(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'CPC'))
  # 2:700 = 243/395
  expect_warning(predictAge(pl_betas[planet::pl_clock$CpGs[2:700],], 
                              type = 'RRPC'))
})

test_that("predictAge() returns correct number of samples", {
  expect_equal(length(predictAge(pl_betas)), ncol(pl_betas))
})

test_that("predictAge() returns numeric vector", {
  expect_true(is.vector(predictAge(pl_betas)))
  expect_true(is.numeric(predictAge(pl_betas)))
})

test_that("predictAge() returns sensible gestational ages", {
  expect_true(all(predictAge(pl_betas) < 50))
  expect_true(all(predictAge(pl_betas) > 0))
})
