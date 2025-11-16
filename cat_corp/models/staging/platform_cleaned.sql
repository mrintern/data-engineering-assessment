
{{ config(materialized='table') }}


select * from {{ ref('platform') }}
