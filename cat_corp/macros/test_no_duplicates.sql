{% test no_duplicates(model) %}

with base as (

    select * from {{ model }}

),

grouped as (
    select
        *,
        count(*) over (
            partition by {{ dbt_utils.star(model, except=['']) }} -- partition by all columns
        ) as row_count
    from base
)

select *
from grouped
where row_count > 1

{% endtest %}
