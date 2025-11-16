
{{ config(materialized='table') }}

with reporting as (
    select *
    from {{ ref('orders_status_daily') }}
)

select *
from reporting