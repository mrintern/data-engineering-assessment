
{{ config(materialized='table') }}


select 
    listing_id, date, count(*) as completed_orders
from {{ ref('orders_cleaned') }}
    where status = 'completed'
    group by listing_id, date
    order by listing_id, date