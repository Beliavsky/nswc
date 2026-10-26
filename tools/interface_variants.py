"""Create a legacy caller view without PURE/ELEMENTAL for fixed-form sources."""
import argparse
from pathlib import Path
import re
from fortran_procedures import HEADER


def legacy_interfaces(text):
    result = []
    for line in text.splitlines(True):
        if HEADER.match(line):
            keyword = re.search(r'\b(?:function|subroutine)\b', line, re.I)
            line = re.sub(r'\b(?:pure|elemental)\s+', '', line[:keyword.start()], flags=re.I) + line[keyword.start():]
        result.append(line)
    return ''.join(result)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('source', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    with args.output.open('xb') as out:
        out.write(legacy_interfaces(args.source.read_text()).encode('ascii'))


if __name__ == '__main__':
    main()
