test_that("pl_infer_age() complains when no CpGs found", {
  expect_error(pl_infer_age(data.frame(1:3, 4:6)))
  expect_error(pl_infer_age(pl_betas[1:500,], type = 'RPC'))
  expect_warning(pl_infer_age(pl_betas[planet::pl_clock$CpGs[2:700],], type = 'RPC'))
  
})

