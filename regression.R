setwd("~/eip-eateries-research")
df = read.csv("data/restaurant_hdb_combined.csv")

library(dplyr)
library(ggplot2)
library(AER)
library(lfe)
library(stargazer)

df_05 = df %>% filter(!is.na(chinese_quota_0.5))
df_10 = df %>% filter(!is.na(chinese_quota_1.0))
df_50 = df %>% filter(!is.na(chinese_quota_5.0))

summary(lm(Chinese ~ chinese_quota_0.5 + malay_quota_0.5 + indian_other_quota_0.5, data=df_05))
# Call:
#   lm(formula = Chinese ~ chinese_quota_0.5 + malay_quota_0.5 + 
#        indian_other_quota_0.5, data = df_05)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -0.2043 -0.1949 -0.1802 -0.1728  0.8834 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)             0.204273   0.006951  29.386  < 2e-16 ***
#   chinese_quota_0.5      -0.031283   0.011061  -2.828  0.00469 ** 
#   malay_quota_0.5        -0.035654   0.023984  -1.487  0.13715    
# indian_other_quota_0.5 -0.064626   0.023714  -2.725  0.00644 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.3881 on 10169 degrees of freedom
# Multiple R-squared:  0.001267,	Adjusted R-squared:  0.0009723 
# F-statistic:   4.3 on 3 and 10169 DF,  p-value: 0.004876

summary(lm(Malay ~ chinese_quota_0.5 + malay_quota_0.5 + indian_other_quota_0.5, data=df_05))
# Call:
#   lm(formula = Malay ~ chinese_quota_0.5 + malay_quota_0.5 + indian_other_quota_0.5, 
#      data = df_05)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -0.07738 -0.03717 -0.02986 -0.01911  0.98453 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)             0.039144   0.003052  12.826  < 2e-16 ***
#   chinese_quota_0.5      -0.023678   0.004856  -4.876  1.1e-06 ***
#   malay_quota_0.5         0.038236   0.010530   3.631 0.000283 ***
#   indian_other_quota_0.5 -0.007334   0.010412  -0.704 0.481166    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.1704 on 10169 degrees of freedom
# Multiple R-squared:  0.005096,	Adjusted R-squared:  0.004803 
# F-statistic: 17.36 on 3 and 10169 DF,  p-value: 3.059e-11

summary(lm(Indian_Type3 ~ chinese_quota_0.5 + malay_quota_0.5 + indian_other_quota_0.5, data=df_05))
# Call:
#   lm(formula = Indian ~ chinese_quota_0.5 + malay_quota_0.5 + indian_other_quota_0.5, 
#      data = df_05)
# 
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -0.26190 -0.02680 -0.01972 -0.01782  0.99563 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)             0.020545   0.003139   6.546  6.2e-11 ***
#   chinese_quota_0.5      -0.002936   0.004994  -0.588    0.557    
# malay_quota_0.5        -0.016179   0.010829  -1.494    0.135    
# indian_other_quota_0.5  0.241350   0.010708  22.540  < 2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.1753 on 10169 degrees of freedom
# Multiple R-squared:  0.05234,	Adjusted R-squared:  0.05206 
# F-statistic: 187.2 on 3 and 10169 DF,  p-value: < 2.2e-16
