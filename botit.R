# update @mgcv_changelog
library(stringr)
library(rtoot)

# pull change log
cl_txt <- readLines("https://cran.r-project.org/web/packages/mgcv/ChangeLog")
cl <- cl_txt

# read the last changelog that we saved
old <- readLines("ChangeLog")

# remove everything before the first version number
cl <- cl[(which(grepl("^\\d+\\.\\d+-\\d+", cl))[1]):length(cl)]
old <- old[(which(grepl("^\\d+\\.\\d+-\\d+", old))[1]):length(old)]

cl_version <- cl[1]
old_version <- old[1]

if(cl_version == old_version) stop()


cl <- cl[-1]
cl <- cl[1:(which(grepl("^\\d+\\.\\d+-\\d+", cl))[1])]
cl <- cl[-length(cl)]

cl <- paste0(cl, collapse="")

# replace double spaces
cl <- str_replace(cl, "  ", " ")

# split by bullet
cl <- str_split(cl, "\\* ")
cl <- cl[[1]]
cl <- str_replace(cl, "\\*", "")
cl <- cl[-1]


for(ii in seq_along(cl)){
  # build a tweet
  this_tweet <- paste0(cl_version, ": ",
                       paste0(cl[ii], collapse=" "))
  # debug
  #cat(str_trunc(this_tweet, 280), "\n")

#  # post the tweet
#  fuzzy_dog <- system2("/usr/local/bin/twurl",
#                       "-d 'status=",
#                       this_tweet,
#                       "' /1.1/statuses/update.json",
#                       stdout=TRUE)

  post_toot(status = this_tweet)

}

writeLines(cl_txt, con="ChangeLog")



