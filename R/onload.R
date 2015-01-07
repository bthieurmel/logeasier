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

.onLoad <- function(libname, pkgname) {

  assign("LogEasieR.env", new.env(), envir=parent.env(environment()))
  assign("base.message",base::message, LogEasieR.env)

  setLayoutFormat()
  setLogLevel()
  setPackagesLogs()
  setTimeStampFormat()
  setLogFile()

  options(error = quote(errorFunction()))
  options(warning.expression = quote(warningFunction()))

  assign("level.numeric", c(INFO = 1, WARN = 2, STOP = 3, NONE = 4), envir=LogEasieR.env)

  logeasierAssignInNamespace("message",message, "base")

}

.onUnload <- function(libpath){
  logeasierAssignInNamespace("message",get("base.message", LogEasieR.env), "base")
  options(error = NULL)
  options(warning.expression = NULL)
}


# .onAttach <- function(libname, pkgname) {
#     pkgversion <- read.dcf(system.file("DESCRIPTION", package=pkgname),
#                            fields="Version")
#     msg <- paste("Package", pkgname, "version", pkgversion,
#                  "\nNOTE: - Logging level is set to", GetLogLevel(),
#                  "\n      - Output file is", GetLogFile(),
#                  "\n      - See 'package?rlogging' for help.")
#     #packageStartupMessage(msg)
# 	message(msg)
# }
