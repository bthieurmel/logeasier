# This file is part of logeasier R package. https://github.com/bthieurmel/logeasier
#
# logeasier is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# logeasier is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with logeasier  If not, see http://www.gnu.org/licenses/.

#' Set packages logs configuration
#'
#' Set packages logs configuration. Level and log file
#'
#' Set packages logs configuration. Level and log file
#'
#' @param package character or character vector of package(s)
#'
#' @param level character or character vector of levels for package(s). Value(s) in c('INFO','WARN', 'STOP', 'NONE'). Default to global log level
#'
#' @param logfile character or character vector of log files for package(s). Default to global log file.
#'
#' @return nothing. Assign value to LogEasieR.env
#'
#' @examples
#'
#' # disable logging for package FactoMineR
#' setPackagesLogs(package = "FactoMineR", level = "NONE")
#'
#' # differents log files and levels for differents packages
#' setPackagesLogs(package = c("FactoMineR", "stats"), level = c("WARN","INFO"),
#'  logfile = c("factominer.log", "stats.txt"))
#'
#' @export
#'

setPackagesLogs <- function(package = NULL, level = getLogLevel()$global, logfile = getLogFile()$global){

  if(is.null(package)){
    current.package.level <- data.frame(package.name = NULL, package.level = NULL, package.logfile = NULL)
    assign("packages", current.package.level, envir=LogEasieR.env)

  }else{
    if(length(unique(package))!=length(package)){
      stop("Needed unique package")
    }
    if((length(package) != length(level)) & length(level)!=1){
      stop("level arguments must have same length of package(s), or only one value")
    }
    if(length(package) != length(logfile) & length(logfile)!=1){
      stop("logfile arguments must have same length of package(s), or only one value")
    }
    if(any(!level%in%c("INFO","WARN", "STOP", "NONE"))){
      stop("Invalid levels. Must be in c('INFO','WARN', 'STOP', 'NONE')")
    }

    available.packages <- installed.packages()[,1]

    if(any(!package%in%available.packages)){
      ind <- which(!package%in%available.packages)
      stop("Package(s) ", paste(package[ind], collapse = ",")," is/are not available. Please verify name or install it.")
    }

    new.package.level <- data.frame(package.name = package, package.level = level, package.logfile = logfile)
    rownames(new.package.level) <- package
    current.package.level <- get("packages", envir=LogEasieR.env)
    current.package.level <- current.package.level[setdiff(rownames(current.package.level), rownames(new.package.level)),]
    current.package.level <- rbind(current.package.level, new.package.level)

    assign("packages", current.package.level, envir=LogEasieR.env)
  }
}

#' Get package(s) logs configuration
#'
#' Get package(s) logs configuration. Level and log file
#'
#' Get package(s) logs configuration. Level and log file
#'
#' @return data.frame.
#'
#' @examples
#'
#' getPackagesLogs()
#'
#' @export
#'
getPackagesLogs <- function(){
  get("packages", envir=LogEasieR.env)
}

#' Set global log level
#'
#' Set global log level
#'
#' Set global log level
#'
#' @param level character. Value in c('INFO','WARN', 'STOP', 'NONE'). Default to "INFO"
#'
#'
#' @return nothing. Assign value to LogEasieR.env
#'
#' @examples
#'
#' # default level want loading package
#' getloglevel()
#'
#' # change to WARN
#' setLogLevel(level = "WARN")
#'
#' @export
#'
setLogLevel <- function(level="INFO") {
  stopifnot(level %in% c("INFO","WARN", "STOP","NONE"))
  assign("loglevel", level, envir=LogEasieR.env)
}


#' Get log level(s)
#'
#' Get log level(s). Global and by packages
#'
#' Get log level(s). Global and by packages
#'
#' @return a list
#'
#' @examples
#'
#' getLogLevel()
#'
#' @export
#'
getLogLevel <-function() {
  list(global = get("loglevel", envir=LogEasieR.env), packages = get("packages", envir=LogEasieR.env))
}


#' Set timestamp format
#'
#' Set timestamp format
#'
#' Set timestamp format
#'
#' @param time.format character. A time format. Default to ' \%Y-\%m-\%d \%H:\%M:\%S'. See \code{\link{strptime}}
#'
#' @return nothing. Assign value to LogEasieR.env
#'
#' @examples
#'
#' # default timestamp format want loading package
#' getTimeStampFormat()
#'
#' # change
#' setTimeStampFormat(time.format = "%a %b %d %X %Y %Z")
#'
#' @export
#'
setTimeStampFormat <- function(time.format="%Y-%m-%d %H:%M:%S") {
  assign("time.format", time.format, envir=LogEasieR.env)
}

#' Get timestamp format
#'
#' Get timestamp format
#'
#' Get timestamp format
#'
#' @return a character
#'
#' @examples
#'
#' getTimeStampFormat()
#'
#' @export
#'
getTimeStampFormat <- function() {
  get("time.format", envir=LogEasieR.env)
}

#' Set layout format
#'
#' Set layout format
#'
#'
#' @param layout.format character. Layout format. Default to '[~time][~level] ~message'
#'
#' @details
#'
#' Available tags are :\cr
#' ~level : Log level\cr
#' ~time : Timestamp\cr
#' ~father.env : Father Namespace\cr
#' ~father.function : Father Calling function name\cr
#' ~father.call : Full father call\cr
#' ~children.env : Children Namespace\cr
#' ~children.function : Calling function\cr
#' ~children.call : Full chidren call\cr
#' ~message : message\cr
#'
#' @return nothing. Assign value to LogEasieR.env
#'
#' @examples
#'
#' # default layout format want loading package
#' getLayoutFormat()
#'
#' # change
#' setLayoutFormat(layout.format = '[~level][~time][~father.env-~father.function] ~message')
#'
#' @export
#'

setLayoutFormat <- function(layout.format = '[~time][~level] ~message'){
  assign("layout.format", layout.format, envir=LogEasieR.env)
}


#' Get layout format
#'
#' Get layout format
#'
#' Get layout format
#'
#' @return a character
#'
#' @examples
#'
#' getLayoutFormat()
#'
#' @export
#'
getLayoutFormat <- function(){
  get("layout.format", envir=LogEasieR.env)
}


#' Set global log file
#'
#' Set global log file
#'
#' Set global log file
#'
#' @param file character. path to log file. Default to file.path(getwd(), "logeasier.log")
#'
#' @return nothing. Assign value to LogEasieR.env
#'
#' @examples
#'
#' # default log file want loading package
#' getLogFile()
#'
#' # change
#' setLogFile(file = "mylogfile.txt")
#'
#' @export
#'
setLogFile <- function(file = file.path(getwd(), "logeasier.log")){
  assign("logfile", file, envir=LogEasieR.env)
}

#' Get log file(s)
#'
#' Get log file(s). Global and by packages
#'
#' Get log file(s). Global and by packages
#'
#' @return a list
#'
#' @examples
#'
#' getLogFile()
#'
#' @export
#'
getLogFile <- function(){
  list(global = get("logfile", envir=LogEasieR.env), packages = get("packages", envir=LogEasieR.env))
}
