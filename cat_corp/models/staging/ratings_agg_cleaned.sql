
{{ config(materialized='table') }}


select DISTINCT * from {{ ref('ratings_agg') }}