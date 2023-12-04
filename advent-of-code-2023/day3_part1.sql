with
schematic as (
    select
        row_number() over (order by Null) as row_index,
        row_text
    from read_csv(
        'data/day3.txt',
        header=false,
        columns={'row_text': 'varchar'}
    )
),

chunks as (
select
    row_index,
    generate_series as col,
    row_text,
    row_text[generate_series:] as row_text_chunk
from schematic, generate_series(1,140)
),

numbers as (
    select
        number,
        col as start_index,
        col + len(number) - 1 as end_index,
        row_index
    from (
        select
            *,
            regexp_extract(row_text_chunk,'^(\d+)') as number
        from chunks
        where number <> ''
    )
    qualify row_number() over (partition by row_index, col + len(number) - 1 order by start_index) = 1
    order by row_index, start_index
),

symbols as (
select
    regexp_extract(row_text_chunk,'^[^\w\s\d.]') as symbol,
    col as col_index,
    row_index
from chunks
where  symbol <> ''
),

part_numbers as (
    select
        n.number,
        n.start_index,
        n.end_index,
        n.row_index,
        s.symbol,
        s.col_index as symbol_col_index,
        s.row_index as symbol_row_index,
        case
            when
                s.col_index between n.start_index - 1 and n.end_index + 1
                and s.row_index between n.row_index - 1 and n.row_index + 1
            then true
            else false
        end as is_adjacent
    from numbers  as n cross join symbols as s
    where is_adjacent
)


select * exclude row_text from chunks
;