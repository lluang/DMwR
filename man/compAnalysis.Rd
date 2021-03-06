\name{compAnalysis}
\alias{compAnalysis}

\title{
  Analyse and print the statistical significance of the differences
  between a set of learners. 
}
\description{
  This function analyses and shows the statistical significance results
  of comparing the estimated average evaluation scores of a set of
  learners. When you run the \code{experimentalComparison()} function to
  compare a set of learners over a set of problems you obtain estimates
  of their performances across these problems. This function allows you
  to test whether the observed differences in these estimated
  performances are statistically significant with a certain confidence
  level. 
}
\usage{
compAnalysis(comp, against = dimnames(comp@foldResults)[[3]][1],
             stats = dimnames(comp@foldResults)[[2]],
             datasets = dimnames(comp@foldResults)[[4]], show = T)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{comp}{
    This is a \code{compExp} object (type "class?compExp" for details)
    that contains the results of an experimental comparison obtained
    through the \code{experimentalComparison()} function. 
  }
  \item{against}{
    When you carry out this type of analysis you have to select against which
    learner all others will be compared to. By default this will
    be the first system in the alternatives you have supplied when running
    the experiments. This parameter allows you to specify the identifier
    of any other learner as the one to compare against.
  }
  \item{stats}{
    By default the analysis will be carried out across all evaluation
  statistics estimated in the experimental comparison. This parameter
  allows you to supply a vector with the names of the subset of
  statistics you wish to analyse.
}
  \item{datasets}{
    By default the analysis will be carried out across all problems you
  have used in the experimental comparison. This parameter
  allows you to supply a vector with the names of the subset of
  problems you wish to analyse.
}
\item{show}{
  By default this function shows a table with the results of the
  analysis and will silently return a data structure (see section Value)
  with these results. If you set this parameter to \code{False} the
  function will not show any thing, simply returning that data structure.
}
}
\details{
  Independently of the experimental methodology you select (e.g. cross
  validation) all results you obtain with the
  \code{experimentalComparison()} function are estimates of the
  (unknown) true scores of the learners you are comparing. This function
  allows you to carry out a statistical test to check the statistical
  significance of the observed differences among the learners. Namely,
  the function will carry out a Wilcoxon paired test for checking the
  significance of the differences among the estimated average
  scores. The function will print the results of these tests using a set
  of symbols that correspond to a set of pre-defined confidence levels
  (essencially the standard 95\% and 99\% thresholds). All tests are
  carried out between two learners: the one indicated in the
  \code{against} parameter, which defaults to the first learner in the
  experiments (named Learn.1 on the tables); and all other learners. For each of the competitors the
  function will print a symbol beside its average score representing the result of the comparison
  against the baseline learner. If there is no symbol it means that the difference among
  the two learners can not be considered statistically significant with
  95\% confidence. If there is one symbol (either a "+" or a "-") it
  means the statistical confidence on the difference is between 95\% and
  99\%. A "+" means
  the competitor has a larger estimated value (this can be good or bad
  depending on the statistic being estimated) than the baseline, whilst
  a "-" means the opposite. Finally, two symbols (either "++" or "--")
  mean that the difference is significant with more than 99\% confidence.
}
\value{
  Usually this function is used to print the tables with the results of
  the statistical significance tests. However, the function also returns
  silently the information on these tables, so that you may further
  proccess it if you want. This means that if you assign the results of
  the function to some variable, you will get as a result a list with as
  many components as there are evaluation statistics in your
  experiment. For each of these list components, you will get a data
  frame with the results of the comparison following the same schema as
  the printed version.
}
\references{ Torgo, L. (2010) \emph{Data Mining using R: learning with case studies},
  CRC Press (ISBN: 9781439810187).

  \url{http://www.dcc.fc.up.pt/~ltorgo/DataMiningWithR}  
}
\author{ Luis Torgo \email{ltorgo@dcc.fc.up.pt} }

\seealso{
\code{\link{experimentalComparison}},\code{\linkS4class{compExp}}
}
\examples{
## Estimating several evaluation metrics on different variants of a
## regression tree on  a data set, using one repetition of 10-fold CV
data(swiss)

## First the user defined functions 
cv.rpartXse <- function(form, train, test, ...) {
    require(DMwR)
    t <- rpartXse(form, train, ...)
    p <- predict(t, test)
    mse <- mean((p - resp(form, test))^2)
    c(nmse = mse/mean((mean(resp(form, train)) - resp(form, test))^2), 
        mse = mse)
}

results <- experimentalComparison(
               c(dataset(Infant.Mortality ~ ., swiss)),
               c(variants('cv.rpartXse',se=c(0,0.5,1))),
               cvSettings(1,10,1234)
                                 )

## Testing the statistical significance of the differences
compAnalysis(results)

## Comparing against the learner with best NMSE, and only on that statistic
compAnalysis(results,against=bestScores(results)$swiss['nmse','system'],
             stats='nmse')
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ models }

