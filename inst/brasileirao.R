library(brasileirao)

brasileirao <- matches %>%
  mutate(home = stringr::str_to_lower(home),
         home = stringr::str_remove_all(home, "[:punct:]"),
         home = stringi::stri_trans_general(home, "Latin-ASCII"),
         away = stringr::str_to_lower(away),
         away = stringr::str_remove_all(away, "[:punct:]"),
         away = stringi::stri_trans_general(away, "Latin-ASCII")
         ) %>%
  filter(home %in% c("palmeiras", "sao paulo", "corinthians",
                     "vasco", "flamengo", "botafogo", "fluminense",
                     "atletico mg", "cruzeiro") |
         away %in% c("palmeiras", "sao paulo", "corinthians",
                     "vasco", "flamengo", "botafogo", "fluminense",
                     "atletico mg", "cruzeiro")) %>%
  mutate(home_score = as.integer(stringr::str_extract(score, "[:digit:]")),
         away_score = as.integer(stringr::str_extract(score, "[:digit:]$")),
         dif = home_score - away_score) %>%
  mutate(resultado_home = case_when(
    home %in% c("palmeiras", "sao paulo", "corinthians",
                "vasco", "flamengo", "botafogo", "fluminense",
                "atletico mg", "cruzeiro") & dif > 0 ~ "venceu",
    home %in% c("palmeiras", "sao paulo", "corinthians",
                "vasco", "flamengo", "botafogo", "fluminense",
                "atletico mg", "cruzeiro") & dif < 0 ~ "perdeu",
    home %in% c("palmeiras", "sao paulo", "corinthians",
                "vasco", "flamengo", "botafogo", "fluminense",
                "atletico mg", "cruzeiro") & dif == 0 ~ "empatou",
         ),
         resultado_away = case_when(
    away %in% c("palmeiras", "sao paulo", "corinthians",
                "vasco", "flamengo", "botafogo", "fluminense",
                "atletico mg", "cruzeiro") & dif < 0 ~ "venceu",
    away %in% c("palmeiras", "sao paulo", "corinthians",
                "vasco", "flamengo", "botafogo", "fluminense",
                "atletico mg", "cruzeiro") & dif > 0 ~ "perdeu",
    away %in% c("palmeiras", "sao paulo", "corinthians",
                       "vasco", "flamengo", "botafogo", "fluminense",
                       "atletico mg", "cruzeiro") & dif == 0 ~ "empatou"
         )
    ) %>%
  mutate(palmeiras_perdeu = if_else((home == "palmeiras" & resultado_home == 'perdeu') |
                                    (away == "palmeiras" & resultado_away == 'perdeu'), 1, 0),
         corinthians_perdeu = if_else((home == "corinthians" & resultado_home == 'perdeu') |
                                      (away == "corinthians" & resultado_away == 'perdeu'), 1, 0),
         sao_paulo_perdeu = if_else((home == "sao paulo" & resultado_home == 'perdeu') |
                                      (away == "sao paulo" & resultado_away == 'perdeu'), 1, 0),
         flamengo_perdeu = if_else((home == "flamengo" & resultado_home == 'perdeu') |
                                      (away == "flamengo" & resultado_away == 'perdeu'), 1, 0),
         vasco_perdeu = if_else((home == "vasco" & resultado_home == 'perdeu') |
                                      (away == "vasco" & resultado_away == 'perdeu'), 1, 0),
         fluminense_perdeu = if_else((home == "fluminense" & resultado_home == 'perdeu') |
                                      (away == "fluminense" & resultado_away == 'perdeu'), 1, 0),
         botafogo_perdeu = if_else((home == "botafogo" & resultado_home == 'perdeu') |
                                      (away == "botafogo" & resultado_away == 'perdeu'), 1, 0),
         cruzeiro_perdeu = if_else((home == "cruzeiro" & resultado_home == 'perdeu') |
                                      (away == "cruzeiro" & resultado_away == 'perdeu'), 1, 0),
         atletico_mg_perdeu = if_else((home == "atletico mg" & resultado_home == 'perdeu') |
                                      (away == "atletico mg" & resultado_away == 'perdeu'), 1, 0)
         ) %>%
  group_by(date) %>%
  summarise(across(.cols = contains("perdeu"),
                   .fns = sum, na.rm = T)) %>%
  ungroup() %>%
  mutate(
    data = lubridate::date(date),
    ano = lubridate::year(date),
    mes = lubridate::month(date),
    semana = lubridate::week(date),
    dia = lubridate::day(date),
    dia_semana = forcats::as_factor(lubridate::wday(date, label = TRUE))
  ) %>%
  filter(ano %in% c(2015, 2016, 2018, 2019)) %>%
  mutate(perdeu_sp = sao_paulo_perdeu + palmeiras_perdeu + corinthians_perdeu,
         perdeu_sp = if_else(perdeu_sp >= 1, 1, 0),
         perdeu_rj = flamengo_perdeu + vasco_perdeu + fluminense_perdeu + botafogo_perdeu,
         perdeu_rj = if_else(perdeu_rj >= 1, 1, 0),
         perdeu_bh = cruzeiro_perdeu + atletico_mg_perdeu,
         perdeu_bh = if_else(perdeu_bh >= 1, 1, 0)
         )

plot2 <- brasileirao %>%
  mutate(dia_semana = forcats::fct_relevel(dia_semana,
                                           "dom",
                                           "sáb",
                                           "qua",
                                           "seg",
                                           "qui",
                                           "ter",
                                           "sex"),
         dia_semana = forcats::fct_rev(dia_semana)) %>%
  # distinct(data, .keep_all = TRUE) %>%
  ggplot(aes(x = dia_semana, fill = dia_semana)) +
  geom_bar(width = 0.7, alpha = 1, color = 'black', size = 1) +
  ggthemes::theme_hc() +
 # labs(y = "Número de Ligações",
 #       title = "Número de ligações para o 180 (violência doméstica) por dia da semana na RM de SP.\nAnos 2015, 2016, 2018 e 2019.") +
  coord_flip() +
  scale_x_discrete(breaks = c("seg", "qua", "ter", "qui", "sex", "dom", "sáb"),
                   labels = c("Seg", "Qua", "Ter", "Qui", "Sex", "Dom", "Sáb")) +
  theme(legend.position = 'none',
        axis.title.y = element_blank(),
        axis.title.x = element_text(size = 15, color = 'black'),
        axis.text.x = element_text(size = 12, color = 'black'),
        axis.text.y = element_text(size = 12, color = 'black')) +
  #ylim(c(0, 30000)) +
  scale_color_manual(
    values = darken(cols, 0.3)
  ) +
  scale_fill_manual(
    values = cols
  ) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(size = .5, color = "darkgray"))


