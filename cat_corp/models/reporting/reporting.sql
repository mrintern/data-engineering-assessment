
{{ config(materialized='table') }}


select * from {{ ref('orders_status_daily') }}
