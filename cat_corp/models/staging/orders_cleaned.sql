
{{ config(materialized='table') }}

with raw_orders as (
    select * from {{ ref('orders') }}
)

select DISTINCT *
from raw_orders