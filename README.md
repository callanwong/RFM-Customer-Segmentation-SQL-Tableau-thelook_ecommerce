# RFM-Customer-Segmentation-SQL-Tableau-thelook_ecommerce
Author: Callan Wong, Business Analytics, CSUN 

RFM customer segmentation and behavioral analysis performed in Google BigQuery and visualized in Tableau using thelook_ecommerce dataset.

## Project Overview
This project applies Recency, Frequency, and Monetary (RFM) analysis to segment customers based on purchasing behavior, using thelook_ecommerce dataset from Google BigQuery.
The objective is to identify high-value customer segments and generate insights related to retention, engagement, and revenue optimization. 
Customer RFM metrics were calculated in SQL and exported to Tableau for visualization.

## Dashboard Preview
<img width="959" height="496" alt="RFM tableau screenshot" src="https://github.com/user-attachments/assets/fa1262f7-14ef-43e8-a031-dccb6b37f48e" />

## Data Source 

**Dataset:**
Google BigQuery Public Dataset: `thelook_ecommerce`.

## Project Objective 

The objective of this project is to segment customers based on purchasing behavior using RFM (Recency, Frequency, Monetary) framework.
By grouping customers into behavioral segments such as Loyal Customers, Potential Loyalists, At Risk, One-Time Buyers, this analysis aims to:

- Identify which customer groups contribute the most to overall revenue
- Compare average order value and revenue per user across segments
- Understand how customer behavior impacts business performance

The goal is to provide insights into which customer segments may benefit from retention or marketing strategies and highlight opportunities for
improving customer lifetime value. 

## Methodology 

Customer transaction data was filtered to include only completed or shipped orders in order to reflect actual realized revenue. 

Using SQL in Google BigQuery, customer-level aggregations were created, including: 

- Total Orders (Frequency)
- Total Amount Spent (Monetary)
- Recency (Days Since Last Purchase)

Customers were then scored on each RFM metric using SQL window functions and then divided into quintiles. Each user was assigned a score of 1-5 for R, F, and M based on relative performance within the dataset. These scores were used to assign each customer into a behavioral
segment based on purchasing activity. 

Example: R>=4 and F>=3 were labeled as Loyal Customers

The resulting customer segmentation table was exported and visualized in Tableau Public to compare: 
- Total Revenue by Segment
- Average Order Value by Segment
- Revenue per User by Segment
- Number of Customers per Segment

## Key Insights

- The **Others** segment represents the largest share of total revenue and also contains the highest number of customers. This indicates that while this group may not show extreme behavior individually, their collective impact is substantial.
- **Potential Loyalists** demonstrate the highest Average Order Value (AOV) and Revenue Per User (RPU), suggesting these customers tend to spend more per transaction on average, despite contributing less to total revenue.
- The low total revenue contribution from Potential Loyalists appears to be driven by a smaller population size, indicated by customer segment count chart.
- **At Risk** and **Loyal Customers** rank second and third in total revenue contribution, indicating that historically engaged customers continue to provide value even if recency decreases.
- **One-Time Buyers** showed relatively similar AOV and RPU compared to other segments, suggesting that frequency and timing may play a larger role in customer value than individual transaction size.
- Given the size and revenue contribution of the **Others** segment, further behavioral segmentation within the group could provide opportunities to identify high-value customers and guide strategy accordingly.

## Business Recommendations

1. Encourage purchase frequency from Potential Loyalists

Potential Loyalists demonstrate the highest Average Order Value (AOV) and Revenue Per User (RPU) but represent a small share of total customers. This suggests that these customers are valuable, yet underrepresented in the overall customer base. 

Recommendations: 
- Loyalty programs
- Post-purchase incentives
- Email campaigns



2. Monitor At-Risk Customers for Retention Opportunities

At-Risk customers maintain relatively high spending behavior but haven't made recent purchases. If engagement is not restored, this group represents a potential loss.

Recommendations: 
- Limited time discounts
- Reminder campaigns
- Re-engagement promotions

3. Further Segmentation/Investigation of "Others"

The "Others" segment accounts for both the largest customer segment and the highest total revenue contribution.

This indicates that total revenue is driven more by customer volume than by exceptional, high-value customers. Further segmentation within this group may uncover emerging high value customers, early-stage potential loyalists, or behavior unexplained through RFM methodology. 

## Limitations and Next Steps

This analysis is based on aggregated transactional features (total_orders, total_spent, recency_days) derived only from completed and shipped orders. 

While RFM segmentation is useful for providing a high-level view of customer behavior, it does not account for:
- Acquisition channels
- Product purchasing patterns
- Seasonality
- Geographic/Demographic factors

With the "Others" segment representing a large portion of the customer base and total revenue, further segmentation/analysis could reveal subgroups not captured through RFM. 

Future analysis could include: 
-Retention analysis within each segment
-Product category preferences
-CLV estimation
-Clustering techniques

## Conclusion

Using customer transaction data from `thelook_ecommerce` dataset, this project applied RFM segmentation to group users based on purchasing behavior. The resulting dashboard highlights meaningful differences in revenue contribution, average order value, revenue per user, and segment size across customer groups. 

Overall revenue distribution aligned closely with customer segment counts, indicating that customer volume plays a major role in business impact. These findings suggest that retention-focused strategies, aimed at the high value but smaller segments (Potential Loyalists), may offer opportunities for revenue growth. 




