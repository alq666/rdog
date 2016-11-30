#' Metrics 
#'
#' Return a list of all active metrics from given time until now
#' @param api_key Your Datadog API key
#' @param application_key Your Application Key
#' @param from_t Start of time range 
#' @export
#' @examples
#' \dontrun{dog_metrics('api_key', 'app_key', 1478872763)}
dog_metrics <- function(api_key, application_key, from_t) {
    res <- RCurl::getForm("https://app.datadoghq.com/api/v1/metrics", 
        api_key = api_key,
        application_key = application_key,
        from = from_t 
    )
    parsed <- jsonlite::fromJSON(res)

    # TODO: format output
    return(parsed$metrics)
}
