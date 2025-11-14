
{{ config(materialized='table') }}

with raw_rank as (
    select * from {{ ref('rank') }}
)

select DISTINCT *
from raw_rank