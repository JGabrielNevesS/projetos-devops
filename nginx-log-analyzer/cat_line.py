import sys

def show_line(path, target):
    with open(path, encoding="utf-8", errors="replace") as log:
        for number, text in enumerate(log, start=1):
            if number == target:
                for index, item in enumerate(text.split(), start=1):
                    print(f"Índice: {index} -> Item: {item!r}")
                return

    print(f"Linha {target} não encontrada.")

def main():
    if len(sys.argv) > 2:
        path = sys.argv[1]
        target = int(sys.argv[2])
    show_line(path=path, target=target)

main()