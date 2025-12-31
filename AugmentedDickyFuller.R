library(quantmod)

# Step 1: Load data for two assets (e.g., AAPL and MSFT)
symbols <- c("AAPL", "MSFT")  # Asset to hedge and hedging instrument
getSymbols(symbols, from = "2023-01-01", to = "2023-12-31", src = "yahoo")
prices <- do.call(merge, lapply(symbols, function(x) Ad(get(x))))
colnames(prices) <- symbols

library(urca)

# Step 2: Perform ADF test on each asset
adf_aapl <- ur.df(log(prices$AAPL), type = "drift", selectlags = "AIC")
adf_msft <- ur.df(log(prices$MSFT), type = "drift", selectlags = "AIC")

# Check stationarity results
summary(adf_aapl)  # Expect non-stationary (null hypothesis not rejected)
summary(adf_msft)


# Step 3: Linear regression to estimate hedge ratio
hedge_model <- lm(log(prices$AAPL) ~ log(prices$MSFT))
summary(hedge_model)

# Extract hedge ratio (coefficient of MSFT)
hedge_ratio <- coef(hedge_model)[2]
cat("Hedge Ratio: ", hedge_ratio, "\n")


# Step 4: Extract residuals
residuals_hedge <- residuals(hedge_model)

# Perform ADF test on residuals
adf_residuals <- ur.df(residuals_hedge, type = "none", selectlags = "AIC")
summary(adf_residuals)

# Interpretation:
# If null is rejected (p-value < 0.05), residuals are stationary, indicating cointegration.