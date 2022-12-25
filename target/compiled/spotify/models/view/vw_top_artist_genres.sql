-- top_artist_genres table
with artist_genres as (
    select
        a.artist_genre
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists` f
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists` a using (artist_id)
    union all
    select
        unnest(string_to_array(a.artist_genre_others, ', ')) as artist_genre
    from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists` f
    left join `dbt-demo-data-372717`.`dbt_ddemo`.`dim_artists` a using (artist_id)
)
select
    *,
    count(*) as count
from artist_genres
where artist_genre is not null
group by artist_genre       
order by count desc