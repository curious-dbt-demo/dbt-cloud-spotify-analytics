
  
    

    create or replace table `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists`
    
    
    OPTIONS()
    as (
      -- top_artists table
with source as (
    select
        *
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_artists`
),
fact_top_artists as (
    select
        artist_rank,
        artist_id
    from source
)
select
    *
from fact_top_artists
    );
  