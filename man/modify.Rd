% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/modify.R
\name{modify}
\alias{modify}
\alias{modify_if}
\alias{modify_at}
\alias{modify_depth}
\alias{map_if}
\alias{map_at}
\alias{at_depth}
\title{Modify elements "in-place"}
\usage{
modify(.x, .f, ...)

modify_if(.x, .p, .f, ...)

modify_at(.x, .at, .f, ...)

modify_depth(.x, .depth, .f, ...)
}
\arguments{
\item{.x}{A list or atomic vector.}

\item{.f}{A function, formula, or atomic vector.

If a \strong{function}, it is used as is.

If a \strong{formula}, e.g. \code{~ .x + 2}, it is converted to a
function with one or two arguments, \code{.x} or \code{.}, and \code{.y}. This
allows you to create very compact anonymous functions with up to
two inputs.

If \strong{character vector}, \strong{numeric vector}, or \strong{list}, it
is converted to an extractor function. Character vectors index by name
and numeric vectors index by position; use a list to index by position
and name at different levels. Within a list, wrap strings in \code{get_attr()}
to extract named attributes If a component is not present, the value of
\code{.null} will be returned.}

\item{...}{Additional arguments passed on to \code{.f}.}

\item{.p}{A single predicate function, a formula describing such a
predicate function, or a logical vector of the same length as \code{.x}.
Alternatively, if the elements of \code{.x} are themselves lists of
objects, a string indicating the name of a logical element in the
inner lists. Only those elements where \code{.p} evaluates to
\code{TRUE} will be modified.}

\item{.at}{A character vector of names or a numeric vector of
positions. Only those elements corresponding to \code{.at} will be
modified.}

\item{.depth}{Level of \code{.x} to map on.
\itemize{
\item \code{modify_depth(x, 0, fun)} is equivalent to \code{fun(x)}
\item \code{modify_depth(x, 1, fun)} is equivalent to \code{map(x, fun)}
\item \code{modify_depth(x, 2, fun)} is equivalent to \code{map(x, ~ map(., fun))}
}}
}
\value{
An object the same class as \code{.x}
}
\description{
\code{modify()} is a short-cut for \code{x[] <- map(x, .f)}. \code{modify_if()} only modifies
the elements of \code{.x} that satisfy a predicate. \code{map_at()} only modifies
elements given by names or positions. \code{modify_depth()} only modifies
elements at a given level of a nested data structure.
}
\details{
These modify the input data structure; it's your responsibility to ensure
that the transformation produces a valid output. For example, if you're
modifying a data frame, \code{.f} must preserve the length of the input.
}
\examples{
# Convert factors to characters
iris \%>\%
  map_if(is.factor, as.character) \%>\%
  str()

# Specify which columns to map with a numeric vector of positions:
mtcars \%>\% map_at(c(1, 4, 5), as.character) \%>\% str()

# Or with a vector of names:
mtcars \%>\% map_at(c("cyl", "am"), as.character) \%>\% str()

list(x = rbernoulli(100), y = 1:100) \%>\%
  transpose() \%>\%
  map_if("x", ~ update_list(., y = ~ y * 100)) \%>\%
  transpose() \%>\%
  simplify_all()

# Modify at specified depth ---------------------------
l1 <- list(
  obj1 = list(
    prop1 = list(param1 = 1:2, param2 = 3:4),
    prop2 = list(param1 = 5:6, param2 = 7:8)
  ),
  obj2 = list(
    prop1 = list(param1 = 9:10, param2 = 11:12),
    prop2 = list(param1 = 12:14, param2 = 15:17)
  )
)

# In the above list, "obj" is level 1, "prop" is level 2 and "param"
# is level 3. To apply sum() on all params, we map it at depth 3:
l1 \%>\% modify_depth(3, sum) \%>\% str()

# modify() lets us pluck the elements prop1/param2 in obj1 and obj2:
l1 \%>\% modify(c("prop1", "param2")) \%>\% str()

# But what if we want to pluck all param2 elements? Then we need to
# act at a lower level:
l1 \%>\% modify_depth(2, "param2") \%>\% str()

# modify_depth() can be with other purrr functions to make them operate at
# a lower level. Here we ask pmap() to map paste() simultaneously over all
# elements of the objects at the second level. paste() is effectively
# mapped at level 3.
l1 \%>\% modify_depth(2, ~ pmap(., paste, sep = " / ")) \%>\% str()
}
\seealso{
Other map variants: \code{\link{imap}},
  \code{\link{invoke}}, \code{\link{lmap}},
  \code{\link{map2}}, \code{\link{map}}
}
