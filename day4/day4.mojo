from helpers.utils import read_file


fn extract_digits(string_digits: DynamicVector[String]) raises -> DynamicVector[Int]:
    """Extracts digits from a string vector."""

    var digits = DynamicVector[Int]()
    for i in range(string_digits.__len__()):
        let element = string_digits[i]
        if element == "" or element == " ":
            continue
        digits.push_back(atol(element))
    return digits


fn find_winners(
    winning_numbers: DynamicVector[Int], lucky_numbers: DynamicVector[Int]
) raises -> DynamicVector[Int]:
    """Finds the winners."""

    var winners = DynamicVector[Int]()
    for i in range(lucky_numbers.__len__()):
        let lucky_number = lucky_numbers[i]
        for j in range(winning_numbers.__len__()):
            if lucky_number == winning_numbers[j]:
                winners.push_back(lucky_number)
    return winners


fn day4(args: VariadicList[StringRef]) raises -> None:
    """Solves day4 challenge."""

    print("Advent of Code: Day 4")
    let file_path = args[2]
    print(file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_contents = read_file(file_path).split("\n")
    let file_len: Int = file_contents.__len__()

    var score: Int = 0
    for i in range(file_len):
        let card_number: Int = i + 1
        let card: String = file_contents[i]
        let card_elements: DynamicVector[String] = card.split(":")

        if verbose:
            print("")
            print(card_elements[0])
        let elements = card_elements[1].split("|")

        let winning_numbers = extract_digits(elements[0].split(" "))
        let lucky_numbers = extract_digits(elements[1].split(" "))

        if verbose:
            for k in range(winning_numbers.__len__()):
                print("Winning number:", winning_numbers[k])
            for k in range(lucky_numbers.__len__()):
                print("Lucky number:", lucky_numbers[k])

        let winners = find_winners(winning_numbers, lucky_numbers)
        let n_winners = winners.__len__()
        if n_winners == 0:
            continue
        score += 2 ** (n_winners - 1)
    print("Score:", score)
