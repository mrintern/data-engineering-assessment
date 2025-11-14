
{{ config(materialized='table') }}

with raw_ratings_agg as (
    select * from {{ ref('ratings_agg') }}
)

select DISTINCT *
from raw_ratings_agg