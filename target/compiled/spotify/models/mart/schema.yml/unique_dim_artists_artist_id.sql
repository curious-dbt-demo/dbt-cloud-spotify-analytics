
    
    

with dbt_test__target as (

  select artist_id as unique_field
  from `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists`
  where artist_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


