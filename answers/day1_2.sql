with
source as (select column0 as string, row_number() over (order by Null) as rn from read_csv('data/day1.csv', auto_detect=true, ignore_errors=1, header=false)),

map as (
    select 0 as number, 'zero' as spelling union all
    select 1, 'one' union all
    select 2, 'two' union all
    select 3, 'three' union all
    select 4, 'four' union all
    select 5, 'five' union all
    select 6, 'six' union all
    select 7, 'seven' union all
    select 8, 'eight' union all
    select 9, 'nine'
),

chunks as (
    select
        t2.string,
        rn,
        i as start_index,
        string_chunk,
        
    from range(1,100) t(i), lateral (select string, rn, string[i:] as string_chunk from source) t2(string, rn, string_chunk)
    where string_chunk != ''
),

matching as (
    select
        string,
        rn,
        start_index,
        map.spelling as match,
        map.number as number_match,
        string_chunk,
        regexp_matches(string_chunk, '^' || map.spelling) as is_match
    from chunks, map
    union all
    select
        string,
        rn,
        start_index,
        map.number as match,
        map.number as number_match,
        string_chunk,
        string_chunk[1] = cast(map.number as string) as is_match
    from chunks, map
),

first_last as (
    select distinct
        string,
        rn,
        cast(first(number_match) over (partition by string order by start_index asc) ||
        first(number_match) over (partition by string order by start_index desc) as int) as calibration_value
    from matching
    where is_match
)

select sum(calibration_value) from first_last


;