from sys import argv


fn day_selection(args: VariadicList[StringRef]) raises -> None:
    let day = args[1]
    if day == "1":
        from day1 import day1

        day1(args)
    elif day == "2":
        from day2 import day2

        day2(args)
    elif day == "3":
        from day3 import day3

        day3(args)
    else:
        print("Invalid day")


fn main() raises -> None:
    day_selection(argv())
