# rdog

Query Datadog directly from R.

## Getting started

```R
require(rdog)
api <- 'abc'
app <- 'def'

to_ts <- as.integer(Sys.time())
from_ts <- to_ts - 3600

results <- dogq(api, app, 'avg:system.cpu.idle{*}', from_ts=from_ts, to_ts=to_ts)
plot(results)
```
