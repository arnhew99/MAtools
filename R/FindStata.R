FindStata <-
function (folder = ".", verbose = TRUE, upcase.names = FALSE) 
{
	require(readstata13)
    curwd <- getwd()
    setwd(folder)
    object.names <- c()
    for (i in list.files()) {
        if (substr(i, nchar(i) - 3, nchar(i)) == ".dta") {
            if (verbose) {
                cat(paste("loading", i, "\n"))
                flush.console()
            }
            dtaname <- substr(i, 1, nchar(i) - 4)
            object.names <- c(object.names, dtaname)
            assign(dtaname, read.dta13(i), envir = .GlobalEnv)
            if (upcase.names) {
                eval(parse(text = paste0("names(", dtaname, ") <- toupper(names(", 
                  dtaname, "))")), envir = .GlobalEnv)
            }
        }
    }
    setwd(curwd)
    invisible(object.names)
}
