test_that("predictAge() complains when no CpGs found", {
  data(plBetas)
  data(ageCpGs)
  expect_error(predictAge(data.frame(1:3, 4:6)))
  expect_error(predictAge(plBetas[1:500,], type = 'RPC'))
  
  # 2:700 = 344/558
  expect_warning(predictAge(plBetas[ageCpGs$CpGs[2:700],], 
                              type = 'RPC'))
  # 2:700 = 337/546
  expect_warning(predictAge(plBetas[ageCpGs$CpGs[2:700],], 
                              type = 'CPC'))
  # 2:700 = 243/395
  expect_warning(predictAge(plBetas[ageCpGs$CpGs[2:700],], 
                              type = 'RRPC'))
})

test_that("predictAge() returns correct number of samples", {
  data(plBetas)
  expect_equal(length(predictAge(plBetas)), ncol(plBetas))
})

test_that("predictAge() returns numeric vector", {
  data(plBetas)
  expect_true(is.vector(predictAge(plBetas)))
  expect_true(is.numeric(predictAge(plBetas)))
})

test_that("predictAge() returns sensible gestational ages", {
  data(plBetas)
  expect_true(all(predictAge(plBetas) < 50))
  expect_true(all(predictAge(plBetas) > 0))
})
