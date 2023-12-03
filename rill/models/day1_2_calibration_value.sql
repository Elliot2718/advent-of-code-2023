with to_list as (
  select
    original_string,
    string,
    string_split(string, '') as list
  from day1_2_replacement 
),

unnest as (
  select
    original_string,
    string,
    list,
    unnest(list) as character,
    generate_subscripts(list, 1) as subscript
  from to_list
),

identify_numbers as (
  select
    original_string,
    string,
    character,
    subscript,
    ascii(character) between 48 and 57 is_number
  from unnest
),

output as (
  select
    original_string,
    string,
    cast(concat(first(character order by subscript), last(character order by subscript)) as numeric) as calibration_value
  from identify_numbers
  where is_number = true
  group by 1, 2
)

select * from output where calibration_value = 88