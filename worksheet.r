require(RCurl)
require(jsonlite)

to_epoch <- function(t) {
  return(as.POSIXct(t/1000, origin="1970-01-01"))
}

query_to_df <- function(api_key, application_key, query, from_t, to_t) {
  res <- getForm('https://app.datadoghq.com/api/v1/query', api_key=api_key, application_key=application_key, from=from_t, to=to_t, query=query)
  parsed <- fromJSON(res)
  timeseries <- parsed[['series']]
  pointlist <- timeseries[['pointlist']]
  df <- data.frame(pointlist[[1]])
  ts <- mapply(to_epoch, df$X1)
  df$X1 <- ts
  return(df)
}
