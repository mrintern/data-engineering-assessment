
{{ config(materialized='table') }}

with raw_orders as (
    select * from {{ ref('orders') }}
)

select DISTINCT
    listing_id,order_id,placed_at,status,
    placed_at::date as date

from raw_orders