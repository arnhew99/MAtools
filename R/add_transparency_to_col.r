add_transparency_to_col <- function(col, transparency) {

	return(paste0("#", paste0(as.hexmode(col2rgb(col)[,1]),collapse=""), transparency))

}
