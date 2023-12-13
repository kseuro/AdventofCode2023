from builtin.string import isdigit
from helpers.utils import read_file, print_string_vector
from helpers.strings import split_string

let digit_strings = StaticTuple[9]("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")

alias min_length: Int = 3
alias max_length: Int = 5

fn string_to_int(string: String, numeric: Bool) raises -> Int:
    """Converts a string to an integer.

    :param string: The string to convert.
    :param numeric: Whether to look for numeric values ('1', '2', '3', etc.) or digit strings ('one', 'two', 'three', etc.).

    :returns: The integer value of the string.
    """
    print("String to Int: ", string)
    if isdigit(string._buffer[0]):
        print("String: ", string._buffer[0], " is digit")
        return atol(string)

    if numeric:
        return 0

    for i in range(digit_strings.__len__()):
        let digit = digit_strings[i]
        print("Digit string: ", digit)
        if string[: len(digit)] == digit:
            return i + 1
    return 0

fn compute_line_sum(lines: DynamicVector[String], numeric: Bool, verbose: Bool) raises -> Int:
    """Computes the sum of all lines in a vector of strings."""
    var totals = DynamicVector[Int](capacity=lines.__len__())

    print("Computing Line Sum")
    for i in range(len(lines)):
        let line = lines[i]
        if verbose:
            print("Line ", i, ": ", line)

        var first: Int = 0
        var last: Int = 0

        if numeric:
            # Search only for individual digits contained it the string
            for j in range(len(line)):
                let char = line[j]
                if isdigit(char._buffer[0]):
                    let digit = atol(char)
                    if first == 0:
                        first = digit
                    last = digit
        totals.push_back(first * 10 + (last or first))
        if verbose:
            print("Total: ", totals[i])

    var total: Int = 0
    for i in range(len(totals)):
        total += totals[i]
    return total

fn solve_part1(lines: DynamicVector[String], numeric: Bool, verbose: Bool) raises -> None:
    """Solves part 1 of the challenge."""
    print("Solving part 1")
    if verbose:
        print("File contents:\n")
        print_string_vector(lines)
    let total = compute_line_sum(lines, numeric=numeric, verbose=verbose)
    print("Part 1 Total: ", total)

fn str_to_value(string: String) -> Int:
    """Maps a string to a value (dict workaround)."""
    if string == "one":
        return 1
    elif string == "two":
        return 2
    elif string == "three":
        return 3
    elif string == "four":
        return 4
    elif string == "five":
        return 5
    elif string == "six":
        return 6
    elif string == "seven":
        return 7
    elif string == "eight":
        return 8
    elif string == "nine":
        return 9
    return 0

fn solve_part2(lines: DynamicVector[String], numeric: Bool, verbose: Bool) raises -> None:
    """Solves part 2 of the challenge."""
    print("\nSolving part 2")
    var totals: DynamicVector[Int] = DynamicVector[Int](capacity=lines.__len__())

    if verbose:
        print("File contents:\n")
        print_string_vector(lines)

    for i in range(len(lines)):
        var first: Int = 0
        var last: Int = 0
        var value: Int = 0
        let line = lines[i]

        for j in range(len(line)):
            let asciival = ord(line[j])

            if isdigit(asciival):
                if first == 0:
                    first = atol(line[j])
                last = atol(line[j])
                continue

            for n in range(min_length, max_length + 1):
                let substr = line[j: j + n]
                if (value := str_to_value(substr)) == 0:
                    continue
                elif first == 0:
                    first = value
                else:
                    last = value
        totals.push_back(first * 10 + (last or first))
        if verbose:
            print("Total: ", totals[i])
    
    var total: Int = 0
    for i in range(len(totals)):
        total += totals[i]
    print("Part 2 Total: ", total)

fn day1(args: VariadicList[StringRef]) raises -> None:
    """Solves day 1 challenge."""
    print(args[0])
    let file_path = args[1]
    print("File path:", file_path)

    let file_content = read_file(file_path)
    let lines = split_string(file_content, "\n", True)

    let no_output: Bool = args[2] == "no_output"

    if no_output:
        solve_part1(lines, numeric=True, verbose=False)
    else:
        solve_part1(lines, numeric=True, verbose=True)

    if no_output:
        solve_part2(lines, numeric=False, verbose=False)
    else:
        solve_part2(lines, numeric=False, verbose=True)

