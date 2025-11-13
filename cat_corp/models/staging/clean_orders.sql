-- models/staging/clean_orders.sql

{{ config(materialized='table') }}

with raw_orders as (
    select * from {{ ref('orders') }}
)

select *
from raw_orders
LIMIT 20
