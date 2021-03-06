library(dplyr)
library(ggplot2)
library(AER)
library(lfe)
library(stargazer)

setwd("~/eip-eateries-research")
restaurant_df = read.csv("data/restaurant_processed_option1.csv")

# remove restaurants that are not serving Chinese, Malay or Indian cuisine (irrelevant to regression)
restaurant_df$include = sign(restaurant_df$Chinese + restaurant_df$Malay + restaurant_df$Indian)
restaurant_df = restaurant_df %>% filter(include == 1)

#### PRELIM REGRESSION MODEL ####
# 500 METRES (WALKING DISTANCE) #
# filter for information
restaurant_df_500m = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_05", 
                                              "malay_proportion_05", "indian_other_proportion_05", 
                                              "chi_quota_05", "malay_quota_05", "io_quota_05")

restaurant_df_500m = restaurant_df_500m[complete.cases(restaurant_df_500m), ]

# regressions
lm_500m_chinese = lm(Chinese ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 + malay_proportion_05, data=restaurant_df_500m)
lm_500m_malay = lm(Malay ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 + malay_proportion_05, data=restaurant_df_500m)
lm_500m_indian = lm(Indian ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 + malay_proportion_05,data=restaurant_df_500m)

stargazer(lm_500m_chinese, lm_500m_malay, lm_500m_indian, 
          type = "text",
          label = "regression_option1_500m_prelim",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion"),
          out = "results/regressions_v2/option1_500m_prelim.tex")


# 1 KM #
# filter for information
restaurant_df_1km = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_1", 
                                             "malay_proportion_1", "indian_other_proportion_1", 
                                             "chi_quota_1", "malay_quota_1", "io_quota_1")

restaurant_df_1km = restaurant_df_1km[complete.cases(restaurant_df_1km), ]

# regressions
lm_1km_chinese = lm(Chinese ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 + malay_proportion_1, data=restaurant_df_1km)
lm_1km_malay = lm(Malay ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 + malay_proportion_1, data=restaurant_df_1km)
lm_1km_indian = lm(Indian ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 + malay_proportion_1,data=restaurant_df_1km)

stargazer(lm_1km_chinese, lm_1km_malay, lm_1km_indian, 
          type = "text",
          label = "regression_option1_1km_prelim",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion"),
          out = "results/regressions_v2/option1_1km_prelim.tex")

#### COMPETITION REGRESSION MODEL ####
# 500 METRES (WALKING DISTANCE) #
# filter for information
restaurant_df_500m = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_05", 
                                              "malay_proportion_05", "indian_other_proportion_05", 
                                              "chi_quota_05", "malay_quota_05", "io_quota_05", 
                                              "competition_chinese_proportion_05", 
                                              "competition_malay_proportion_05",
                                              "competition_indian_proportion_05")

restaurant_df_500m = restaurant_df_500m[complete.cases(restaurant_df_500m), ]


# regressions
lm_500m_chinese_comp = lm(Chinese ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                          + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05, 
                          data=restaurant_df_500m)
lm_500m_malay_comp = lm(Malay ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                        + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05,
                        data=restaurant_df_500m)
lm_500m_indian_comp = lm(Indian ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                         + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05,
                         data=restaurant_df_500m)

stargazer(lm_500m_chinese_comp, lm_500m_malay_comp, lm_500m_indian_comp, 
          type = "text",
          label = "regression_option1_500m_competition",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion",
            "Chinese Cuisine Proportion", "Malay Cuisine Proportion"),
          out = "results/regressions_v2/option1_500m_competition.tex")


# 1 KM #
# filter for information
restaurant_df_1km = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_1", 
                                             "malay_proportion_1", "indian_other_proportion_1", 
                                             "chi_quota_1", "malay_quota_1", "io_quota_1",
                                             "competition_chinese_proportion_1", 
                                             "competition_malay_proportion_1",
                                             "competition_indian_proportion_1")

restaurant_df_1km = restaurant_df_1km[complete.cases(restaurant_df_1km), ]

# regressions
lm_1km_chinese_comp = lm(Chinese ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                         + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1,
                         data=restaurant_df_1km)
lm_1km_malay_comp= lm(Malay ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                      + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1,
                      data=restaurant_df_1km)
lm_1km_indian_comp = lm(Indian ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                        + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1, 
                        data=restaurant_df_1km)

stargazer(lm_1km_chinese_comp, lm_1km_malay_comp, lm_1km_indian_comp, 
          type = "text",
          label = "regression_option1_1km_competition",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion",
            "Chinese Cuisine Proportion", "Malay Cuisine Proportion"),
          out = "results/regressions_v2/option1_1km_competition.tex")

