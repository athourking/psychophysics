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
dataset$acc <- ifelse(dataset$location==dataset$response,1,0)

dataset <- dataset[ dataset[,4] < 10 | dataset[,4] > 40 , ] # FILTER THE 4 FLASHES CONDITIONS

data.frame(dataset$acc,dataset$location,dataset$response)



# Calculate accuracy means for each subject
aggregatedData <- aggregate(dataset$acc,list(dataset$maskCode,dataset$contrast,dataset$subject),mean)
names(aggregatedData) <- c("maskCode","contrast","subject","acc")
# Create our factors
aggregatedData$maskCode <- factor(aggregatedData$maskCode)
aggregatedData$contrast <- factor(aggregatedData$contrast)
aggregatedData$subject <- factor(aggregatedData$subject)

interaction.plot(aggregatedData$contrast,aggregatedData$maskCode,aggregatedData$acc,ylim=c(0,1))

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
