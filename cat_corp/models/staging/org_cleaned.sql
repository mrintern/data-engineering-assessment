
{{ config(materialized='table') }}

with raw_org as (
    select * from {{ ref('org') }}
)

select DISTINCT *
from raw_org