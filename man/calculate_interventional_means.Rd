% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_interventional_means.R
\name{calculate_interventional_means}
\alias{calculate_interventional_means}
\title{Calculate Mean Vector of the Interventional Distribution}
\usage{
calculate_interventional_means(C, x, SI, n, IN, verbose)
}
\arguments{
\item{C}{C matrix}

\item{x}{interventional level}

\item{SI}{selection matrix 1_I}

\item{n}{number of observed variables}

\item{IN}{I_N matrix}

\item{verbose}{A single number, integer. 0...no output (default),
1...user messages, 2...debugging-relevant messages.}

\item{Psi}{Psi matrix}
}
\value{
The Mean Vector of the Interventional Distribution.
}
\description{
Calculate Mean Vector of the Interventional Distribution.
}
\references{
Gische, C., Voelkle, M.C. (2021) Beyond the mean: a flexible
framework for studying causal effects using linear models. Psychometrika
(advanced online publication). https://doi.org/10.1007/s11336-021-09811-z
}
