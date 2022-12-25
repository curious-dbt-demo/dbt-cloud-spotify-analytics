



select
    1
from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_artists`

where not(artist_rank artist_rank >= 1)

