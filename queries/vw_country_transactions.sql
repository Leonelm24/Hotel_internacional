CREATE OR ALTER VIEW vw_country_transactions AS
SELECT
    customer_country,
    COUNT(*) AS total_bookings,
    SUM(total_revenue_in_euros) AS total_revenue,
    AVG(total_revenue_in_euros) AS avg_revenue,
    STDEVP(total_revenue_in_euros) AS stddev_revenue,
    -- Coeficiente de variación
    (STDEVP(total_revenue_in_euros) / NULLIF(AVG(total_revenue_in_euros), 0)) * 100 AS coef_variation
FROM transactions
GROUP BY customer_country;
;

/*SELECT
    t.customer_country,
    COUNT(*) AS total_transactions,
    SUM(t.total_revenue_in_euros) AS total_revenue,
    SUM(t.total_revenue_in_euros) * 1.0 / COUNT(*) AS avg_ticket,
    SUM(t.total_revenue_in_euros) * 1.0 / SUM(t.rooms_booked) AS avg_ticket_per_room
FROM transactions t
GROUP BY t.customer_country;*/

