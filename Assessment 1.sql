USE adashi_staging;
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