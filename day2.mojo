from math import max
from helpers.utils import read_file
from helpers.strings import split_string

alias MAX_RED: Int = 12
alias MAX_GREEN: Int = 13
alias MAX_BLUE: Int = 14

fn part1(lines: DynamicVector[String], verbose: Bool = False) raises -> None:
    """Solves part 1 of day 2 challenge."""
    var possible_games: DynamicVector[String] = DynamicVector[String](capacity=lines.__len__())

    for i in range(lines.__len__()):
        let game_split = split_string(lines[i], ":", False)
        let game_id = game_split[0]
        let game_sets = split_string(game_split[1], ";", True)

        if verbose:
            print(game_id)
        var game_max_red : Int = 0
        var game_max_green : Int = 0
        var game_max_blue : Int = 0

        for j in range(game_sets.__len__()):

            if verbose:
                print("Game Set:", game_sets[j])

            let num_colors = game_sets[j].split(",")
            for k in range(num_colors.__len__()):
                let color_split = num_colors[k].split(" ")
                let count: Int = atol(color_split[1])
                let color: String = color_split[2]
                if verbose:
                    print("Count:", count)
                    print("Color:", color)
                if color == "red":
                    game_max_red = max(game_max_red, count)
                elif color == "green":
                    game_max_green = max(game_max_green, count)
                elif color == "blue":
                    game_max_blue = max(game_max_blue, count)

        if game_max_red <= MAX_RED and game_max_green <= MAX_GREEN and game_max_blue <= MAX_BLUE:
            possible_games.push_back(game_id)

        if verbose:
            print("\n")

    if verbose:
        print("Possible games:")
    var game_id_total: Int = 0
    for i in range(possible_games.__len__()):
        if verbose:
            print(possible_games[i])
        game_id_total += atol(possible_games[i].split(" ")[1])
    print("Game ID Total:", game_id_total)

fn part2(lines: DynamicVector[String], verbose: Bool = False) raises -> None:
    """Solves part 2 of day 2 challenge."""
    pass

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

