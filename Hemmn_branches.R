rm(list=ls())

setwd("/Users/simonwey/Repos/Hemmnisse")

library(echarts4r)
library(viridisLite)
library(jsonlite)
library(tidyverse)
library(readxl)
library(zoo)
library(readr)

Dat="2011 Q1"
Tables <- list('Demand','Fin_Sit','M_AK','No_probl','oth_probl',"tech_Kap")
#Branches <- #list('Bau','MEM','Pharma','IT','Gesundheit','Gastgewerbe','Grosshandel','Finanzen')
Branches <- list('IT','Gesundheit','Gastgewerbe', 'Grosshandel','Finanzen','Bau','MEM','Pharma')  

#Define function to subset data
restr_table <- function(a,dat) {
  a$Date <- as.yearqtr(a$Date,"%Y-%m")
  a <- subset(a, a$Date>= dat)
  a$Date <- format(a$Date,format="%Y-Q%q")
  return(a)
}

xlsx_exa <- read_xlsx("20201112_BeschBar_Hemmn_FK.xlsm", sheet="Hemmnisse_Calc") #,range ="" "d19:d44")
#xlsx_exa <- xlsx_exa[c(1:53,71:123,141:193,211:263,281:333,351:403),]
xlsx_exa_Demand <- xlsx_exa[c(1:53),] 
xlsx_exa_Fin_Sit <- xlsx_exa[c(71:123),]
xlsx_exa_M_AK <- xlsx_exa[c(141:193),]
xlsx_exa_No_probl <- xlsx_exa[c(211:263),]
xlsx_exa_oth_probl <- xlsx_exa[c(281:333),]
xlsx_exa_tech_Kap <- xlsx_exa[c(351:403),]

TS_Demand <- c()
TS_mean_Demand <- c()
TS_Fin_Sit <- c()
TS_mean_Fin_Sit <- c()
TS_M_AK <- c()
TS_mean_M_AK <- c()
TS_No_probl <- c()
TS_mean_No_probl <- c()
TS_oth_probl <- c()
TS_mean_oth_probl <- c()
TS_tech_Kap <- c()
TS_mean_tech_Kap <- c()

for(i in 1:length(Tables)) { 
  eval(parse(text=paste(paste0(paste0("xlsx_exa_", Tables[i]),"[1,1]"),"<-'Date'")))
  eval(parse(text=paste(paste0(paste0(paste0("names(xlsx_exa_", Tables[i]),")"), "<- eval(parse(text=paste0(paste0('xlsx_exa_', Tables[i]),'[1,]')))"))))
  eval(parse(text=paste(paste0(paste0("xlsx_exa_", Tables[i]), "<- eval(parse(text=paste0(paste0('xlsx_exa_', Tables[i]),'[-1,]')))"))))
}
#eval(parse(text=paste(paste0(paste0(paste0("xlsx_exa_", Tables[i]),"$Date")), "<- eval(parse(text=paste0(paste0(paste0(paste0('as.yearqtr(xlsx_exa_', Tables[i]),'$Date,'),'%Y-%m'),')')))")))

for(i in 1:length(Tables)) {
  eval(parse(text=paste(paste0(paste0("xlsx_exa_", Tables[i]), "<- eval(parse(text=paste0(paste0('restr_table(xlsx_exa_', Tables[i]),',Dat)')))"))))
  #xlsx_exa_Demand <- eval(parse(text=paste0(paste0("restr_table(xlsx_exa_", Tables[i]),",Dat)")))
}

for (j in 1:length(Tables)) {
  for(i in 1:length(Branches)) { 
    #Last value of the time series obstacles
    eval(parse(text=paste(paste0("TS_", Tables[j]), "<- eval(parse(text=paste0(paste0(paste0(paste0(paste0(paste0('c(TS_',Tables[j]),',round(as.numeric(tail(xlsx_exa_'), Tables[j]),'$'),Branches[i]),',n=1)),0))')))")))
    #substract last value for calculating mean
    eval(parse(text=paste('tmp', "<- eval(parse(text=paste0(paste0(paste0(paste0('mean(as.numeric(head(xlsx_exa_', Tables[j]),'$'),Branches[i]),',-1)))')))")))
    #Corrected (minus last value) mean of the time series obstacles
    eval(parse(text=paste(paste0("TS_mean_", Tables[j]), "<- eval(parse(text=paste0(paste0('c(TS_mean_',Tables[j]),',round(tmp,0))')))")))
    
    #Mean (with all data) of the time series obstacles
    #eval(parse(text=paste(paste0("TS_mean_", Tables[j]), "<- eval(parse(text=paste0(paste0(paste0(paste0(paste0(paste0('c(TS_mean_',Tables[j]),',mean(as.numeric(xlsx_exa_'), Tables[j]),'$'),Branches[i]),')))')))")))
  }
}


Branches[3] <- "Gastgew."
Branches[4] <- "Grossh."

TS_Demand
d <- data.frame(
  nam=unlist(Branches),
  dem=TS_Demand,
  fin=TS_Fin_Sit,
  AKM=TS_M_AK,
  NPr=TS_No_probl,
  dem_m=TS_mean_Demand,
  fin_m=TS_mean_Fin_Sit,
  AKM_m=TS_mean_M_AK,
  NPr_m=TS_mean_No_probl
  #mean_val=V21
)

#d$AKM <- paste(round(d$AKM, 0), "%", sep="")

d |>
  e_charts(nam) |>
  e_bar(AKM) |>
  e_bar(AKM_m) |>
  e_bar(NPr) |>
  e_bar(NPr_m) |>
  e_color(
    c("#C0392B","#ffaf51","#1A5276","#5DADE2"),
  ) |>
  #e_bar(dem, name="Demand") |>
  #e_bar(fin) |>
  #e_bar(NPr) |>
  e_x_axis(axisLabel = list(interval = 0, rotate = 75)) |> # rotate
  e_title("Hemmnisse",subtext="Saisonbereinigte Werte",sublink="www.focus50plus.ch", left="10%") |>
  e_tooltip(trigger="axis") |>
  #e_datazoom(type = "slider") |>
  e_legend(orient = 'horizontal', left = 250, top = 25) |>
  e_format_y_axis(suffix = "%") |>
  e_toolbox_feature("saveAsImage")
