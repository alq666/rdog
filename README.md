# rdog

Query Datadog directly from R.

## Getting started

```R
install.packages("devtools")
devtools::install_github("datadog/rdog")
require(rdog)
api <- 'abc'
app <- 'def'

to_t <- as.integer(Sys.time())
from_t <- to_t - 3600

# Get an xts object to keep timestamps
results <- dog_query(api, app, 'avg:system.cpu.idle{*}', from_t=from_t, to_t=to_t)
plot(results)

# Get a data frame
results <- dog_query(api, app, 'avg:system.cpu.idle{*}', from_t=from_t, to_t=to_t, TRUE)
plot(results)
```
