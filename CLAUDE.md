# CLAUDE.md

## General

- Never use em dashes in any output, code, comments, or documentation.
- Never add a co-author attribution (e.g. `Co-Authored-By` lines) when committing or making Pull Requests.
- Do not edit files unless specifically asked to. Explain and suggest changes first, and only make them when requested.

## GDScript

- Always use explicit types. Never rely on inferred types (no `:=`), and type every variable, parameter, and return value.
- Do not use magic numbers for tuning values. Use a named `const`, or an `@export var` if it should be tweakable in the Inspector. Natural rest values such as `0.0`, `1.0`, `Vector2.ZERO`, and `Vector2.ONE` can stay as literals.
