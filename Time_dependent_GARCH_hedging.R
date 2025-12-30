install.packages("rugarch")   # For univariate GARCH models
install.packages("rmgarch")   # For multivariate GARCH models
install.packages("quantmod")
library(quantmod)
library(rugarch)
library(rmgarch)
# Download adjusted closing prices for multiple stocks
symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN")
getSymbols(symbols, from = "2023-01-01", to = "2023-12-01", src = "yahoo")

# Extract adjusted closing prices and convert to log returns
prices <- do.call(merge, lapply(symbols, function(x) Ad(get(x))))
log_returns <- na.omit(diff(log(prices)))

# View the log returns
head(log_returns)



# Specify univariate GARCH model for each asset
ugarch_spec <- ugarchspec(mean.model = list(armaOrder = c(0, 0)), 
                          variance.model = list(model = "sGARCH"), 
                          distribution.model = "norm")
                          
                          

# Create a multivariate GARCH specification
multispec <- multispec(replicate(ncol(log_returns), ugarch_spec))

# Specify Dynamic Conditional Correlation (DCC-GARCH) model
dcc_spec <- dccspec(uspec = multispec, 
                    dccOrder = c(1, 1), 
                    distribution = "mvnorm")  # Multivariate normal distribution



# Fit the DCC-GARCH model
dcc_fit <- dccfit(dcc_spec, data = log_returns)

# View model summary
print(dcc_fit)



correlations <- rcor(dcc_fit)
# View the first few time-varying correlations
correlations[, , 1]  # Correlations for the first time step


covariances <- rcov(dcc_fit)
# View the first conditional covariance matrix
covariances[, , 1]  # Covariances for the first time step


plot(correlations[1, 2, ], type = "l", 
     main = "Dynamic Correlation: Asset 1 vs Asset 2",
     xlab = "Time", ylab = "Correlation")
     


# Forecast 10 steps ahead
dcc_forecast <- dccforecast(dcc_fit, n.ahead = 10)

# Extract forecasted correlations and covariances
forecast_correlations <- rcor(dcc_forecast)
forecast_covariances <- rcov(dcc_forecast)








library(quantmod)
library(rugarch)
library(rmgarch)

# Step 1: Download stock prices and compute log returns
symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN")  # Example assets
getSymbols(symbols, from = "2023-01-01", to = "2023-12-01", src = "yahoo")
prices <- do.call(merge, lapply(symbols, function(x) Ad(get(x))))
log_returns <- na.omit(diff(log(prices)))

# Step 2: Specify univariate GARCH specification
ugarch_spec <- ugarchspec(mean.model = list(armaOrder = c(0, 0)), 
                          variance.model = list(model = "sGARCH"), 
                          distribution.model = "norm")

# Step 3: Specify multivariate DCC-GARCH specification
multispec <- multispec(replicate(ncol(log_returns), ugarch_spec))
dcc_spec <- dccspec(uspec = multispec, dccOrder = c(1, 1), distribution = "mvnorm")

# Step 4: Fit DCC-GARCH model
dcc_fit <- dccfit(dcc_spec, data = log_returns)

# Step 5: Extract time-varying hedge ratios
# Get conditional covariance matrices
cond_cov <- rcov(dcc_fit)  # 3D array: (assets x assets x time)
cond_cor <- rcor(dcc_fit)  # Conditional correlations (optional)

# Define the target asset and hedging assets
target_index <- 1  # AAPL
hedging_indices <- 2:4  # MSFT, GOOGL, AMZN

# Calculate hedge ratios
hedge_ratios <- list()

for (hedge_index in hedging_indices) {
  # Extract conditional covariance and variance
  cov_target_hedge <- cond_cov[target_index, hedge_index, ]  # Covariance over time
  var_hedge <- cond_cov[hedge_index, hedge_index, ]  # Variance over time

  # Hedge ratio: Cov(r_1, r_h) / Var(r_h)
  hedge_ratios[[colnames(log_returns)[hedge_index]]] <- cov_target_hedge / var_hedge
}

# Step 6: Display time-varying hedge ratios
print("Time-varying Hedge Ratios:")
for (name in names(hedge_ratios)) {
  cat("\nHedge Ratios for", name, ":\n")
  print(hedge_ratios[[name]])
}