#' Search
#'
#' Search for entries from the last 24 hours
#' @param api_key Your Datadog API key
#' @param application_key Your Application Key
#' @param query Query string.
#' @export
#' @examples
#' dog_search('api_key', 'app_key', 'test')
dog_search <- function(api_key, application_key, query) {
    res <- RCurl::getForm("https://app.datadoghq.com/api/v1/search", 
        api_key = api_key,
        application_key = application_key,
        q = query
    )
    parsed <- jsonlite::fromJSON(res)

    # TODO: format output
    return(parsed$results)

}
