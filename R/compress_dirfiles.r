compress_dirfiles <- function(directory, filetypes=c("log"), use_parallel=TRUE, delete_original=FALSE) {

	filelist <- list.files(directory, pattern=paste0("^.*\\.(", paste0(filetypes, collapse="|"), ")$"), full.names=TRUE)
	
	if (length(filelist) == 0) {
		cat("0 files found\n")
		return(FALSE)
	}
	
	compress_file <- function(filename) {

		con <- file(filename, open="rb", raw=TRUE)
		contents <- readBin(con, what="raw", n=file.size(filename)+10)
		close(con)
		
		con <- xzfile(paste0(filename, ".xz"), compression=9, open="wb")
		writeBin(contents, con)
		close(con)
		
		return(TRUE)
	}
	
	if (use_parallel) {
		require(parallel)
		cl <- makeCluster(min(length(filelist), 2*detectCores()), methods=FALSE)
		curwd <- getwd()
		clusterExport(cl, "curwd", envir=environment())
		clusterEvalQ(cl, setwd(curwd))
		res <- parSapply(cl, filelist, compress_file)
		stopCluster(cl)
		rm(cl)
	} else {
		res <- sapply(filelist, compress_file)
	}
	
	if (all(all(res), delete_original)) {
		file.remove(filelist)
	}
	
	return(TRUE)

}
