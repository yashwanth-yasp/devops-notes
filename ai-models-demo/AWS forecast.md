---
date: 2025-09-10
Speaker: Amit Palissery
tags:
  - ai
  - ust
  - aws
---
**1. The Challenge of Forecasting**

Every business needs to forecast. How much inventory do we need? How many employees should we staff? What will our revenue be next quarter? Traditionally, this was done with complex statistical models or even spreadsheets, which are often inaccurate and labor-intensive.

**2. What is AWS Forecast?**

AWS Forecast is a fully managed machine learning service. This means it automates the entire forecasting process for you. You provide it with historical time-series data, and it does the rest: from data processing and model selection to training and deployment. It is based on the same technology Amazon.com uses for its own forecasting needs.

**3. How AWS Forecast Works (Technical Deep Dive)**

- **Data Ingestion:** You upload your historical time-series data (e.g., daily sales, hourly server usage) and related data (e.g., weather data, promotions).
- **Automatic Machine Learning (AutoML):** This is the core of the service.

- **Algorithm Selection:** It automatically analyzes your data and selects the best algorithm from a pool of models, including proprietary Amazon algorithms and traditional methods like ARIMA.

·  **Forecast analyses:**

o   Trends

o   Seasonality

o   Missing values

o   Data frequency

Forecast **selects the best-performing model** based on accuracy metrics like **WQL (Weighted Quantile Loss)**.

- **Hyperparameter Tuning:** It tunes the parameters of the chosen algorithm to achieve the highest accuracy for your specific dataset.

- **Model Training and Deployment:** Once the model is trained, it's deployed as a private, dedicated API endpoint, ready for you to query.
- **Probabilistic Forecasts:** A key feature is its ability to generate probabilistic forecasts. Instead of a single number, you get a range of potential outcomes with different probabilities (e.g., P10, P50, P90). The P50 forecast is the median, while P10 and P90 represent the range of likely outcomes, which is vital for risk management.

**4. The Business Value of AWS Forecast**

- **Accuracy:** It uses machine learning to identify complex patterns that traditional models miss, leading to more accurate predictions.
- **Scalability:** It can handle billions of data points effortlessly, allowing companies to forecast at a granular level.
- **Accessibility:** You don't need a team of data scientists to use it. The service abstracts away the complexity of machine learning.

**5. Real-World Use Cases**

- **Retail & E-commerce:** A retailer can predict demand for individual products in specific stores or regions to optimize stock levels and prevent lost sales.
- **Energy Management:** Utility companies can forecast power consumption to optimize grid operations and avoid outages.

**South Central Ambulance Services (UK)** – Emergency Response

- **Use Case**: Workforce and resource planning
- **Impact**: Delivered more accurate **weekly and six-week rolling forecasts**
- **Details**: Used PlanIQ (powered by Amazon Forecast) to anticipate spikes in patient demand and allocate resources efficiently

 **More Retail (India)** – Omni-channel Grocery Chain

- **Use Case**: Product-level demand forecasting
- **Impact**: Improved forecast accuracy by **20%** compared to their previous solution
- **Details**: Built an automated system using Forecast’s APIs

Sure! Here's another **simple example** of how AWS Forecast can be used—this time in a **restaurant setting** 🍽️.

---

**Example: Forecasting Daily Orders for a Pizza Shop**

Imagine you run a pizza shop and want to predict how many pizzas you'll sell each day so you can prep ingredients and staff accordingly.

 **Step 1: Collect Historical Data**

You gather a CSV file like this:

timestamp, location, pizzas_sold

2023-01-01, Chennai, 120

2023-01-02, Chennai, 135

...

You can also include related data like:

- Weather (rainy days might reduce orders)
- Day of the week (weekends might spike demand)
- Promotions (discounts or special offers)

 **Step 2: Upload to AWS Forecast**

- Create a **Dataset Group**
- Upload your **Target Time Series** (pizzas sold per day)
- Add **Related Time Series** (weather, holidays, etc.)

**Step 3: Train the Model**

- Choose a forecast horizon (e.g., next 7 days)
- AWS Forecast automatically selects the best algorithm (like DeepAR+)
- It learns patterns like weekend spikes or rainy-day dips

 **Step 4: Generate Forecast**

You get predictions like:

timestamp, location, predicted_pizzas_sold

2023-04-01, Chennai, 140

2023-04-02, Chennai, 160

...

 **Step 5: Take Action**

- Prep ingredients based on forecast
- Schedule staff shifts
- Plan promotions for low-demand days

---

This kind of forecasting helps reduce waste, improve customer satisfaction, and optimize operations.

**Alternatives**

Facebook Prophet -    Need fast, interpretable results

Azure Forecasting -     Working in Microsoft ecosystem

Dataiku   -                    Want collaborative data science

---
