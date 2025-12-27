# Hedging in Quant Finance 


## What is Hedging (Time-Independent)?

- It's a strategy to choose weights in Portfolio selection in such a way that it mitigates risk optimally using the correlation between stocks.
- It can be applied only when two (or more) stocks are correlated and one stock performs good compared to the other, then we should long the stock performing good and short the other one. In which ratio it should be done that information could be obtained from portlio weights.
- The return for a portfolio can be expressed as follows

$$
R= \beta_{0} + \sum_{i=1}^{n} \beta_{i}R_{i} + \epsilon
$$


- where,

$\beta_{0}=\alpha
$
is the intercept
- $X= (R_{1},R_{2},...., R_{n})$ is n stocks in the portfolio
- $\beta_{i}$ is the weight of stock $R_{i}$
- $\epsilon$ is the residual/error term
- All the coefficient and intercepts can be found using regression $\hat{\beta}=(X^{T}X)^{-1}X^{T}R$
- But abolve accurately works in regression, only if the stock returns have no correlation with eact other , i.e, $cov(R_{i},R_{j})=0$ for $i\neq j$. When above doesn't follow , then we can express the return $R_{1}$ as linear combination of other stock returns ( i.e. as linear comination of $R_{2}$ to $R_{n}$).
- So, we can define a parameter $\Pi= R_{1} - \vec{h}^{T}\vec{R^{\prime}}$, where
  $\vec{R^{\prime}}= (R_{2},R_{3},...., R{n})^{T}$ and $\vec{h}=(h_{2},h_{3},...., h_{n})^{T}$ both are $n-1$ dimensional vector.
- The coeffiecient vector with elements $h_{i}$ would give the hedge ratio as following: 

$$
\vec{h}_{optimal}= argmax_{(h_{2},h_{3},...,h_{n})}Var(\Pi)
$$
-Using above we get 
$$
\vec{h}_{optimal}= Var(R^{\prime})^{-1}Cov(R_{1},R^{\prime})
$$
- Same thing can be achieved using least squared method with equation
  
$$
R_{1}= h^{\prime}_{0} + \sum_{i=2}^{n} h_{i}R_{i} + \epsilon^{\prime}
$$

- In above equation $h_{0}$ is an constant a
