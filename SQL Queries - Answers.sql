/* Q1. */
SELECT product_name, base_price
FROM dim_products
JOIN fact_events USING(product_code)
WHERE base_price > 500
AND promo_type = 'BOGOF';

/* Q2. */
SELECT City, count(*) as 'Number of Stores'
FROM dim_stores
GROUP BY City
ORDER BY 'Number of Stores' desc;

/* Q3. */
SELECT campaign_name, 
		ROUND((`quantity_sold(before_promo)` * base_price) / 1000000, 2) as 'Total Revenue in million(Before Promo)',
        ROUND((`quantity_sold(after_promo)` * base_price) / 1000000, 2) as 'Total Revenue in million(After Promo)'
FROM dim_campaigns
JOIN fact_events USING(campaign_id);

/* Q4. */
SELECT 
    dp.category,
    ROUND(SUM(fe.`quantity_sold(after_promo)`) / SUM(fe.`quantity_sold(before_promo)`) * 100, 2) AS `ISU(%)`,
    DENSE_RANK() OVER (ORDER BY SUM(fe.`quantity_sold(after_promo)`) / SUM(fe.`quantity_sold(before_promo)`) DESC) AS `Rank`
FROM fact_events fe
JOIN dim_products dp ON fe.product_code = dp.product_code
JOIN dim_campaigns dc ON fe.campaign_id = dc.campaign_id
WHERE dc.campaign_name = 'Diwali'
GROUP BY dp.category
ORDER BY `ISU(%)` DESC;

/* Q5. */
SELECT 
    dp.product_name,
    dp.category,
    ROUND(
        (
            (SUM(fe.`quantity_sold(after_promo)`) * fe.base_price) - 
            (SUM(fe.`quantity_sold(before_promo)`) * fe.base_price)
        ) / (SUM(fe.`quantity_sold(before_promo)`) * fe.base_price) * 100, 2
    ) AS `IR%`
FROM 
    dim_products dp
JOIN 
    fact_events fe ON dp.product_code = fe.product_code
GROUP BY 
    dp.product_name, dp.category
ORDER BY 
    `IR%` DESC
LIMIT 5;


        