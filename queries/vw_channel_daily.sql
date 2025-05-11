CREATE OR ALTER VIEW vw_channel_daily AS
    SELECT
    booking_date,
    id_marketing_channel,
    SUM(total_revenue_in_euros) AS total_revenue,
    COUNT(DISTINCT booking_id) AS total_reservations,
    -- Ratio ingresos por reserva
    SUM(total_revenue_in_euros) / NULLIF(COUNT(DISTINCT booking_id), 0) AS revenue_per_booking,
    -- Media móvil 7 días por canal
    AVG(SUM(total_revenue_in_euros)) OVER (
        PARTITION BY id_marketing_channel ORDER BY booking_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7d
FROM transactions
GROUP BY booking_date, id_marketing_channel;

/*SELECT
    t.booking_date,
    c.Channel_Name,
    c.Channel_Type,
    COUNT(*) AS total_transactions,
    SUM(t.total_revenue_in_euros) AS total_revenue,
    SUM(t.total_revenue_in_euros) * 1.0 / COUNT(*) AS avg_ticket
FROM transactions t
JOIN channels c ON t.id_marketing_channel = c.ID
GROUP BY t.booking_date, c.Channel_Name, c.Channel_Type;
*/