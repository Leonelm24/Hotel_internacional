CREATE OR ALTER VIEW vw_hotel_sales AS
SELECT
    t.hotel_id,
    h.Name AS hotel_name,
    SUM(t.total_revenue_in_euros) AS total_revenue,
    SUM(t.rooms_booked) AS total_rooms,
    COUNT(*) AS total_transactions,
    -- Métricas derivadas
    SUM(t.total_revenue_in_euros) * 1.0 / COUNT(*) AS avg_ticket,
    SUM(t.total_revenue_in_euros) * 1.0 / SUM(t.rooms_booked) AS avg_ticket_per_room
FROM transactions t
JOIN hotels h ON t.hotel_id = h.ID
GROUP BY t.hotel_id, h.Name;

