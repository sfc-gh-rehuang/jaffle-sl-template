with 

orders as (
    
    select * from {{ ref('stg_orders')}}

),

order_items_table as (
    
    select * from {{ ref('order_items')}}

),

order_items_summary as (

    select

        order_items.order_id,

        sum(supply_cost) as order_cost,
        sum(is_food_item) as count_food_items,
        sum(is_drink_item) as count_drink_items,
        count(order_item_id) as count_order_items
 

    from order_items_table as order_items

    group by 1

),


compute_booleans as (
    select

        orders.*,
        count_food_items > 0 as is_food_order,
        count_drink_items > 0 as is_drink_order,
        order_cost,
        count_order_items

    from orders
    
    left join order_items_summary on orders.order_id = order_items_summary.order_id
)

select * from compute_booleans
