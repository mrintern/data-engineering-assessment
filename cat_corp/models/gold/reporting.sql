
{{ config(materialized='table') }}

-- The reporting table should contain information on 
-- more interesting data on individual orders

-- i want uniqueness for date + listing_id
select a.*, 
       coalesce(b.completed_orders, 0) as completed_orders, -- null here means 0 orders were completed
       c.outlet_id as outlet_id,
       c.platform_id as platform_id,
       c.org_id as org_id,
       e.cnt_ratings as cnt_ratings,
       d.avg_tmp as avg_tmp,
       d.avg_wind as avg_wind,
       d.avg_humidity as avg_humidity,
       e.avg_rating as avg_rating,
       f.avg_rank as avg_rank,
       lag(e.cnt_ratings) over (
        partition by a.listing_id
        order by a.date
        ) as cnt_ratings_yesterday,
        cnt_ratings - lag(e.cnt_ratings) over (
        partition by a.listing_id
        order by a.date
        ) as delta_ratings
from {{ ref('orders_daily_agg') }} as a 
LEFT JOIN {{ ref('orders_status_daily') }} as b 
on a.listing_id = b.listing_id
and a.date = b.date
LEFT JOIN {{ref('listing_lookup')}} as c 
on a.listing_id = c.id
LEFT JOIN {{ref('outlet_weather_data_cleaned')}} as d
on c.outlet_id = d.outlet_id::int
and a.date = d.date
LEFT JOIN {{ref('ratings_agg_cleaned')}} as e
on a.listing_id = e.listing_id
and a.date = e.date
LEFT JOIN {{ref('rank_daily_agg')}} as f
on a.listing_id = f.listing_id
and a.date = f.date

order by listing_id, date desc
