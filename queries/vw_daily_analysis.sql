CREATE OR ALTER VIEW vw_daily_analysis AS
SELECT
    booking_date,
    hotel_id,
    SUM(total_revenue_in_euros) AS total_revenue,
    COUNT(DISTINCT booking_id) AS total_reservations,

    -- Media móvil de 7 días
    AVG(SUM(total_revenue_in_euros)) OVER (PARTITION BY hotel_id ORDER BY booking_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_7d,

    -- Media móvil de 14 días
    AVG(SUM(total_revenue_in_euros)) OVER (PARTITION BY hotel_id ORDER BY booking_date ROWS BETWEEN 13 PRECEDING AND CURRENT ROW) AS moving_avg_14d,

    -- Media móvil de 30 días
    AVG(SUM(total_revenue_in_euros)) OVER (PARTITION BY hotel_id ORDER BY booking_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS moving_avg_30d

FROM transactions
GROUP BY booking_date, hotel_id;


/*SELECT
    t.booking_date,
    COUNT(*) AS total_transactions,
    SUM(t.total_revenue_in_euros) AS total_revenue,
    -- Métricas derivadas
    SUM(t.total_revenue_in_euros) * 1.0 / COUNT(*) AS avg_ticket,
    SUM(t.total_revenue_in_euros) * 1.0 / SUM(t.rooms_booked) AS avg_ticket_per_room,
    DATENAME(WEEKDAY, t.booking_date) AS weekday
FROM transactions t
GROUP BY t.booking_date;*/
