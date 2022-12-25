

  create or replace view `dbt-demo-data-372717`.`dbt_ddemo`.`vw_songplays_albums`
  OPTIONS()
  as -- songplays_albums table
with songplay_albums as (
    select
        f.*,
        a.album_name,
        a.album_release_year,
        a.album_type,
        t.track_name,
        track_popularity,
        track_danceability,
        track_speechiness
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_songplays` f
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_tracks` t using (track_id)
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_albums` a using (album_id)
)
select
    *
from songplay_albums;

