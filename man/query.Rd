\name{query}
\alias{query}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%% query
}
\description{
%% Query metrics via the Datadog API and turn them into time series
}
\usage{
query(api_key, application_key, query, from_t, to_t)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{api_key}{
%%     Your Datadog account's API key, found at https://app.datadoghq.com/account/settings#api
}
  \item{application_key}{
%%     A Datadog Application key, also found at https://app.datadoghq.com/account/settings#api
}
  \item{query}{
%%     A query using Datadog's syntax, documented at https://docs.datadoghq.com
}
  \item{from_t}{
%%     The start of the time window for the query, expressed a POSIX timestamp
}
  \item{to_t}{
%%     The end of the time window for the query, also expressed a POSIX timestamp
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% See https://doc.datadoghq.com for documentation on queries
}
\author{
%% Alexis Le-Quoc
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (api_key, application_key, query, from_t, to_t) 
{
    res <- getForm("https://app.datadoghq.com/api/v1/query", 
        api_key = api_key, application_key = application_key, 
        from = from_t, to = to_t, query = query)
    parsed <- fromJSON(res)
    if (parsed[["status"]] == "ok") {
        timeseries <- parsed[["series"]]
        scope <- timeseries[["scope"]]
        if (length(scope) == 1 && scope == "*") {
            scope <- "all"
        }
        pointlist <- timeseries$pointlist
        start <- max(timeseries$start)
        end <- max(timeseries$end)
        interval <- min(timeseries$interval)
        timestamps <- to_epoch(pointlist[[1]][, 1])
        v <- mapply(values, pointlist)
        df <- xts(v, order.by = timestamps, frequency = 1/interval)
        colnames(df) <- scope
    }
    else {
        df <- xts()
    }
    return(df)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
