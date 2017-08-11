# Map functions
# These two functions adapted from http://www.jstatsoft.org/v19/c01/paper
# northarrowTanimura(loc=c(612,927),size=40)
# scalebarTanimura(loc=c(370,927),length=128.7475,unit="miles")

# Minor edit to scalebar by JEK: added the unitconv routine and the auto-locator

# origin is lower left corner
scalebarTanimura <- function(loc, length, inset, mapunit="meters", unit.lab="meters", division.cex=.8, ...) {
    if(missing(loc)) stop("loc is missing")
    if(missing(length)) stop("length is missing")
    if(missing(inset)) inset <- 0
    if(is.character(loc[1])) loc <- autoLoc(loc, length, inset)
    x <- c(0,length/c(4,2,4/3,1),length*1.1)+loc[1]
    y <- c(0,length/(10*3:1))+loc[2]
    cols <- rep(c("black","white"),2)
    for (i in 1:4) rect(x[i],y[1],x[i+1],y[2],col=cols[i])
    for (i in 1:5) segments(x[i],y[2],x[i],y[3])
    if(mapunit == unit.lab) {
        unitconv <- 1
    } else if(mapunit == 'meters') {
        unitconv <- switch(
            unit.lab,
            miles=0.000621371,
            km=0.621371
        )
    } else if(mapunit == 'degrees') {
        unitconv <- switch(
            unit.lab,
            miles=long2mile(mean(y)),
            km=long2km(mean(y)),
            meters=long2meter(mean(y))
        )
    }
    labels <- x[c(1,3)]-loc[1]
    labels <- append(round(labels*unitconv),paste(round((x[5]-loc[1])*unitconv),unit.lab))
    graphics::text(x[c(1,3,5)],y[4],labels=labels,adj=.5,cex=division.cex)
}

# origin is centroid
northarrowTanimura <- function(loc,size,inset,bearing=0,cols,cex=1,mapunit="meters",...) {
    # checking arguments
    if(missing(loc)) stop("loc is missing")
    if(missing(size)) stop("size is missing")
    if(missing(inset)) inset <- 0
    if(is.character(loc[1])) loc <- autoLoc(loc, size, inset)
    # size is adjusted for diameter and char width
    size <- size/2-2*strwidth('W') #par('cxy')[1]
    # default colors are white and black
    if(missing(cols)) cols <- rep(c("white","black"),8)
    # polygons radii
    radii <- rep(size/c(1,4,2,4),4)
    # correct for x distortion in lat-long coordinates
    if(mapunit == 'degrees') {
        xcf <- 69 / long2meter(loc[2])
        radii <- radii + c(xcf,0,xcf/2,0,0,0,xcf/2,0,xcf,0,xcf/2,0,0,0,xcf/2,0)
        xcfl <- c(xcf,0,xcf,0)
    } else xcfl <- c(0,0,0,0)
    # calculating coordinates of polygons
    x <- radii[(0:15)+1]*cos((0:15)*pi/8+bearing)+loc[1]
    y <- radii[(0:15)+1]*sin((0:15)*pi/8+bearing)+loc[2]
    # drawing polygons
    for (i in 1:15) {
    x1 <- c(x[i],x[i+1],loc[1])
    y1 <- c(y[i],y[i+1],loc[2])
    polygon(x1,y1,col=cols[i])
    }
    # drawing the last polygon
    polygon(c(x[16],x[1],loc[1]),c(y[16],y[1],loc[2]),col=cols[16])
    # drawing letters
    b <- c("E","N","W","S")
    for (i in 0:3) graphics::text((size+par("cxy")[1]+xcfl[i+1])*cos(bearing+i*pi/2)+loc[1],
    (size+par("cxy")[2]+xcfl[i+1])*sin(bearing+i*pi/2)+loc[2],b[i+1],
    cex=cex)
}


# Mostly from legend()
# loc is character
# size is the width of the item in map pixels (usually 30m pixels)
# inset is a length 2 vector of scale factors 

autoLoc <- function(loc, size, inset) {
    auto <- match.arg(loc, c("bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right", "center"))
    if(missing(inset)) inset <- 0
    ##-- outermost reaches of plotted area
    usr <- par("usr") # x1 x2 y1 y2
    ##-- (w,h) are item size 
    w <- h <- size
    inset <- rep_len(inset, 2)
    insetx <- inset[1L] * size 
    left <- switch(auto, "bottomright"=,
           "topright"=, "right" = usr[2L] - w - insetx,
           "bottomleft"=, "left"=, "topleft"= usr[1L] + insetx,
           "bottom"=, "top"=, "center"= (usr[1L] + usr[2L] - w)/2 - insetx)
#           "bottom"=, "top"=, "center"= (usr[1L] + usr[2L] - w)/2)
    insety <- inset[2L] * size
    top <- switch(auto, "bottomright"=,
          "bottom"=, "bottomleft"= usr[3L] + h + insety,
          "topleft"=, "top"=, "topright" = usr[4L] - insety,
          "left"=, "right"=, "center" = (usr[3L] + usr[4L] + h)/2 + insety)
    c(left, top)
}
 
    
# These two are from https://knowledge.safe.com/articles/725/calculating-accurate-length-in-meters-for-lat-long.html
long2meter <- function(lat) 111412.84 * cos(lat*pi/180) - 93.5 * cos(3*lat*pi/180)
long2km <- function(lat) long2meter(lat) * 0.001
long2mile <- function(lat) long2meter(lat) * 0.000621371
#long2mile <- function(lat) 69.22871 * cos(lat*pi/180) - 0.05809819 * cos(3*lat*pi/180) 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
