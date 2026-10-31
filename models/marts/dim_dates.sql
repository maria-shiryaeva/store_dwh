{{ config(
    distributed_replicated=true
) }}

with date_all as (
    select min(order_date) as min_date,
        max(order_date) as max_date
    from {{ ref('fct_orders') }}
),

date_interval as (
    select generate_series(
        (select min_date from date_all),
        (select max_date from date_all),
        '1 day'::interval
    )::date as date_key
)

select date_key,
    extract(year from date_key)::int as year,
    extract(quarter from date_key)::int as quarter,
    extract(month from date_key)::int as month,
    extract(day from date_key)::int as day,
    extract(isodow from date_key)::int as day_of_week,
    extract(isodow from date_key) in (6, 7) as is_weekend
from date_interval