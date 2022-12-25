
  
    

    create or replace table `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists`
    
    
    OPTIONS()
    as (
      -- artists table



    select distinct
        artist_id,
        artist_name,
        artist_popularity,
        artist_followers,
        artist_genre,
        artist_genre_others                                     
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_songplays`
    union distinct

    select distinct
        artist_id,
        artist_name,
        artist_popularity,
        artist_followers,
        artist_genre,
        artist_genre_others                                     
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_artists`
    union distinct

    select distinct
        artist_id,
        artist_name,
        artist_popularity,
        artist_followers,
        artist_genre,
        artist_genre_others                                     
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_tracks`
    

    );
  