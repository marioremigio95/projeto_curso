library(dplyr)
library(magrittr)

df <- rio::import("D:/Downloads/boletins.csv", encoding = "UTF-8") %>%
  rename(municipio = CIDADE)

df <- df %>%
  as_tibble() %>%
  janitor::remove_empty() %>%
  janitor::clean_names() %>%
#  rename(municipio = cidade) %>%
  mutate(municipio = stringr::str_replace(municipio, "\\.", " "),
         municipio = stringr::str_to_lower(municipio),
         municipio = stringr::str_remove_all(municipio, "[:punct:]"),
         municipio = stringi::stri_trans_general(municipio, "Latin-ASCII")) %>%
  filter(municipio %in% c("s paulo",
                          "aruja",
                          "barueri",
                          "biritiba mirim",
                          "caieiras",
                          "cajamar",
                          "carapicuiba",
                          "cotia",
                          "diadema",
                          "embu das artes",
                          "embu guaçu",
                          "embu guacu",
                          "francisco morato",
                          "franco da rocha",
                          "guararema",
                          "guarulhos",
                          "itapecerica da serra",
                          "itapevi",
                          "itaquaquecetuba",
                          "jandira",
                          "juquitiba",
                          "mairipora",
                          "maua",
                          "mogi das cruzes",
                          "osasco",
                          "pirapora do bom jesus",
                          "poa",
                          "ribeirao pires",
                          "rio grande da serra",
                          "salesopolis",
                          "s isabel",
                          "santana de parnaiba",
                          "s de parnaiba",
                          "s andre",
                          "s caetano do sul",
                          "s bernardo do campo",
                          "s lourenço da serra",
                          "s lourenco da serra",
                          "suzano",
                          "taboao da serra",
                          "vargem grande paulista")) %>%
  mutate(data_ocorrencia_bo = format.Date(lubridate::as_date(data_ocorrencia_bo), "%d-%m-%Y")) %>%
  mutate(data_comunicacao_bo = format.Date(data_comunicacao_bo, "%d-%m-%Y")) %>%
  mutate(dif = lubridate::as.period(lubridate::dmy(data_comunicacao_bo) -
                                    lubridate::dmy(data_ocorrencia_bo))/
                                      lubridate::days(1))

df %>%
  mutate(data_ocorrencia_bo = as.Date(data_ocorrencia_bo, format = "%d-%m-%Y")) %>%
  mutate(data_comunicacao_bo = as.Date(data_comunicacao_bo, format = "%d-%m-%Y")) %>%
  mutate(
    data = lubridate::date(data_ocorrencia_bo),
    ano = lubridate::year(data_ocorrencia_bo),
    mes = lubridate::month(data_ocorrencia_bo),
    semana = lubridate::week(data_ocorrencia_bo),
    dia = lubridate::day(data_ocorrencia_bo),
    dia_semana = forcats::as_factor(lubridate::wday(data_ocorrencia_bo, label = TRUE))
  ) %>% glimpse()
