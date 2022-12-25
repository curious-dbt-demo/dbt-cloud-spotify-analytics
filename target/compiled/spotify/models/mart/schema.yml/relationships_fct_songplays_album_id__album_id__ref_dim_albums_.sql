
    
    

with child as (
    select album_id as from_field
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_songplays`
    where album_id is not null
),

parent as (
    select album_id as to_field
    from `dbt-demo-data-372717`.`dbt_ddemo`.`dim_albums`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


