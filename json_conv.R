library(jsonlite)

#path = "./uavtemp2"
temp1 = list.files(pattern = "*.json", full.names=TRUE)
filename = paste(temp1, sep = "/")
uav_xls = c()
for (i in filename){
  i
  uavtemp <- stream_in(file(i))
  #uavtemp = fromJSON(file = i)
  uav_flat <- flatten(uavtemp)
  library(tibble)
  uav_tbl <- as_data_frame(uav_flat)
  library(magrittr)
  library(dplyr)
  uav_tbl %>% mutate(acList = as.character(acList)) %>% select(acList)
  library(stringr)
  library(tidyr)
  uav_final <- uav_tbl %>% filter(str_detect(acList, "id")) %>% unnest(acList) %>% select(Id, Lat, Long, Alt, PosTime)
  uav_final <- unite(uav_final, Lat_Long_Alt_Time_val, -1, sep = ",")
  uav_xls = rbind(uav_xls, uav_final)
}

#uav <- stream_in(file("2016-06-20-0245Z.json"))

library(xlsx)
write.xlsx(uav_xls, "b:/UAV_Data/uav_1.xlsx")
