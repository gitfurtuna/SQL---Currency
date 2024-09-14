insert into currency values (100, 'EUR', 0.85, '2022-01-01 13:29');
insert into currency values (100, 'EUR', 0.79, '2022-01-08 13:29');


SELECT  COALESCE("user".name,'not defined') AS name,
        COALESCE("user".lastname,'not defined') AS lastname,
        currency.name AS currency_name,
        COALESCE(b.t1, b.t2) * b.money as currency_in_usd
FROM balance
LEFT JOIN "user"
ON balance.user_id = "user".id
LEFT JOIN (SELECT balance.user_id, balance.money, balance.currency_id ,
     (SELECT currency.rate_to_usd FROM currency WHERE currency.id = balance.currency_id AND currency.updated <= balance.updated ORDER BY currency.updated DESC LIMIT 1) AS t1,
     (SELECT currency.rate_to_usd FROM currency WHERE currency.id = balance.currency_id AND currency.updated >= balance.updated ORDER BY currency.updated LIMIT 1) AS t2
      FROM balance) AS b
      ON b.user_id = balance.user_id
RIGHT JOIN currency
ON b.currency_id = currency.id
GROUP BY "user".name,currency_in_usd, "user".lastname,currency_name
ORDER BY COALESCE("user".name,'not defined') DESC, COALESCE("user".lastname,'not defined') ASC,currency_name ASC;









