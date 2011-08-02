
#############################################################################
# PART I: DETECTION FOR DIFFERENT TIMINGS OF PRESENTATION OF THE CHECHERBOARD
#############################################################################

# experimental data set
setwd('/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data_results/')
dataset <- read.table('Data_12Subjects.txt',as.is=TRUE)
str(dataset)

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
# Create our factors
aggregatedData$maskCode <- factor(aggregatedData$maskCode)
aggregatedData$contrast <- factor(aggregatedData$contrast)
aggregatedData$subject <- factor(aggregatedData$subject)

# Plot the interactions
interaction.plot(aggregatedData$contrast,aggregatedData$maskCode,aggregatedData$acc,ylim=c(0.18,1),
                 type="b",pch=c(16,17,18,19),cex=1.5)


#subj <- "12"
#interaction.plot(aggregatedData$contrast[aggregatedData$subject==subj],
#                 aggregatedData$maskCode[aggregatedData$subject==subj],
#                 aggregatedData$acc[aggregatedData$subject==subj],
#                 ylim=c(0,1),type="b",pch=c(16,22,18,21),cex=1.5)

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
  mod[[i]] <- aov(zAcc ~  maskCode +
                       Error(subject /  maskCode) ,data=aggregatedData[idxs,])
  i <- i + 1

}

# Post-Hoc multiple comparisons
idxs <- aggregatedData$contrast == 0.12
bw <- aggregatedData$zAcc[idxs & aggregatedData$maskCode == 1]
fw <- aggregatedData$zAcc[idxs & aggregatedData$maskCode == 2]
md <- aggregatedData$zAcc[idxs & aggregatedData$maskCode == 3]
ct <- aggregatedData$zAcc[idxs & aggregatedData$maskCode == 4]

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
setwd("/home/lisandro/Work/Project_CFS/CFS_Checkerboard/Data_results/")
dataset <- read.table('freqExp_allDataUnix.txt',as.is=TRUE)
str(dataset)

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




