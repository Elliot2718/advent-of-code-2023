with
games as (
    select
        *
    from read_csv(
        'data/day2.txt',
        delim='|',
        header=false,
        columns={'game_results': 'varchar'}
    )
),

parse_1 as (
    select
        string_split(string_split(game_results, ':')[1],' ')[2] as game,
        [[l] for l in string_split(string_split(game_results, ':')[2], ';')] as results
    from games
),

parse_2 as (
    select
        game,
        row_number() over (partition by game) as draw_number,
        string_split(draw, ',') as draw
    from (
        select
            game,
            unnest(results, recursive := true) as draw
        from parse_1
    )
),

parse_3 as (
select
    game,
    draw_number,
    string_split(trim(d.draw), ' ')[2] as draw_color,
    cast(string_split(trim(d.draw), ' ')[1] as int) as draw_count
from parse_2, unnest(draw) as d
),

minimum_possible as (
select
    game,
    draw_color,
    max(draw_count) as minimum_possible
from parse_3
group by 1, 2
),

powers as (
    select
        game,
        product(minimum_possible) as product_of_minimums
    from minimum_possible
    group by 1
)

select sum(product_of_minimums) from powers

;