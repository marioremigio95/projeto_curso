library(ggthemes)
library(colorspace)
library(cowplot)
library(tidyverse)
library(ggrepel)

df <- readRDS("data/ligue180.rds")

#cols <- c("#E69F00", "#56B4E9", "#009E73",
                # "#F0E442", "#0072B2", "#999999",
                # "#BC8F8F")

cols <- c("#DCDCDC", "#D3D3D3",
                 "#C0C0C0", "#A9A9A9", "#808080",
                 "#696969", "#000000")

#cols <- c("#FF7F50", "#FF6347",
                # "#DC143C", "#B22222", "#A52A2A",
                # "#8B0000", "#800000")

df %>%
   mutate(dia_semana = forcats::fct_relevel(dia_semana,
                                   "seg",
                                   "qua",
                                   "ter",
                                   "qui",
                                   "sex",
                                   "dom",
                                   "sáb"),
dia_semana = forcats::fct_rev(dia_semana)) %>%
# distinct(data, .keep_all = TRUE) %>%
ggplot(aes(x = dia_semana, fill = dia_semana)) +
geom_bar(width = 0.7, alpha = 1, color = 'black', size = 1) +
ggthemes::theme_hc() +
labs(y = "Número de Ligações",
     title = "Número de ligações para o 180 (violência doméstica) por dia da semana na RM de SP.\nAnos 2015, 2016, 2018 e 2019.") +
coord_flip() +
scale_x_discrete(breaks = c("seg", "qua", "ter", "qui", "sex", "dom", "sáb"),
labels = c("Seg", "Qua", "Ter", "Qui", "Sex", "Dom", "Sáb")) +
theme(legend.position = 'none',
axis.title.y = element_blank(),
axis.title.x = element_text(size = 15, color = 'black'),
axis.text.x = element_text(size = 12, color = 'black'),
axis.text.y = element_text(size = 12, color = 'black')) +
ylim(c(0, 10000)) +
  scale_color_manual(
    values = darken(cols, 0.3)
  ) +
  scale_fill_manual(
    values = cols
  ) +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.major.x = element_line(size = .5, color = "darkgray"))
