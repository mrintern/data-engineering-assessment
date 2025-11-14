-- tests/unique_order_customer.sql

with duplicates as (
    select
        order_id,
        listing_id,
        count(*) as count_rows
    from {{ ref('orders_cleaned') }}
    group by order_id, listing_id
    having count(*) > 1
)

select *
from duplicates
