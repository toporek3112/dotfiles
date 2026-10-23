# Python formatting instructions

Apply these instructions when writing or editing Python code. Match the supplied MT-Bench script's layout. Preserve behavior when formatting existing code.

## Indentation and spacing

- Use exactly **2 spaces per indentation level**. Never use tabs.
- Use normal Python spacing: spaces around assignment, comparison, and arithmetic operators; one space after commas and colons where applicable.
- Do not add spaces around `=` in keyword arguments or parameter defaults.
- Use a space after the colon in a slice with a nontrivial bound, such as `questions[: args.limit]`. Keep simple numeric slices compact, such as `text[:1000]`.
- Remove trailing whitespace and end files with one newline.

## Line wrapping

- Keep calls, conditions, comprehensions, assignments, and exception messages on one line when they remain readable, including long lines like those in the supplied example.
- Do not wrap code solely to satisfy an arbitrary line-length limit.
- In particular, keep `parser.add_argument(...)`, `Request(...)`, `raise ValueError(...)`, and `raise RuntimeError(...)` on one line when readable.
- Use multiline layout for dictionaries and other structured data when individual entries benefit from separate lines.
- If a statement genuinely needs wrapping, use parentheses and 2-space indentation for continuation lines. Avoid backslash continuations.

## Blank lines and logical groups

- Use two blank lines before top-level function and class definitions and before the `if __name__ == "__main__":` entry-point block.
- Inside functions, use one blank line between distinct logical steps.
- Keep related assignments and calls together without blank lines between every statement.
- Separate setup, validation, transformations, request construction, network calls, response processing, and output writing when those are distinct steps.
- Use blank lines around guard clauses when they separate logical steps, especially guards that `continue`, `raise`, or return early.
- Keep closely related validation checks together, as in the supplied example.
- Do not insert a blank line immediately after a function, loop, conditional, `with`, or `try` header.
- Keep `if`/`elif`/`else` and `try`/`except`/`finally` clauses contiguous.

## Strings, collections, and imports

- Prefer double quotes for strings and dictionary keys. Use triple double quotes for docstrings.
- Use f-strings for interpolated messages.
- Write multiline dictionaries with one entry per line, trailing commas, and the closing brace aligned with the start of the assignment.
- Keep small lists and dictionaries inline when readable.
- Put imports after the module docstring. Separate standard-library, third-party, and local import groups with one blank line when multiple groups exist.
- Preserve existing import order unless changing it is requested or needed for correctness.

## Script layout and documentation

- For executable standalone scripts, begin with `#!/usr/bin/env python3`.
- Place the module docstring immediately after the shebang. Start its summary on the same line as the opening triple quotes.
- Include concise purpose, usage, defaults, and relevant limitations in the module docstring.
- Keep module-level constants above functions and use uppercase names for constants.
- Use `snake_case` for functions and variables.
- Keep comments concise and useful. Do not add comments that merely repeat the code.
- Do not refactor, change dependencies, alter defaults, or change behavior as part of a formatting-only edit.

## Example

```python
#!/usr/bin/env python3
"""Read questions from a JSONL file."""

import json
from pathlib import Path


DEFAULTS = {
  "limit": 2,
  "encoding": "utf-8",
}


def load_questions(path, limit=None):
  raw_questions = Path(path).read_text(encoding="utf-8")
  questions = [json.loads(line) for line in raw_questions.splitlines() if line.strip()]

  if not questions:
    raise ValueError("The question file is empty.")

  questions = questions[: limit]

  return questions


if __name__ == "__main__":
  questions = load_questions("question.jsonl", limit=DEFAULTS["limit"])
  print(f"Loaded {len(questions)} questions.")
```

## Applying these instructions

Read this file before generating or editing Python code for the associated task. Explicit user instructions take precedence. Do not apply a formatter whose settings overwrite this style. This is a formatting guide; it is not an executable formatter configuration.
