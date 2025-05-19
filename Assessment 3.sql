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

select * from plans_plan