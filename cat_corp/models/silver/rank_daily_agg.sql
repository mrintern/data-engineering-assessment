
{{ config(materialized='table') }}

select 
    listing_id,date,avg(rank) as avg_rank
    from {{ref('rank_cleaned')}}
    where is_online = true
GROUP BY listing_id,date
