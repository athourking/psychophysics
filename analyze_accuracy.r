
#############################################################################
# PART I: DETECTION FOR DIFFERENT TIMINGS OF PRESENTATION OF THE CHECHERBOARD
#############################################################################

# experimental data set
setwd("/media/New Volume/psychScriptz/CFS_Checkerboard/Data")
dataset <- read.table('Data_12Subjects.txt',as.is=TRUE)
str(dataset)
library(sciplot)

# (1) subject number ; (2) Block number; (3) contrast value ; (4) timing
# value ; (5) code for the timing conditions ; (6) location of the checkerboard
# (7) responses for locations ; (8) responses for subjective visibility

nomi <- c("subject",
  "block",
  "contrast",
  "timing",
  "maskCode",
  "location",
  "response",
  "subjectiveResponse")
names(dataset) <- nomi  
str(dataset)

# Calculate accuracies
dataset$acc <- ifelse(dataset$location == dataset$response, 1, 0)

# FILTER OUT THE TRIALS WITH LESS THAN 4 INITIAL FLASHES
dataset <- dataset[ dataset[,4] < 10 | dataset[,4] > 40 , ]                                                             

# Data sanity check: prints only the first 6 rows
head(data.frame(dataset$acc,dataset$location,dataset$response))

# Calculate accuracy means for each subject
aggregatedData <- aggregate(dataset$acc,list(dataset$maskCode,dataset$contrast,dataset$subject),mean)
names(aggregatedData) <- c("maskCode","contrast","subject","acc")

# filter out control (initial) condition for plotting
aggregatedData <- aggregatedData[aggregatedData$maskCode!=4,]

# Create our factors
aggregatedData$maskCode <- factor(aggregatedData$maskCode)
aggregatedData$contrast <- factor(aggregatedData$contrast)
aggregatedData$subject <- factor(aggregatedData$subject)


# Sciplot
contrastLin <- as.numeric(as.character(aggregatedData[,2]))
subjMeans <- rep(tapply(aggregatedData[,4],list(aggregatedData[,3]),mean),rep(15,12))
overallMean <- rep(mean(aggregatedData[,4]),length(subjMeans))
plotData <- aggregatedData[,4]-(subjMeans-overallMean)
lineplot.CI(aggregatedData[,2],plotData,group=aggregatedData[,1],x.cont=TRUE,
            ci.fun = function(x) c( mean(x) + sd(x)/sqrt(12) , mean(x) - sd(x)/sqrt(12) ),
            ylim=c(0.2,1),bty="n",axes=FALSE,x.leg=0.3,y.leg=0.5,xlim=c(0,0.7),
            err.lty=c(1,2,3),lty=c(1,2,3),col=c("black","grey25","grey50"),pch=c(15,16,17)
	    ,lwd=2,cex=2,cex.lab=1.5,cex.leg=2,
	    xlab="",ylab="",leg.lab=c("Middle","Backward","Forward"))
title(xlab="Contrast",ylab="Accuracy",cex.lab=2)
abline(h=0.25,lwd=1,lty=2)
axis(2,seq(0.2,1,0.1),seq(0.2,1,0.1),las=1,cex.axis=1.4)
axis(1,unique(contrastLin),unique(contrastLin),cex.axis=1.4)

# log Sciplot
subjMeans <- rep(tapply(aggregatedData[,4],list(aggregatedData[,3]),mean),rep(15,12))
overallMean <- rep(mean(aggregatedData[,4]),length(subjMeans))
plotData <- aggregatedData[,4]-(subjMeans-overallMean)
contrastLin <- as.numeric(as.character(aggregatedData[,2]))
contrastLog <- log(as.numeric(as.character(aggregatedData[,2])))
lineplot.CI(contrastLog,plotData,group=aggregatedData[,1],x.cont=TRUE,
            ci.fun = function(x) c( mean(x) + sd(x)/sqrt(12) , mean(x) - sd(x)/sqrt(12) ),
            ylim=c(0.2,1),bty="n",axes=FALSE,x.leg=min(unique(contrastLog)),y.leg=0.9,xlim=c(min(unique(contrastLog)),max(unique(contrastLog))),
            err.lty=c(4,3,2,1),lwd=2,cex=2,cex.lab=1.5,cex.leg=1)
