
  
    

    create or replace table `dbt-demo-data-372717`.`dbt_ddemo`.`fct_songplays`
    
    
    OPTIONS()
    as (
      -- songplays table
with source as (
    select
        *
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_songplays`
),
fact_songplays as (
    select
        songplays_id,
        track_id,
        track_played_at,
        album_id,
        artist_id,
        artist_id_others,
        artist_name_others
    from source
)
select
    *
from fact_songplays
    );
  