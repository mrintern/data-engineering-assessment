
{{ config(materialized='table') }}

with raw_outlet as (
    select * from {{ ref('outlet') }}
)

select DISTINCT *
from raw_outlet