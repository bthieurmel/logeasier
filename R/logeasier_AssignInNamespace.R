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

# to overwrite temporarely base function message
logeasierAssignInNamespace <- function (x, value, ns, pos = -1, envir = as.environment(pos))
{
    nf <- sys.nframe()
    if (missing(ns)) {
        nm <- attr(envir, "name", exact = TRUE)
        if (is.null(nm) || substring(nm, 1L, 8L) != "package:")
            stop("environment specified is not a package")
        ns <- asNamespace(substring(nm, 9L))
    }
    else ns <- asNamespace(ns)

    if (bindingIsLocked(x, ns)) {
        in_load <- Sys.getenv("_R_NS_LOAD_")
        if (nzchar(in_load)) {
            ns_name <- getNamespaceName(ns)
            if (in_load != ns_name) {
                msg <- gettextf("changing locked binding for %s in %s whilst loading %s",
                  sQuote(x), sQuote(ns_name), sQuote(in_load))
                #if (!in_load %in% c("Matrix", "SparseM"))
                  #warning(msg, call. = FALSE, domain = NA, immediate. = TRUE)
            }
        }
        else if (nzchar(Sys.getenv("_R_WARN_ON_LOCKED_BINDINGS_"))) {
            ns_name <- getNamespaceName(ns)
            warning(gettextf("changing locked binding for %s in %s",
                sQuote(x), sQuote(ns_name)), call. = FALSE, domain = NA,
                immediate. = TRUE)
        }
        unlockBinding(x, ns)
        assign(x, value, envir = ns, inherits = FALSE)
        w <- options("warn")
        on.exit(options(w))
        options(warn = -1)
        lockBinding(x, ns)
    }
    else {
        assign(x, value, envir = ns, inherits = FALSE)
    }
    if (!isBaseNamespace(ns)) {
        S3 <- getNamespaceInfo(ns, "S3methods")
        if (!length(S3))
            return(invisible(NULL))
        S3names <- S3[, 3L]
        if (x %in% S3names) {
            i <- match(x, S3names)
            genfun <- get(S3[i, 1L], mode = "function", envir = parent.frame())
            if (.isMethodsDispatchOn() && methods::is(genfun,
                "genericFunction"))
                genfun <- methods::slot(genfun, "default")@methods$ANY
            defenv <- if (typeof(genfun) == "closure")
                environment(genfun)
            else .BaseNamespaceEnv
            S3Table <- get(".__S3MethodsTable__.", envir = defenv)
            remappedName <- paste(S3[i, 1L], S3[i, 2L], sep = ".")
            if (exists(remappedName, envir = S3Table, inherits = FALSE))
                assign(remappedName, value, S3Table)
        }
    }
    invisible(NULL)
}
