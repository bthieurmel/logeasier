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

# @export
extractWarningInfo <- function(value.sys.calls, end.exp = "^.signalSimpleWarning|^warning", tag.message = "^.signalSimpleWarning"){
  controle.calls <- unlist(value.sys.calls)

  deb <- 1

  ind.fin <- min(grep(end.exp, controle.calls))
  fin <- ind.fin[length(ind.fin)]-1

  current.message <- grep(tag.message, controle.calls)
  current.message <- as.character(controle.calls[current.message][[1]])[2]

  if(deb<=fin){
    call.function = unlist(as.character(value.sys.calls[deb:fin]))

    name.function = as.vector(sapply(call.function, function(x){
      unlist(strsplit(x,"[(]"))[1]
    }))

    name.package = as.vector(sapply(name.function, function(x){
      f <- findFunction(gsub("[(]{1}[[:print:]]*","",x))
      if(length(f) > 0){
        gsub("^package:","",environmentName(f[[1]]))
      }else{
        ""
      }
    }))

    res <- data.frame(call.function, name.function, name.package)

    return(list(current.message = current.message, res = res))
  }

  return(list(current.message = current.message, res = NULL))
}

# @export
extractErrorInfo <- function(value.sys.calls){

  controle.calls <- unlist(value.sys.calls)
  controle.calls <- controle.calls[-length(controle.calls)]
  deb <- 1

  controle.stop <- grep("^stop",controle.calls)
  fin <- ifelse(length(controle.stop) > 0, controle.stop - 1, length(controle.calls))

  if(deb<=fin){
    call.function = unlist(as.character(value.sys.calls[deb:fin]))

    name.function = as.vector(sapply(call.function, function(x){
      unlist(strsplit(x,"[(]"))[1]
    }))

    name.package = as.vector(sapply(name.function, function(x){
      f <- findFunction(gsub("[(]{1}[[:print:]]*","",x))
      if(length(f) > 0){
        gsub("^package:","",environmentName(f[[1]]))
      }else{
        ""
      }
    }))

    res <- data.frame(call.function, name.function, name.package)

    return(res)
  }

  return(NULL)
}

# @export
extractMessageInfo <- function(value.sys.calls){

  controle.calls <- unlist(value.sys.calls)

  deb <- 1

  controle.stop <- grep("^message",controle.calls)
  fin <- ifelse(length(controle.stop) > 0, controle.stop - 1, length(controle.calls))

  if(!any(grepl(".packageStartupMessage",controle.calls[[controle.stop]]))){
    if(deb<=fin){
      call.function = unlist(as.character(value.sys.calls[deb:fin]))

      name.function = as.vector(sapply(call.function, function(x){
        unlist(strsplit(x,"[(]"))[1]
      }))

      name.package = as.vector(sapply(name.function, function(x){
        f <- findFunction(gsub("[(]{1}[[:print:]]*","",x))
        if(length(f) > 0){
          gsub("^package:","",environmentName(f[[1]]))
        }else{
          ""
        }
      }))

      res <- data.frame(call.function, name.function, name.package)

      return(res)
    }
    return(NULL)
  }else{
    return(0)
  }
}

#' @export
errorFunction<- function(){
  logfile = getLogFile()
  levels = getLogLevel()
  layout.format = getLayoutFormat()
  time.format = getTimeStampFormat()
  timestamp <- format(Sys.time(), format= time.format)

  calls <- sys.calls()
  current.message <- geterrmessage()

#   m <- gregexpr("(:)", current.message)
#   current.message <- gsub("^[[:space:]]","",substring(current.message, m[[1]][1]+1))

  info <- extractErrorInfo(calls)

  if(!is.null(info) & nrow(levels$package)>0){
    set.level = as.character(levels$package[as.character(info[1,"name.package"]),2])
    control.level <- ifelse(!is.na(set.level), set.level, levels$global)
  }else{
    control.level <- levels$global
  }

  if(!is.null(info) & nrow(logfile$package)>0){
    set.log = as.character(logfile$package[as.character(info[1,"name.package"]),3])
    control.logfile <- ifelse(!is.na(set.log), set.log, logfile$global)
  }else{
    control.logfile <- logfile$global
  }

  level.num <- get("level.numeric", envir=LogEasieR.env)

  if(level.num[as.character("STOP")] >= level.num[as.character(control.level)]){

    current.message <-  printMessage (message = current.message, level = "STOP", timestamp = timestamp,
                                      info.message = info, format = layout.format)

    cat(current.message, "\n", file= control.logfile, sep="", append=TRUE)
  }

  #   print(calls)
  #   print(current.message)
  #   print(function.info)
}

#' @export
warningFunction <- function(){

  logfile = getLogFile()
  levels = getLogLevel()
  layout.format = getLayoutFormat()
  time.format = getTimeStampFormat()
  timestamp <- format(Sys.time(), format= time.format)

  calls=sys.calls()

  info <- extractWarningInfo(calls, end.exp = "^.signalSimpleWarning|^warning", tag.message = "^.signalSimpleWarning")
  current.message <- info$current.message

  base.message <-  get("base.message", LogEasieR.env)
  base.message("Warning message:\n", current.message, domain=NULL, appendLF=TRUE)

  info <- info$res

  if(!is.null(info) & nrow(levels$package)>0){
    set.level = as.character(levels$package[as.character(info[1,"name.package"]),2])
    control.level <- ifelse(!is.na(set.level), set.level, levels$global)
  }else{
    control.level <- levels$global
  }

  if(!is.null(info) & nrow(logfile$package)>0){
    set.log = as.character(logfile$package[as.character(info[1,"name.package"]),3])
    control.logfile <- ifelse(!is.na(set.log), set.log, logfile$global)
  }else{
    control.logfile <- logfile$global
  }

  level.num <- get("level.numeric", envir=LogEasieR.env)

  if(level.num[as.character("WARN")] >= level.num[as.character(control.level)]){

    current.message <-  printMessage (message = current.message, level = "WARN", timestamp = timestamp,
                                      info.message = info, format = layout.format)

    cat(current.message, "\n", file=control.logfile, sep="", append=TRUE)
  }

}
