#' Este codigo:
#'  1) importa as bases cruas das ligacoes para o 180;
#'  2) as limpa;
#'  3) as junta;
#'  4) e salva a base resultante que será utilizada na análise;

library(tidyverse)

source("R/limpeza.R")

ligue180_2015 <- readxl::read_xlsx("data-raw/ligue180_2015.xlsx")

ligue180_2016 <- readxl::read_xlsx("data-raw/ligue180_2016.xlsx")

ligue180_2018_2019 <- readxl::read_xlsx("data-raw/ligue180_2018_2019.xlsx",
                  skip = 8)

ligue180 <- map_df(list(ligue180_2015,
                         ligue180_2016,
                         ligue180_2018_2019
                        ),
                   limpeza
                   )

write_rds(ligue180, "data/ligue180.rds")
