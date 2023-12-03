import re

str2num = {
    "one": "o1e",
    "two": "t2o",
    "three": "t3e",
    "four": "f4r",
    "five": "f5e",
    "six": "s6x",
    "seven": "s7n",
    "eight": "e8t",
    "nine": "n9e",
}

def replace_words(text):
    for k, v in str2num.items():
        text = text.replace(k, v)
    return text

def calibration(text):
    with open("day1_2_answers.txt", "w") as f:
        for l in re.sub(r"[A-z]", "", replace_words(text)).split("\n"):
            f.write((f"{int(l[0] + l[-1])}\n"))

text = open("data/day1.csv").read()
print(calibration(text))
print(calibration(replace_words(text)))