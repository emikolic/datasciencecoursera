run_analysis<-function() {
        
        #read path - program expect that "UCI HAR Dataset" 
        #Folder exists in your working directory
        path<-getwd()
        dataPath<-file.path(path, "UCI HAR Dataset")
        
        #read training and test subject data
        subjectTrainingData<-read.table(paste(dataPath, "/train/subject_train.txt", sep=""))
        subjectTestData<-read.table(paste(dataPath, "/test/subject_test.txt", sep=""))
        
        #read training and test activity data
        activityTrainingData<-read.table(paste(dataPath, "/train/y_train.txt", sep=""))
        activityTestData<-read.table(paste(dataPath, "/test/y_test.txt", sep=""))
        
        #read training and test measurements
        trainingData<-read.table(paste(dataPath, "/train/X_train.txt", sep=""))
        testData<-read.table(paste(dataPath, "/test/X_test.txt", sep=""))
        
        #merge training and test subject data 
        subjectDataTable<-rbind(subjectTrainingData, subjectTestData)
        setnames(subjectDataTable, "V1", "person")
        
        #merge training and test activity data 
        activityDataTable<-rbind(activityTrainingData, activityTestData)
        setnames(activityDataTable, "V1", "activityID")
        
        #merge training and test data measurements
        dataTable<-rbind(trainingData, testData)
        
        #merge subject to activities data tables
        subjectActivitiesTable<-cbind(subjectDataTable, activityDataTable)
        
        #merge subject, activities and measurements data in one data table
        mergedDataTable<-data.table(cbind(subjectActivitiesTable, dataTable))
        
        #sorting mergedDataTable, sorted columns are the key
        setkey(mergedDataTable, person, activityID)
        
        #read feature.txt file which contains measures
        features<-data.table(read.table(paste(dataPath, "/features.txt", sep="")))
        
        #set column names
        setnames(features, names(features), c("measureID", "measureName"))
        
        #extracting mean an standard deviation using grep1
        meanAndStdDeviations<-features[like(measureName,"mean|std")]
        
        #create measureCode column that matches to a "V" + measureID
        meanAndStdDeviations$measureCode<-meanAndStdDeviations[,paste0("V", measureID)]
        
        #select only rows with the mean and std values
        select <- c(key(mergedDataTable), meanAndStdDeviations$measureCode)
        mergedDataTable <- mergedDataTable[, select, with=F]
        
        #read activity labels
        activityLabels<-read.table(paste(dataPath, "/activity_labels.txt", sep=""))
        setnames(activityLabels, names(activityLabels), c("activityID", "activityName"))
        
        #merge activity labels with merged data table
        mergedDataTable<-merge(mergedDataTable, activityLabels, by="activityID", all.x=T)
        
        #sort merged data table and add activity as a key
        setkey(mergedDataTable, person, activityID, activityName)
        
        #reshape data table to tall and narrow format - form suitable for easy casting
        mergedDataTable<-data.table(melt(mergedDataTable, key(mergedDataTable), variable.name="measureCode", value.name="value"))
        
        #merge measure codes
        mergedDataTable<-merge(mergedDataTable, meanAndStdDeviations[,list(measureID,measureCode,measureName)], by="measureCode", all.x=T)

        #convert activityName and measureName to factor in order to calculate averages
        mergedDataTable$activityName<-factor(mergedDataTable$activityName)
        mergedDataTable$measureName<-factor(mergedDataTable$measureName)
        
        #get the averages
        varAverages<-dcast(mergedDataTable, person + activityName ~ measureName, mean, value.var="value")
        
        #write tidy data to a file "tidyData.txt"
        write.table(varAverages, file="tidyData.txt", sep=",", row.name=F)
}

