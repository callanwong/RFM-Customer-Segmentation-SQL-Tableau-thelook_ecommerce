/* STEP 1: Revenue Data Cleaning

We filter to order_status IN ('Shipped', 'Complete')
to isolate realized revenue events. 

This prevents revenue inflation caused by:
- Canceled orders
- Pending transactions
- Incomplete checkouts
- Returns
*/

CREATE OR REPLACE TABLE `inbound-augury-469417-g8.Revenue.transactions_clean` AS
SELECT
  o.user_id,
  oi.order_id,
  oi.created_at,
  oi.sale_price
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.orders` o
  ON oi.order_id = o.order_id
WHERE oi.status IN ('Shipped', 'Complete');



/* STEP 2: Aggregate to Customer-Level Metrics

We transform order-level data into customer-level summaries. 

Calculated: 
- total_spent
- total_orders
- recency_days (number of days since customers most recent completed purchase)
*/

CREATE OR REPLACE TABLE `inbound-augury-469417-g8.Revenue.rfm_base_2` AS

SELECT
  user_id,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(sale_price) AS total_spent,
  MAX(created_at) AS last_order_date,
  DATE_DIFF(
    (SELECT MAX(created_at) FROM `inbound-augury-469417-g8.Revenue.transactions_clean`), 
    MAX(created_at), DAY) AS recency_days
FROM `inbound-augury-469417-g8.Revenue.transactions_clean`
GROUP BY user_id;


/* STEP 3: Assign RFM scores

-NTILE(5) is used to divide customers into quintiles
-Each customer receives a score from 1-5 (R, F, M)
-Higher scores indicate stronger customer value per dimension 

*/

CREATE OR REPLACE TABLE `inbound-augury-469417-g8.Revenue.rfm_scores` AS

SELECT
  user_id,
  recency_days,
  total_orders,
  total_spent,

  ## Recency: 
  (6 - NTILE(5) OVER (ORDER BY recency_days ASC)) AS r_score, 
  ## Frequency: 
  NTILE(5) OVER (ORDER BY total_orders DESC) AS f_score,
  ## Monetary: 
  NTILE(5) OVER (ORDER BY total_spent DESC) AS m_score

FROM
`inbound-augury-469417-g8.Revenue.rfm_base_2`;



/* STEP 4: Assigning Customer Segments using RFM Scores
- Segments are defined using Recency (R), Frequency (F), and Monetary (M)
- Higher scores indicate stronger performance in that dimension
*/

CREATE OR REPLACE TABLE `inbound-augury-469417-g8.Revenue.rfm_segments` AS 
WITH scored AS (
  SELECT *,
    r_score + f_score + m_score AS rfm_score
  FROM `inbound-augury-469417-g8.Revenue.rfm_scores`
)
SELECT
  user_id,
  r_score,
  f_score,
  m_score,
  rfm_score,
  CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champion'
    WHEN f_score >= 4 AND m_score >= 3 THEN 'Loyal Customer'
    WHEN m_score = 5 THEN 'Big Spender'
    WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
    WHEN r_score = 1 AND f_score >= 2 THEN 'Lost Customer'
    WHEN r_score >= 4 AND f_score = 3 THEN 'Potential Loyalist' 
    WHEN r_score = 1 AND f_score = 1 AND m_score = 1 THEN 'One Time Buyer'
    ELSE 'Others'
  END AS customer_segment
FROM scored;

/* STEP 5: Create final RFM table for Visualization: 

Table consolidates: 
- Recency (days since last completed order)
- Frequency (toatal completed orders)
- Monetary (total revenue generated)
- RFM scores (NTILE)
- Final customer segment classification 
*/

CREATE OR REPLACE TABLE `inbound-augury-469417-g8.Revenue.tableau_rfm_export` AS
SELECT
  s.user_id,
  s.customer_segment,
  s.r_score,
  s.f_score,
  s.m_score,
  s.rfm_score,
  b.total_orders,
  b.total_spent,
  b.last_order_date
FROM `inbound-augury-469417-g8.Revenue.rfm_segments` s
JOIN `inbound-augury-469417-g8.Revenue.rfm_base_2` b 
USING(user_id)