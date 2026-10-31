{{ config(
    distributed_replicated=true
) }}

with products as (
    select * 
    from {{ ref('stg_shop__products') }}
),

categories as (
    select * 
    from {{ ref('stg_shop__product_categories') }}
),

category_tree as (
    select c.category_id,
        c.category_name,
        p.category_name as parent_category_name,
        coalesce(gp.category_name, p.category_name, c.category_name) as root_category_name
    from categories c
    left join categories p on p.category_id = c.parent_category_id
    left join categories gp on gp.category_id = p.parent_category_id
)

select pr.product_id,
    pr.product_name,
    pr.brand,
    pr.category as category_name,
    ct.parent_category_name,
    ct.root_category_name
from products pr
left join category_tree ct on ct.category_name = pr.category