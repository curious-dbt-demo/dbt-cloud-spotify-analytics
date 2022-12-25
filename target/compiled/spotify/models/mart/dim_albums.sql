-- albums table



    select distinct
        album_id,
        album_name,
        album_release_year,
        album_type                                   
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_songplays`
    union distinct

    select distinct
        album_id,
        album_name,
        album_release_year,
        album_type                                   
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_tracks`
    
