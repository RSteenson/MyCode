#-- Randomly sample n exercises from categories including:
#--   warm-up (warmup == TRUE)
#--   all types (type == NULL)
#--   specific exercise type (type == c(...))
set_exercises <- function(n_ex, warmup=FALSE, cooldown=FALSE, type=NULL){

  if(warmup == TRUE){

    ex_list <- exercises %>%
      filter(Type == "Warm-up") %>%
      sample_n(size = n_ex)

  } else if(cooldown == TRUE){

    ex_list <- exercises %>%
      filter(Type == "Cool-down") %>%
      sample_n(size = n_ex)

  } else {

    # If no exercise type is given i.e FULL
    if(is.null(type)){

      ex_list <- exercises %>%
        filter(Type != "Warm-up") %>%
        sample_n(size = n_ex)

    } else {

      # Is workout type valid?
      for(i in type){

        if(!any(str_detect(exercises$Type, i)))
          stop(paste0(i, " is not a valid workout type."))
      }

      ex_list <- exercises %>%
        filter(Type != "Warm-up") %>%
        filter(str_detect(Type, paste(type, collapse="|")))

    }

  }

  return(ex_list)
}