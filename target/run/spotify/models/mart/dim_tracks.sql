
  
    

    create or replace table `dbt-demo-data-372717`.`dbt_ddemo`.`dim_tracks`
    
    
    OPTIONS()
    as (
      -- tracks table



    select distinct
        track_id,
        track_name,
        track_duration,
        track_is_explicit,
        track_popularity,
        track_danceability,
        track_energy,
        track_key,
        track_loudness,
        track_mode,
        track_speechiness,
        track_acousticness,
        track_instrumentalness,
        track_liveness,
        track_valence
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_songplays`
    union distinct

    select distinct
        track_id,
        track_name,
        track_duration,
        track_is_explicit,
        track_popularity,
        track_danceability,
        track_energy,
        track_key,
        track_loudness,
        track_mode,
        track_speechiness,
        track_acousticness,
        track_instrumentalness,
        track_liveness,
        track_valence
    from `dbt-demo-data-372717`.`dbt_ddemo`.`stg_top_tracks`
    

    );
  