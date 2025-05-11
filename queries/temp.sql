SELECT *
FROM channels
WHERE Channel_Type = 'Paid'
order by Channel_Name;

SELECT
  ID,
  Channel_Name
FROM
  channels
WHERE
  Channel_Name LIKE '%E%'
  AND Channel_Type <> 'Non-Paid'
ORDER BY
  ID DESC;

  SELECT *
FROM hotels
WHERE Location LIKE '%I%'
AND NAME <> 'Barcelo Vigo'
order by ID ASC;




SELECT distinct Channel_Type
FROM channels;

select
    count(booking_id) as total_boking
from transactions;

SELECT
    customer_country,
    COUNT(booking_id) as total_reservas
FROM transactions
group by customer_country
having total_reservas > 100
order by total_reservas desc;


SELECT
    customer_country,
    COUNT(booking_id) AS total_reservas
FROM
    transactions
GROUP BY
    customer_country
HAVING
    COUNT(booking_id) > 100
ORDER BY
    total_reservas DESC;

select
    customer_country,
    sum(total_revenue_in_euros) as total_ingresos
from transactions
group by customer_country
HAVING
    SUM(total_revenue_in_euros) > 10000
order by total_ingresos desc;

select top 5
    t.booking_id,
    H.Name,
    H.Location,
    T.total_revenue_in_euros
from transactions T
inner join hotels H
on T.hotel_id = H.ID;


select top 5
    t.customer_country,
    sum(T.total_revenue_in_euros) as total_ingreso,
    count(t.booking_id) as total_reservas
from transactions T
left join hotels H
on T.hotel_id = H.ID
group by t.customer_country
having
    count(t.booking_id) > 50
order by total_ingreso ASC ;


SELECT
    COUNT(T.booking_id) as total_reservas,
    C.Channel_Name
FROM transactions T
INNER JOIN channels C ON C.ID= T.id_marketing_channel
group by C.Channel_Name
order by total_reservas ASC;

SELECT
    SUM(total_revenue_in_euros) as total_ingresos,
    hotel_id,
    h.Name
FROM transactions T
inner join hotels H
ON T.hotel_id = H.ID
group by  h.Name, hotel_id
order by total_ingresos DESC ;

/* Sub consultas y CTE */

SELECT
    customer_country,
    COUNT(booking_id) as total_reservas
FROM transactions
group by customer_country;

SELECT AVG(total_reservas) as promedio
FROM (
    SELECT
    customer_country,
    COUNT(booking_id) as total_reservas
    FROM transactions
    group by customer_country
     )  AS subconsulta;

SELECT
    customer_country,
    COUNT(booking_id) as total_reservas
FROM transactions
group by customer_country
HAVING
    count(booking_id) > (
        SELECT AVG(total_reservas) as promedio
FROM (
        SELECT
        customer_country,
        COUNT(booking_id) as total_reservas
        FROM transactions
        group by customer_country
         )  AS subconsulta
        );


WITH reservas_por_pais AS (
    SELECT
        customer_country,
        COUNT(booking_id) AS total_reservas
    FROM
        transactions
    GROUP BY
        customer_country
);

SELECT
    customer_country,
    COUNT(booking_id) AS total_reservas
FROM transactions
    GROUP BY customer_country;

WITH reservas_pais as (
    SELECT
        customer_country,
        COUNT(booking_id) AS total_reservas
    FROM transactions
        GROUP BY customer_country
)
SELECT
    customer_country,
    total_reservas
from reservas_pais
where total_reservas >
      (SELECT AVG(total_reservas) from reservas_pais)
order by total_reservas DESC;


SELECT
    H.Name,
    sum(t.total_revenue_in_euros) as total_ingresos
FROM transactions T
    inner join hotels H on T.hotel_id = H.ID
group by H.Name;

with ingresos_por_hotel as (
    SELECT
    H.Name,
    sum(t.total_revenue_in_euros) as total_ingresos
FROM transactions T
    inner join hotels H on T.hotel_id = H.ID
group by H.Name
)

SELECT
Name,
total_ingresos
FROM ingresos_por_hotel
where total_ingresos > (select AVG(total_ingresos) from ingresos_por_hotel);

SELECT
booking_id,
hotel_id,
total_revenue_in_euros
FROM transactions
where hotel_id is null;

