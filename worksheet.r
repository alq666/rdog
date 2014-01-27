require(RCurl)
require(rjson)
require(zoo)

to_epoch <- function(t) {
  return(as.POSIXct(t/1000, origin="1970-01-01"))
}

query_to_df <- function(api_key, application_key, query, from_t, to_t) {
  res <- getForm('https://app.datadoghq.com/api/v1/query', api_key=api_key, application_key=application_key, from=from_t, to=to_t, query=query)
  parsed <- fromJSON(res)
  series <- parsed[['series']]
  timeseries <- series[[1]]
  pointlist <- timeseries[['pointlist']]
  timestamps <- to_epoch(sapply(pointlist, '[', 1))
  values <- sapply(pointlist, '[', 2)
  return(zoo(values, order.by=timestamps))
}
