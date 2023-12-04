# advent-of-code-2023

Advent of Code 2023...using only SQL!

Is it practical? *Debatable*.

Is is possible? *Doubtful*.

Is it fun to try anyways? *I hope so!* 😛.

# Approach
- I'm using the [DuckDB](https://duckdb.org/) CLI in VSCode. Motherduck has a [great little tutorial](https://motherduck.com/blog/duckdb-tutorial-for-beginners/) on how to do this!
- My goal is learning, so I'm generally avoiding the use of ChatGPT and Copilot, with some exceptions:
    - regex! I don't want to figure this out on my own
    - as a Google replacement (aka asking about what functions are available in DuckDB)
- I'm aiming to have a single query (with CTEs) for each part of each day. This violates the DRY principle, but for this I thought it would be fun to see if each part could be done in what is a single select statement.

# Daily reviews
## Day 1
Part 1: feeling good, knocked it out! Learned the `unnest` function, cool!
Part 2: 😤 baugh. So many problems. Missed the combined numbers (e.g. `fiveight`). Then when I figured that out, it turns out I had a non-deterministic query... Once I finally fixed that, it worked, surprise, surprise 🤪.

## Day 2
Feeling behind when I started. But then...throw around `string_split` and `unnest` enough and it was fine. The hardest part was just parsing the data, otherwise easy. Then for part 2, since I already had the data parsed, it was straightforward.

## Day 3
Ok, this was my favorite so far. SQL actually worked...pretty well for this one??? Followed a similar approach to day 1 in order to extract items from the text using regex. The challenge was that I needed to extract substrings **and** record the locations of those substrings. So, for both days, I generated truncated versions of every line of text and matched the beginning. For example:

```
row_index │  col  │                                                                row_text_chunk                                                                │
│   int64   │ int64 │                                                                   varchar                                                                    │
├───────────┼───────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│         1 │     1 │ ..........................380.......................143............................108.............630...........425........................ │
│         1 │     2 │ .........................380.......................143............................108.............630...........425........................  │
│         1 │     3 │ ........................380.......................143............................108.............630...........425........................   │
│         1 │     4 │ .......................380.......................143............................108.............630...........425........................    │
│         1 │     5 │ ......................380.......................143............................108.............630...........425........................     │
│         1 │     6 │ .....................380.......................143............................108.............630...........425........................      │
│         1 │     7 │ ....................380.......................143............................108.............630...........425........................       │
│         1 │     8 │ ...................380.......................143............................108.............630...........425........................        │
│         1 │     9 │ ..................380.......................143............................108.............630...........425........................         │
│         1 │    10 │ .................380.......................143............................108.............630...........425........................          │
│         1 │    11 │ ................380.......................143............................108.............630...........425........................           │
│         1 │    12 │ ...............380.......................143............................108.............630...........425........................            │
│         1 │    13 │ ..............380.......................143............................108.............630...........425........................             │
│         1 │    14 │ .............380.......................143............................108.............630...........425........................              │
│         1 │    15 │ ............380.......................143............................108.............630...........425........................               │
│         1 │    16 │ ...........380.......................143............................108.............630...........425........................                │
│         1 │    17 │ ..........380.......................143............................108.............630...........425........................                 │
...
```

Then I matched on the beginning of the string, allowing me to record locations. This worked pretty well!

And part two was easy. Now I'm feeling like I'm overconfident 😆.
