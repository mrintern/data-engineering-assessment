-- models/staging/orders_cleaned.sql

{{ config(materialized='table') }}

with raw_orders as (
    select * from {{ ref('orders') }}
)

select *
from raw_orders