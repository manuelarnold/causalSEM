## Changelog:
# CG 0.0.2 2022-01-13: changed structure of internal_list
#                      cleaned up code (documentation, 80 char per line)
#                      changed dot-case to snake-case
# MA 0.0.1 2021-11-19: initial programming

## Documentation
#' @title Calculate Asymptotics of the Interventional Mean Vector
#' @description Calculates the asysmptotic covariance matrix,
#' the aysmptotic standard errors, and the approximate z-values 
#' of the of the interventional means for a specific interventional level.
#' @param model internal_list or object of class causalSEM
#' @param x interventional levels
#' @param intervention_names names of interventional variables
#' @param outcome_names names of outcome variables
#' @param verbose verbosity of console outputs
#' @return The asysmptotic covariance matrix, the aysmptotic 
#' standard errors, and the approximate z-values of the the interventional
#' means for a specific interventional level.
#' (see Corollaries, 10, 11 in Gische and Voelkle, 2021).
#' @references Gische, C., Voelkle, M.C. (2021) Beyond the mean: a flexible 
#' framework for studying causal effects using linear models. Psychometrika 
#' (advanced online publication). https://doi.org/10.1007/s11336-021-09811-z

calculate_ase_interventional_means <- function(model, x, intervention_names, 
                                               outcome_names, verbose) {

  # function name
  fun_name <- "calculate_ase_interventional_means"

  # function version
  fun_version <- "0.0.2 2022-01-13"

  # function name+version
  fun_name_version <- paste0(fun_name, " (", fun_version, ")")

  # get verbose argument
  verbose <- model$control$verbose

  # console output
  if (verbose >= 2) {
    cat(paste0("start of function ", fun_name_version, " ", Sys.time(), "\n"))
  }

  # TODO check if user argument model is the internal_list or
  # an object of class causalSEM
  # CURRENTLY, the function assumes that the input model is
  # of type internal_list. After allowing for objects of class causalSEM
  # the pathes starting with internal_list$ might need adjustment


  # get variable names of interventional variables
  # TODO: Rethink setting a default here
  if (is.character(intervention_names) &&
      all(intervention_names %in% model$info_model$var_names)) {
    x_labels <- intervention_names
  } else {
    x_labels <- model$info_interventions$intervention_names
  }

  # get interventional levels
  # TODO: Rethink setting a default here
  if (is.numeric(x) && length (x) == length(intervention_names)) {
    x_values <- x
  } else {
    x_values <- model$info_interventions$intervention_levels
  }
  
  # get variable name of outcome variable
  # TODO: Rethink setting a default here
  if( is.character( outcome_names ) &&
      outcome_names %in% setdiff(model$info_model$var_names, x_labels) 
      ){
    y_labels <- outcome_names
  } else {
    stop( paste0( fun.name.version, ": Argument outcome_names needs to be the a
                  character string with the name of a non-interventional 
                  variable."  ) )
  }

  # get total number of variables
  # get number of unique parameters
  n <- model$info_model$n_ov
  n_unique <- model$info_model$param$n_par_unique

  # get intervential means
  # TODO: assign E by calling the function calculate_interventional_means
  gamma_1 <- model$interventional_distribution$means$values

  # compute jacobian of the pdf
  jac_g1 <- calculate_jacobian_interventional_means(
    model = model,
    x = x_values,
    intervention_names = intervention_names,
    outcome_names = y_labels,
    verbose = verbose
  )

  # get AV of parameter vector
  acov <- model$info_model$param$varcov_par_unique

  # compute asymptotic variance
  acov_gamma_1 <- jac_g1 %*% acov %*% t(jac_g1)

  # compute asymptotic standard errors
  ase_gamma_1 <- sqrt(diag(acov_gamma_1))

  # compute approximate z-value
  z_gamma_1 <- gamma_1 / ase_gamma_1

  # Prepare output ----

  # Console output
  if (verbose >= 2) {
    cat(paste0("  end of function ", fun_name_version, " ", Sys.time(), "\n"))
  }

  # Output
  list(gamma_1 = gamma_1,
       acov_gamma_1 = acov_gamma_1,
       ase_gamma_1 = ase_gamma_1,
       z_gamma_1 = z_gamma_1)

}
