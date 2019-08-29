library(twitteR)
library(ggmap)  
library(rtweet)
library(maps)
library(tidyr)
library(maptools)
library(usmap)
library(ggplot2)
library(revgeo)
library(reshape2)

api_key = "7nOjD4MCGqdpwvfgdGNs65m22"
api_secret = "wpEO61KmNh3ddYfhULFsd2cdT8sFjYN6zlyQasCCqIzUIXl4OK"
access_token = "464870798-75FP4gx8AO6Bil2Gk31Ds1x79BUlVFJVc6FQq0OO"
access_secret = "vQXhHdINSjYEALuItjDuiDGuBkCWy7z6zSmzgUGlzDSKL"

setup_twitter_oauth(api_key,api_secret,access_token,access_secret)
register_google(key = 'AIzaSyAgscf5AcofyitLbOTaceMOvG1znRTnKRM')

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

tag1 = " flu "
tag2 = "influenza"
tag3 = "avian flu OR bird flu"
tag4 = "swine flu OR H1N1"
tag5 = "canine flu OR Dog flu"


tweet1=search_tweets(q=tag1,
                     n=200,geocode=lookup_coords("usa"),include_rts=FALSE)

tweet2=search_tweets(q=tag2,
                     n=300,geocode=lookup_coords("usa"),include_rts=FALSE)

tweet3=search_tweets(q=tag3,
                     n=300,geocode=lookup_coords("usa"),include_rts=FALSE)

tweet4=search_tweets(q=tag4,
                     n=300,geocode=lookup_coords("usa"),include_rts=FALSE)

tweet5=search_tweets(q=tag5,
                     n=300,geocode=lookup_coords("usa"),include_rts=FALSE)

nrow(tweet1)
nrow(tweet2)
nrow(tweet3)
nrow(tweet4)
nrow(tweet5)



#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


process <- function(tweets,tag) {
  
  userData <- lookupUsers(tweets$screen_name)
  
  geo_Code=geocode(tweets$location, output = c("latlon"),
                   source = c("google", "dsk"), override_limit = FALSE,
                   nameType = c("long", "short"), data)
  #nrow(geo_Code)
  #name=paste("Geoloc",tag,".csv",sep="")
  #write.csv(geo_Code, file=name)
  #geo_Code <- read.csv(name)
  
  
  tweets$lon=geo_Code$lon
  tweets$lat=geo_Code$lat
  
  completeRows=complete.cases(tweets[,"lon"])
  tweets=tweets[completeRows,]
  
  #name=paste("Tweets",tag,".csv",sep="")
  #save_as_csv(tweets,file_name=name)
  #tweets <- read.csv(name)

  rm(completeRows,geo_Code,userData,name)
  
  tweets_states=revgeo(longitude = tweets$lon, latitude = tweets$lat,
                       provider = "google", API ="AIzaSyAgscf5AcofyitLbOTaceMOvG1znRTnKRM", output = "frame",item = "state" )
  #name=paste("States",tag,".csv",sep="")
  #write.table( tweets_states, file=name, sep=',',col.names=NA)
  
  #tweets_states<-read.csv(name)
  
  return(tweets_states)
}

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


fluStates=process(tweet1,"_flu")
influStates=process(tweet2,"_influ")
avianFluStates=process(tweet3,"_avian")
swineFluStates=process(tweet4,"_swine")
canineFluStates=process(tweet5,"_canine")


#fluStates
#influStates
#avianFluStates
#swineFluStates
#canineFluStates

#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

plottingMap <- function(x,tag) {

  n <- x$state
  state <- table(n)

  statedata <- as.data.frame(state)

  dataf <- data.frame(fips = fips(statedata$n), Level = as.numeric(statedata$Freq))

  completeRows=complete.cases(dataf[,"fips"])
  dataf=dataf[completeRows,]
  
  dataf
  
  name=paste("USmap",tag)
  jpeg(name)
  par(bg = "grey")
  plot_usmap(data = dataf, values = "Level", labels = TRUE, lines="black", label_color = "black") + scale_fill_continuous(
  low = "green", high = "red", name = "Severity Level", label = scales::comma
  ) + theme(legend.position = "right")

  dev.off()
}

plottingMap(fluStates,"_flu")
plottingMap(influStates,"_influ")
plottingMap(avianFluStates,"_avian")
plottingMap(swineFluStates,"_swine")
plottingMap(canineFluStates,"_canine")

