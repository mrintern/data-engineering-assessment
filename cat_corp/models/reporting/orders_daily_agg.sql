
{{ config(materialized='table') }}

select date,listing_id, sum(orders) as total_orders

    from {{ref('orders_daily_cleaned')}}
GROUP BY date,listing_id
