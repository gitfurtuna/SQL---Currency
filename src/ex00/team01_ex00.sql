SELECT  COALESCE("user".name,'not defined') AS name, COALESCE("user".lastname,'not defined') AS lastname,
        balance.type AS type,
        balance.money AS volume,
        COALESCE(currency.name,'not defined') AS currency_name,
        COALESCE(cur1.last_rate_to_usd, 1) AS last_rate_to_usd,
        ((COALESCE(cur1.last_rate_to_usd, 1))* balance.money) AS total_volume_in_usd
FROM (SELECT user_id, SUM(money) AS money, type, currency_id
FROM balance
GROUP BY user_id,type,currency_id) as balance
LEFT JOIN "user"
ON balance.user_id = "user".id
LEFT JOIN "currency"
ON balance.currency_id = currency.id
LEFT JOIN ((SELECT id, rate_to_usd AS last_rate_to_usd
           FROM currency
           WHERE currency.name = 'EUR'
           ORDER BY updated DESC
           LIMIT 1)
           UNION
           (SELECT id, rate_to_usd AS last_rate_to_usd
           FROM currency
           WHERE currency.name = 'USD'
           ORDER BY updated DESC
           LIMIT 1)
           UNION
           (SELECT id, rate_to_usd AS last_rate_to_usd
           FROM currency
           WHERE currency.name = 'JPY'
           ORDER BY updated DESC
           LIMIT 1)) AS cur1
           ON cur1.id = balance.currency_id
GROUP BY COALESCE("user".name,'not defined'),COALESCE("user".lastname,'not defined'),balance.type,balance.money,currency.name,cur1.last_rate_to_usd
ORDER BY COALESCE("user".name,'not defined') DESC,COALESCE("user".lastname,'not defined') ASC,balance.type ASC;


balance.type,,,cur1.last_rate_to_usd



