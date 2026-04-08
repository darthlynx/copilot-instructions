# Common Fixes

## Simplify error handling
Prefer:

```go
if err != nil {
    return err
}
```

over deeply nested conditionals.

## Preallocate slices
Prefer:

```go
result := make([]T, 0, n)
```

when the expected size is known.

## Use table-driven tests
Prefer table-driven tests for multiple cases and edge conditions.

## Avoid unnecessary interfaces
Do not introduce interfaces unless they improve testability or decouple behavior meaningfully.
