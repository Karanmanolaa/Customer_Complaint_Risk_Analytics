USE customer_complaint_analytics;

SELECT COUNT(*) AS total_rows
FROM complaints;

-- Create dashboard-ready tables

USE customer_complaint_analytics;


-- 1 - Monthly product trends

CREATE TABLE monthly_product_trends AS
SELECT
    received_month,
    product,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY received_month, product
ORDER BY received_month, product;


-- 2 - Top companies

CREATE TABLE top_companies AS
SELECT
    company,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY company
ORDER BY complaint_count DESC
LIMIT 20;


-- 3 - Top issues

CREATE TABLE top_issues AS
SELECT
    issue,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY issue
ORDER BY complaint_count DESC
LIMIT 20;


-- 4 - Response quality by company

CREATE TABLE response_quality AS
SELECT
    company,
    COUNT(*) AS total_complaints,
    SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) AS timely_responses,
    SUM(CASE WHEN timely_response = 'No' THEN 1 ELSE 0 END) AS late_responses,
    ROUND(
        SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS timely_response_rate
FROM complaints
GROUP BY company
HAVING total_complaints >= 100
ORDER BY timely_response_rate ASC, total_complaints DESC;


-- 5 - State summary

CREATE TABLE state_summary AS
SELECT
    state,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY state
ORDER BY complaint_count DESC;


-- 6 - Company response breakdown

CREATE TABLE response_breakdown AS
SELECT
    company_response_to_consumer,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS response_share_percent
FROM complaints
GROUP BY company_response_to_consumer
ORDER BY complaint_count DESC;


-- 7 - Company risk score


CREATE TABLE company_risk_score AS
SELECT
    company,
    COUNT(*) AS total_complaints,
    SUM(CASE WHEN timely_response = 'No' THEN 1 ELSE 0 END) AS late_responses,
    ROUND(
        SUM(CASE WHEN timely_response = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS late_response_rate,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY company
HAVING total_complaints >= 100
ORDER BY late_response_rate DESC, total_complaints DESC;


-- 8 - Product issue summary


CREATE TABLE product_issue_summary AS
SELECT
    product,
    issue,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY product, issue
ORDER BY product, complaint_count DESC;


show tables;

SELECT * FROM monthly_product_trends LIMIT 10;

SELECT * FROM top_companies LIMIT 10;

SELECT * FROM top_issues LIMIT 10;

SELECT * FROM response_quality LIMIT 10;

SELECT * FROM state_summary LIMIT 10;

SELECT * FROM response_breakdown LIMIT 10;

SELECT * FROM company_risk_score LIMIT 10;

SELECT * FROM product_issue_summary LIMIT 10;