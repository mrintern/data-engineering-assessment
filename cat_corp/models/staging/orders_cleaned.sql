
{{ config(materialized='table') }}

select DISTINCT
    listing_id,
    order_id,
    placed_at,
    status,
    placed_at::date as date

from {{ ref('orders') }}