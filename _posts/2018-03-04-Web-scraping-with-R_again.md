---
layout: post
title: "Web scraping with R, Again"
date: 2018-04-04
description: ""
category: 
tags: [R, Scraping]
---
{% include JB/setup %}

The last time I wrote this my functions were only semi-coherent, looking at them no it seems I had modified them to look at sold listings and left them mostly broken. Hopefully I straighten out a few things here. These functions will fail with changes to the DOM, but they might work for a few weeks.


```r
library(rvest)
```

```
## Loading required package: xml2
```

```r
url <- 'https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/'

# I manually checked the source html to find the correct node to read
more.urls <- read_html(url) %>%
  html_nodes(".zsg-pagination a") %>%
  html_attr("href") 
more.urls <- na.omit(unique(more.urls))
# See how high the pagination goes
more.urls <- strsplit(more.urls, '/')
more.urls <- lapply(more.urls, function(x) x[length(x)])
more.urls <- as.numeric(gsub('[_p]','', more.urls))
more.urls <- max(more.urls)
# Now paste together a url for each page
urls <- c(url, paste0(url,2:more.urls,'_p/'))

urls
```

```
##  [1] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/"     
##  [2] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/2_p/" 
##  [3] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/3_p/" 
##  [4] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/4_p/" 
##  [5] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/5_p/" 
##  [6] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/6_p/" 
##  [7] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/7_p/" 
##  [8] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/8_p/" 
##  [9] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/9_p/" 
## [10] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/10_p/"
## [11] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/11_p/"
## [12] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/12_p/"
## [13] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/13_p/"
## [14] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/14_p/"
## [15] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/15_p/"
## [16] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/16_p/"
## [17] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/17_p/"
## [18] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/18_p/"
## [19] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/19_p/"
## [20] "https://www.zillow.com/homes/for_sale/VT/58_rid/globalrelevanceex_sort/45.60443,-69.598389,42.112486,-75.305787_rect/7_zm/20_p/"
```

Next I use a line from the demo script to scrape each of these URLs. Since I've now got 20 urls I go ahead and define a quick function to do the scraping. The function is really just an `lapply` loop. The page caps the display at 500 listings; there are more there, the solution may be to run this repeatedly for more local geographies.


```r
# The scraper function
getZillow <- function(urls) {
    # return a list of html <article></article> tags, one for each URL
    lapply(urls, function(u) {
        # call out the at-bat url in case there is an error
        cat(u, '\n')
        houses <- read_html(u) %>%
          html_nodes("article")
        houses
    })
}
```

To use this function I just need to give it the urls I made earlier:


```r
zdata2 <- getZillow(urls)
```

I still need to parse the returned pointers. I read it by coercing it to a character vector, copying it off the console into my text editor.


```r
# not run
as.character(zdata2[[1]][1])
```


Here are the parsing functions. They include an argument to debug the script as it runs--this just means if you set `debugFun=cat` it will call out each node as it runs, and when it fails you can tease apart the node that caused the crash and get everything working again.  



```r
# The workhorse
parsePhotoCard <- function(houses, debugFun) {
    z_id <- houses %>% html_attr("id")

    debugFun('    address\n')
    address <- houses %>%
        html_node("div") %>%
        html_node("span") 
        
    address <- lapply(address, function(x) {
        x %>%
        html_nodes("span") %>%
        html_text(trim=TRUE)
    })
    
    address <- lapply(address, function(x) {
        tab <- data.frame(t(x))
        names(tab) <- c('Address', 'Town', 'State', 'Zip')
        tab
    })
    
    address <- do.call(rbind.data.frame, address)
    
    debugFun('    geo\n')  
    lat <- houses %>% html_attr("data-latitude")
    lon <- houses %>% html_attr("data-longitude")

    geo <- data.frame(lat=as.numeric(lat)*10e-7, long=as.numeric(lon)*10e-7)

    debugFun('    price\n')  
    price <- houses %>%
        html_node("div") %>%
        html_node("p") 
    
    price2 <- lapply(price, function(x) {
        x %>%
        html_nodes("span") %>% 
        html_text(trim=TRUE)
    })
    
    price3 <- lapply(price2, function(x) {
        det <- strsplit(x[2], split=x[3])[[1]]
        det[1:2] <- gsub('[^0-9\\.]', '', det[1:2])
        tab <- data.frame(t(c(x[1], det)))
        if(length(tab) < 4) tab <- data.frame(tab[1], NA, NA, tab[2])
        names(tab) <- c('Price', 'Beds', 'Baths', 'Area')
        tab
    })
    
    price <- do.call(rbind.data.frame, price3)
    
    data.frame(z_id=z_id, address=address, geo, price)
}

# The parsing controller
parseZillow <- function(zhouse.l, debugFun=function(...) NULL) {
    len.h <-1:length(zhouse.l)
    lapply(1:length(zhouse.l), function(x) {
        debugFun(x, '\n')
        houses <- zhouse.l[[x]]
        parsePhotoCard(houses, debugFun)
    })
}


# Here's how I put it all together
zdata3 <- parseZillow(zdata2)
zdata4 <- do.call(rbind.data.frame, zdata3)
write.csv(zdata4, 'RS_2018Apr04.csv', row.names=FALSE)
```


