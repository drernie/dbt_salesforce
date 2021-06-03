with order as (

    select *
    from {{ var('order') }}

), salesforce_user as (

    select *
    from {{ var('user') }}

), account as (

    select *
    from {{ var('account') }}

), add_fields as (

    select
      order.*,
      account.account_number,
      account.account_source,
      account.industry,
      account.account_name,
      account.number_of_employees,
      account.type as account_type,
      order_owner.user_id as order_owner_id,
      order_owner.user_name as order_owner_name,
      order_owner.city order_owner_city,
      order_owner.state as order_owner_state,
      order_manager.user_id as order_manager_id,
      order_manager.user_name as order_manager_name,
      order_manager.city order_manager_city,
      order_manager.state as order_manager_state


    --The below script allows for pass through columns.

      {% if var('order_enhanced_pass_through_columns') %}
      ,
      {{ var('order_enhanced_pass_through_columns') | join (", ")}}

      {% endif %}

    from order
    left join account
      on order.account_id = account.account_id
    left join salesforce_user as order_owner
      on order.owner_id = order_owner.user_id
    left join salesforce_user as order_manager
      on order_owner.manager_id = order_manager.user_id
)

select *
from add_fields
