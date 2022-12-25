

  create or replace view `dbt-demo-data-372717`.`dbt_ddemo`.`vw_top_artist_genres`
  OPTIONS()
  as -- top_artist_genres table
With other_genres as (
    select split(a.artist_genre_others) as nested_genres
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists` f
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists` a using (artist_id)
),

artist_genres as (
    select
        a.artist_genre
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists` f
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists` a using (artist_id)
    union all
    select
        unnested
    from other_genres, unnest(nested_genres) as unnested
)
select
    *,
    count(*) as count
from artist_genres
where artist_genre is not null
group by artist_genre       
order by count desc;