abline(h=0.25,lwd=1,lty=2)
axis(2,seq(0.2,1,0.1),seq(0.2,1,0.1),las=1)
axis(1,unique(contrastLog),unique(contrastLin))

# Calculate zscore accuracy means
aggregatedData$zAcc <- rep(0,dim(aggregatedData)[1])
for (i in levels(aggregatedData$subject)) {
  zScoreSubj <- scale( aggregatedData[aggregatedData$subject==i,4] )
  aggregatedData$zAcc[aggregatedData$subject==i] <- zScoreSubj
}

# Two-ways repeated measures Anova 
mod.withinAnova <- aov(acc ~ (contrast * maskCode) +
                       Error(subject / (contrast * maskCode) ),data=aggregatedData)
summary(mod.withinAnova)

# Two-ways repeated measures Anova with the z-score values
mod.withinAnovaZscore <-  aov(zAcc ~ (contrast * maskCode) +
                       Error(subject / (contrast * maskCode) ),data=aggregatedData)
summary(mod.withinAnovaZscore)


# One-way repeated measures anova for each contrast condition
mod <- list(0)
i <- 1
for (cond in levels(aggregatedData$contrast)){  
  idxs <- aggregatedData$contrast == cond
  mod[[i]] <- aov(acc ~  maskCode +
                       Error(subject /  maskCode) ,data=aggregatedData[idxs,])
  i <- i + 1

}

# Post-Hoc multiple comparisons
idxs <- aggregatedData$contrast == 0.64
bw <- aggregatedData$acc[idxs & aggregatedData$maskCode == 1]
fw <- aggregatedData$acc[idxs & aggregatedData$maskCode == 2]
md <- aggregatedData$acc[idxs & aggregatedData$maskCode == 3]
ct <- aggregatedData$acc[idxs & aggregatedData$maskCode == 4]

t.test(bw,fw,paired=TRUE,alternative=("two.sided"))
t.test(bw,md,paired=TRUE,alternative=("less"))
t.test(bw,ct,paired=TRUE,alternative=("less"))

t.test(fw,md,paired=TRUE,alternative=("two.sided"))
t.test(md,ct,paired=TRUE,alternative=("two.sided"))



# boxplot(aggregatedData$acc ~ aggregatedData$maskCode)




#############################################################################
# PART II: DETECTION FOR DIFFERENT FREQUENCIES OF THE MONDRIANS
#############################################################################


# experimental data set
setwd("/media/New Volume/psychScriptz/CFS_Checkerboard/Data")
dataset <- read.table('freqExp_allData.txt',as.is=TRUE)
str(dataset)
library(sciplot)

# (1) subject number ; (2) Block number; (3) contrast value ; (4) timing of checkerboard;
# (5) mask frequencies; (6) location of the checkerboard
# (7) responses for locations ; (8) responses for subjective visibility

nomi <- c("subject",
  "block",
  "contrast",
  "timing",
  "frequency",
  "location",
  "response",
  "subjectiveResponse")
names(dataset) <- nomi  
str(dataset)

# Calculate accuracies
dataset$acc <- ifelse(dataset$location == dataset$response, 1, 0)

# Data sanity check: prints only the first 6 rows
head(data.frame(dataset$acc,dataset$location,dataset$response))

# Calculate accuracy means for each subject
aggregatedData <- aggregate(dataset$acc,list(dataset$frequency, dataset$contrast, dataset$subject),mean)
names(aggregatedData) <- c("frequency","contrast","subject","acc")

# Create our factors
aggregatedData$frequency <- factor(aggregatedData$frequency)
aggregatedData$contrast <- factor(aggregatedData$contrast)
aggregatedData$subject <- factor(aggregatedData$subject)

