rm(list=ls())

setwd("/Users/simonwey/Repos/Hemmnisse")

library(echarts4r)
library(viridisLite)
library(jsonlite)
library(tidyverse)
library(readxl)

Dat="2011 Q1"
Tables <- list('Demand','Fin_Sit','M_AK','No_probl','oth_probl',"tech_Kap")
Branches <- list('Bau','MEM','Pharma','IT','Gesundheit','Gastgewerbe','Grosshandel','Finanzen')

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
mean(as.numeric(xlsx_exa_Demand$Bau),n=2)
for (j in 1:length(Tables)) {
  for(i in 1:length(Branches)) { 
    #Last value of the time series obstacles
    eval(parse(text=paste(paste0("TS_", Tables[j]), "<- eval(parse(text=paste0(paste0(paste0(paste0(paste0(paste0('c(TS_',Tables[j]),',tail(xlsx_exa_'), Tables[j]),'$'),Branches[i]),',n=1))')))")))
    #Mean of the time series obstacles
    eval(parse(text=paste(paste0("TS_mean_", Tables[j]), "<- eval(parse(text=paste0(paste0(paste0(paste0(paste0(paste0('c(TS_mean_',Tables[j]),',mean(as.numeric(xlsx_exa_'), Tables[j]),'$'),Branches[i]),')))')))")))
  }
}
a <- unlist(Branches)
a
TS_Demand
d <- data.frame(
  nam=unlist(Branches),
  dem=TS_Demand,
  fin=TS_Fin_Sit,
  AKM=TS_M_AK,
  NPr=TS_No_probl
  #mean_val=V21
)

d |>
  e_charts(nam) |>
  e_bar(AKM) |>
  e_bar(dem, name="Demand") |>
  e_bar(fin) |>
  e_bar(NPr) |>
#  e_bar(mean_val, name="Mittelwert 2011 bis 2021:Q3") |>
 # e_line(Banken) |>
 # e_line(Gastgewerbe) |>
 # e_line(Gesundheit) |>
 # e_line(IT) |>
  e_x_axis(axisLabel = list(interval = 0, rotate = 45)) |> # rotate
  e_title("Arbeitskräftemangel: Entwicklung und Satus Quo",subtext="Saisonbereinigte Werte",sublink="www.focus50plus.ch", left="10%") |>
  e_tooltip(trigger="axis") |>
  #e_datazoom(type = "slider") |>
  e_legend(orient = 'horizontal', left = 320, top = 20) |>
  e_format_y_axis(suffix = "%") |>
  e_toolbox_feature("saveAsImage")
