select *
from {{ ref('rank_cleaned') }}
where is_online = true
  and rank is null
