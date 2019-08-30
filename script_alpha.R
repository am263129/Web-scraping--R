rm(list = ls())

library(xml2)
library(rvest)
library(dplyr)
library(stringr)

url.df <- read.csv("ZooverURLS.csv",header = F)
url.df$URL <- as.character(url.df$V1)
df_overall <- NULL

#Avoid special characters
#Sys.setlocale("LC_CTYPE", "de_DE.UTF-8")
#Sys.setlocale("LC_CTYPE", "fr_FR.UTF-8")
Sys.setlocale("LC_CTYPE", "nl_NL.UTF-8")

for(i in 1:nrow(url.df)){
  if(i != 191) {
  url.name <- url.df$URL[i]
  page = read_html(url.name)
      brand_pos = unique(page %>% html_nodes("._8e3k8UOR")%>% html_text())
      print(brand_pos)
      brand_pos = gsub(brand_pos,pattern = "Bekijk prijs",replacement = "")
      brand_pos = gsub(brand_pos,pattern = "0",replacement = "")
  brand_pos = gsub(brand_pos,pattern = "Go4Holiday.nl",replacement = "Go4holiday")
  title = page %>% html_nodes("h1") %>% html_text() 
  xyz = html_node(page,"a._5uGQhGSw")
  x1 = xyz
  x2 = xyz %>% html_attr("href") 
  str.entid <- strsplit(x2,split = "&")[[1]] 
  entid = gsub(str.entid[grepl(pattern = "entid=",x = str.entid,ignore.case = T)],
               pattern = "entid=",replacement = "")
  try(df <- data.frame(Date = Sys.Date(),URL = url.name, Endid = entid, Title = title ,Brand_name = brand_pos, Position = c(1:length(brand_pos))))
  df_overall <- rbind(df_overall,df)
  print(i)
  }
}
save(df_overall,file = "final_dataframe.Rdata")
write.table(df_overall, "test.csv", row.names=FALSE , col.names=FALSE, sep="," , append=TRUE)
name = Sys.Date()
write.table(df_overall, paste (toString(name),".csv") , row.names=FALSE , col.names=TRUE, sep="," , append=FALSE)


