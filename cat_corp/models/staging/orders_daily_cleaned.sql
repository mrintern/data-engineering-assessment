
{{ config(materialized='table') }}

select DISTINCT * from {{ ref('orders_daily') }}
where orders >= 0
