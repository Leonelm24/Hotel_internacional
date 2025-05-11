-- Base Query
create view report_revenue as
with base_query as (
    SELECT
        T.booking_date,
        T.hotel_id,
        T.total_revenue_in_euros as revenue,
        H.Name as Hotel,
        H.Location as Country
    FROM transactions T
    left join hotels H on T.hotel_id = H.ID
    WHERE t.booking_date IS NOT NULL
),
    /* Agregaciones personalizadas */
    customer_aggregation as(
       select
    booking_date,
    Hotel,
    Country,
    count(revenue) as total_transaction,
    sum(revenue) as total_revenue,
    round(avg(revenue),2) as avg_revenue,
    max(revenue) as max_revenue,
    min(revenue) as min_revenue,
    datediff(month , min(booking_date), max(booking_date)) as lifespan
    from base_query
        group by
            booking_date, Hotel, Country
    )
    SELECT
        booking_date,
        Hotel,
        Country,
        total_transaction,
        total_revenue,
        avg_revenue,
        CASE
            WHEN total_revenue > avg_revenue then 'top'
            WHEN total_revenue < avg_revenue then 'bottom'
            ELSE 'equal'
        END AS performance_revenue,

        max_revenue,
        min_revenue,
        lifespan
    FROM customer_aggregation