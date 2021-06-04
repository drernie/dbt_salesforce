with order as (

    select *
    from {{ var('enhanced') }}

), item as (

    select *
    from {{ var('item') }}

), product as (

    select *
    from {{ var('product') }}

), add_fields as (

    select
      order.order_number,
      order.account_name,
      order.account_type,
      order.total_amount,
      order.effective_date,
      order.end_date,
      order.status,
      order.status_code,
      order.record_type_id,
      product.product_code,
      product.name as product_name,
      product.family as product_family,
      item.*


    --The below script allows for pass through columns.

      {% if var('order_enhanced_pass_through_columns') %}
      ,
      {{ var('order_enhanced_pass_through_columns') | join (", ")}}

      {% endif %}

    from item
    left join order
      on item.order_id = order.order_id
    left join product
      on item.product_2_id = product.product_id
)

select *
from add_fields
