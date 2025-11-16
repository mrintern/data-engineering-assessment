
{{ config(materialized='table') }}

select DISTINCT * from {{ ref('rank') }}