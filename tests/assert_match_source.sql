with source_sum as (
    select sum(p.amount) as source_amount
    from {{ source('shop', 'orders') }} o
    join {{ source('shop', 'payments') }} p on p.order_id = o.order_id
    where o.status = 'paid' 
      and p.payment_status = 'success' 
      and p.amount > 0
),
mart_sum as (
    select sum(paid_amount) as mart_amount
    from {{ ref('fct_orders') }}
    where is_confirmed = true
)
select * 
from source_sum, mart_sum
where source_sum.source_amount != mart_sum.mart_amount