```r
head(zdata4)
```

```
##              z_id            address.Address address.Town address.State
## 1 zpid_2090412856          7609 Us Route 2 S      Alburgh            VT
## 2  zpid_122659278         513 French Hill Rd SAINT ALBANS            VT
## 3   zpid_92291445 1172 E Lakeshore Dr UNIT 5   COLCHESTER            VT
## 4   zpid_75446905                49 Hunt Cir      CORINTH            VT
## 5 zpid_2091083922         756 E Lakeshore Dr   Colchester            VT
## 6   zpid_53713743               54 Sutton Pl    Charlotte            VT
##   address.Zip      lat      long    Price Beds Baths        Area
## 1        5440 44.93520 -73.27310 $355,000    2     2  2,031 sqft
## 2        5478 44.81656 -73.02043 $214,900    2     2  1,536 sqft
## 3        5446 44.55166 -73.19442 $429,000    2     2  2,370 sqft
## 4        5039 44.05955 -72.24694 $142,500    3     1  1,144 sqft
## 5        5446 44.54777 -73.20166 $495,000    2     3  2,500 sqft
## 6        5445 44.32498 -73.23060 $258,100    3     2  1,732 sqft
```

There is also an embedded json to pass data to the map that can be parsed. This has more fields, but somehow less data overall.


```r
library(jsonlite)

# my version of plyr::rbind.fill
rbf <- function(x, y) {
    xn <- names(x)
    yn <- names(y)
    missx <- xn[!xn %in% yn]
    missy <- yn[!yn %in% xn]
    if(length(missy)) x[missy] <- NA
    if(length(missx)) y[missx] <- NA
    rbind(x, y)     
}

minibubble <- function(houses) {
    jsondat <- houses %>% 
        html_node(".minibubble", ) %>%
        html_node(xpath = 'comment()')
    # Pull the json out of the HTML comment
    jsondat2 <- gsub('<!--', '', jsondat)  
    jsondat2 <- gsub('-->', '', jsondat2)
    # fix an escaped character that breaks the json
    jsondat2 <- gsub('\\\\-', '-', jsondat2)  
    jsondat3 <- lapply(jsondat2, function(x) data.frame(t(unlist(jsonlite::fromJSON(x)))))  
    
    jd3 <- jsondat3[[1]]
    for(i in 2:length(jsondat3)) jd3 <- rbf(jd3, jsondat3[[i]])  
    jd3
}

# The parsing controller
parseMinibubble <- function(zhouse.l, debugFun=function(...) NULL) {
    len.h <-1:length(zhouse.l)
    lapply(1:length(zhouse.l), function(x) {
        debugFun(x, '\n')
        houses <- zhouse.l[[x]]
        minibubble(houses)
    })
}

# put it all together
zdata5 <- parseMinibubble(zdata2)
mb <- zdata5[[1]]
for(i in 2:length(zdata5)) mb <- rbf(mb, zdata5[[i]])
write.csv(mb, 'mb_2018Apr04.csv', row.names=FALSE)
```


```r
head(mb)
```

