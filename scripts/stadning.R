orders_raw <- read_csv("data/ecommerce_orders.csv")
orders_clean <- orders_raw

names(orders_clean)

colSums(is.na(orders_clean))

orders_clean %>% distinct(customer_type) 
orders_clean %>% distinct(region) 
orders_clean %>% distinct(city) 
orders_clean %>% distinct(returned) 
orders_clean %>% distinct(quantity) 

# Gör om returned till logisk varibel
orders_clean <- orders_clean %>%
  mutate(returned = returned == "Yes")

count(orders_clean, returned)

# Städar city så att samma stad inte finns med olika stavning/format
orders_clean <- orders_clean %>%
  mutate(city = str_trim(city),
         city = str_to_title(city))

orders_clean %>% distinct(city)


# Kontrollerar de rader där rabatt saknas för att se om NA verkar betyda "ingen rabatt"
orders_clean %>%
  filter(is.na(discount_pct)) %>%
  select(order_id, customer_type, product_category, quantity, unit_price, discount_pct) %>%
  head(10)

# Osäkert om NA i discount_pct är samma som 0. Låter bli att hantera NA- värden i discount_pct. 
# Använd na.rm = TRUE i analys för discount_pct.


# Kontrollerar rader där leveransdagar saknas. Tittar på några relevanta kolumner för att se om något mönster syns
orders_clean %>%
  filter(is.na(shipping_days)) %>%
  select(order_id, customer_type, region, city, returned, shipping_days) %>%
  head(10)

# Hittade inga tydliga mönster för NA i shipping_days. Använd na.rm = TRUE i analys för shipping_days


# Skapar nya variabler som behövs i analysen
# order_value = ordervärde före rabatt
# price_after_discount = ordervärde efter att rabatt dragits av
orders_clean <- orders_clean %>%
  mutate(
    order_value = unit_price * quantity,
    price_after_discount = order_value * (1 - discount_pct)
  )

# Kontrollerar att de nya variablerna har skapats korrekt
orders_clean %>%
  select(unit_price, quantity, discount_pct, order_value, price_after_discount) %>%
  head(10)


# Sammanfattning:
# - returned har gjorts om från text till logisk variabel (TRUE/FALSE)
# - city har standardiserats för att undvika dubbla stavningsvarianter
# - saknade värden i discount_pct och shipping_days har kontrollerats
# - inga osäkra ersättningar har gjorts för NA-värden
# - nya analysvariabler har skapats: order_value och price_after_discount


















