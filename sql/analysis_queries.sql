-- Create database for the project

CREATE DATABASE customer_complaint_analytics;

USE customer_complaint_analytics;

CREATE TABLE complaints (
    date_received TEXT,
    product TEXT,
    sub_product TEXT,
    issue TEXT,
    sub_issue TEXT,
    company_public_response TEXT,
    company TEXT,
    state TEXT,
    zip_code TEXT,
    tags TEXT,
    submitted_via TEXT,
    date_sent_to_company TEXT,
    company_response_to_consumer TEXT,
    timely_response TEXT,
    complaint_id TEXT,
    received_month TEXT,
    days_to_send TEXT,
    is_timely TEXT,
    has_narrative TEXT

);


LOAD DATA LOCAL INFILE '/Users/karanmanola/Downloads/customer_complaint_analytics/outputs/complaints_sql_ready.csv'
INTO TABLE complaints
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    date_received,
    product,
    sub_product,
    issue,
    sub_issue,
    company_public_response,
    company,
    state,
    zip_code,
    tags,
    submitted_via,
    date_sent_to_company,
    company_response_to_consumer,
    timely_response,
    complaint_id,
    received_month,
    days_to_send,
    is_timely,
    has_narrative
);


SELECT COUNT(*) AS total_rows
FROM complaints;


-- 1 — Complaint share by product
SELECT
    product,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY product
ORDER BY complaint_count DESC;


-- 2 — Monthly complaint trend by product

SELECT
    received_month,
    product,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY received_month, product
ORDER BY received_month, complaint_count DESC;

-- 3 — Top 20 companies by complaint volume
SELECT
    company,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY company
ORDER BY complaint_count DESC
LIMIT 20;

-- 4 — Top 20 complaint issues
SELECT
    issue,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY issue
ORDER BY complaint_count DESC
LIMIT 20;

-- 5 — Timely response rate by company
SELECT
    company,
    COUNT(*) AS total_complaints,
    SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) AS timely_responses,
    ROUND(
        SUM(CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS timely_response_rate
FROM complaints
GROUP BY company
HAVING total_complaints >= 100
ORDER BY timely_response_rate ASC, total_complaints DESC
LIMIT 20;

-- 6 — Complaints by state
SELECT
    state,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS complaint_share_percent
FROM complaints
GROUP BY state
ORDER BY complaint_count DESC;

-- 7 — Company response breakdown
SELECT
    company_response_to_consumer,
    COUNT(*) AS complaint_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM complaints), 2) AS response_share_percent
FROM complaints
GROUP BY company_response_to_consumer
ORDER BY complaint_count DESC;

-- 8 — Product-wise issue trends
SELECT
    product,
    issue,
    COUNT(*) AS complaint_count
FROM complaints
GROUP BY product, issue
ORDER BY product, complaint_count DESC;




