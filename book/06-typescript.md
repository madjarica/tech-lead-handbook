# TypeScript

> **Status:** Skeleton. Do not treat as final content.
> See `../CHAPTER_TEMPLATE.md` and `../BOOK_SPEC.md` before generating.

## Chapter Goal

After this chapter, the reader can use TypeScript's structural type
system effectively, write small but useful generic utilities, design
discriminated unions for safety, and configure a `tsconfig.json` that
scales across teams.

## Why This Matters for a Tech Lead

TypeScript is now the default for medium-to-large JavaScript codebases.
A Tech Lead must set the strictness level, the module strategy, and
the type-safety boundary that the team can sustain.

## Mental Model

> TODO: TypeScript as a "structural type system layered on top of
> JavaScript". Types do not exist at runtime. Add a small Mermaid
> diagram showing the build pipeline (TS source -> type check ->
> emit -> JS runtime).

## Core Terminology

> TODO: Structural typing, nominal typing, type narrowing,
> discriminated union, generic, conditional type, mapped type,
> template literal type, declaration merging, ambient module.

## Theoretical Foundation

> TODO: Cover:
>
> - Structural vs nominal typing.
> - Type inference and narrowing; control-flow analysis.
> - `any`, `unknown`, `never`, `void`, `null`, `undefined`.
> - Generics; default type parameters; constraints with `extends`.
> - Conditional types and `infer`.
> - Mapped types and key remapping.
> - Template literal types.
> - Discriminated unions and exhaustiveness checks (`never`).
> - Module resolution: `node`, `node16`, `nodenext`, `bundler`;
>   `paths`, `baseUrl`.
> - ESM/CJS interop; `esModuleInterop`, `verbatimModuleSyntax`.
> - `tsconfig.json` strict family: `strict`, `noUncheckedIndexedAccess`,
>   `exactOptionalPropertyTypes`.
> - Declaration files and ambient declarations.
> - Type-only imports and side-effect imports.

## Practical Usage

> TODO: Where TypeScript pays off:
>
> - Domain modeling with discriminated unions.
> - API contracts shared between frontend and backend.
> - Refactor-safety in large codebases.
>
> Where it costs: build-time overhead, type-level overengineering,
> excessive generics.

## Examples

> TODO:
>
> - A discriminated union with exhaustive `switch` and `assertNever`.
> - A small generic utility (`Result<T, E>` or `Branded<T, B>`).
> - A `tsconfig.json` for a monorepo with project references.
> - A typed Express handler with `unknown` request bodies validated
>   by a runtime schema.

## Common Mistakes

> TODO:
>
> 1. Reaching for `any` in test code and letting it spread.
> 2. Trusting types where the data crosses a network boundary
>    (need runtime validation).
> 3. Type-level golf that no teammate can read.
> 4. `as` casts hiding broken assumptions.
> 5. Loose `tsconfig.json` (`strict: false`) on greenfield projects.

## Trade-offs

> TODO: Strict vs lenient tsconfig; TypeScript-only vs
> TypeScript+runtime-validation (Zod/io-ts/Valibot); decorators on/off.

## Production Considerations

> TODO:
>
> - Build performance: `tsc --build`, project references, `swc`/
>   `esbuild` for emit, `tsc` for type-check.
> - Editor performance and `tsserver` memory.
> - Migration strategy from JS to TS.
> - Library publishing: `.d.ts` quality, `exports` field.

## How to Explain This in an Interview

> TODO: Strong answer to "Why TypeScript over JavaScript?" that goes
> beyond "type safety".

## Good Answer vs Weak Answer

> TODO: Strong vs weak answer for "When would you use `unknown`?".

## Tech Lead Checklist

- [ ] `strict` is on. Exceptions are documented.
- [ ] Network boundaries validate at runtime.
- [ ] Type-level complexity is reviewed like any code complexity.
- [ ] Build pipeline separates type-checking from emit when speed matters.
- [ ] Migration plan exists for any remaining `.js` files.

## Interview Questions and Answers

### Basic

> TODO: "What is structural typing?"

### Senior

> TODO: "What does `noUncheckedIndexedAccess` change?"

### Tech Lead

> TODO: "How do you decide between strict TypeScript and less-strict
> for an existing large codebase?"

### Scenario-based

> TODO: "Design types for a feature flag system."

### Trick Questions

> TODO: "Are TypeScript interfaces and types interchangeable?"

### Red Flags

> TODO: Candidates who treat `as` as the answer to type errors.

## Summary

> TODO: 5–8 bullets.

## Further Study

> TODO: TypeScript handbook; `type-challenges` repository for type-level
> exercises; `tsconfig` reference.

---

### Generation Notes

- Mark version-sensitive features (decorators, `using`,
  `verbatimModuleSyntax`) and add to `notes/verification-needed.md`.
- Cross-link to chapter 05 (JavaScript) and chapter 12 (API Design)
  for contracts.
