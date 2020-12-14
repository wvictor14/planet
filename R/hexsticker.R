# create hex sticker
#I created a placenta vector .pdf image saved in man/figures/placenta_vector.pdf
library(hexSticker)
library(tidyverse)
here::here('man', 'figures', 'placenta_vector.svg') %>%
  sticker(package = "planet",
          p_size = 20,
          p_color = "firebrick",
          s_x = 1,
          s_y = 0.75,
          s_width = 0.4*1.4,
          s_height = 0.4*1.2,
          h_fill = "white",
          h_color = "firebrick",
          filename = here::here("man", "figures", "hexsticker.png"),
          dpi = 300)