#### COMPETITION + PRICE REGRESSION MODEL ####
# 500 METRES (WALKING DISTANCE) #
# filter for information
restaurant_df_500m = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_05", 
                                              "malay_proportion_05", "indian_other_proportion_05", 
                                              "chi_quota_05", "malay_quota_05", "io_quota_05", 
                                              "competition_chinese_proportion_05", "competition_malay_proportion_05",
                                              "competition_indian_proportion_05", "price_per_pax")

restaurant_df_500m = restaurant_df_500m[complete.cases(restaurant_df_500m), ]


# regressions
lm_500m_chinese_price = lm(Chinese ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                           + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05
                           + price_per_pax, data=restaurant_df_500m)
lm_500m_malay_price = lm(Malay ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                         + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05
                         + price_per_pax, data=restaurant_df_500m)
lm_500m_indian_price = lm(Indian ~ chi_quota_05 + malay_quota_05 + io_quota_05 + chinese_proportion_05 
                          + malay_proportion_05 + competition_chinese_proportion_05 + competition_malay_proportion_05
                          + price_per_pax, data=restaurant_df_500m)

stargazer(lm_500m_chinese_price, lm_500m_malay_price, lm_500m_indian_price, 
          type = "text",
          label = "regression_option1_500m_competition_price",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion",
            "Chinese Cuisine Proportion", "Malay Cuisine Proportion",
            "Price Per Pax"),
          out = "results/regressions_v2/option1_500m_competition_price.tex")


# 1 KM #
# filter for information
restaurant_df_1km = restaurant_df %>% select("Chinese", "Malay", "Indian", "chinese_proportion_1", 
                                             "malay_proportion_1", "indian_other_proportion_1", 
                                             "chi_quota_1", "malay_quota_1", "io_quota_1",
                                             "competition_chinese_proportion_1", "competition_malay_proportion_1",
                                             "competition_indian_proportion_1", "price_per_pax")

restaurant_df_1km = restaurant_df_1km[complete.cases(restaurant_df_1km), ]

# regressions
lm_1km_chinese_price = lm(Chinese ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                          + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1
                          + price_per_pax, data=restaurant_df_1km)
lm_1km_malay_price = lm(Malay ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                        + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1
                        + price_per_pax, data=restaurant_df_1km)
lm_1km_indian_price = lm(Indian ~ chi_quota_1 + malay_quota_1 + io_quota_1 + chinese_proportion_1 
                         + malay_proportion_1 + competition_chinese_proportion_1 + competition_malay_proportion_1
                         + price_per_pax, data=restaurant_df_1km)

stargazer(lm_1km_chinese_price, lm_1km_malay_price, lm_1km_indian_price, 
          type = "text",
          label = "regression_option1_1km_competition_price",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c(
            "Chinese Quota", "Malay Quota", "Indian/Others Quota",
            "Chinese Ethnic Proportion","Malay Ethnic Proportion",
            "Chinese Cuisine Proportion", "Malay Cuisine Proportion",
            "Price Per Pax"),
          out = "results/regressions_v2/option1_1km_competition_price.tex")

#### COLLATED RESULTS ####
stargazer(lm_500m_chinese, lm_500m_malay, lm_500m_indian,
          lm_500m_chinese_comp, lm_500m_malay_comp, lm_500m_indian_comp,
          lm_500m_chinese_price, lm_500m_malay_price, lm_500m_indian_price, 
          type = "text",
          label = "regression_option1_500m_collated",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine",
                           "Chinese Cuisine", "Malay Cuisine", "Indian Cuisine",
                           "Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c("Chinese Quota", "Malay Quota", "Indian/Others Quota",
                             "Chinese Ethnic Proportion","Malay Ethnic Proportion", 
                             "Chinese Cuisine Proportion", "Malay Cuisine Proportion",
                             "Price Per Pax"),
          out = "results/regressions_v2/option1_500m_collated.tex")

stargazer(lm_1km_chinese, lm_1km_malay, lm_1km_indian,
          lm_1km_chinese_comp, lm_1km_malay_comp, lm_1km_indian_comp,
          lm_1km_chinese_price, lm_1km_malay_price, lm_1km_indian_price, 
          type = "text",
          label = "regression_option1_1km_collated",
          title = "Regression Results", 
          align=TRUE,
          dep.var.labels=c("Chinese Cuisine", "Malay Cuisine", "Indian Cuisine",
                           "Chinese Cuisine", "Malay Cuisine", "Indian Cuisine",
                           "Chinese Cuisine", "Malay Cuisine", "Indian Cuisine"),
          covariate.labels=c("Chinese Quota", "Malay Quota", "Indian/Others Quota",
                             "Chinese Ethnic Proportion","Malay Ethnic Proportion", 
                             "Chinese Cuisine Proportion", "Malay Cuisine Proportion", 
                             "Price Per Pax"),
          out = "results/regressions_v2/option1_1km_collated.tex")

