with to_list as (
  select
    column0 as string,
    string_split(column0, '') as list
  from day1 
),

unnest as (
  select
    string,
    list,
    unnest(list) as character,
    generate_subscripts(list, 1) as subscript
  from to_list
),

identify_numbers as (
  select
    string,
    character,
    subscript,
    ascii(character) between 48 and 57 is_number
  from unnest
),

output as (
  select 
    string,
    cast(concat(first(character order by subscript), last(character order by subscript)) as numeric) as calibration_value
  from identify_numbers
  where is_number = true
  group by 1
)

select * from output