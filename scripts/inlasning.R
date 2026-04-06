library(tidyverse)
library(skimr)
library(patchwork)


orders_raw <- read_csv("data/ecommerce_orders.csv")

# 1) Dataförståelse

# Översikt över datasetet
glimpse(orders_raw)
skim_without_charts(orders_raw)

# Kontroll av eventuella outliers i unit_price
orders_raw %>%
  arrange(desc(unit_price)) %>%
  select(product_category, product_subcategory, unit_price, quantity) %>%
  head(5)

# Identifiera multipla varianter av städer
orders_raw %>%
  distinct(city) %>%
  arrange(city) %>%
  print(n = Inf)

#Fördelning av kategoriska variabler av betydelse för våra frågor
orders_raw %>% count(customer_type, sort = TRUE)
orders_raw %>% count(returned, sort = TRUE)

p1 <- ggplot(orders_raw, aes(x = customer_type)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Antal order per kundtyp",
       x = "Kundtyp",
       y = "Antal")

p2 <- ggplot(orders_raw, aes(x = returned)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Antal returer",
       x = "Returnerad",
       y = "Antal")

p3 <- ggplot(orders_raw, aes(y = unit_price)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Fördelning av unit_price",
       y = "Pris")

p4 <- ggplot(orders_raw, aes(y = shipping_days)) +
  geom_boxplot(fill = "steelblue") +
  labs(title = "Fördelning av shipping_days",
       y = "Leveransdagar")

p1 + p2 + p3 + p4
# Om en 2x2 behövs i Rmd-filen så skriv (p1 + p2) / (p3 + p4)

# beskriva kort vilka delar av datan som verkar viktigast för er analys
# --3. Finns det samband mellan rabatt och ordervärde?
# --5. Finns det tecken på att längre leveranstid hänger ihop med fler returer?
# --Förslag på egen fråga:
# --Skiljer sig köpbeteendet (ordervärde, rabatt, returgrad) mellan nya, återkommande och VIP-kunder?

# Dessa variabler är viktiga för oss:
# För fråga 3: discount_pct, unit_price x quantity
# för fråga 5: shipping days och returned
# Egen fråga: unit_price x quantity, discount_pct, returned och customer_type
# Notera: order_value behöver beräknas: unit_price * quantity * (1 - discount_pct)

# NOTERINGAR FRÅN DATAFÖRSTÅELSE
# ================================
# Datatyper: förslag på vad som bör ändras i stadning.R:
# - customer_segment, customer_type, region, city, product_category, product_subcategory, payment_method, campaign_source → factor
# - customer_type kan göras till ordnad faktor: New < Returning < VIP
# - returned till logical (Yes/No till TRUE/FALSE)

# Saknade värden: förslag på hantering i stadning.R:
# - city (21 st): påverkar inte våra analysfrågor, kan lämnas
# - payment_method (25 st): påverkar inte våra analysfrågor, kan lämnas
# - campaign_source (31 st): påverkar inte våra analysfrågor, kan lämnas
# - discount_pct (27 st): påverkar fråga 3 - då rabatt 0 finns angivet så är det troligt att NA är 0 och kan ersättas med det
# - shipping_days (22 st): påverkar fråga 5 - ta bort rader vid analys

# Övrigt att notera:
# - city har stavningsvarianter som behöver städas (se distinct-körningen)
# - unit_price max = 1626, ha i åtanke att använda median vid behov













