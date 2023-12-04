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

check_draws as (
    select
        game,
        draw_number,
        draw_color,
        draw_count,
        case draw_color
            when 'red' then draw_count <= 12
            when 'green' then draw_count <= 13
            when 'blue' then draw_count <=14
        end as is_draw_possible
    from parse_3
    order by game, draw_number
),

check_games as (
    select
        game,
        product(cast(is_draw_possible as int)) as is_game_possible
    from check_draws
    group by 1
)

select
    sum(cast(game as int))
from check_games
where is_game_possible = 1
;

