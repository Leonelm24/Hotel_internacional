CREATE OR ALTER VIEW vw_marketing_analysis AS
SELECT
    c.channel_name,
    t.id_marketing_channel,
    COUNT(*) AS total_bookings,
    SUM(total_revenue_in_euros) AS total_revenue,
    AVG(total_revenue_in_euros) AS avg_revenue,
    SUM(rooms_booked) AS total_rooms,
    SUM(total_revenue_in_euros) / NULLIF(SUM(rooms_booked), 0) AS revenue_per_room
FROM transactions t
JOIN channels c ON t.id_marketing_channel = c.id
GROUP BY c.channel_name, t.id_marketing_channel;

/*SELECT
    c.Channel_Name,
    c.Channel_Type,
    COUNT(*) AS total_transactions,
    SUM(t.total_revenue_in_euros) AS total_revenue,
    SUM(t.total_revenue_in_euros) * 1.0 / COUNT(*) AS avg_ticket
FROM transactions t
JOIN channels c ON t.id_marketing_channel = c.ID
GROUP BY c.Channel_Name, c.Channel_Type;*/
