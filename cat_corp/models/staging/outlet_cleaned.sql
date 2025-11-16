
{{ config(materialized='table') }}

select DISTINCT
    id,
    org_id,
    name,
    coalesce(latitude, 0.0)  as latitude,
    coalesce(longitude, 0.0) as longitude,
    timestamp
from {{ ref('outlet') }}