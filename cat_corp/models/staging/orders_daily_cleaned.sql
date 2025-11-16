
{{ config(materialized='table') }}

select DISTINCT * from {{ ref('orders_daily') }}
