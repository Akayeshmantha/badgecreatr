### scenarios

#' Add a minimum of badges to your project
#' 
#' Returns markdown to manually place in your readme.Rmd file.
#' This is a function you might want to use in the early stages of your project.
#' This function returns badges link{projectstatusbadge}, link(licensebadge), 
#' and link(last_change_badge_static).
#' @family scenarios
#' @param status one of concept, wip, suspended, abandoned, active, inactive or unsupported
#' @param license one of GPL-3, GPL-2, MIT, or CC0.
#' @param date a date of your choosing, defaults to current date.
#' @return text to put into rmd
#' @export
#' @examples 
#' minimal_badges("abandoned", "GPL-3")
minimal_badges <- function(status = "concept",license = NULL, date = NULL ){
    paste0(
        badge_projectstatus(status = status),
        badge_license(license = license),
        badge_last_change_static(date = date)
    )
}

#' Add dynamic content to readme
#' 
#' This function returns markdown that you must place in the readme. This is
#' dynamic content. This function returns a RMarkdown piece that does some
#' calculation and a set of badges are placed underneath the code part.
#' @family scenarios
#' @param status one of concept, wip, suspended, abandoned, active, inactive or unsupported
#' @param license one of GPL-3, GPL-2, MIT, or CC0.
#' @param last_change adding a last change badge? TRUE or FALSE
#' @param minimal_r_version adding minimal r version badge? TRUE or FALSE
#' @param travisfile add a travis statusbadge
#' @param codecov add a codecov badge
#' @param location defaults to current location
#' @return text to put into rmd file
#' @export
#' @examples
#' \dontrun{
#' dynamic_badges_minimal(status = "active",last_change = FALSE,minimal_r_version = FALSE) 
#' }
dynamic_badges_minimal <- function(status = "concept",license = NULL,
                                   last_change = TRUE, minimal_r_version = TRUE,
                                   travisfile= NULL, codecov = NULL, location = "."){
    # apply some logic to search for travis and codecov
    if(any(is.null(travisfile), is.null(codecov))){
        badges <- findbadges(location = location)
        travisfile <- badges$travisfile
        codecov <- badges$codecov_in_travisfile
    }
    

    paste0(
        "```{r, echo = FALSE}", 
        eval(expression("description <- read.dcf('DESCRIPTION')")), 
        eval(expression("version <- as.vector(description[, 'Version'])")),
        badge_projectstatus(status = status),
        badge_license(license = license),
        if(last_change){badge_last_change()} ,
        if(minimal_r_version){badge_minimal_r_version(FALSE)},
        badge_packageversion(FALSE),
        if(travisfile){
            badge_travis(location = location)
        },
        if(codecov){
            badge_codecov(location = location)
        }
        )
    
}


