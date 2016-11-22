to_epoch <- function(t) {
    return(as.POSIXct(t/1000, origin = "1970-01-01"))
}

values <- function(l) {
    return(l[, 2])
}

#' Compute the frequency based on the interval
freq <- function(i) {
    if (i <= 60) {
        return(60)
    } else if (60 < i && i <= 3600) {
        return(24)
    } else {
        return(7)
    }
}

 
