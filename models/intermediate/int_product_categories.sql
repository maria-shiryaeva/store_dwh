with categories as (
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

select * 
from category_tree