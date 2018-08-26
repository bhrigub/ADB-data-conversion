library(jsonlite)

#path = "./uavtemp2"
temp1 = list.files(pattern = "*.json", full.names=TRUE)
filename = paste(temp1, sep = "/")
uav_xls = c()
uav_xls2 = c()
uav_s1 = c()
uav_s2 = c()
uav_s3 = c()
uav_set2 = c()

for (i in filename){
  
  uavtemp <- stream_in(file(i))
  
  #uavtemp = fromJSON(file = i)
  
  uav_flat <- flatten(uavtemp)
  library(tibble)
  
  #flatten the data frame
  uav_tbl <- as_data_frame(uav_flat)
  library(magrittr)
  library(dplyr)
  uav_tbl %>% mutate(acList = as.character(acList)) %>% select(acList)
  library(stringr)
  library(tidyr)
  
  #Extract data from json
  uav_final <- uav_tbl %>% filter(str_detect(acList, "id")) %>% unnest(acList) %>% select(Id, Lat, Long, Alt, PosTime)
  uav_final <- unite(uav_final, Lat_Long_Alt_Time_val, -1, sep = ",")
  uav_xls = rbind(uav_xls, uav_final)
  
  #Create set2 data
  uav_setTemp <- uav_tbl %>% filter(str_detect(acList, "id")) %>% unnest(acList) %>% select(Id, Lat, Long, Alt, PosTime)
  
  #Linking multiple jsons together
  uav_xls2 = rbind(uav_xls2, uav_setTemp)
  
  #condition
  #uav_set2 <- uav_xls2 [36.20848772 < Lat & Lat < 45.21354683) & -68.09768319 < Long & Long < -79.91426241]
  
}

#Sorting data as per the location
uav_s1 <- subset(uav_xls2, Lat > 36.20848772)
uav_s2 <- subset(uav_s1, Lat < 45.21354683)
uav_s3 <- subset(uav_s2, Long < -68.09768319)
uav_set2 <- subset(uav_s3, Long > -79.91426241)

#Unix time to GMT time
options(digits.secs=3)
uav_set2$timeDate = .POSIXct(uav_set2$PosTime/1000,  tz="GMT")
uav_set2$timeReqFormat = format(uav_set2$timeDate ,format = "%H:%M:00")
uav_set2 <- subset( uav_set2, select = -c(PosTime, timeDate ) )

#Combine columns of data
uav_set2 <- unite(uav_set2, Lat_Long_Alt_Time_val, -1, sep = ",")

#Sort data as per the Id sequence
sorted_uav <- arrange(uav_xls, Id)
sorted_uav2 <- arrange(uav_set2, Id)

#Combine similar ID's
#library(plyr)
sorted_uav3 <- ddply(sorted_uav2, .(Id), summarize,
             Lat_Long_Alt_Time_val=paste(unique(Lat_Long_Alt_Time_val),collapse=" | "))

#uav <- stream_in(file("2016-06-20-0245Z.json"))
#options(java.parameters = "-Xmx1000m")
#library(xlsx)
#write.xlsx(uav_xls, "b:/UAV_Data/uav_1.xlsx")

#Write tables to txt file
write.table(sorted_uav, file = "uav_temp.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

write.table(sorted_uav3, file = "uav_set2.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

