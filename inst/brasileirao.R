library(brasileirao)

df <- matches %>%
  mutate(
    data = lubridate::date(date),
    ano = lubridate::year(date),
    mes = lubridate::month(date),
    semana = lubridate::week(date),
    dia = lubridate::day(date),
    dia_semana = forcats::as_factor(lubridate::wday(date, label = TRUE))
  ) %>%
  filter(ano %in% c(2015, 2016, 2018, 2019)) %>%
  filter(home %in% c("Palmeiras", "São Paulo", "Corinthians") |
         away %in% c("Palmeiras", "São Paulo", "Corinthians")) %>%
  mutate(home_score = as.integer(stringr::str_extract(score, "[:digit:]")),
         away_score = as.integer(stringr::str_extract(score, "[:digit:]$")),
         dif = home_score - away_score) %>%
  mutate(resultado = case_when(
    home %in% c("Palmeiras", "São Paulo", "Corinthians") & dif > 0 ~ "venceu",
    home %in% c("Palmeiras", "São Paulo", "Corinthians") & dif < 0 ~ "perdeu",
    away %in% c("Palmeiras", "São Paulo", "Corinthians") & dif < 0 ~ "venceu",
    away %in% c("Palmeiras", "São Paulo", "Corinthians") & dif > 0 ~ "perdeu",
    home %in% c("Palmeiras", "São Paulo", "Corinthians") & dif == 0 ~ "empatou",
    away %in% c("Palmeiras", "São Paulo", "Corinthians") & dif == 0 ~ "empatou"
    ))
