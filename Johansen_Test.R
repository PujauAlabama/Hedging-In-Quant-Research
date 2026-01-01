install.packages("quantmod")
install.packages("urca")
library(quantmod)

# Download adjusted prices for target and hedging assets
symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN")  # Example portfolio with 4 stocks
getSymbols(symbols, from = "2023-01-01", to = "2023-12-31", src = "yahoo")

# Combine adjusted closing prices
prices <- do.call(merge, lapply(symbols, function(x) Ad(get(x))))
colnames(prices) <- c("AAPL", "MSFT", "GOOGL", "AMZN")

# Convert to log prices
log_prices <- log(prices)


library(urca)

# ADF Test for each series
adf_results <- lapply(log_prices, function(series) ur.df(series, type = "drift", selectlags = "AIC"))
lapply(adf_results, summary)  # Confirm they are non-stationary at levels



# Perform Johansen test
#If trend term absent
johansen_test <- ca.jo(log_prices, type = "trace", ecdet = "none", K = 2, spec="longrun")
#or if trend present , that would appear as constant term
johansen_test <- ca.jo(log_prices, type = "trace", ecdet = "const", K = 2, spec="longrun")

# Summary of Johansen test results
summary(johansen_test)


# Extract cointegration vectors
cointegration_vectors <- johansen_test@V  # Cointegration matrix

# Normalize the first asset (target asset) coefficient to 1
hedge_ratios <- cointegration_vectors[, 1] / cointegration_vectors[1, 1]
cat("Hedge Ratios:", hedge_ratios, "\n")