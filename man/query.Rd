\name{query}
\alias{query}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
query(api_key, application_key, query, from_t, to_t)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{api_key}{
%%     ~~Describe \code{api_key} here~~
}
  \item{application_key}{
%%     ~~Describe \code{application_key} here~~
}
  \item{query}{
%%     ~~Describe \code{query} here~~
}
  \item{from_t}{
%%     ~~Describe \code{from_t} here~~
}
  \item{to_t}{
%%     ~~Describe \code{to_t} here~~
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
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
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
        df <- zoo()
    }
    return(df)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
