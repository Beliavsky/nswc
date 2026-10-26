"""Remove every empty C/c comment record from maintained fixed form."""


def transform_fixed(data):
    return b''.join(line for line in data.splitlines(keepends=True)
                    if not (line[:1].lower() == b'c' and not line[1:].strip()))
