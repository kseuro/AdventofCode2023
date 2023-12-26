from helpers.utils import read_file
from utils.static_tuple import StaticTuple


@value
@register_passable("trivial")
struct Number(CollectionElement):
    var row: Int
    var begin: Int
    var end: Int
    var value: Int


@value
@register_passable("trivial")
struct Symbol(CollectionElement):
    var row: Int
    var col: Int


struct IndexBucket:
    var numbers: DynamicVector[Number]
    var symbols: DynamicVector[Symbol]

    fn __init__(
        inout self, numbers: DynamicVector[Number], symbols: DynamicVector[Symbol]
    ):
        self.numbers = numbers
        self.symbols = symbols


fn get_element_indices(
    file_contents: DynamicVector[String],
    verbose: Bool = False,
) raises -> IndexBucket:
    let file_len: Int = file_contents.__len__()

    var symbols = DynamicVector[Symbol]()
    var numbers = DynamicVector[Number]()

    if verbose:
        for i in range(file_len):
            print("row", i, ": ", file_contents[i])

    for i in range(file_len):
        let row_num: Int = i
        let row: String = file_contents[i]

        var row_idx: Int = 0
        let row_len: Int = row.__len__()
        while row_idx < row_len:
            if isdigit(ord(row[row_idx])):
                let begin: Int = row_idx
                while row_idx < row_len and isdigit(ord(row[row_idx])):
                    row_idx += 1
                var end: Int = row_idx
                let value: Int = atol(row[begin:end])
                end -= 1
                if verbose:
                    print(
                        "Row: ",
                        row_num,
                        " begin: ",
                        begin,
                        " end: ",
                        end,
                        " value: ",
                        value,
                    )
                numbers.push_back(Number(row_num, begin, end, value))
            if row_idx >= row_len:
                break
            let token = row[row_idx]
            if token != "." and token != "\n" and not isdigit(ord(token)):
                if verbose:
                    print("Symbol: ", token, " row: ", i, " col: ", row_idx)
                symbols.push_back(Symbol(i, row_idx))
            row_idx += 1

    return IndexBucket(numbers, symbols)


fn row_adjacent(symbol_row: Int, number_row: Int) -> Bool:
    return (
        symbol_row == number_row - 1
        or symbol_row == number_row
        or symbol_row == number_row + 1
    )


fn number_adjacent(symbol_col: Int, number_begin: Int, number_end: Int) -> Bool:
    return (
        symbol_col == number_begin - 1
        or symbol_col == number_begin
        or symbol_col == number_begin + 1
        or symbol_col == number_end - 1
        or symbol_col == number_end
        or symbol_col == number_end + 1
    )


fn compute_parts_total(bucket: IndexBucket, verbose: Bool = False) raises -> None:
    var total: Int = 0
    var num_i: Int = 0
    while num_i < bucket.numbers.__len__():
        var sym_i: Int = 0
        while sym_i < bucket.symbols.__len__():
            if row_adjacent(
                bucket.symbols[sym_i].row, bucket.numbers[num_i].row
            ) and number_adjacent(
                bucket.symbols[sym_i].col,
                bucket.numbers[num_i].begin,
                bucket.numbers[num_i].end,
            ):
                if verbose:
                    print("Included value: ", bucket.numbers[num_i].value)
                total += bucket.numbers[num_i].value
                break
            sym_i += 1
        num_i += 1
    print("Total: ", total)


fn solve_part1(
    file_contents: DynamicVector[String], verbose: Bool = True
) raises -> None:
    let bucket: IndexBucket = get_element_indices(file_contents, verbose)
    compute_parts_total(bucket, verbose)


fn day3(args: VariadicList[StringRef]) raises -> None:
    """Solves day3 challenge."""

    print("Advent of Code: Day 3")
    let file_path = args[2]
    print(file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_contents = read_file(file_path).split("\n")
    let file_len: Int = file_contents.__len__()

    solve_part1(file_contents, verbose)
