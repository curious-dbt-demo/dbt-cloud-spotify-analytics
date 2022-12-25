



select
    1
from `dbt-demo-data-372717`.`dbt_ddemo`.`fct_top_tracks`

where not(track_rank track_rank >= 1)

