
{{ config(materialized='table') }}

select DISTINCT * from {{ ref('org') }}
