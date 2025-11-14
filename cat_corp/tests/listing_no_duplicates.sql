
with duplicates as (
    select
        id,
        outlet_id,
        platform_id,
        timestamp,
        count(*) as count_rows
    from {{ ref('listing_cleaned') }}
    group by id, outlet_id, platform_id, timestamp
    having count(*) > 1
)

select *
from duplicates
