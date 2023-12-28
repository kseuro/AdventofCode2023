from math import max, min
from helpers.utils import read_file
from helpers.strings import split_string
from utils.vector import InlinedFixedVector

alias MAX_RED: Int = 12
alias MAX_GREEN: Int = 13
alias MAX_BLUE: Int = 14


fn get_game_split(line: String) raises -> DynamicVector[String]:
    """Gets the game split for a given line."""
    return split_string(line, ":", False)


fn get_max_colors(game_split: DynamicVector[String]) raises -> InlinedFixedVector[Int]:
    """Gets the max colors for a given line."""

    let game_sets = split_string(game_split[1], ";", True)

    var game_max_red: Int = 0
    var game_max_green: Int = 0
    var game_max_blue: Int = 0
    let n_colors: Int = 3
    var colors = InlinedFixedVector[Int](capacity=n_colors)

    for j in range(game_sets.__len__()):
        let num_colors = game_sets[j].split(",")
        for k in range(num_colors.__len__()):
            let color_split = num_colors[k].split(" ")
            let count: Int = atol(color_split[1])
            let color: String = color_split[2]
            if color == "red":
                game_max_red = max(game_max_red, count)
            elif color == "green":
                game_max_green = max(game_max_green, count)
            elif color == "blue":
                game_max_blue = max(game_max_blue, count)

    colors.append(game_max_red)
    colors.append(game_max_green)
    colors.append(game_max_blue)

    return colors


fn compute_possible_game_total(
    possible_games: DynamicVector[String], verbose: Bool = False
) raises -> None:
    """Computes the possible game total."""
    if verbose:
        print("Possible games:")
    var game_id_total: Int = 0
    for i in range(possible_games.__len__()):
        if verbose:
            print(possible_games[i])
        game_id_total += atol(possible_games[i].split(" ")[1])
    print("Game ID Total:", game_id_total)


fn part1(lines: DynamicVector[String], verbose: Bool = False) raises -> None:
    """Solves part 1 of day 2 challenge."""
    var possible_games: DynamicVector[String] = DynamicVector[String](
        capacity=lines.__len__()
    )

    for i in range(lines.__len__()):
        let game_split = get_game_split(lines[i])
        let game_id = game_split[0]
        let colors = get_max_colors(game_split)
        let game_max_red = colors[0]
        let game_max_green = colors[1]
        let game_max_blue = colors[2]

        if (
            game_max_red <= MAX_RED
            and game_max_green <= MAX_GREEN
            and game_max_blue <= MAX_BLUE
        ):
            possible_games.push_back(game_id)

        if verbose:
            print("\n")

    compute_possible_game_total(possible_games, verbose)


fn compute_power_set_total(
    power_sets: DynamicVector[Int], verbose: Bool = False
) raises -> None:
    """Computes the power set total."""
    if verbose:
        print("Power Sets:")
    var power_set_total: Int = 0
    for i in range(power_sets.__len__()):
        if verbose:
            print(power_sets[i])
        power_set_total += atol(power_sets[i])
    print("Power Set Total:", power_set_total)


fn part2(lines: DynamicVector[String], verbose: Bool = False) raises -> None:
    """Solves part 2 of day 2 challenge."""
    var power_sets: DynamicVector[Int] = DynamicVector[Int](capacity=lines.__len__())

    for i in range(lines.__len__()):
        let colors = get_max_colors(get_game_split(lines[i]))
        power_sets.push_back(colors[0] * colors[1] * colors[2])

        if verbose:
            print("\n")

    compute_power_set_total(power_sets, verbose)


fn day2(args: VariadicList[StringRef]) raises -> None:
    """Solves day2 challenge."""

    print("Advent of Code: Day 2")
    let file_path = args[2]

    print("File path:", file_path)
    let verbose: Bool = not args[3] == "no_output"

    let file_content = read_file(file_path)
    let lines = split_string(file_content, "\n", True)

    part1(lines, verbose)
    part2(lines, verbose)
