
{{ config(materialized='table') }}

with ranked as (
    select
        *,
        row_number() over (
            partition by date, listing_id
            order by cnt_ratings desc, avg_rating desc
        ) as rn
    from (select DISTINCT * from {{ ref('ratings_agg') }}) as r
)

select
    date,
    listing_id,
    cnt_ratings,
    avg_rating
from ranked
where rn = 1
order by date, listing_id
