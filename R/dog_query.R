#' Querying
#'
#' @param api_key Your Datadog API key
#' @param application_key Your Application Key
#' @param query 
#' @param from_t Start of time range 
#' @param to_t End of time range
#' @param as_df Boolean, returns xts when FALSE, data.fame when TRUE
#' @export
#' @examples
#' dog_metrics('api_key', 'app_key', 1478872763, as.integer(Sys.time()))

dog_query <- function(api_key, application_key, query, from_t, to_t, as_df = FALSE) {
    res <- RCurl::getForm("https://app.datadoghq.com/api/v1/query", api_key = api_key, application_key = application_key, 
        from = from_t, to = to_t, query = query)
    parsed <- jsonlite::fromJSON(res)
    if (parsed[["status"]] == "ok") {
        timeseries <- parsed[["series"]]  # data frame
        scope <- timeseries[["scope"]]  # names of each group, if any
        
        # If * is the only scope, rename it to something else
        if (length(scope) == 1 && scope == "*") {
            scope <- "all"
        }
        pointlist <- timeseries$pointlist
        # collect time parameters
        start <- max(timeseries$start)
        end <- max(timeseries$end)
        interval <- min(timeseries$interval)
        
        
        # Extract timestamps from the first list They will be identical across all groups
        timestamps <- to_epoch(pointlist[[1]][, 1])
        print(class(timestamps))
        
        # Collect all series values (accessible as [, 2])
        v <- mapply(values, pointlist)
        
        # build the time series
        if (as_df) {
            df <- data.frame(timestamps, v)
            colnames(df) <- c('time', scope)
        } else {
            df <- xts::xts(v, order.by = timestamps, frequency = freq(interval))
            colnames(df) <- scope
        }
    } else {
        df <- xts()
    }
    return(df)
}
