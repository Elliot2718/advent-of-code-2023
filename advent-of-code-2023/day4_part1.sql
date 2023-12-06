with
scratchcards as (
    select
        row_number() over (order by Null) as row_index,
        row_text
    from read_csv(
        'data/day4.txt',
        header=false,
        columns={'row_text': 'varchar'}
    )
),

winning_numbers as (
    select
        cast(substring(row_text, 6, 3) as int) as card,
        generate_series as winning_number_index,
        cast(substring(row_text, 8 + generate_series * 3, 3) as int) as winning_number
    from scratchcards, generate_series(1,10)
),

my_numbers as (
    select
        cast(substring(row_text, 6, 3) as int) as card,
        generate_series as my_number_index,
        cast(substring(row_text, 40 + generate_series * 3, 3) as int) as my_number
    from scratchcards, generate_series(1,25)
),

matches as (
    select
        a.card,
        my_number_index,
        my_number,
        winning_number_index,
        winning_number
    from my_numbers as a cross join winning_numbers as b
    where a.card = b.card and a.my_number = b.winning_number
    order by a.card, my_number_index
),

points as (
    select
        card,
        count(my_number) as matches,
        2 ** (count(my_number) - 1) as points
    from matches
    group by 1
    order by card
)

select sum(points) from points
;