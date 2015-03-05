require(RCurl)
require(jsonlite)
require(xts)

to_epoch <- function(t) {
  return(as.POSIXct(t/1000, origin="1970-01-01"))
}

values <- function(l) {
  return(l[, 2])
}

query <- function(api_key, application_key, query, from_t, to_t) {
  res <- getForm('https://app.datadoghq.com/api/v1/query', api_key=api_key, application_key=application_key, from=from_t, to=to_t, query=query)
  parsed <- fromJSON(res)
  if (parsed[['status']] == "ok") {
    timeseries <- parsed[['series']]  # data frame
    scope <- timeseries[['scope']]  # names of each group, if any
    
    # If * is the only scope, rename it to something else
    if (length(scope) == 1 && scope == "*") {
      scope <- "all"
    }
    pointlist <- timeseries$pointlist
    # collect time parameters
    start <- max(timeseries$start)
    end <- max(timeseries$end)
    interval <- min(timeseries$interval)
    
    # Extract timestamps from the first list
    # They will be identical across all groups
    timestamps <- to_epoch(pointlist[[1]][, 1])
    
    # Collect all series values (accessible as [, 2])
    v <- mapply(values, pointlist)
    
    # build the time series
    df <- xts(v, order.by=timestamps, frequency=1/interval)
    colnames(df) <- scope
    
  } else {
    df <- xts()
  }
  return(df)
}
