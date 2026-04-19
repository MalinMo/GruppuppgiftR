# Ladda paket
library(tidyverse)

# Kör städningsskriptet för att få in 'orders_clean' i minnet
source("scripts/stadning.R")

# ==========================================
# FRÅGA 3: Samband mellan rabatt och ordervärde
# ==========================================
# Variabler: discount_pct (numerisk), order_value (numerisk)

discount_impact <- orders_clean %>%
  # Vi behöver inte group_by här, eftersom vi vill se sambandet över hela datasetet
  summarise(
    correlation = cor(discount_pct, order_value, use = "complete.obs")
  )

# Visa resultatet
print(discount_impact)


# ==========================================
# FRÅGA 5: Leveranstid och returer
# ==========================================
# Variabler: shipping_days (numerisk), returned (logisk)

shipping_return_summary <- orders_clean %>%
  # Steg 1: Gruppera på om varan returnerades eller inte (TRUE / FALSE)
  group_by(returned) %>%
  
  # Steg 2: Räkna ut den genomsnittliga leveranstiden för båda grupperna
  summarise(
    avg_shipping_days = mean(shipping_days, na.rm = TRUE),
    order_count = n() # n() räknar hur många ordrar som finns i varje grupp
  )

# Visa resultatet
print(shipping_return_summary)


# ==========================================
# EGEN FRÅGA: Köpbeteende mellan kundtyper
# ==========================================
# Variabler: customer_type (faktor), order_value, discount_pct, returned

# Skapa en sammanställning av köpbeteende per kundtyp
customer_summary <- orders_clean %>%
  
  # Steg 1: "Split" - Gruppera datat baserat på kundtyp
  group_by(customer_type) %>%
  
  # Steg 2: "Apply & Combine" - Räkna ut medelvärden
  summarize(
    avg_order_value = mean(order_value, na.rm = TRUE),
    avg_quantity    = mean(quantity, na.rm = TRUE),      # Ny rad: testar antal varor
    avg_unit_price  = mean(unit_price, na.rm = TRUE),    # Ny rad: testar snittpris per vara
    avg_discount = mean(discount_pct, na.rm = TRUE),
    
    # Eftersom 'returned' är TRUE/FALSE (1/0), ger mean() oss en procentandel!
    return_rate = mean(returned, na.rm = TRUE) 
  )

# Visa tabellen
print(customer_summary)