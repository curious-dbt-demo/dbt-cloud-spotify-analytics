
    
    

with dbt_test__target as (

  select artist_genre as unique_field
  from `dbt-demo-data-372717`.`dbt_ddemo`.`vw_top_track_genres`
  where artist_genre is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


