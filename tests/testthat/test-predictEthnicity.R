test_that("predictEthnicity() returns data.frame", {
    data(plBetas)
    expect_true(is.data.frame(predictEthnicity(plBetas)))
})

test_that("predictEthnicity() calculates same output", {
    data(plBetas)
    p_af <- c(0.00330768872656711, 0.000771710643944653, 
              0.000806094180369881, 0.000883141643235066, 
              0.000884799797494469, 0.000852126991452609,
              0.000902063114953439, 0.00174040366539355, 
              0.000961711725825801, 0.00286898820795831, 
              0.00105386675074057, 0.000306481182770728, 
              0.000942764984559228, 0.000946060820782058, 
              0.0020524966920266, 0.00142326915917206, 
              0.0123073248178282, 0.0156960710252504, 
              0.0208420964578393, 0.000927554963875521, 
              0.00226345903184434, 0.00659734968883996, 
              0.00215776758283817, 0.00113972509373285
    )
    expect_equal(predictEthnicity(plBetas)$Prob_African, p_af)
    
    p_as <- c(0.016379989165612, 0.000514334630824522, 0.0006992472221568, 
              0.000791574845990966, 0.00130198889660584, 0.000973412726488719, 
              0.00175940873572904, 0.00223347616841534, 0.00230663583890151, 
              0.0035613536326078, 0.00106756692524558, 0.000514884325764231, 
              0.000818043969376253, 0.00167604274057553, 0.00251044567272013, 
              0.00247488942951423, 0.952354422257874, 0.15952127142996, 
              0.895451754694616, 0.000880124891818622, 0.00280074668729557, 
              0.0112012645744202, 0.00241963027188368, 0.00176508849863307)
    expect_equal(predictEthnicity(plBetas)$Prob_Asian, p_as)
    
    p_ca <- c(0.980312322107821, 0.998713954725231, 0.998494658597473, 
              0.998325283510774, 0.9978132113059, 0.998174460282059, 
              0.997338528149317, 0.996026120166191, 0.996731652435273, 
              0.993569658159434, 0.997878566324014, 0.999178634491465, 
              0.998239191046065, 0.997377896438642, 0.995437057635253, 
              0.996101841411314, 0.035338252924298, 0.82478265754479, 
              0.0837061488475445, 0.998192320144306, 0.99493579428086, 
              0.98220138573674, 0.995422602145278, 0.997095186407634)
    expect_equal(predictEthnicity(plBetas)$Prob_Caucasian, p_ca)
    
})

test_that("predictEthnicity() works when some CpGs missing", {
    data(plBetas)
    plBetas_missing_cpgs <- plBetas[1:1500,]
    expect_true(
        suppressWarnings(
            is.data.frame(
                predictEthnicity(plBetas_missing_cpgs))))
    expect_warning(predictEthnicity(plBetas_missing_cpgs))
})

test_that("predictEthnicity() output contains all columns", {
    data(plBetas)
    output_colnames <- names(predictEthnicity(plBetas))
    expect_true(
        all(
            c("Predicted_ethnicity_nothresh", "Predicted_ethnicity",
              "Prob_African", "Prob_Asian", "Prob_Caucasian", "Highest_Prob") %in%
                output_colnames))
})

test_that("predictEthnicity() returns probabilities that sum to 1", {
    data(plBetas)
    sums <- predictEthnicity(plBetas) %>%
        dplyr::mutate(sum_of_prob = Prob_African + Prob_Asian + Prob_Caucasian) %>%
        dplyr::pull(sum_of_prob)
    expect_equal(sums, rep(1, 24))
})

test_that("predictEthnicity(plBetas) returns expected probabilities", {
    data(plBetas)
    probs <- predictEthnicity(plBetas[,1:3]) %>%
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
