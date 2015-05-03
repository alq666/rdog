# rdog

Query Datadog directly from R.

## Getting started

```R
install.packages("devtools")
devtools::install_github("alq666/rdog")
require(rdog)
api <- 'abc'
app <- 'def'

to_ts <- as.integer(Sys.time())
from_ts <- to_ts - 3600

# Get an xts object to keep timestamps
results <- dogq(api, app, 'avg:system.cpu.idle{*}', from_ts=from_ts, to_ts=to_ts)
plot(results)

# Get a data frame
results <- dogq(api, app, 'avg:system.cpu.idle{*}', from_ts=from_ts, to_ts=to_ts, TRUE)
plot(results)
```
