rm(list=ls())

setwd("/Users/simonwey/Repos/Hemmnisse")

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


V20 <- c(as.numeric(tail(xlsx_exa$IT,n=1)),as.numeric(tail(xlsx_exa$Gesundheit,n=1)),as.numeric(tail(xlsx_exa$Gastgewerbe,n=1)),as.numeric(tail(xlsx_exa$Grosshandel,n=1)),as.numeric(tail(xlsx_exa$Finanzen,n=1)),as.numeric(tail(xlsx_exa$Bau,n=1)), as.numeric(tail(xlsx_exa$MEM,n=1)), as.numeric(tail(xlsx_exa$Pharma,n=1)))
#V21 <- c(mean(as.numeric(xlsx_exa$IT)),mean(as.numeric(xlsx_exa$Gesundheit)),mean(as.numeric(xlsx_exa$Gastgewerbe)),mean(as.numeric(xlsx_exa$Grosshandel)),mean(as.numeric(xlsx_exa$Finanzen)),mean(as.numeric(xlsx_exa$Bau)),mean(as.numeric(xlsx_exa$MEM)),mean(as.numeric(xlsx_exa$Pharma)))
V21 <- c(mean(as.numeric(head(xlsx_exa$IT,-1))),mean(as.numeric(head(xlsx_exa$Gesundheit,-1))),mean(as.numeric(head(xlsx_exa$Gastgewerbe,-1))),mean(as.numeric(head(xlsx_exa$Grosshandel,-1))),mean(as.numeric(head(xlsx_exa$Finanzen,-1))),mean(as.numeric(head(xlsx_exa$Bau,-1))),mean(as.numeric(head(xlsx_exa$MEM,-1))),mean(as.numeric(head(xlsx_exa$Pharma,-1))))
names <- c(as.character('IT'),as.character('Gesundheit'),as.character('Gastgewerbe'),as.character('Grosshandel'),as.character('Finanzen'),as.character('Bau'),as.character('MEM-Industrie'),as.character('Pharma'))
names

d <- data.frame(
  nam=names,
  act_val=V20,
  mean_val=V21
)

d |>
  e_charts(nam) |>
  e_bar(act_val, name="2021:Q4") |>
  e_bar(mean_val, name="Mittelwert 2011 bis 2021:Q3") |>
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
