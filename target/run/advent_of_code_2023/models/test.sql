
  
  create view "memory"."main"."test__dbt_tmp" as (
    select * from read_csv('data/day1.csv', auto_detect=true, ignore_errors=1, header=false)
  );
