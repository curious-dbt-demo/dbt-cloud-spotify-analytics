
    
    

with child as (
    select artist_id as from_field
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists`
    where artist_id is not null
),

parent as (
    select artist_id as to_field
    from `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


