\name{dogq}
\alias{dogq}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
dogq
}
\description{
Query metrics via the Datadog API and turn them into time series
}
\usage{
dogq(api_key, application_key, query, from_t, to_t, to_ts)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{api_key}{
       Your Datadog account's API key, found at https://app.datadoghq.com/account/settings#api
  }
  \item{application_key}{
       A Datadog Application key, also found at https://app.datadoghq.com/account/settings#api
  }
  \item{query}{
       A query using Datadog's syntax, documented at https://docs.datadoghq.com
  }
  \item{from_t}{
        The start of the time window for the query, expressed a POSIX timestamp
  }
  \item{to_t}{
       The end of the time window for the query, also expressed a POSIX timestamp
  }
  \item{to_ts}{
       Decision to return xts or ts
  }
}
\details{
None
}
\value{
A set of \code{xts} indexed by time, each named appropriately depending on the query.
}
\references{
See https://doc.datadoghq.com for documentation on queries
}
\author{
Alexis Le-Quoc
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(api_key, application_key, query, from_t, to_t, to_ts=FALSE)
{
  res <- getForm('https://app.datadoghq.com/api/v1/query', api_key=api_key, application_key=application_key, from=from_t, to=to_t, query=query)
  parsed <- fromJSON(res)
  if (parsed[['status']] == "ok") {
    timeseries <- parsed[['series']]  # data frame
    scope <- timeseries[['scope']]  # names of each group, if any
    
    if (length(scope) == 1 && scope == "*") {
      scope <- "all"
    }
    pointlist <- timeseries$pointlist
    start <- max(timeseries$start)
    end <- max(timeseries$end)
    interval <- min(timeseries$interval)
    timestamps <- to_epoch(pointlist[[1]][, 1])
    v <- mapply(values, pointlist)
    if (to_ts) {
      df <- ts(v, frequency=60/interval)
    } else {
      df <- xts(v, order.by=timestamps, frequency=60/interval)
    }
    colnames(df) <- scope
  } else {
    df <- xts()
  }
  return(df)
}
}
