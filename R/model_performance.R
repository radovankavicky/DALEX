#' Model Performance Plots
#'
#' @param explainer a model to be explained, preprocessed by the 'explain' function
#' @param ... other parameters
#'
#' @return An object of the class 'model_performance_explainer'.
#'
#' @export
#' @examples
#' #\dontrun{
#' library("breakDown")
#' library("randomForest")
#' HR_rf_model <- randomForest(left~., data = breakDown::HR_data, ntree = 100)
#' explainer_rf  <- explain(HR_rf_model, data = HR_data, y = HR_data$left)
#' model_performance(explainer_rf)
#'
#' HR_glm_model <- glm(left~., data = breakDown::HR_data, family = "binomial")
#' explainer_glm <- explain(HR_glm_model, data = HR_data, y = HR_data$left,
#'                     predict_function = function(m,x) predict.glm(m,x,type = "response"))
#' model_performance(explainer_glm)
#'
#' HR_lm_model <- lm(left~., data = breakDown::HR_data)
#' explainer_lm <- explain(HR_lm_model, data = HR_data, y = HR_data$left)
#' model_performance(explainer_lm)
#' #}
#'
model_performance <- function(explainer, ...) {
  if (!("explainer" %in% class(explainer))) stop("The model_performance() function requires an object created with explain() function.")
  if (is.null(explainer$data)) stop("The model_performance() function requires explainers created with specified 'data' parameter.")
  if (is.null(explainer$y)) stop("The model_performance() function requires explainers created with specified 'y' parameter.")

  observed <- explainer$y
  predicted <- explainer$predict_function(explainer$model, explainer$data, ...)
  residuals <- data.frame(predicted, observed, diff = predicted - observed)

  class(residuals) <- c("model_performance_explainer", "data.frame")
  residuals$label <- explainer$label
  residuals
}


#' Model Performance Summary
#'
#' @param x a model to be explained, object of the class 'model_performance_explainer'
#' @param ... other parameters
#'
#' @importFrom stats quantile
#' @export
#' @examples
#' #\dontrun{
#' library("breakDown")
#' library("randomForest")
#' HR_rf_model <- randomForest(left~., data = breakDown::HR_data, ntree = 100)
#' explainer_rf  <- explain(HR_rf_model, data = HR_data, y = HR_data$left)
#' model_performance(explainer_rf)
#'
#' #}
#'
print.model_performance_explainer <- function(x, ...) {
  print(quantile(x$diff, seq(0, 1, 0.1)))
}


