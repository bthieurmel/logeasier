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

message <- function(..., domain=NULL, appendLF=TRUE) {

  base.message <-  get("base.message", LogEasieR.env)
  base.message(..., domain=domain, appendLF=appendLF)

  logfile = getLogFile()
  levels = getLogLevel()
  layout.format = getLayoutFormat()
  time.format = getTimeStampFormat()
  timestamp <- format(Sys.time(), format= time.format)

  calls=sys.calls()

  current.message <- paste0(...)

  info <- extractMessageInfo(calls)

  if(is.null(info)){
    control.level <- levels$global
    control.logfile <- logfile$global

    level.num <- get("level.numeric", envir=LogEasieR.env)

    if(level.num[as.character("INFO")] >= level.num[as.character(control.level)]){

      current.message <-  printMessage (message = current.message, level = "INFO", timestamp = timestamp,
                                        info.message = info, format = layout.format)

      cat(current.message, "\n", file=control.logfile, sep="", append=TRUE)
    }

  }else{
    if(!identical(info,0)){
      if(nrow(levels$package)>0){
        set.level = as.character(levels$package[as.character(info[1,"name.package"]),2])
        control.level <- ifelse(!is.na(set.level), set.level, levels$global)
      }else{
        control.level <- levels$global
      }

      if(nrow(logfile$package)>0){
        set.log = as.character(logfile$package[as.character(info[1,"name.package"]),3])
        control.logfile <- ifelse(!is.na(set.log), set.log, logfile$global)
      }else{
        control.logfile <- logfile$global
      }

      level.num <- get("level.numeric", envir=LogEasieR.env)

      if(level.num[as.character("INFO")] >= level.num[as.character(control.level)]){

        current.message <-  printMessage (message = current.message, level = "INFO", timestamp = timestamp,
                                          info.message = info, format = layout.format)

        cat(current.message, "\n", file= control.logfile, sep="", append=TRUE)
      }
    }
  }

}