# Sciplot
subjMeans <- rep(tapply(aggregatedData[,4],list(aggregatedData[,3]),mean),rep(15,12))
overallMean <- rep(mean(aggregatedData[,4]),length(subjMeans))
plotData <- aggregatedData[,4]-(subjMeans-overallMean)
lineplot.CI(aggregatedData[,1],plotData,group=aggregatedData[,2],
            ci.fun = function(x) c( mean(x) + sd(x)/sqrt(12) , mean(x) - sd(x)/sqrt(12) ),
            ylim=c(0,1),bty="n",axes=FALSE,x.leg=1,y.leg=0.25,
            err.lty=c(3,2,1),lwd=1.5,cex=3,cex.lab=1.5,cex.leg=2)


# Plot interactions
interaction.plot(aggregatedData$frequency, aggregatedData$contrast, aggregatedData$acc,
                 ylim=c(0.18,1), type="b",pch=c(16,17,18,19),cex=1.5)


# Two-ways repeated measures Anova 
mod.withinAnova <- aov(acc ~ (frequency * contrast ) +
                       Error(subject / (frequency * contrast) ),data=aggregatedData)
summary(mod.withinAnova)


# One-way repeated measures anova for each contrast condition
mod <- list(0)
i <- 1
for (cond in levels(aggregatedData$contrast)){  
  idxs <- aggregatedData$contrast == cond
  mod[[i]] <- aov(acc ~  frequency +
                       Error(subject /  frequency) ,data=aggregatedData[idxs,])
   # mod[[i]].cond <- cond
  i <- i + 1
}

??tuckey
# Post hoc comparisons: 10 comparisons make a bonferroni corrected p value
# of 0.005

idxs <- aggregatedData$contrast == 0.12

hz_5 <- aggregatedData$acc[idxs & aggregatedData$frequency == 5]
hz_8 <- aggregatedData$acc[idxs & aggregatedData$frequency == 8.5]
hz_10 <- aggregatedData$acc[idxs & aggregatedData$frequency == 10]
hz_16 <- aggregatedData$acc[idxs & aggregatedData$frequency == 16.6]
hz_28 <- aggregatedData$acc[idxs & aggregatedData$frequency == 28.5]

t.test(hz_5, hz_8, paired=TRUE, alternative=("two.sided"))
t.test(hz_5, hz_10, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_16, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_8, hz_10, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_28, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_16, hz_28, paired=TRUE,alternative=("two.sided"))


idxs <- aggregatedData$contrast == 0.16

hz_5 <- aggregatedData$acc[idxs & aggregatedData$frequency == 5]
hz_8 <- aggregatedData$acc[idxs & aggregatedData$frequency == 8.5]
hz_10 <- aggregatedData$acc[idxs & aggregatedData$frequency == 10]
hz_16 <- aggregatedData$acc[idxs & aggregatedData$frequency == 16.6]
hz_28 <- aggregatedData$acc[idxs & aggregatedData$frequency == 28.5]

t.test(hz_5, hz_8, paired=TRUE, alternative=("two.sided"))
t.test(hz_5, hz_10, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_16, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_8, hz_10, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_28, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_16, hz_28, paired=TRUE,alternative=("two.sided"))


idxs <- aggregatedData$contrast == 0.64

hz_5 <- aggregatedData$acc[idxs & aggregatedData$frequency == 5]
hz_8 <- aggregatedData$acc[idxs & aggregatedData$frequency == 8.5]
hz_10 <- aggregatedData$acc[idxs & aggregatedData$frequency == 10]
hz_16 <- aggregatedData$acc[idxs & aggregatedData$frequency == 16.6]
hz_28 <- aggregatedData$acc[idxs & aggregatedData$frequency == 28.5]

t.test(hz_5, hz_8, paired=TRUE, alternative=("two.sided"))
t.test(hz_5, hz_10, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_16, paired=TRUE,alternative=("two.sided"))
t.test(hz_5, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_8, hz_10, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_8, hz_28, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_16, paired=TRUE, alternative=("two.sided"))
t.test(hz_10, hz_28, paired=TRUE,alternative=("two.sided"))
t.test(hz_16, hz_28, paired=TRUE,alternative=("two.sided"))




