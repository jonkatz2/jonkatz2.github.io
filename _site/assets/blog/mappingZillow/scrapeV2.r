# Inspired by https://github.com/notesofdabbler
# Almost directly from the code demo rvest::zillow in help(package=rvest)
library(rvest)

# FOR SALE
url <- "http://www.zillow.com/homes/for_sale/VT/58_rid/any_days/45.537137,-69.062805,42.187829,-75.846863_rect/7_zm/"#2_p/"

more.urls <- read_html(url) %>%
  html_nodes(".zsg-pagination a") %>%
  html_attr("href") 
  
more.urls <- more.urls[!is.na(more.urls)]
more.urls <- strsplit(more.urls, '/')
more.urls <- lapply(more.urls, function(x) x[length(x)])
more.urls <- as.numeric(gsub('[_p]','', more.urls))
more.urls <- max(more.urls)
urls <- c(url, paste0(url,2:more.urls,'_p/'))

zdata2 <- getZillow(urls)
#save(zdata2, file='data/FS_2016April24.rda')
zdata3 <- parseZillow(zdata2)
zdata4 <- do.call(rbind.data.frame, zdata3)
for(i in c('lat', 'long','price','beds','baths','sqft', 'acres', 'yr_built')) zdata4[i] <- as.numeric(as.character(zdata4[,i]))

write.csv(zdata4, 'data/FS_2016May01.csv', row.names=FALSE)

# RECENTLY SOLD
url <- "http://www.zillow.com/homes/recently_sold/VT/58_rid/any_days/45.690832,-68.768921,42.200038,-75.552979_rect/7_zm/"

more.urls <- read_html(url) %>%
  html_nodes(".zsg-pagination a") %>%
  html_attr("href") 
  
more.urls <- more.urls[!is.na(more.urls)]
more.urls <- strsplit(more.urls, '/')
more.urls <- lapply(more.urls, function(x) x[length(x)])
more.urls <- as.numeric(gsub('[_p]','', more.urls))
more.urls <- max(more.urls)
urls <- c(url, paste0(url,2:more.urls,'_p/'))

zdata2 <- getZillow(urls)
#save(zdata2, file='data/RS_2016April24.rda')
zdata3 <- parseSoldZillow(zdata2)
zdata4 <- do.call(rbind.data.frame, zdata3)
for(i in c('lat', 'long', 'price', 'pricepersqft', 'beds','baths','sqft', 'acres', 'yr_built')) zdata4[i] <- as.numeric(as.character(zdata4[,i]))


write.csv(zdata4, 'data/RS_2016May01.csv', row.names=FALSE)


# Spatial analysis
library(rgdal)
library(sp)
library(raster)
library(rgeos)
library(gstat)


vt <- rgdal::readOGR('/home/jon/Documents/AMElicitation/rasters/BoundaryState_VTBND', 'Boundary_VTBND_poly')

vt.twn <- rgdal::readOGR('/home/jon/Dropbox/AMharvest/shinyApps/AMHarvestSummary/data/spatial/Vermont/Boundary_TWNBNDS', 'Boundary_TWNBNDS_poly')

z.spat <- sp::SpatialPointsDataFrame(zdata4[,c('long', 'lat')], data=zdata4, proj4string=CRS("+init=epsg:4326"))

vt.wgs84 <- spTransform(vt, proj4string(z.spat))
plot(vt.wgs84)
plot(z.spat, add=TRUE, pch=19)

twn.w <- spTransform(vt.twn, proj4string(z.spat))
twn.sales <- over(z.spat, twn.w)
z.spat$TOWNNAME <- twn.w$TOWNNAME[twn.sales]

aggregate(z.spat$price, by=list(z.spat$TOWNNAME), FUN=median)

acres <- z.spat['acres']
ac <- acres@data[, 'acres']
ac[!is.na(ac) & ac > 1e3] <- NA#ac[!is.na(ac) & ac > 1e3]/43560
acres@data['acres'] <- ac

