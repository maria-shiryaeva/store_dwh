select order_id,
    is_confirmed,
    successful_payments_count
from {{ ref('fct_orders') }}
where is_confirmed = true and successful_payments_count = 0