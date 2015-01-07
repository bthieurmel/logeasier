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

# printing message
#
#
# ~level - Log level
# ~time - Timestamp
# ~father.env - Father Namespace
# ~father.function - Father Calling function name
# ~father.call -
# ~children.env - Children Namespace
# ~children.function - Calling function
# ~children.call
# ~message - print.message

printMessage <- function(message, level, timestamp, info.message, format){
  n.row <- nrow(info.message)
  print.message <- gsub('~level',level, format, fixed=TRUE)
  print.message <- gsub('~time',timestamp, print.message, fixed=TRUE)
  print.message <- gsub('~father.env',ifelse(is.null(info.message),"", as.character(info.message[1,3])), print.message, fixed=TRUE)
  print.message <- gsub('~father.call',ifelse(is.null(info.message),"",as.character(info.message[1,1])), print.message, fixed=TRUE)
  print.message <- gsub('~father.function',ifelse(is.null(info.message),"",as.character(info.message[1,2])), print.message, fixed=TRUE)
  print.message <- gsub('~children.env',ifelse(is.null(info.message),"", as.character(info.message[n.row,3])), print.message, fixed=TRUE)
  print.message <- gsub('~children.call',ifelse(is.null(info.message),"",as.character(info.message[n.row,1])), print.message, fixed=TRUE)
  print.message <- gsub('~children.function',ifelse(is.null(info.message),"",as.character(info.message[n.row,2])), print.message, fixed=TRUE)
  print.message <- gsub('~message', as.character(message), print.message, fixed=TRUE)
  print.message <- gsub("\n*$","",print.message)
  print.message <- gsub("\n"," ",print.message)
  print.message <- gsub("\\[\\]|\\[-*\\]","",print.message)
  return(print.message)

}

