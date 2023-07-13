-- <Analyzing Repeat Visit & Purchase Behavior>

-- TASK 1: Identifying Repeat Visitors

-- STEP 1: Identify the relevant new sessions
-- STEP 2: Use the user_id values form STEP 1 to find any repeat sessions thouse users had
-- STEP 3: Analyze the data at the user level (how many sessions did each user have?)
-- STEP 4: Aggregate the user-level analysis to generate a behavioral analysis


CREATE TEMPORARY TABLE sessions_w_repeats
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM(
SELECT
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at < '2014-11-01' -- the date of the request
	AND created_at >= '2014-01-01' -- prescribed date range in request
    AND is_repeat_session = 0 -- new sessions only
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 -- was a repeat session
        AND website_sessions.website_session_id > new_sessions.website_session_id -- session was later than new session
        AND website_sessions.created_at < '2014-11-01' -- the date of the request
        AND website_sessions.created_at >= '2014-01-01' -- prescribed date range in request
;


SELECT * FROM sessions_w_repeats;

SELECT
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM(
SELECT
	user_id,
    COUNT(DISTINCT new_session_id) AS new_sessions,
    COUNT(DISTINCT repeat_session_id) AS repeat_sessions
FROM sessions_w_repeats
GROUP BY 1
ORDER BY 3 DESC
) AS user_level

GROUP BY 1
;
