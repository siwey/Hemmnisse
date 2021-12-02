rm(list=ls())

setwd("/Users/simonwey/Repos/Hemmnisse-KOF")

library(echarts4r)
library(viridisLite)
library(jsonlite)
library(tidyverse)
library(readxl)

Dat="2011 Q1"


xlsx_exa <- read_xlsx("20201112_BeschBar_Hemmn_FK.xlsm", sheet="Hemmnisse_Calc") #,range ="" "d19:d44")
xlsx_exa <- xlsx_exa[c(141,150:193),]
xlsx_exa[1,1] <- "Date"
names(xlsx_exa) <- xlsx_exa[1,]

xlsx_exa <- xlsx_exa[-1,]

xlsx_exa$Date <- as.yearqtr(xlsx_exa$Date,"%Y-%m")
xlsx_exa$Date[2]
xlsx_exa$Date >= "2018 Q1"

xlsx_exa <- subset(xlsx_exa, xlsx_exa$Date>= Dat)
xlsx_exa$Date <- format(xlsx_exa$Date,format="%Y-Q%q")


xlsx_exa$Pharma <- pmax(xlsx_exa$Pharma,0)

xlsx_exa |>
  e_charts(Date) |>
  e_line(serie=Bau, name="Baugewerbe") |>
  e_line(Banken) |>
  e_line(Gastgewerbe) |>
  e_line(Gesundheit) |>
  e_line(IT) |>
  e_line(MEM,name="MEM-Industrie") |>
  e_line(Pharma) |>
  e_title("Arbeitskräftemangel",subtext="Saisonbereinigte Werte",sublink="www.focus50plus.ch", left="10%") |>
  #e_tooltip(trigger = "axis")
  e_tooltip(trigger="axis") |>
  e_datazoom(type = "slider") |>
  e_legend(orient = 'horizontal', left = 0, top = 470) |>
  e_format_y_axis(suffix = "%") 
