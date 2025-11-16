
{{ config(materialized='table') }}

with orders_status_daily as (
    select listing_id, status, date, count(*) as completed_orders
    
    from {{ ref('orders_cleaned') }}
    where status = 'completed'
    group by listing_id, status, date
)

select *
from orders_status_daily
order by listing_id, date