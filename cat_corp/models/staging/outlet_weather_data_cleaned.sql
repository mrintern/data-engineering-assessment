
{{ config(materialized='table') }}

select 
    date::date as date,
    round(avg(temperature_2m::numeric), 2) as avg_tmp,
    round(avg(wind_speed_10m::numeric), 2) as avg_wind,
    round(avg(relative_humidity_2m::numeric), 2) as avg_humidity,
    REPLACE(outlet_id::text, '.0', '') as outlet_id
from {{ ref('outlet_weather_data') }}
group by date::date, outlet_id
order by date, outlet_id