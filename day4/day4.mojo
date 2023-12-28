from helpers.utils import read_file


fn day4(args: VariadicList[StringRef]) raises -> None:
    """Solves day4 challenge."""

    print("Advent of Code: Day 4")
    let file_path = args[2]
    print(file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_contents = read_file(file_path)
