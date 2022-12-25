-- top_track_genres table
With other_genres as (
    select split(a.artist_genre_others) as nested_genres
    from {{ ref('fct_top_tracks') }} f
    left join {{ ref('dim_artists') }} a using (artist_id)
),

track_genres as (
    select
        a.artist_genre
    from {{ ref('fct_top_tracks') }} f
    left join {{ ref('dim_artists') }} a using (artist_id)
    union all
    select
        unnested
    from other_genres, unnest(nested_genres) as unnested
)
select
    *,
    count(*) as count
from track_genres
where artist_genre is not null
group by artist_genre       
order by count desc