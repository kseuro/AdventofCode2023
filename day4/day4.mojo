from helpers.utils import read_file


struct Numbers:
    var winning_numbers: DynamicVector[DynamicVector[Int]]
    var lucky_numbers: DynamicVector[DynamicVector[Int]]

    fn __init__(
        inout self,
        winning_numbers: DynamicVector[DynamicVector[Int]],
        lucky_numbers: DynamicVector[DynamicVector[Int]],
    ) raises -> None:
        self.winning_numbers = winning_numbers
        self.lucky_numbers = lucky_numbers

    fn __len__(self) -> Int:
        return self.winning_numbers.__len__()


@value
struct Card(CollectionElement):
    var number: Int
    var n_winners: Int

    fn __init__(inout self, number: Int, n_winners: Int) raises -> None:
        self.number = number
        self.n_winners = n_winners


fn extract_digits(string_digits: DynamicVector[String]) raises -> DynamicVector[Int]:
    """Extracts digits from a string vector."""

    var digits = DynamicVector[Int]()
    for i in range(string_digits.__len__()):
        let element = string_digits[i]
        if element == "" or element == " ":
            continue
        digits.push_back(atol(element))
    return digits


fn extract_winning_and_lucky_numbers(
    file_contents: DynamicVector[String], verbose: Bool = False
) raises -> Numbers:
    let file_len: Int = file_contents.__len__()
    var tmp_winners = DynamicVector[DynamicVector[Int]]()
    var tmp_lucky = DynamicVector[DynamicVector[Int]]()

    for i in range(file_len):
        let card_number: Int = i + 1
        let card: String = file_contents[i]
        let card_elements: DynamicVector[String] = card.split(":")

        if verbose:
            print("")
            print(card_elements[0])
        let elements = card_elements[1].split("|")
        if verbose:
            print(elements[0])
            print(elements[1])
        let winning_numbers = extract_digits(elements[0].split(" "))
        tmp_winners.push_back(winning_numbers)

        let lucky_numbers = extract_digits(elements[1].split(" "))
        tmp_lucky.push_back(lucky_numbers)
    return Numbers(tmp_winners, tmp_lucky)


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


fn part1(numbers: Numbers, verbose: Bool = False) raises -> None:
    """Computes the score for part 1."""
    var score: Int = 0
    for i in range(numbers.__len__()):
        let winners = find_winners(numbers.winning_numbers[i], numbers.lucky_numbers[i])
        let n_winners = winners.__len__()
        if n_winners == 0:
            continue
        score += 2 ** (n_winners - 1)
    print("Score:", score, "\n")


fn make_card_stack(numbers: Numbers) raises -> DynamicVector[Card]:
    """Creates a card stack."""

    var card_stack: DynamicVector[Card] = DynamicVector[Card](
        capacity=numbers.__len__()
    )
    for i in range(numbers.__len__()):
        let winners = find_winners(numbers.winning_numbers[i], numbers.lucky_numbers[i])
        let n_winners = winners.__len__()
        card_stack.push_back(Card(i + 1, n_winners))
    return card_stack


fn compute_total_cards(
    card_stack: DynamicVector[Card], verbose: Bool = False
) raises -> DynamicVector[Card]:
    """Computes the total number of cards."""
    var extra_cards: DynamicVector[Card] = DynamicVector[Card]()
    for i in range(card_stack.__len__()):
        let card_number = card_stack[i].number
        let n_winners = card_stack[i].n_winners

        if verbose:
            print("Card number:", card_number, "n_winners:", n_winners)

        if n_winners == 0:
            continue

        for j in range(n_winners):
            let new_card_number = card_number + j + 1
            if verbose:
                print(
                    "\t",
                    "Adding card number:",
                    new_card_number,
                    " with n_winners:",
                    card_stack[new_card_number].n_winners,
                )
            extra_cards.push_back(
                Card(new_card_number, card_stack[new_card_number].n_winners)
            )
            if verbose:
                for k in range(extra_cards.__len__()):
                    print("\t", extra_cards[k].number, extra_cards[k].n_winners)
                print("\t", "Total extra cards:", extra_cards.__len__())
    return extra_cards


fn part2(numbers: Numbers, verbose: Bool = False) raises -> None:
    """Computes the number of additional cards for part 2."""
    let card_stack = make_card_stack(numbers)
    var total_cards: Int = card_stack.__len__()
    var extra_cards = compute_total_cards(card_stack, verbose)

    while extra_cards.__len__() > 0:
        total_cards += extra_cards.__len__()
        extra_cards = compute_total_cards(extra_cards, verbose)

    print("Total cards:", total_cards, "\n")


fn day4(args: VariadicList[StringRef]) raises -> None:
    """Solves day4 challenge."""

    print("Advent of Code: Day 4")
    let file_path = args[2]
    print(file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_contents = read_file(file_path).split("\n")
    let file_len: Int = file_contents.__len__()

    let numbers = extract_winning_and_lucky_numbers(file_contents, verbose)
    part1(numbers, verbose)
    part2(numbers, verbose)
