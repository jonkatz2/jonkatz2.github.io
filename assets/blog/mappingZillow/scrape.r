# Inspired by https://github.com/notesofdabbler
# Almost directly from the code demo rvest::zillow in help(package=rvest)
library(rvest)


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

zdata3 <- parseZillow(zdata2)
zdata4 <- zdata3[sapply(zdata3, function(x) length(x)>1)]
zdata4 <- do.call(rbind.data.frame, zdata4)
for(i in c('lat', 'long','price','beds','baths','sqft', 'acres', 'yr_built')) zdata4[i] <- as.numeric(as.character(zdata4[,i]))

library(rgdal)
library(sp)
library(raster)


vt <- rgdal::readOGR('/home/jon/Documents/AMElicitation/rasters/BoundaryState_VTBND', 'Boundary_VTBND_poly')

vt.twn <- rgdal::readOGR('/home/jon/Dropbox/AMharvest/shinyApps/AMHarvestSummary/data/spatial/Vermont/Boundary_TWNBNDS', 'Boundary_TWNBNDS_poly')

z.spat <- sp::SpatialPointsDataFrame(zdata4[,c('long', 'lat')], data=zdata4, proj4string=CRS("+init=epsg:4326"))

vt.wgs84 <- spTransform(vt, proj4string(z.spat))
plot(vt.wgs84)
plot(z.spat, add=TRUE, pch=19)

twn.w <- spTransform(vt.twn, proj4string(z.spat))
twn.sales <- over(z.spat, twn.w)

age <- aggregate(z.spat['yr_built'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE)
count <- aggregate(z.spat['price'], by=twn.w['TOWNNAME'], length)
price <- aggregate(z.spat['price'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE) 
acres <- aggregate(z.spat['acres'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE) 
z.spat$pricepersqft <- z.spat$price/z.spat$sqft
pricepersqft <- aggregate(z.spat['pricepersqft'], by=twn.w['TOWNNAME'], mean, na.rm=TRUE)
twn.sales <- over(z.spat, as(twn.w,'SpatialPolygons'), fn=mean)
over(twn.w, z.spat)

# distance from urban center
# by school district
# distnace from water
# elevation?
# valuation of a home: price/sqft + 50*baths + 25*beds + price/acre/10 - age
z.spat$jonval <- z.spat$price/z.spat$sqft + 50*z.spat$baths + 25*z.spat$beds + z.spat$price/z.spat$acres/1000 - (2016-z.spat$yr_built)
jonval <- aggregate(z.spat['jonval'], by=twn.w['TOWNNAME'], median, na.rm=TRUE) 

getZillow <- function(urls) {
    lapply(urls, function(u) {
        cat(u, '\n')
        
        houses <- read_html(u) %>%
          html_nodes("article")

        houses
    })
}

parseZillow <- function(zhouse.l, quiet=TRUE) {
    if(quiet) debugFun <- function(...){NULL}
    else debugFun <- cat
    len.h <-1:length(zhouse.l)
    lapply(1:length(zhouse.l), function(x) {
        houses <- zhouse.l[[x]]
        active <- tryCatch(houses %>% html_node(".property-data"), error=function(e) NULL)
        if(!is.null(active)) {
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

            geo <- data.frame(lat=geo[seq(1,length(geo), by=2)], long=geo[seq(2,length(geo), by=2)])

            debugFun('    price\n')  
            price <- houses %>%
              html_node(".price-large") %>%
              html_text() #%>%
            #  tidyr::extract_numeric()

            price <- gsub('[^0-9]', '', price)

            params <- houses %>%
              html_node(".property-data") %>%
              html_text() %>%
              strsplit(", ")  
              
            params.l <- lapply(params, function(x) {
                debugFun(x, '\n')
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
        } else NA
    })
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

