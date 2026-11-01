{{ config(distributed_replicated=true) }}

with products as (
    select * 
    from {{ ref('stg_shop__products') }}
),

categories as (
    select * 
    from {{ ref('int_product_categories') }}
)

select pr.product_id,
    pr.product_name,
    pr.brand,
    pr.category as category_name,
    ct.parent_category_name,
    ct.root_category_name
from products pr
left join categories ct on ct.category_name = pr.category