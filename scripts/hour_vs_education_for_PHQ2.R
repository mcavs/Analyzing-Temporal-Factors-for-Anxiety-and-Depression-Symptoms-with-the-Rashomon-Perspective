################################################################################
library(readr)
library(tidyverse)
library(DALEX)
library(randomForest)
library(dplyr)
library(ggplot2)

datadf     <- read_csv("Dataset2020_2024_PHQ4_Rashomon.csv")

datadf     <- datadf |>
  mutate(date_parsed     = as.POSIXct(date_modified, format = "%m/%d/%Y %I:%M:%S %p"),
         weekday_weekend = ifelse(weekdays(date_parsed) %in% c("Saturday", "Sunday"), "Weekend", "Weekday"),
         hour_numeric    = as.numeric(format(date_parsed, "%H")) + as.numeric(format(date_parsed, "%M")) / 60)

datadf     <- datadf[datadf$sex != "Other",]
datadf$sex <- factor(datadf$sex)

datadf <- datadf |> mutate(PHQ2_score_cat = ifelse(PHQ2_score >= 3, 1, 0))
datadf <- datadf |> mutate(GAD2_score_cat = ifelse(GAD2_score >= 3, 1, 0))
################################################################################
set.seed(123)

N <- 100
n <- nrow(datadf)

ndf        <- list()
models     <- list()
explainers <- list()
profiles   <- list()
profiles_w <- list()

for (i in 1:N) {
  ndf[[i]]        <- datadf[sample(1:n, n, replace = TRUE), ]
  models[[i]]     <- randomForest(factor(PHQ2_score_cat) ~ age + education + sex + weekday_weekend + hour_numeric,
                                  data = ndf[[i]])
  explainers[[i]] <- DALEX::explain(models[[i]],
                                    data = ndf[[i]][, c(8, 9, 10, 11, 15, 16)],
                                    y = ndf[[i]]$PHQ2_score_cat,
                                    verbose = FALSE)
  profiles[[i]]   <- model_profile(explainers[[i]], variable_splits = list(hour_numeric = 0:23), N = NULL)
  profiles_w[[i]] <- model_profile(explainers[[i]], groups = "education",
                                   variable_splits = list(hour_numeric = 0:23), N = NULL)
  
  profiles[[i]]$cp_profiles   <- NULL
  profiles_w[[i]]$cp_profiles <- NULL
  
  cat(i, "\n")
}

tmp_w <- lapply(1:length(profiles_w), function(i) data.frame(profiles_w[[i]]$agr_profiles, idx = i))
all_profiles_w <- do.call(rbind, tmp_w)

# new line, fixed naming
colnames(all_profiles_w) <- substr(colnames(all_profiles_w), 2, 100)

ribbons_w <- all_profiles_w |>
  group_by(`_x_`, `_groups_`) |>
  summarise(
    x    = mean(`_x_`),
    min  = min(`_yhat_`),
    q025 = quantile(`_yhat_`, 0.025),
    q975 = quantile(`_yhat_`, 0.975),
    max  = max(`_yhat_`),
    avg  = mean(`_yhat_`),
    sd   = sd(`_yhat_`)
  )

#ggplot(all_profiles_w, aes(`_x_`, `_yhat_`)) +
#  geom_ribbon(data = ribbons_w,
#              aes(y = avg, ymin = q025, ymax = q975, x = x, fill = factor(`_groups_`)),
#              alpha = 0.2) +
#  geom_line(data = ribbons_w,
#            aes(y = avg, x = x, color = factor(`_groups_`))) +
#  theme_bw() +
#  xlab("Hour of Day") +
#  ylab("Partial Dependence") +
#  scale_fill_discrete("Weekday/Weekend") +
#  scale_color_discrete("Weekday/Weekend") +
#  ggtitle(
#    "Percentile Bootstrap Intervals (alpha=0.05) for Random Forest PD profiles - PHQ2",
#    subtitle = paste(N, "replications")
#  )

saveRDS(all_profiles_w, "profiles_hour_vs_education_for_PHQ2.rds")
