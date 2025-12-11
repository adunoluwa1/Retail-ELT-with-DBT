{%- macro initcap_and_coalesce(column_name, value='') -%}
    INITCAP(COALESCE({{column_name}},'{{value}}'))
{%- endmacro -%}