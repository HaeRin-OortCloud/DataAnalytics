-- User Analysis Task_4: Comparing of Conversion rates and Revenue per Session for New vs. Repeat sessions

USE mavenfuzzyfactory;

SELECT 
    is_repeat_session, 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    SUM(price_usd) AS total_revenue
FROM
    website_sessions
	LEFT JOIN orders
	    ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2014-11-08' -- the date of the request
    AND website_sessions.created_at >= '2014-01-01' -- prescribed date range in the request
GROUP BY 1
;


SELECT 
    is_repeat_session, 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    ROUND(COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id),3) AS conv_rate,
    ROUND(SUM(price_usd) / COUNT(DISTINCT website_sessions.website_session_id), 3) AS rev_per_session
FROM
    website_sessions
	LEFT JOIN orders
	    ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2014-11-08' -- the date of the request
    AND website_sessions.created_at >= '2014-01-01' -- prescribed date range in the request
GROUP BY 1
;