Create view  vw_reservas_altas as
    SELECT
        booking_id,
        customer_country,
        total_revenue_in_euros
    FROM transactions
    WHERE total_revenue_in_euros > 1000;

SELECT * FROM vw_reservas_altas;

create view vw_reporte_reservas as
    SELECT
        T.booking_id,
        T.customer_country,
        t.total_revenue_in_euros,
        h.Name as hotel_name,
        C.Channel_Name as Channel
    FROM transactions t
    inner join Hotels H on t.hotel_id = H.ID
    inner join channels C on t.id_marketing_channel = C.id
    where
        total_revenue_in_euros > 500;




SELECT
    booking_id,
    total_revenue_in_euros,
    AVG(total_revenue_in_euros) OVER() AS promedio_general
FROM
    transactions;


SELECT
    h.Name,
    SUM(t.total_revenue_in_euros) AS total_ingresos,
    RANK() OVER (ORDER BY SUM(t.total_revenue_in_euros) DESC) AS ranking
FROM
    transactions t
INNER JOIN hotels h ON t.hotel_id = h.ID
GROUP BY
    h.Name
ORDER BY
    ranking;


SELECT

    YEAR(booking_date) AS year_booking,
    SUM(total_revenue_in_euros) as total
FROM transactions
WHERE booking_date IS NOT NULL
GROUP BY year(booking_date)
ORDER BY  year(booking_date) ASC;

SELECT

    month(booking_date) AS mont_booking,
    SUM(total_revenue_in_euros) as total,
    AVG(number_of_guests) AS avg_guest
FROM transactions
WHERE booking_date IS NOT NULL
GROUP BY month(booking_date)
ORDER BY  month(booking_date) ASC;

SELECT
    booking_date,
    SUM(total_revenue_in_euros) as total_revenue
FROM transactions
WHERE booking_date IS NOT NULL
GROUP BY booking_date;

-- Construyendo la sub consulta con windows function

SELECT
    booking_date,
    month(booking_date) as month_date,
    total_revenue,
-- windows funtion
    SUM(total_revenue) over (partition by month(booking_date)  order by booking_date) as acumulative_revenue,
    avg(avg_moving) over (partition by month(booking_date)  order by booking_date) as acumulative_avg
FROM (
    SELECT
    booking_date,
    SUM(total_revenue_in_euros) as total_revenue,
    AVG(total_revenue_in_euros) AS avg_moving
    FROM transactions
    WHERE booking_date IS NOT NULL
    GROUP BY booking_date

     ) as t;

SELECT
    month(T.booking_date) AS month_t,
    H.Name,
    SUM(t.total_revenue_in_euros) as total_revenue
FROM transactions T
left join hotels H
on T.hotel_id = H.ID
where booking_date IS NOT NULL
GROUP BY month(T.booking_date), H.Name;

WITH month_hotel_sales as (
    SELECT
    month(T.booking_date) AS month_t,
    H.Name as hotel,
    SUM(t.total_revenue_in_euros) as total_revenue
    FROM transactions T
    left join hotels H
    on T.hotel_id = H.ID
    where booking_date IS NOT NULL
    GROUP BY month(T.booking_date), H.Name
)
    SELECT
        month_t,
        hotel,
        total_revenue,
        avg(total_revenue) over ( partition by hotel) as avg_hotel,
        total_revenue - avg(total_revenue) over ( partition by hotel) as dif,
        CASE
            WHEN total_revenue - avg(total_revenue) over ( partition by hotel) > 0 THEN 'TOP'
            WHEN total_revenue - avg(total_revenue) over ( partition by hotel) < 0 THEN 'BOTTOM'
        ELSE 'MIDDLE'
        END Avg_change

    FROM month_hotel_sales
    order by hotel;

SELECT
    H.Name,
    SUM(total_revenue_in_euros) AS total_revenue
from transactions T
left join hotels H on T.hotel_id = H.ID
GROUP BY H.Name;

with hotel_sales as(
    SELECT
    H.Name  as hotel,
    SUM(total_revenue_in_euros) AS total_revenue
    from transactions T
    left join hotels H on T.hotel_id = H.ID
    GROUP BY H.Name
)
    select
        hotel,
        total_revenue,
        sum(total_revenue) over (  ) as overall_revenue,
        concat(round(CAST(total_revenue AS FLOAT) / SUM(total_revenue) OVER () * 100,2),'%') AS pct_revenue
    from hotel_sales;