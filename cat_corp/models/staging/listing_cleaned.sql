
{{ config(materialized='table') }}

select DISTINCT * from {{ ref('listing') }}
