with recursive

map as (
  select map{
      0: 'zero',
      1: 'one',
      2: 'two',
      3: 'three',
      4: 'four',
      5: 'five',
      6: 'six',
      7: 'seven',
      8: 'eight',
      9: 'nine',
  } as m
),

input as (
  select column0 as string from day1
),

number_sequence as (
  union all
  select
    1 as number,
    string as original_string,
    regexp_replace(string,m[0][1], 0, 'g') as string
  from input, map
  union all
  select number+1, original_string, regexp_replace(string, m[number][1], number, 'g') 
  from number_sequence, map
  where number <= 10
)

select * from number_sequence where original_string like '%oneight%'