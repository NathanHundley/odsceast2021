# Packages ####

# forecasting
library(fable)
# plotting
library(feasts)
library(ggplot2)
library(timetk)
# time series data manipulation
library(tsibble)
# data manipulation
library(dplyr)
library(tidyr)
library(purrr)


# Data ####

elec <- readr::read_csv('data/electricity_france.csv')
elec

elec <- elec %>% 
    as_tsibble(index=Date) %>% 
    mutate(Year=lubridate::year(Date)) %>% 
    filter_index('2007' ~ .)

# Time Series Formats ####

ts_elec <- ts(elec$ActivePower, start=min(elec$Date), end=max(elec$Date))
ts_elec
ts_elec %>% class()
ts_elec %>% plot()

xts_elec <- xts::as.xts(ts_elec)
xts_elec
xts_elec %>% class()

xts_elec %>% plot()

# Visualization ####

# from {feats}

elec %>% autoplot(ActivePower)
elec %>% gg_season(ActivePower, period='year')

# from {timetk}

elec %>% 
    plot_time_series(
        .date_var=Date, .value=ActivePower)
elec %>% 
    plot_time_series(
        .date_var=Date, .value=ActivePower, 
        .interactive=FALSE
    )

elec %>% 
    plot_time_series(
        .date_var=Date, .value=ActivePower, 
        .color_var=Year,
        .interactive=TRUE
    )

elec %>% 
    plot_time_series(
        .date_var=Date, .value=ActivePower, 
        .color_var=Year,
        .facet_vars=Year, .facet_scales='free_x',
        .smooth=FALSE,
        .interactive=TRUE
    )

p <- elec %>% 
    plot_time_series(
        .date_var=Date, .value=ActivePower, 
        .color_var=Year,
        .facet_vars=Year, .facet_scales='free_x',
        .smooth=FALSE,
        .interactive=TRUE
    )
plotly::toWebGL(p)

# ACF ####

# Autocorrelation function
elec %>% ACF(ActivePower)
elec %>% ACF(ActivePower) %>% autoplot()

plot_acf_diagnostics(elec, .date_var=date, .value=ActivePower, .lags=40)

# Simple Forecasting ####

elec %>% autoplot(ActivePower)

naive_mod <- elec %>% 
    model(Naive=NAIVE(ActivePower))
naive_mod
naive_mod %>% select(Naive) %>% report()
naive_mod %>% forecast(h=90)

naive_mod %>% forecast(h=90) %>% autoplot()
naive_mod %>% forecast(h=90) %>% autoplot(elec)
naive_mod %>% forecast(h=90) %>% autoplot(elec %>% filter_index('2010' ~ .))

naive_mod %>% forecast(h='90 days')
naive_mod %>% forecast(h='3 months')                                          

mean_mod <- elec %>% 
    model(Mean=MEAN(ActivePower))
mean_mod

elec2010 <- elec %>% filter_index('2010' ~ .)
mean_mod %>% forecast(h=90) %>% autoplot(elec2010)

snaive_mod <- elec %>% 
    model(SNaive=SNAIVE(ActivePower ~ lag('month') + lag('year') + lag('week')))
snaive_mod %>% forecast(h=90) %>% autoplot(elec2010)          

simple_mods <- elec %>% 
    model(
        Mean=MEAN(ActivePower),
        Naive=NAIVE(ActivePower),
        SNaive=SNAIVE(ActivePower ~ lag('month') + lag('year') + lag('week'))
    )

simple_mods
simple_mods %>% select(SNaive) %>% report()
simple_mods %>% glance()

simple_mods %>% forecast(h=90)
simple_mods %>% forecast(h=90) %>% View
simple_mods %>% forecast(h=90) %>% autoplot(elec2010)
simple_mods %>% forecast(h=90) %>% autoplot(elec2010, level=NULL)


# Transformations ####

elec %>% autoplot(ActivePower)
elec %>% autoplot(log(ActivePower))

elec %>% autoplot(box_cox(ActivePower, lambda=1.7))
elec %>% autoplot(box_cox(ActivePower, lambda=0.7))
elec %>% autoplot(box_cox(ActivePower, lambda=0.07))
elec %>% autoplot(box_cox(ActivePower, lambda=0.0))

# feasts
elec %>% 
    features(ActivePower, features=guerrero)

elec %>% autoplot(box_cox(ActivePower, lambda=0.67))

# Fitted Values and Residuals ####

simple_mods %>% augment()

# Prediction Intervals ####

snaive_mod %>% forecast(h=10) %>% hilo()
snaive_mod %>% forecast(h=10) %>% hilo(level=95)

# Evaluating Model ####

snaive_augment <- snaive_mod %>% augment()
snaive_augment

mean_augment <- mean_mod %>% augment()
mean_augment

mean_augment %>% autoplot(.resid)

mean_mod %>% gg_tsresiduals()

train <- elec %>% 
    filter_index(. ~ '2010-08-31')
test <- elec %>% 
    filter_index('2010-09-01' ~ .)

train_mods <- train %>% 
    model(
        Mean=MEAN(ActivePower),
        SNaive=SNAIVE(ActivePower ~ lag('year'))
    )        
train_mods

train_mods %>% forecast(h=nrow(test))
train_mods %>% forecast(new_data=test)


train_forecast <- train_mods %>% forecast(new_data=test)
train_forecast %>% 
    autoplot(train %>% filter_index('2010'), level=NULL) +
    autolayer(test, ActivePower) + 
    facet_wrap(~.model, ncol=1)

accuracy(train_forecast, test)