```
##   bed miniBubbleType
## 1   2              1
## 2   2              1
## 3   2              1
## 4   3              1
## 5   2              1
## 6   3              1
##                                                                      image
## 1 https:\\/\\/photos.zillowstatic.com\\/p_a\\/ISifz8wi7w0jok1000000000.jpg
## 2 https:\\/\\/photos.zillowstatic.com\\/p_a\\/IS23v8mq7d2t0l1000000000.jpg
## 3 https:\\/\\/photos.zillowstatic.com\\/p_a\\/ISax325ipbpqz20000000000.jpg
## 4 https:\\/\\/photos.zillowstatic.com\\/p_a\\/ISm6fmzhmf1chs1000000000.jpg
## 5 https:\\/\\/photos.zillowstatic.com\\/p_a\\/ISmm7baalud0rm1000000000.jpg
## 6 https:\\/\\/photos.zillowstatic.com\\/p_a\\/ISaxntbpz11kzv1000000000.jpg
##   sqft label isPropertyTypeVacantLand datasize title bath homeInfo.zpid
## 1 2031 $355K                    FALSE        9 $355K    2    2090412856
## 2 1536 $215K                    FALSE        9 $215K    2            NA
## 3 2370 $429K                    FALSE        9 $429K    2            NA
## 4 1144 $142K                    FALSE        9 $142K    1            NA
## 5 2500 $495K                    FALSE        8 $495K    3            NA
## 6 1732 $258K                    FALSE        8 $258K    2            NA
##   homeInfo.streetAddress homeInfo.zipcode homeInfo.city homeInfo.state
## 1      7609 Us Route 2 S             5440       Alburgh             VT
## 2                   <NA>               NA          <NA>           <NA>
## 3                   <NA>               NA          <NA>           <NA>
## 4                   <NA>               NA          <NA>           <NA>
## 5                   <NA>               NA          <NA>           <NA>
## 6                   <NA>               NA          <NA>           <NA>
##   homeInfo.latitude homeInfo.longitude homeInfo.price homeInfo.dateSold
## 1           44.9352           -73.2731         355000                 0
## 2                NA                 NA             NA                NA
## 3                NA                 NA             NA                NA
## 4                NA                 NA             NA                NA
## 5                NA                 NA             NA                NA
## 6                NA                 NA             NA                NA
##   homeInfo.bathrooms homeInfo.bedrooms homeInfo.livingArea
## 1                  2                 2                2031
## 2                 NA                NA                  NA
## 3                 NA                NA                  NA
## 4                 NA                NA                  NA
## 5                 NA                NA                  NA
## 6                 NA                NA                  NA
##   homeInfo.yearBuilt homeInfo.lotSize homeInfo.homeType
## 1               1900            18730     SINGLE_FAMILY
## 2                 NA               NA              <NA>
## 3                 NA               NA              <NA>
## 4                 NA               NA              <NA>
## 5                 NA               NA              <NA>
## 6                 NA               NA              <NA>
##   homeInfo.homeStatus homeInfo.photoCount
## 1            FOR_SALE                  47
## 2                <NA>                  NA
## 3                <NA>                  NA
## 4                <NA>                  NA
## 5                <NA>                  NA
## 6                <NA>                  NA
##                                                 homeInfo.imageLink
## 1 https://photos.zillowstatic.com/p_g/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##   homeInfo.daysOnZillow homeInfo.isFeatured homeInfo.shouldHighlight
## 1                     6                TRUE                    FALSE
## 2                    NA                  NA                       NA
## 3                    NA                  NA                       NA
## 4                    NA                  NA                       NA
## 5                    NA                  NA                       NA
## 6                    NA                  NA                       NA
##   homeInfo.brokerId homeInfo.contactPhone homeInfo.zestimate
## 1              2877            8023725777             257291
## 2                NA                    NA                 NA
## 3                NA                    NA                 NA
## 4                NA                    NA                 NA
## 5                NA                    NA                 NA
## 6                NA                    NA                 NA
##   homeInfo.listing_sub_type.is_newHome homeInfo.priceReduction
## 1                                 TRUE                        
## 2                                   NA                    <NA>
## 3                                   NA                    <NA>
## 4                                   NA                    <NA>
## 5                                   NA                    <NA>
## 6                                   NA                    <NA>
##   homeInfo.isUnmappable homeInfo.rentalPetsFlags
## 1                 FALSE                       64
## 2                    NA                       NA
## 3                    NA                       NA
## 4                    NA                       NA
## 5                    NA                       NA
## 6                    NA                       NA
##                                           homeInfo.mediumImageLink
## 1 https://photos.zillowstatic.com/p_c/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##   homeInfo.isPreforeclosureAuction homeInfo.homeStatusForHDP
## 1                            FALSE                  FOR_SALE
## 2                               NA                      <NA>
## 3                               NA                      <NA>
## 4                               NA                      <NA>
## 5                               NA                      <NA>
## 6                               NA                      <NA>
##   homeInfo.priceForHDP homeInfo.festimate
## 1               355000             208835
## 2                   NA                 NA
## 3                   NA                 NA
## 4                   NA                 NA
## 5                   NA                 NA
## 6                   NA                 NA
##   homeInfo.isListingOwnedByCurrentSignedInAgent homeInfo.timeOnZillow
## 1                                         FALSE          1.522272e+12
## 2                                            NA                    NA
## 3                                            NA                    NA
## 4                                            NA                    NA
## 5                                            NA                    NA
## 6                                            NA                    NA
##   homeInfo.isListingClaimedByCurrentSignedInUser
## 1                                          FALSE
## 2                                             NA
## 3                                             NA
## 4                                             NA
## 5                                             NA
## 6                                             NA
##                                            homeInfo.hiResImageLink
## 1 https://photos.zillowstatic.com/p_f/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##                                            homeInfo.watchImageLink
## 1 https://photos.zillowstatic.com/p_j/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##   homeInfo.contactPhoneExtension
## 1                             NA
## 2                             NA
## 3                             NA
## 4                             NA
## 5                             NA
## 6                             NA
##                                               homeInfo.tvImageLink
## 1 https://photos.zillowstatic.com/p_m/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##                                     homeInfo.tvCollectionImageLink
## 1 https://photos.zillowstatic.com/p_l/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##                                        homeInfo.tvHighResImageLink
## 1 https://photos.zillowstatic.com/p_n/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##   homeInfo.videoCount homeInfo.zillowHasRightsToImages
## 1                   1                            FALSE
## 2                  NA                               NA
## 3                  NA                               NA
## 4                  NA                               NA
## 5                  NA                               NA
## 6                  NA                               NA
##   homeInfo.newConstructionType
## 1                 BUILDER_SPEC
## 2                         <NA>
## 3                         <NA>
## 4                         <NA>
## 5                         <NA>
## 6                         <NA>
##                                    homeInfo.desktopWebHdpImageLink
## 1 https://photos.zillowstatic.com/p_h/ISifz8wi7w0jok1000000000.jpg
## 2                                                             <NA>
## 3                                                             <NA>
## 4                                                             <NA>
## 5                                                             <NA>
## 6                                                             <NA>
##   homeInfo.hideZestimate homeInfo.isPremierBuilder flexData1     flexData2
## 1                   TRUE                     FALSE        NA          <NA>
## 2                     NA                        NA         1   Sun. 12-2pm
## 3                     NA                        NA         1 Sat. 11am-2pm
## 4                     NA                        NA         3       $17,500
## 5                     NA                        NA        NA          <NA>
## 6                     NA                        NA        NA          <NA>
##   flexData3 homeInfo.rentZestimate homeInfo.isNonOwnerOccupied
## 1      <NA>                     NA                          NA
## 2      <NA>                     NA                          NA
## 3      <NA>                     NA                          NA
## 4   (Mar 9)                     NA                          NA
## 5      <NA>                     NA                          NA
## 6      <NA>                     NA                          NA
##   homeInfo.lotId homeInfo.lotId64  lot
## 1             NA               NA <NA>
## 2             NA               NA <NA>
## 3             NA               NA <NA>
## 4             NA               NA <NA>
## 5             NA               NA <NA>
## 6             NA               NA <NA>
##   homeInfo.listing_sub_type.is_bankOwned flexData homeInfo.group_type
## 1                                     NA       NA                <NA>
## 2                                     NA       NA                <NA>
## 3                                     NA       NA                <NA>
## 4                                     NA       NA                <NA>
## 5                                     NA       NA                <NA>
## 6                                     NA       NA                <NA>
##   homeInfo.grouping_id homeInfo.grouping_name
## 1                   NA                   <NA>
## 2                   NA                   <NA>
## 3                   NA                   <NA>
## 4                   NA                   <NA>
## 5                   NA                   <NA>
## 6                   NA                   <NA>
##   homeInfo.listing_sub_type.is_openHouse homeInfo.priceSuffix
## 1                                     NA                 <NA>
## 2                                     NA                 <NA>
## 3                                     NA                 <NA>
## 4                                     NA                 <NA>
## 5                                     NA                 <NA>
## 6                                     NA                 <NA>
##   homeInfo.title homeInfo.datePriceChanged homeInfo.isRentalWithBasePrice
## 1           <NA>                        NA                             NA
## 2           <NA>                        NA                             NA
## 3           <NA>                        NA                             NA
## 4           <NA>                        NA                             NA
## 5           <NA>                        NA                             NA
## 6           <NA>                        NA                             NA
##   homeInfo.listing_sub_type.is_forAuction homeInfo.priceChange
## 1                                      NA                   NA
## 2                                      NA                   NA
## 3                                      NA                   NA
## 4                                      NA                   NA
## 5                                      NA                   NA
## 6                                      NA                   NA
```






















