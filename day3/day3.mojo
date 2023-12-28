from helpers.utils import read_file


@value
@register_passable("trivial")
struct Number(CollectionElement):
    var row: Int
    var begin: Int
    var end: Int
    var value: Int


@value
struct Symbol(CollectionElement):
    var row: Int
    var col: Int
    var symbol: String


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
                numbers.push_back(Number(row_num, begin, end, value))
            if row_idx >= row_len:
                break
            let token = row[row_idx]
            if token != "." and token != "\n" and not isdigit(ord(token)):
                symbols.push_back(Symbol(i, row_idx, token))
            row_idx += 1

    return IndexBucket(numbers, symbols)


fn row_adjacent(first: Int, second: Int) -> Bool:
    return first >= second - 1 and first <= second + 1


fn column_adjacent(first: Int, second: Int) -> Bool:
    return first >= second - 1 and first <= second + 1


fn compute_parts_total(
    element_indices: IndexBucket, verbose: Bool = False
) raises -> None:
    var total: Int = 0
    var num_i: Int = 0
    while num_i < element_indices.numbers.__len__():
        var sym_i: Int = 0
        while sym_i < element_indices.symbols.__len__():
            if row_adjacent(
                element_indices.symbols[sym_i].row, element_indices.numbers[num_i].row
            ) and (
                column_adjacent(
                    element_indices.numbers[num_i].begin,
                    element_indices.symbols[sym_i].col,
                )
                or column_adjacent(
                    element_indices.numbers[num_i].end,
                    element_indices.symbols[sym_i].col,
                )
            ):
                if verbose:
                    print("Included value: ", element_indices.numbers[num_i].value)
                total += element_indices.numbers[num_i].value
                break
            sym_i += 1
        num_i += 1
    print("Parts Total: ", total)


fn compute_gear_ratios(
    element_indices: IndexBucket, verbose: Bool = False
) raises -> None:
    var Gear_ratios: DynamicVector[Int] = DynamicVector[Int]()

    for i in range(element_indices.symbols.__len__()):
        let symbol: String = element_indices.symbols[i].symbol
        if not symbol == "*":
            continue
        if verbose:
            print(
                "* at: ",
                element_indices.symbols[i].row,
                ",",
                element_indices.symbols[i].col,
            )
        var first_num: Int = -1
        var second_num: Int = -1

        for k in range(element_indices.numbers.__len__()):
            if verbose:
                print(
                    "number at: ",
                    element_indices.numbers[k].row,
                    ",",
                    element_indices.numbers[k].begin,
                    ",",
                    element_indices.numbers[k].end,
                    ", value: ",
                    element_indices.numbers[k].value,
                )
            let row_adj: Bool = row_adjacent(
                element_indices.symbols[i].row, element_indices.numbers[k].row
            )
            if verbose:
                print("row_adj: ", row_adj)

            let col_adj_begin: Bool = column_adjacent(
                element_indices.numbers[k].begin, element_indices.symbols[i].col
            )
            if verbose:
                print("col_adj_begin: ", col_adj_begin)

            let col_adj_end: Bool = column_adjacent(
                element_indices.numbers[k].end, element_indices.symbols[i].col
            )
            if verbose:
                print("col_adj_end: ", col_adj_end)

            if row_adj and (col_adj_begin or col_adj_end):
                if first_num == -1:
                    first_num = element_indices.numbers[k].value
                else:
                    second_num = element_indices.numbers[k].value
                    break
        if first_num == -1 or second_num == -1:
            continue

        if verbose:
            print("first_num: ", first_num, " second_num: ", second_num)
        let gear_ratio: Int = first_num * second_num
        Gear_ratios.push_back(gear_ratio)

    var ratio_total: Int = 0
    for ratio in range(Gear_ratios.__len__()):
        ratio_total += Gear_ratios[ratio]
    print("Gear Ratios Total: ", ratio_total)


fn day3(args: VariadicList[StringRef]) raises -> None:
    """Solves day3 challenge."""

    print("Advent of Code: Day 3")
    let file_path = args[2]
    print(file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_contents = read_file(file_path).split("\n")
    let file_len: Int = file_contents.__len__()

    let element_indices: IndexBucket = get_element_indices(file_contents, verbose)

    if verbose:
        print("Numbers:")
        for i in range(element_indices.numbers.__len__()):
            print(
                "row: ",
                element_indices.numbers[i].row,
                " begin: ",
                element_indices.numbers[i].begin,
                " end: ",
                element_indices.numbers[i].end,
                " value: ",
                element_indices.numbers[i].value,
            )
        print("Symbols:")
        for i in range(element_indices.symbols.__len__()):
            print(
                "row: ",
                element_indices.symbols[i].row,
                " col: ",
                element_indices.symbols[i].col,
                " symbol: ",
                element_indices.symbols[i].symbol,
            )
    compute_parts_total(element_indices, verbose)
    compute_gear_ratios(element_indices, verbose)
