library(tidyverse)

orders_raw <- read_csv("ecommerce_orders.csv")

# 1) Dataförståelse

# datasetets storlek
glimpse(orders_raw)

# typer av variabler som finns
# --vilka variabler som finns
names(orders_raw)

# --vilka variabler som är numeriska
orders_raw %>% 
  select(where(is.numeric)) %>% 
  names()

# --vilka variabler som är kategoriska eller text
orders_raw %>% 
  select(where(is.character)) %>% 
  names()

# identifiera saknade värden
# --i vilka kolumner finns det saknade värden
orders_raw %>% 
  summarise(
    across(everything(), ~ sum(is.na(.)))) %>% 
        pivot_longer(everything(), names_to = "kolumn", values_to = "saknas värden")

# beskriva kort vilka delar av datan som verkar viktigast för er analys
# --3. Finns det samband mellan rabatt och ordervärde?
# --5. Finns det tecken på att längre leveranstid hänger ihop med fler returer?
# --Förslag på egen fråga:
# --Skiljer sig köpbeteendet (ordervärde, rabatt, returgrad) mellan nya, återkommande och VIP-kunder?

# Dessa variabler är viktiga för oss:
# För fråga 3: discount_pct, unit_price x quantity
# för fråga 5: shipping days och returned
# Egen fråga: unit_price x quantity, discount_pct, returned och customer_type
# Notera: order_value behöver beräknas: unit_price * quantity