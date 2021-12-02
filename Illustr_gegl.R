library(echarts4r)
library(viridisLite)
library(jsonlite)
library(tidyverse)
library(readxl)
library(zoo)

xlsx_exa <- read_xlsx("20201112_BeschBar_Hemmn_FK.xlsm", sheet="Hemmnisse_Tr_Calc") 
xlsx_exa <- xlsx_exa[c(140,173:192),]
xlsx_exa[1,1] <- "Date"
names(xlsx_exa) <- xlsx_exa[1,]

xlsx_exa <- xlsx_exa[-1,]

#mean(as.numeric(xlsx_exa$Bau[1:10]))
mean(as.numeric(xlsx_exa$Bau))
mean(as.numeric(xlsx_exa$Grosshandel))

xlsx_exa$Date <- as.yearqtr(xlsx_exa$Date,"%Y-%m")
class(xlsx_exa$Date)
format(xlsx_exa$Date,format="%Y/Q%q")
as.Date(xlsx_exa$Date)
class(xlsx_exa$Date)
#for (i in 1:length(xlsx_exa$Date))
#  if substr(xlsx_exa$Date[i],6,7)=="01"{
#    xlsx_exa$Date[i] <- as.Date(substr(xlsx_exa$Date[i],1,4))
#  }


xlsx_exa |>
  e_charts(Date) |>
  e_line(serie=Bau) |>
  e_line(Finanzen) |>
  e_line(Grosshandel) |>
  e_line(Gastgewerbe) |>
  e_line(Gesundheit) |>
  e_line(IT) |>
  e_title("Arbeitskräftemangel",subtext="Geglättete Werte",sublink="www.focus50plus.ch", left="10%") |>
  #e_tooltip(trigger = "axis")
  e_tooltip(trigger="axis") |>
  e_datazoom(type = "slider") |>
  e_legend(orient = 'horizontal', left = 350, top = 0) |>
  e_format_y_axis(suffix = "%") 

