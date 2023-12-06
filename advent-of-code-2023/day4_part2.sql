with recursive
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
        count(winning_number) as matches
    from my_numbers as a cross join winning_numbers as b,
    where a.card = b.card and a.my_number = b.winning_number
    group by 1
    order by a.card
),

start as (
    select a.card, b.matches
    from (select distinct card from my_numbers) as a
        left join matches as b on a.card = b.card
    order by a.card
),

copies as (
    select card, matches from start
    union all
    select
        a.card,
        b.matches
    from (
        select
            i as card,
        from copies as a, unnest(generate_series(card + 1, card + matches)) as b(i)
        order by i
    ) as a inner join start as b on a.card = b.card
    where a.card <= 205
)

select * from copies;
