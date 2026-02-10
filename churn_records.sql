USE Churn
SELECT * 
FROM dbo.[Customer-Churn-Records];

/* Executive Summary - KPIs
Calculate Total Customers, Activity Rate, Satisfaction, and Churn Rate.
*/

SELECT 
    COUNT(CustomerId) AS Total_Customers,
    FORMAT(AVG(CAST(IsActiveMember AS FLOAT)), 'P2') AS Engagement_Rate,
    ROUND(AVG(CAST(Satisfaction_Score AS FLOAT)), 2) AS Avg_Satisfaction_Score,
    ROUND(SUM(CAST(Exited AS INT)),0) AS Number_Of_Exited_Customers,
    FORMAT(CAST(SUM(CAST(Exited AS INT)) AS FLOAT) / COUNT(*), 'P2') AS Churn_Rate
FROM dbo.[Customer-Churn-Records];


-- Churn Risk by Age Demographics


WITH AgeBuckets AS (
    SELECT 
        Exited,
        CASE 
            WHEN Age < 30 THEN 'Young Adult (<30)'
            WHEN Age BETWEEN 30 AND 45 THEN 'Adult (30-45)'
            WHEN Age BETWEEN 46 AND 60 THEN 'Mid-Career (46-60)'
            ELSE 'Senior (60+)' 
        END AS Age_Group
    FROM dbo.[Customer-Churn-Records]
)
SELECT 
    Age_Group,
    COUNT(*) AS Customer_Count,
    ROUND(AVG(CAST(Exited AS FLOAT)) * 100, 2) AS Churn_Rate
FROM AgeBuckets
GROUP BY Age_Group
ORDER BY Churn_Rate DESC;


-- Churn Risk By Geography --

 
SELECT 
    Geography,
    COUNT(*) AS Customer_Count,
    ROUND(AVG(CAST(Exited AS FLOAT)) * 100, 2) AS Churn_Rate
FROM [Customer-Churn-Records]
GROUP BY Geography
ORDER BY Churn_Rate DESC;


-- Churn Risk by Card Type -- 

SELECT 
    Card_Type,
    COUNT(*) AS Customer_count,
    ROUND(CAST(SUM(CAST(Exited AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS Churn_Percentage
FROM dbo.[Customer-Churn-Records]
GROUP By Card_Type
ORDER BY Churn_Percentage DESC;

-- Churn Risk by Number of Products  -- 

SELECT 
    NumOfProducts,
    COUNT(*) AS Customer_count,
    ROUND(CAST(SUM(CAST(Exited AS INT)) AS FLOAT) / COUNT(*) * 100, 2) AS Churn_Percentage
FROM dbo.[Customer-Churn-Records]
GROUP By NumOfProducts
ORDER BY Churn_Percentage DESC;


-- Churn Risk by credit score --


WITH CreditScoreBucket AS (
SELECT
    Exited,
    CASE
        WHEN CreditScore < 400 THEN 'Credit Score (0 - 399)'
        WHEN CreditScore BETWEEN 400 AND 499 THEN 'Credit Score (400 - 499)'
        WHEN CreditScore BETWEEN 400 AND 499 THEN 'Credit Score (400 - 499)'
        WHEN CreditScore BETWEEN 500 AND 599 THEN 'Credit Score (500 - 599)'
        WHEN CreditScore BETWEEN 600 AND 699 THEN 'Credit Score (600 - 699)'
        WHEN CreditScore BETWEEN 700 AND 799 THEN 'Credit Score (700 - 799)'
        ELSE '800+'
    END AS CreditScoreCategory
FROM dbo.[Customer-Churn-Records]
)
SELECT 
    CreditScoreCategory,
    COUNT(*) AS customer_count,
    ROUND(CAST(SUM(CAST(Exited AS INT)) AS FLOAT) / COUNT(*) * 100,2) AS Churn_Rate
FROM CreditScoreBucket
GROUP BY CreditScoreCategory
ORDER BY Churn_Rate DESC;