# rdog

Query Datadog directly from R.

## Getting started

```R
install.packages("devtools")
devtools::install_github("alq666/rdog")
require(rdog)
api <- 'abc'
app <- 'def'

to_t <- as.integer(Sys.time())
from_t <- to_t - 3600

# Get an xts object to keep timestamps
results <- dogq(api, app, 'avg:system.cpu.idle{*}', from_t=from_t, to_t=to_t)
plot(results)

# Get a data frame
results <- dogq(api, app, 'avg:system.cpu.idle{*}', from_t=from_t, to_t=to_t, TRUE)
plot(results)
```
