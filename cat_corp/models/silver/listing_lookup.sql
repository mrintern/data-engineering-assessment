
{{ config(materialized='table') }}

with unique_listing as (
    select distinct id, outlet_id, platform_id
    from {{ ref('listing_cleaned') }}
),

outlet_lookup as (
    select distinct id, org_id, name, latitude, longitude
    from {{ ref('outlet_cleaned') }}
)

select 
    ul.*,
    ol.org_id,
    ol.name,
    ol.latitude,
    ol.longitude
from unique_listing ul
left join outlet_lookup ol
    on ul.outlet_id = ol.id
