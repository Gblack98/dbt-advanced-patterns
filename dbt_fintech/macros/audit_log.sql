{% macro audit_log(model_name) %}

    {% set row_count_query %}
        SELECT COUNT(*) AS row_count FROM {{ this }}
    {% endset %}

    {% set results = run_query(row_count_query) %}

    {% if execute %}
        {% set row_count = results.columns[0].values()[0] %}
        {{ log("AUDIT | " ~ model_name ~ " | rows: " ~ row_count, info=True) }}
    {% endif %}

{% endmacro %}
