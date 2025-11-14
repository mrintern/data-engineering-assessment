
{{ config(materialized='table') }}

with raw_platform as (
    select * from {{ ref('platform') }}
)

select DISTINCT *
from raw_platform