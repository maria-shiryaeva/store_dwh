{{ config(severity='warn') }}

select * 
from {{ ref('fct_orders') }}
where paid_amount > order_amount