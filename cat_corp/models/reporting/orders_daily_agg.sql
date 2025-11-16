
{{ config(materialized='table') }}

select date,listing_id, round(avg(orders),2) as avg_orders
    from {{ref('orders_daily_cleaned')}}
GROUP BY date,listing_id
