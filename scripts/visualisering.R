library(tidyverse)

# Laddar in 'orders_clean'
source("scripts/stadning.R")



# Sambandet mellan rabatt och ordervärde
p_discount <- ggplot(orders_clean, aes(x = discount_pct, y = order_value)) + 
  geom_point(alpha = 0.5, color = "steelblue") +
  geom_smooth(method = "lm", se = TRUE) +
  labs(
    title = "Samband mellan rabatt och ordervärde",
    x = "Rabatt (%)",
    y = "Ordervärde"
    ) +
  theme_minimal()

p_discount

# Variationen är stor därmed verkar sambandet mellan rabatt och ordervärdet verkar svagt.



# Leveranstid vs retur

  # Grupperar in leveranstid
orders_clean <- orders_clean %>%
  mutate(
    shipping_group = case_when(
      shipping_days <= 3 ~ "Snabb",
      shipping_days <= 7 ~ "Medel snabb",
      TRUE ~ "Lång"
    )
  )


p_shipping_return <- ggplot(orders_clean, aes(x = shipping_group, fill = factor(returned, labels = c("Nej", "Ja")))) + 
  geom_bar(alpha = 0.7, position = "fill") + 
  labs(
    title = "Samband mellan leveranstid och retur",
    x = "Leveranstid",
    y = "Andel",
    fill = "Returnerad"
    ) +
theme_minimal()
p_shipping_return

# Andelen returer ökar vid längre leveranstider som pekar på ett möjligt samband.



# Visualisering för ordervärde per kundtyp
p_customer_value <- ggplot(orders_clean, aes(x = customer_type, y = order_value)) +
  geom_boxplot(alpha = 0.7) +
  labs (
    title = "Ordervärde per kundtyp",
    x = "Kundtyp", 
    y = "Ordervärde"
    ) +
  coord_flip() +
  theme_minimal() 
p_customer_value

# Boxplotten visar att återkommande kunder har fler extremvärden jämfört med resterande kundtyper annars är ordervärdet relativt liknande mellan kundtyperna. 


# Visualisering för returgrad per kundtyp
p_customer_return <- ggplot(orders_clean, aes(x = customer_type, fill = factor(returned, labels = c("Nej", "Ja")))) +
  geom_bar(alpha = 0.7, position = "fill") + 
  labs(
    title = "Returgrad per kundtyp",
    x = "Kundtyp",
    y = "Andel",
    fill = "Returnerad"
  ) +
theme_minimal()
p_customer_return

# Diagrammet visar att nya kunder har en något högre returgrad än de övriga kundtyperna.

# Sparar visualiseringar

ggsave("output/visualisering/discount.png", p_discount, width = 8, height = 5)
ggsave("output/visualisering/shipping_return.png", p_shipping_return, width = 8, height = 5)
ggsave("output/visualisering/customer_value.png", p_customer_value, width = 8, height = 5)
ggsave("output/visualisering/customer_return.png", p_customer_return, width = 8, height = 5)

