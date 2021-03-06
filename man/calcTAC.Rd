% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calcTAC.R
\name{calcTAC}
\alias{calcTAC}
\title{Calculate total allowable catch}
\usage{
calcTAC(rec, canER, harvContRule, amER, ppnMixVec, species = NULL,
  manAdjustment = NULL, lowFRP = NULL, highFRP = NULL,
  minER = NULL, maxER = NULL, overlapConstraint = NULL,
  constrainMix = TRUE)
}
\arguments{
\item{rec}{A numeric representing MU-specific return abundance.}

\item{canER}{A numeric representing the target Canadian exploitation rate if
\code{harvContRule = fixedER}}

\item{harvContRule}{A character signifying whether TACs are based on a fixed
exploitation rate (\code{fixedER}) or the simplified TAM rule (\code{TAM}).}

\item{amER}{A numeric representing the target American exploitation rate.
**Note** that American catch is a function of TAC not escapement for Fraser
sockeye and takes into account the Aboriginal Fishery Exclusion (400k fish).
Thus their catch/harvest rate is generally below the input parameter.}

\item{species}{A character that can currently take either \code{chum} or
\code{sockeye} values. Determines how American TAC is partitioned relative
to Canadian.}

\item{manAdjustment}{A numeric  representing MU-specific management
adjustments. These values are used to adjust forecasted spawner abundance
to account for en route mortality (i.e. they increase the target escapement
goal).}

\item{lowFRP}{A numeric representing a MU-specific lower fishery reference
point.}

\item{highFRP}{A numeric vector a MU-specific upper fishery reference point.}

\item{minER}{A numeric representing minimum exploitation rate (intended to
represent mortality due to bycatch or test fisheries).}

\item{maxER}{A numeric representing maximum exploitation rate that is
applied when MU is above its higher FRP.}

\item{overlapConstraint}{A numeric representing whether a given MU's TAC
should be constrained or not.}

\item{ppnMix}{A numeric representing the proportion of the Canadian TAC
allocated to mixed stock fisheries.}
}
\value{
Returns a six element list of numeric vectors with length equal to
forecast: American TAC, single fishery TAC, mixed fishery TAC, total TAC,
unconstrained American TAC, and unconstrained Canadian TAC (latter two for
reference purposes only).
}
\description{
This function calculates total allowable catch (TAC) for different MUs using
either a) a fixed exploitation rate or b) a simplified version of the total
allowable mortality rule currently used to manage the fishery. Total
allowable catch is divided between one American and two Canadian fisheries
(mixed stock and single stock) based on \code{ppnMix} variable.
}
\details{
All values should be passed as single values using apply family or for loops
because if statements are common.

In the case of the TAM rule TAC is based on  abundance relative to two
fishery reference points. This determines whether exploitation is based
on a minimum exploitation rate, fixed escapement goal, or maximum
exploitation rate. Note that abundance relative to reference points is
adjusted downwards to account for anticipated en route mortality
(\code{manAdjustment}). TAC will be further reduced based on
\code{overlapConstraint} which represents whether other MUs that co-migrate
are at sufficiently low abundance to limit a given fishery (see
\code{overlapConstraint} for additional details).
}
\examples{
#Note that the function is intended to receive vectors rather than the DF
#used in this example to increase efficiency within the full closed-loop
simulation.
head(exampleHCRList)
names(exampleHCRList)[4] <- "recRYMU"

rec <- exampleHCRList$recRYMU
lowFRP <- exampleHCRList$lowFRP
highFRP <- exampleHCRList$highFRP
manAdjustment <- exampleHCRList$adjustment
manUnit <- exampleHCRList$mu
overlapConstraint <- constrain(rec, highFRP, manAdjustment,
                               manUnit)$muConstrained

## Fixed ER version
calcTAC(rec, canER = 0.4, harvContRule = "fixedER", amER = 0.1, ppnMix = 1,
        species = "sockeye")
## TAM version
calcTAC(rec, canER, harvContRule = "TAM", amER = 0.1, ppnMix = 1,
        species = "sockeye", manAdjustment = manAdjustment, lowFRP = lowFRP,
        highFRP = highFRP,  minER = 0.1, maxER = 0.6,
        overlapConstraint = overlapConstraint)

}
