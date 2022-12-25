
  
    

    create or replace table `dbt-demo-data-372717`.`dbt_ddemo`.`dim_albums`
    
    
    OPTIONS()
    as (
      -- albums table



    select distinct
        album_id,
        album_name,
        album_release_year,
        album_type                                   
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_songplays`
    union

    select distinct
        album_id,
        album_name,
        album_release_year,
        album_type                                   
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_tracks`
    

    );
  