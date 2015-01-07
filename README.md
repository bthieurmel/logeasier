logeasier : Easy logging in R, configurable by package
=========

logeasier is a very simple package to configure logs in R. No needed to change current code of functions / packages,
logeasier use a redirection of error using options(error), warning using options(warning.expression), 
and message overwriting temporarely base function message().
Moreover, you can configure log level and file by packages if needed.

Functionalities
-------------

  * Set global log levels (INFO, WARN, STOP, or NONE)
  * Set global log file
  * If needed, set packages levels and logfile

Installation
------------

```coffee
require(devtools)
install_github('bthieurmel/logeasier')
```

Use
------------

```coffee
require(logeasier)
?logeasier

```
