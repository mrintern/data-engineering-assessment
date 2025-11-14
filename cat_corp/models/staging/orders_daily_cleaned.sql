
{{ config(materialized='table') }}

with raw_orders_daily as (
    select * from {{ ref('orders_daily') }}
)

select DISTINCT *
from raw_orders_daily