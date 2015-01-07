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

#' logeasier
#'
#' Easy logging in R, configurable by package
#'
#' \tabular{ll}{ Package: \tab logeasier\cr Type: \tab Package\cr Version:
#' \tab 0.1\cr Date: \tab 2014-11-18\cr License: \tab GPL\cr }
#'
#' @name logeasier-package
#' @aliases logeasier-package logeasier
#' @docType package
#' @author Maintainer: Benoit Thieurmel <bt@@datak.fr>
#' @seealso \itemize{
#' \item \code{\link{setLogLevel}}, \code{\link{getLogLevel}},
#' \item \code{\link{setTimeStampFormat}}, \code{\link{getTimeStampFormat}}
#' \item \code{\link{setLayoutFormat}}, \code{\link{getLayoutFormat}}
#' \item \code{\link{setLogFile}}, \code{\link{getLogFile}}
#' \item \code{\link{setPackagesLogs}}, \code{\link{getPackagesLogs}}
#' }
#'
#' @examples
#' require(logeasier)
#'
#' # see default parameters
#' getLogLevel()
#' getLogFile()
#' getPackagesLogs()
#' getTimeStampFormat()
#' getLayoutFormat()
#'
#' # two functions
#' g<-function(){
#'   a = 1
#'   message("Function g message ", a ,".")
#'   warning("Function g warning ",a, ".")
#'   h()
#' }
#'
#' h<-function(){
#'   message("Function h message ", a ,".")
#'   warning("Function h warning ", 10)
#'   rnorm("a")
#' }
#'
#' # first test
#' a = 1000
#'
#' g()
#'
#' warning("This is a warning")
#' message("My message")
#' stop("Oh, an error")
#'
#' # stats
#' rnorm("b")
#' b=runif(100)
#'
#' # base
#' log("a")
#' cc = c +10
#' zz=log(a)
#' cbind(1:3, 1:10)
#' rbind(data.frame(a = 1), data.frame(b = 2))
#'
#' # second test, setting parameters
#' setLayoutFormat('[~level][~time][~father.env-~father.function-~father.call][~children.env-~children.function-~children.call] ~message')
#' setTimeStampFormat("%a %b %d %X %Y %Z")
#' setPackagesLogs(package = c("stats","base"), level = c("STOP","STOP"), logfile=c("stats.log", "global.txt"))
#'
#' a = 1000
#'
#' g()
#'
#' warning("This is a warning")
#' message("My message")
#' stop("Oh, an error")
#'
#' # stats
#' rnorm("b")
#' b=runif(100)
#'
#' # base
#' log("a")
#' cc = c +10
#' zz=log(a)
#' cbind(1:3, 1:10)
#' rbind(data.frame(a = 1), data.frame(b = 2))
#'
NULL
