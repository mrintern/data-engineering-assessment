
{{ config(materialized='table') }}

with raw_listing as (
    select * from {{ ref('listing') }}
)

select DISTINCT *
from raw_listing