
dias_perdeu_sp <- brasileirao %>%
  filter(perdeu_sp == 1) %>%
  pull(data)

dias_perdeu_rj <- brasileirao %>%
  filter(perdeu_rj == 1) %>%
  pull(data)

dias_perdeu_bh <- brasileirao %>%
  filter(perdeu_bh == 1) %>%
  pull(data)

lag_df <- function(df) {

  df %>%
    mutate(ligacoes_no_dia_posterior = lead(ligacoes_no_dia))

}

df <- ligue180 %>%
  mutate(time_perdeu = case_when(
    uf == 'SP' & data %in% dias_perdeu_sp ~ 1,
    uf == 'RJ' & data %in% dias_perdeu_rj ~ 1,
    uf == 'BH' & data %in% dias_perdeu_bh ~ 1,
    TRUE ~ 0
                                )
         ) %>%
  group_by(data, uf) %>%
  distinct(data, .keep_all = T) %>%
  ungroup() %>%
  filter(grupo %in% c('violencia domestica e familiar',
                      'feminicidio')) %>%
  arrange(data) %>%
  group_by(uf) %>%
  group_split() %>%
  map_df(~lag_df(.)) %>%
  arrange(data)



fixest::feols(fml = ligacoes_no_dia_posterior ~ time_perdeu | uf + dia_semana, data = df)
