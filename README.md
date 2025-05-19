# DataAnalytics_Assessment
Question 1: 
Write a query to find customers with at least one funded savings plan AND one
funded investment plan, sorted by total deposits.
Answer 1:
SELECT 
    pp.owner_id,
	    concat(uc.first_name, ' ', uc.last_name) AS name,   
    COUNT(CASE WHEN pp.is_regular_savings = 1 AND sa.new_balance > 0 THEN 1 END) AS savings_count,
    COUNT(CASE WHEN pp.is_a_fund = 1 AND sa.new_balance > 0 THEN 1 END) AS investment_count,
    SUM(sa.confirmed_amount) AS total_deposits
FROM 
    plans_plan AS pp
JOIN 
    savings_savingsaccount AS sa ON sa.owner_id = pp.owner_id
JOIN 
    users_customuser uc ON uc.id = pp.owner_id
GROUP BY 
    pp.owner_id, name
HAVING 
    savings_count > 0 AND investment_count > 0
ORDER BY 
    total_deposits DESC;

Explanation:
There are three separate tables involved in answering this question (users_customuser, savings_savingsaccount, plans_plan). 
These three tables can be put into a single unit using JOIN. My choice of INNER JOIN is because we only need  results with a match across the three tables i.e., users or customers whose ID appears across the three tables.
Using the AS statement, I renamed each of those tables to maintain a simpler and clearer query. Also, it is more efficient to write the alias rather than each table name every now and then.
The tables were joined based on the common columns
i.	The common column between users_customuser table and plans_plan is owner_id and id on the user table
ii.	The common column between users_customuser and savings_savingsaccount is owner_id and id on user table also
Note: the alias of the three tables were used in the select statement because we need mysql to understand from what table are we choosing a certain column i.e. we have column “name” across all tables which would lead to error if we don’t specify what table we need that name column from.

CONCAT(uc.first_name,' ', uc.last_name) AS name: This would join the first and last name together and store under the name column

COUNT(CASE WHEN pp.is_regular_savings = 1 AND sa.new_balance > 0 THEN 1 END) AS savings_count: using the CASE statement which is like IF statement in Excel, we categorized customers with a funded savings account. After which we COUNT the number of customers that obey both conditions

COUNT(CASE WHEN pp.is_a_fund = 1 AND sa.new_balance > 0 THEN 1 END) AS investment_count: same as above. We categorize customers with a funded investment account and then COUNT it as investment_count.

This way, mysql would only count rows that meets the conditions

The GROUP BY statement is to roll results into just one category i.e. if I have the same user_id, I can roll it all up under one user_id instead of many.

The SUM function is to get the total deposits made by the user(s) gotten from running the query. So, we roll the user_id up (GROUP BY) because a user may have deposited on various days, so we need to put them all in one user_id and then sum up the total deposit made by that user under that user_id.

HAVING savings_count > 0 AND investment_count > 0: This works like WHERE statement except that it is for aggregated group of rows. This filters rows whose collective count is greater than 0

ORDER BY total_deposits DESC: this orders the entire result based on the total deposits from highest to lowest




Question 3:
Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)
 Answer 3
SELECT
  pp.id AS plan_id,
  pp.owner_id,
  pp.plan_type_id,
  MAX(sa.transaction_date) AS last_transaction_date,
  DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days
FROM plans_plan AS pp
LEFT JOIN savings_savingsaccount AS sa
  ON pp.id = sa.plan_id
WHERE pp.status_id = 1
GROUP BY pp.id, pp.owner_id, pp.plan_type_id
HAVING last_transaction_date IS NULL
    OR last_transaction_date < DATE_SUB(CURDATE(), INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;

Explanation
MAX(sa.transaction_date) AS last_transaction_date: to get the latest transaction date for each row
DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS inactivity_days: to get the difference in current date and last transaction date
LEFT JOIN because the question says all active accounts whether savings or investments
WHERE pp.status_id = 1 (assuming that means the account is active)

