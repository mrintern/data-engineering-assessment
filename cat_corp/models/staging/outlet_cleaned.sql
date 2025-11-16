
{{ config(materialized='table') }}

with raw_outlet as (
    select DISTINCT * from {{ ref('outlet') }}
)

select 
    id,
    org_id,
    name,
    coalesce(latitude, 0.0)  as latitude,
    coalesce(longitude, 0.0) as longitude,
    timestamp
from raw_outlet

