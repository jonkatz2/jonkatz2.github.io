setwd('/home/jon/Documents/VMC/Climate/data2016')
library(sp)
library(rgdal)

mins <- list.files(pattern='...min\\....')
maxs <- list.files(pattern='...max\\....')
means <- list.files(pattern='...mean\\....')

options(stringsAsFactors=FALSE)
mins <- lapply(mins, function(x) {
    dat <- read.csv(x)
    dat$month <- substr(x, 1, 3)
    dat
})




setwd('/home/jon/Documents/VMC/Climate/data')
library(sp)
library(rgdal)
library(raster)
library(gstat)

source('/home/jon/Documents/personalWebsite/jonkatz2.github.io/assets/blog/mappingZillow/legend.R')
#source('/home/jon/Documents/personalWebsite/jonkatz2.github.io/assets/blog/mappingZillow/mapFunctions.R')
source('mapFunctions.R')

options(stringsAsFactors=FALSE)
ma <- read.csv('max.csv')
mi <- read.csv('min.csv')
me <- read.csv('mean.csv')

dat <- merge(ma[1:2], mi[1:2], by='Name', all=TRUE, sort=FALSE)
dat <- merge(dat, me[1:2], by='Name', all=TRUE, sort=FALSE)
names(dat) <- c('Name', 'Max', 'Min', 'Mean')
for(i in 2:4) dat[i] <- (as.numeric(dat[,i])-32) * 5/9

locations <- read.csv('locations.csv')
dat <- merge(locations, dat, by='Name', all=TRUE, sort=FALSE)
dat <- na.omit(dat)
dat <- dat[-10,]
rownames(dat) <- 1:nrow(dat)
for(i in 2:3) dat[i] <- as.numeric(dat[,i])
datum <- "+init=epsg:4326"

spdat <- SpatialPointsDataFrame(coords=dat[,c('Longitude','Latitude')], data=dat[,c('Name','Elevation','Max','Min','Mean')], proj4string = CRS("+init=epsg:4326"))

vt <- readOGR(dsn='VT', layer='VT_Boundaries__state_polygon')
counties <- readOGR(dsn='BoundaryCounty_CNTYBNDS', layer='Boundary_CNTYBNDS_poly')
vt <- spTransform(vt, CRS(proj4string(spdat)))
plot(vt)
plot(spdat, add=TRUE)



hilsh <- raster('/home/jon/Documents/VMC/Climate/data/hilsh250/hilsh250')

vt <- spTransform(vt, CRS(proj4string(hilsh)))
counties <- spTransform(counties, CRS(proj4string(hilsh)))
spdat <- spTransform(spdat, CRS(proj4string(hilsh)))
vthilsh <- crop(hilsh, vt)
vthilsh <- mask(hilsh, vt)

plot(vthilsh, axes=FALSE, legend=FALSE, ext=vt, box=FALSE)
plot(vt, add=TRUE)
plot(spdat, add=TRUE)

dem <- raster('/home/jon/Documents/VMC/Climate/data/dem_250/dem_250')
plot(dem, axes=FALSE, legend=FALSE, ext=vt, box=FALSE)


# Spatial models use stats::lm and raster::predict since x and y are not explicit model parameters (per the helpfile for interpolate)
elev <- extract(dem, spdat)
spdat@data <- cbind(spdat@data, dem=elev)
spdat <- cbind(spdat, coordinates(spdat))
fit <- lm(formula = Max ~ dem, data = spdat)
maxint <- predict(dem, fit, ext=vt)


# This works, but doesn't look very good
demcoords <- coordinates(dem)
names(demcoords) <- c('Longitude', 'Latitude')
newdat <- SpatialPoints(demcoords, proj4string=CRS(proj4string(dem)), bbox=bbox(dem))
newdem <- extract(dem, newdat)
newpts <- cbind(demcoords, dem=newdem)
newpts <- as.data.frame(newpts)
names(newpts) <- c('Longitude', 'Latitude', 'dem')
proj4string(newpts) <- proj4string(dem)

# This works, but doesn't look very good
tempdata <- spdat@data
tempdata <- cbind(tempdata, coordinates(spdat))
gridded(newpts) <- ~Longitude+Latitude
fit <- gstat(formula = Max ~ 1, data = spdat, nmax = 4, set = list(idp = .5))
maxint <- interpolate(dem, model=fit, ext=vt)


fit <- gstat(formula = Max ~ dem, data = spdat, nmax = 4, set = list(idp = .5))
maxint2 <- predict(fit, newpts)
maxintr <- raster(maxint2)
vtmax2 <- mask(maxintr, vt)
plot(vtmax2, ext=vt, col=rev(heat.colors(255)), axes=FALSE, box=FALSE)
plot(vt, add=TRUE)
plot(spdat, add=TRUE)

