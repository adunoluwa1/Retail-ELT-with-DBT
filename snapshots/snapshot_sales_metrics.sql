{% snapshot snapshot_sales_metrics %}
{{config(
    target_schema='snapshots',
    strategy='timestamp',
    unique_key='order_date',
    updated_at='etl_load_timestamp'
)}}

SELECT * FROM {{ref('sales_metrics')}}
{% endsnapshot %}