age <- aggregate(z.spat['yr_built'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE)
age$yr_built <- 2016 - age$yr_built
count <- aggregate(z.spat['price'], by=twn.w['TOWNNAME'], length)
price <- aggregate(z.spat['price'], by=twn.w['TOWNNAME'], median, na.rm=TRUE) 
acres <- aggregate(acres['acres'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE) 

z.spat$pricepersqft <- z.spat$price/z.spat$sqft
pricepersqft <- aggregate(z.spat['pricepersqft'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE)
twn.sales <- over(z.spat, as(twn.w,'SpatialPolygons'), fn=mean)
over(twn.w, z.spat)

# distance from urban center
# by school district
# distnace from water
# elevation?
# valuation index: price/sqft + 50*baths + 25*beds + price/acre/10 - age
z.spat$jonval <- z.spat$price/z.spat$sqft + 50*z.spat$baths + 25*z.spat$beds + z.spat$price/z.spat$acres/1000 - (2016-z.spat$yr_built)
jonval <- aggregate(z.spat['jonval'], by=twn.w['TOWNNAME'], median, na.rm=TRUE)
ord <- order(jonval$jonval[!is.na(jonval$jonval)]) 
colorplot <- heat.colors(max(ord)+1)
plot(jonval[!is.na(jonval$jonval),], col=colorplot[ord])
plot(twn.w, add=TRUE)

choropleth <- function(sp, attrib, color.ramp=heat.colors, ...) {
    spa <- na.omit(sp[[attrib]])
    bins <- hist(spa, plot=FALSE, ...)$breaks
    bin <- rep(NA, length(spa))
    for(i in length(bins):1) bin[spa > 0 & spa <= bins[i]] <- i-1
    sp$bin <- NA
    sp[['bin']][!is.na(sp[[attrib]])] <- bin
    customcolor <- rev(color.ramp(length(bins)-1))
    customcolor[1] <- "#FFFFFF"
    plot(sp, col=customcolor[sp$bin])
    low.bin <- bins + 1
    low.bin[1] <- 0
    oldopts <- options(scipen=100000)
    on.exit(options(oldopts))
    invisible(paste(low.bin[1:(length(low.bin)-1)], '-', bins[2:length(bins)]))
}
#[sort(unique(na.omit(sp$bin)))]
x <- choropleth(age, 'yr_built', color.ramp=colorRampPalette(c('red', 'orange', 'yellow')), breaks=4)

plot(z.spat, add=TRUE, pch=19)

choropleth(acres, 'acres')
plot(z.spat, add=TRUE, pch=19)

x <- choropleth(price, 'price',  breaks=c(0, 0, seq(250000,500000, by=50000), 1500000))
fill <- rev(heat.colors(length(x)))
fill[1] <- 'white'
legend('bottomright', legend=x, fill=fill, bty='n')

fill.col <- colorRampPalette(c('red', 'orange', 'lightgray'))
x <- choropleth(price, 'price', color.ramp=fill.col, breaks=c(0, 0, seq(250000, 500000, by=75000), 1500000))
fill <- rev(fill.col(length(x)))
fill[1] <- 'white'
legend('bottomright', legend=x, fill=fill, bty='n')


plot(z.spat, add=TRUE, pch=19)

choropleth(count, 'price', breaks=4)
plot(z.spat, add=TRUE, pch=19)
legend('bottomright', legend=x, fill=rev(heat.colors(length(x))), bty='n')








getZillow <- function(urls) {
    lapply(urls, function(u) {
        cat(u, '\n')
        
        houses <- read_html(u) %>%
          html_nodes("article")

        houses
    })
}

parseZillow <- function(zhouse.l, quiet=TRUE, debugFun=function(...) NULL) {
    len.h <-1:length(zhouse.l)
    lapply(1:length(zhouse.l), function(x) {
        debugFun(x, '\n')
        houses <- zhouse.l[[x]]
        propdata <- tryCatch(houses %>% html_node(".property-data"), error=function(e) NULL)
        if(!is.null(propdata)) {
            parsePropData(houses, quiet)
        } else {
            parsePhotoCard(houses, quiet)
        }
    })
}

parseSoldZillow <- function(zhouse.l, quiet=TRUE, debugFun=function(...) NULL) {
    len.h <-1:length(zhouse.l)
    lapply(1:length(zhouse.l), function(x) {
        debugFun(x, '\n')
        houses <- zhouse.l[[x]]
        propdata <- tryCatch(houses %>% html_node(".property-data"), error=function(e) NULL)
        if(!is.null(propdata)) {
            parseSoldHome(houses, quiet)
        } #else {
#            parsePhotoCard(houses, quiet)
#        }
    })
}
# sold homes
parseSoldHome <- function(houses, quiet) {
    if(quiet) debugFun <- function(...){NULL}
    else debugFun <- cat
    
    z_id <- houses %>% html_attr("id")
    
    propinfo <- houses %>%
        html_node(".property-info") 
        
    address <- propinfo %>%
      html_node(".property-address a") %>%
      html_attr("href") %>%
      strsplit("/") %>%
      pluck(3, character(1))
    
    geolab <- propinfo %>%
      html_nodes(".property-address meta") %>%
      html_attr("itemprop") 
    
    geoloc <- propinfo %>%
      html_nodes(".property-address meta") %>%
      html_attr("content")
    
    geoloc <- as.numeric(geoloc)
    
    geo <- matrix(geoloc, ncol=2, byrow=TRUE)
    colnames(geo) <- c('lat', 'long')  

    saleprice <- propinfo %>% 
        html_node(".listing-type") %>%
        html_text() 
        
    saleprice <- gsub('[^0-9]', '', saleprice)
          
    saledate <- propinfo %>%    
        html_node(".sold-date") %>%
        html_text() 
        
    saledate <- gsub('Sold on ', '', saledate)
    
    pricepersqft <- propinfo %>%    
        html_nodes(".zsg-fineprint") %>%
        html_text()
        
    pricepersqft <- pricepersqft[seq(1, length(pricepersqft), by=2)]
    pricepersqft <- gsub('[^0-9]', '', pricepersqft)   
    
    params <- houses %>%
      html_node(".property-data") %>%
      html_text() %>%
      strsplit(", ") 
      
    params.l <- lapply(params, function(x) {
        if(length(x)) {
            x <- gsub('Studio', '0.5 bds', x)
            
            debugFun('    beds\n')  
            beds <- grepl('bds', x)
            if(beds) {
                beds <- x %>%
                strsplit('bds')
                beds <- beds[[1]][1]
              } 
            
            debugFun('    baths\n')  
            baths <- grepl('ba', x)
            if(baths) {
                baths <- x %>%
                strsplit('ba')
                baths <- strsplit(baths[[1]], ' ')[[1]]
                baths <- baths[length(baths)]
            } 
            
            debugFun('    house_area\n')  
            house_area <- grepl('sqft [^a-z]+ ', x)
            if(house_area) {
                house_area <- x %>%
                strsplit('sqft [^a-z]+ ')
                house_area <- strsplit(house_area[[1]], ' ')[[1]]
                house_area <- house_area[length(house_area)]
            } 

            debugFun('    lot_ac\n')  
            lot_ac <- grepl('ac lot', x)
            if(lot_ac) {
                lot_ac <- x %>%
                strsplit('ac lot')
                lot_ac <- strsplit(lot_ac[[1]], ' ')[[1]]
                lot_ac <- lot_ac[length(lot_ac)]
            }
            
            lot_sqft <- grepl('sqft lot', x)
            if(lot_sqft) {
                lot_ac <- x %>%
                strsplit('sqft lot')
                lot_ac <- gsub('[^0-9.]', '', lot_ac) %>%
                as.numeric() 
                lot_ac <- lot_ac/43560
            }
            
            debugFun('    year_built\n')  
            year_built <- grepl('Built', x)
            if(year_built) {
                year_built <- x %>%
                strsplit('Built')
                year_built <- year_built[[1]][2]
            } 
            
            out <- c(beds=beds, baths=baths, sqft=house_area, acres=lot_ac, yr_built=year_built)
            out.vals <- gsub('[^0-9.]', '', out)
            out.df <- data.frame(t(as.numeric(out.vals)))
            names(out.df) <- names(out)
            out.df
        } else data.frame(beds=NA, baths=NA, sqft=NA, acres=NA, yr_built=NA)
    })

    params.df <- do.call(rbind.data.frame, params.l)

    data.frame(z_id=z_id, address=address, geo, price=saleprice, saledate=saledate, pricepersqft=pricepersqft, params.df)
}


parsePropData <- function(houses, quiet) {
    if(quiet) debugFun <- function(...){NULL}
    else debugFun <- cat

    debugFun(x, '\n')
    z_id <- houses %>% html_attr("id")

    debugFun('    address\n')
    address <- houses %>%
      html_node(".property-address a") %>%
      html_attr("href") %>%
      strsplit("/") %>%
      pluck(3, character(1))
      
    debugFun('    geo\n')  
    geo <- houses %>%
      html_nodes(".property-address meta") %>%
      html_attr("content") 
    geo <- as.numeric(geo)
    geo <- data.frame(lat=geo[seq(1,length(geo), by=2)], long=geo[seq(2,length(geo), by=2)])

    debugFun('    price\n')  
    price <- houses %>%
      html_node(".price-large") %>%
      html_text()


    price <- gsub('[^0-9]', '', price)

    params <- houses %>%
      html_node(".property-data") %>%
      html_text() %>%
      strsplit(", ") 
      
    params.l <- lapply(params, function(x) {
        if(length(x)) {
            x <- gsub('Studio', '0.5 bds', x)
            
            debugFun('    beds\n')  
            beds <- grepl('bds', x)
            if(beds) {
                beds <- x %>%
                strsplit('bds')
                beds <- beds[[1]][1]
              } 
            
            debugFun('    baths\n')  
            baths <- grepl('ba', x)
            if(baths) {
                baths <- x %>%
                strsplit('ba')
                baths <- strsplit(baths[[1]], ' ')[[1]]
                baths <- baths[length(baths)]
            } 
            
            debugFun('    house_area\n')  
            house_area <- grepl('sqft [^a-z]+ ', x)
            if(house_area) {
                house_area <- x %>%
                strsplit('sqft [^a-z]+ ')
                house_area <- strsplit(house_area[[1]], ' ')[[1]]
                house_area <- house_area[length(house_area)]
            } 

            debugFun('    lot_ac\n')  
            lot_ac <- grepl('ac lot', x)
            if(lot_ac) {
                lot_ac <- x %>%
                strsplit('ac lot')
                lot_ac <- strsplit(lot_ac[[1]], ' ')[[1]]
                lot_ac <- lot_ac[length(lot_ac)]
            }
            
            lot_sqft <- grepl('sqft lot', x)
            if(lot_sqft) {
                lot_ac <- x %>%
                strsplit('sqft lot')
                lot_ac <- gsub('[^0-9.]', '', lot_ac) %>%
                as.numeric() 
                lot_ac <- lot_ac/43560
            }
            
            debugFun('    year_built\n')  
            year_built <- grepl('Built', x)
            if(year_built) {
                year_built <- x %>%
                strsplit('Built')
                year_built <- year_built[[1]][2]
            } 
            
            out <- c(beds=beds, baths=baths, sqft=house_area, acres=lot_ac, yr_built=year_built)
            out.vals <- gsub('[^0-9.]', '', out)
            out.df <- data.frame(t(as.numeric(out.vals)))
            names(out.df) <- names(out)
            out.df
        } else data.frame(beds=NA, baths=NA, sqft=NA, acres=NA, yr_built=NA)
    })

    params.df <- do.call(rbind.data.frame, params.l)

    data.frame(z_id=z_id, address=address, geo, price=price, params.df)
}


parsePhotoCard <- function(houses, quiet) {
    if(quiet) debugFun <- function(...){NULL}
    else debugFun <- cat

    z_id <- houses %>% html_attr("id")

    debugFun('    address\n')
    address <- houses %>%
      html_node(".zsg-photo-card-spec a") %>%
      html_attr("href") %>%
      strsplit("/") %>%
      pluck(3, character(1))
      
    debugFun('    geo\n')  
    
    lat <- houses %>% html_attr("data-latitude")
    lon <- houses %>% html_attr("data-longitude")
#    geo <- houses %>%
#      html_nodes(".property-address meta") %>%
#      html_attr("content") 

    geo <- data.frame(lat=as.numeric(lat)*10e-7, long=as.numeric(lon)*10e-7)

    debugFun('    price\n')  
    price <- houses %>%
      html_nodes(".zsg-photo-card-status")%>%
      html_text()
      
    price <- price!='Auction'
    for(i in 1:length(price)) {
        if(price[i]) {
            price[i] <- houses[i] %>%
              html_nodes(".zsg-photo-card-spec") %>% 
              html_nodes(".zsg-photo-card-price") %>%
              html_text()
        }
    }

    price <- gsub('[^0-9]', '', price)

    params <- houses %>%
      html_nodes(".zsg-photo-card-spec") %>% 
      html_nodes(".zsg-photo-card-info") %>%
      html_text() %>%
      strsplit(", ")  
      
    params.l <- lapply(params, function(x) {
        debugFun(x, '\n')
        if(length(x)) {
            x <- gsub('Studio', '0.5 bds', x)
            x <- gsub('--', 'NA', x)
            debugFun('    beds\n')  
            beds <- grepl('bds', x)
            if(beds) {
                beds <- x %>%
                strsplit('bds')
                beds <- beds[[1]][1]
              } 
            
            debugFun('    baths\n')  
            baths <- grepl('ba', x)
            if(baths) {
                baths <- x %>%
                strsplit('ba')
                baths <- strsplit(baths[[1]], ' ')[[1]]
                baths <- baths[length(baths)]
            } 
            
            debugFun('    house_area\n')  
            house_area <- grepl('sqft', x)
            if(house_area && grepl('k sqft', x)) {
                house_area <- x %>%
                strsplit('k sqft')
                house_area <- strsplit(house_area[[1]], ' ')[[1]]
                house_area <- house_area[length(house_area)]
                house_area <- gsub('[^0-9]', '', house_area)
                house_area <- as.numeric(house_area) * 100
            } else {
                house_area <- x %>%
                strsplit('sqft')
                house_area <- strsplit(house_area[[1]], ' ')[[1]]
                house_area <- house_area[length(house_area)]
            }

            debugFun('    lot_ac\n')  
            lot_ac <- grepl('ac lot', x)
            if(lot_ac) {
                lot_ac <- x %>%
                strsplit('ac lot')
                lot_ac <- strsplit(lot_ac[[1]], ' ')[[1]]
                lot_ac <- lot_ac[length(lot_ac)]
            }
            
            lot_sqft <- grepl('sqft lot', x)
            if(lot_sqft) {
                lot_ac <- x %>%
                strsplit('sqft lot')
                lot_ac <- gsub('[^0-9.]', '', lot_ac) %>%
                as.numeric() 
                lot_ac <- lot_ac/43560
            }
            
            debugFun('    year_built\n')  
            year_built <- grepl('Built', x)
            if(year_built) {
                year_built <- x %>%
                strsplit('Built')
                year_built <- year_built[[1]][2]
            } 
            
            out <- c(beds=beds, baths=baths, sqft=house_area, acres=lot_ac, yr_built=year_built)
            out.vals <- gsub('[^0-9.]', '', out)
            out.df <- data.frame(t(as.numeric(out.vals)))
            names(out.df) <- names(out)
            out.df
        } else data.frame(beds=NA, baths=NA, sqft=NA, acres=NA, yr_built=NA)
    })

    params.df <- do.call(rbind.data.frame, params.l)

    data.frame(z_id=z_id, address=address, geo, price=price, params.df)
}



##beds <- params %>%
##  pluck(1, character(1)) #%>%
###  extract_numeric()
##  
##baths <- params %>%
##  pluck(2, character(1)) #%>%
###  extract_numeric()
##  
##house_area <- params %>%
##  pluck(3, character(1)) %>%
##  area()

