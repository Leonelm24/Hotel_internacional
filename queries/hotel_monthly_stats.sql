CREATE OR ALTER VIEW vw_hotel_monthly_stats AS
WITH base AS (
    SELECT
        t.hotel_id,
        h.Name AS hotel_name,
        FORMAT(t.booking_date, 'yyyy-MM') AS year_month,
        t.total_revenue_in_euros
    FROM transactions t
    JOIN hotels h ON t.hotel_id = h.ID
),

agg_stats AS (
    SELECT
        hotel_id,
        hotel_name,
        year_month,
        COUNT(*) AS total_transacciones,
        AVG(total_revenue_in_euros) AS media_ingresos,
        MIN(total_revenue_in_euros) AS minimo,
        MAX(total_revenue_in_euros) AS maximo,
        MAX(total_revenue_in_euros) - MIN(total_revenue_in_euros) AS rango,
        VARP(total_revenue_in_euros) AS varianza,
        STDEVP(total_revenue_in_euros) AS desviacion,
        CASE
            WHEN AVG(total_revenue_in_euros) = 0 THEN NULL
            ELSE STDEVP(total_revenue_in_euros) / AVG(total_revenue_in_euros) * 100
        END AS coeficiente_variacion
    FROM base
    GROUP BY hotel_id, hotel_name, year_month
),


percentiles AS (
    SELECT DISTINCT
        hotel_id,
        year_month,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue_in_euros) OVER (PARTITION BY hotel_id, year_month) AS percentil_25,
        PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY total_revenue_in_euros) OVER (PARTITION BY hotel_id, year_month) AS mediana,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue_in_euros) OVER (PARTITION BY hotel_id, year_month) AS percentil_75
    FROM base
),

moda_calc AS (
    SELECT
        hotel_id,
        FORMAT(booking_date, 'yyyy-MM') AS year_month,
        total_revenue_in_euros,
        COUNT(*) AS frecuencia,
        ROW_NUMBER() OVER (
            PARTITION BY hotel_id, FORMAT(booking_date, 'yyyy-MM')
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM transactions
    GROUP BY hotel_id, FORMAT(booking_date, 'yyyy-MM'), total_revenue_in_euros
)

SELECT
    a.hotel_id,
    a.hotel_name,
    a.year_month,
    a.total_transacciones,
    a.media_ingresos,
    a.minimo,
    a.maximo,
    a.rango,
    a.varianza,
    a.desviacion,
    a.coeficiente_variacion,
    p.percentil_25,
    p.mediana,
    p.percentil_75,
    m.total_revenue_in_euros AS moda
FROM agg_stats a
LEFT JOIN percentiles p
    ON a.hotel_id = p.hotel_id AND a.year_month = p.year_month
LEFT JOIN moda_calc m
    ON a.hotel_id = m.hotel_id AND a.year_month = m.year_month AND m.rn = 1;
