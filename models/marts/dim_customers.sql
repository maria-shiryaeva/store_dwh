{{ config(
    distributed_replicated=true
) }}

with customers as (
    select * 
    from {{ ref('stg_shop__customers') }}
),

customer_orders as (
    select customer_id,
        min(order_id) filter (where is_confirmed) as first_confirmed_order_id,
        min(ordered_at) filter (where is_confirmed) as first_confirmed_at,
        count(*) filter (where is_confirmed) as confirmed_orders_count,
        coalesce(sum(order_amount) filter (where is_confirmed), 0) as confirmed_revenue,
        bool_or(is_confirmed) as buy
    from {{ ref('fct_orders') }}
    group by customer_id
)

select c.customer_id,
    c.registration_date,
    c.city,
    c.acquisition_channel,
    o.first_confirmed_order_id,
    o.first_confirmed_at,
    coalesce(o.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(o.confirmed_revenue, 0) as confirmed_revenue,
    coalesce(o.is_buyer, false) as buy
from customers c
left join customer_orders o on o.customer_id = c.customer_id