## MAX
# The inverse distance weighted interpolation looks best
fitmax <- gstat(formula = Max ~ 1, data = spdat, nmax = 4, set = list(idp = .5))
maxint <- interpolate(dem, model=fitmax, ext=vt)
# smooth with a local average
fmean <- function(x) mean(x, na.rm=TRUE)
vtmaxsm <- focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)
# mask to state boundary
vtmaxsm_m <- mask(vtmaxsm, vt)
# determine the range of temps
max_minval <- floor(cellStats(vtmaxsm_m, stat='min'))
max_maxval <- ceiling(cellStats(vtmaxsm_m, stat='max'))
max_temprange <- max_minval:max_maxval
maxcolgrad <- rev(heat.colors(length(max_temprange)))

## MIN
fitmin <- gstat(formula = Min ~ 1, data = spdat, nmax = 4, set = list(idp = .5))
minint <- interpolate(dem, model=fitmin, ext=vt)
# smooth with a local average
vtminsm <- focal(minint, w=matrix(1, 101, 101), fmean, pad=TRUE)
# mask to state boundary
vtminsm_m <- mask(vtminsm, vt)
# determine the range of temps
min_minval <- floor(cellStats(vtminsm_m, stat='min'))
min_maxval <- ceiling(cellStats(vtminsm_m, stat='max'))
min_temprange <- min_minval:min_maxval
coolramp <- colorRampPalette(c('#007db7', '#bfe4e5'))
mincolgrad <- coolramp(length(min_temprange))

## MEAN
fitmean <- gstat(formula = Mean ~ 1, data = spdat, nmax = 4, set = list(idp = .5))
meanint <- interpolate(dem, model=fitmean, ext=vt)
# smooth with a local average
vtmeansm <- focal(meanint, w=matrix(1, 101, 101), fmean, pad=TRUE)
# mask to state boundary
vtmeansm_m <- mask(vtmeansm, vt)
# determine the range of temps
mean_minval <- floor(cellStats(vtmeansm_m, stat='min'))
mean_maxval <- ceiling(cellStats(vtmeansm_m, stat='max'))
mean_temprange <- mean_minval:mean_maxval
meanramp <- colorRampPalette(c('#f1f4d8', '#8dc63f'))#008080
meancolgrad <- meanramp(length(mean_temprange))

# Only for degrees F
max_temprange <- round(max_temprange * 9/5 + 32, 1)
min_temprange <- round(min_temprange * 9/5 + 32, 1)
mean_temprange <- round(mean_temprange * 9/5 + 32, 1)


png('temphoriz_counties_F.png', 1800, 600, pointsize=24)
par(mfrow=c(1,3))

png('tempvert_counties_F.png', 600, 1800, pointsize=24)
par(mfrow=c(3,1))

par(mar=c(5.1,0,4.1,0))
plot(vtmaxsm_m, ext=vt, col=maxcolgrad, axes=FALSE, box=FALSE, legend=FALSE, main='2016 Maximum Temperature')
for(i in 1:nrow(counties)) plot(counties[i,], border=rgb(0,0,0,alpha=0.12), lwd=2, add=TRUE)
plot(vt, add=TRUE)
legend('bottomright', legend=rev(max_temprange), fill=rev(maxcolgrad), bty='n', title=expression(paste("\t   ", degree,"F")),  box.cex=c(2, 1), inset=c(0, .25)) # border=NA, 
#plot(spdat, add=TRUE)

par(mar=c(5.1,0,4.1,0))
plot(vtminsm_m, ext=vt, col=mincolgrad, axes=FALSE, box=FALSE, legend=FALSE, main='2016 Minimum Temperature')
for(i in 1:nrow(counties)) plot(counties[i,], border=rgb(0,0,0,alpha=0.12), lwd=2, add=TRUE)
plot(vt, add=TRUE)
legend('bottomright', legend=rev(min_temprange), fill=rev(mincolgrad), bty='n', title=expression(paste("\t   ", degree, "F")), box.cex=c(2, 1), inset=c(0, .25)) # border=NA, 

par(mar=c(5.1,0,4.1,0))
plot(vtmeansm_m, ext=vt, col=meancolgrad, axes=FALSE, box=FALSE, legend=FALSE, main='2016 Average Temperature')
for(i in 1:nrow(counties)) plot(counties[i,], border=rgb(0,0,0,alpha=0.12), lwd=2, add=TRUE)
plot(vt, add=TRUE)
legend('bottomright', legend=rev(mean_temprange), fill=rev(meancolgrad), bty='n', title=expression(paste("\t   ", degree, "F")), box.cex=c(2, 1), inset=c(0, .25)) # border=NA, 

northarrowTanimura(loc=c(611923.3, 59500), size=60000, cex=0.8)
#northarrowTanimura(loc=c(599037.5, 58730), size=40000)
dev.off()


599037.5-592594.6



























