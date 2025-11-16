
{{ config(materialized='table') }}

-- The reporting table should contain information on 
-- more interesting data on individual orders
-- delta ratings (per day )
-- ratings (both cumulative and delta) 
-- and rank (average of available data points per day).


-- i want uniqueness for date + listing_id
select a.*, 
       coalesce(b.completed_orders, 0) as completed_orders, -- null here means 0 orders were completed
       c.outlet_id as outlet_id,
       c.platform_id as platform_id,
       c.org_id as org_id,
       e.cnt_ratings as cnt_ratings,
       e.avg_rating as avg_rating,
       lag(e.cnt_ratings) over (
        partition by a.listing_id
        order by a.date
        ) as cnt_ratings_yesterday
from {{ ref('orders_daily_agg') }} as a -- good
LEFT JOIN {{ ref('orders_status_daily') }} as b -- good
on a.listing_id = b.listing_id
and a.date = b.date
LEFT JOIN {{ref('listing_lookup')}} as c --good
on a.listing_id = c.id
LEFT JOIN {{ref('ratings_agg_cleaned')}} as e
on a.listing_id = e.listing_id
and a.date = e.date

