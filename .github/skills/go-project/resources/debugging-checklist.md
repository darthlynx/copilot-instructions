# Debugging Checklist

When debugging a Go issue:

1. Reproduce the problem with the smallest possible scope.
2. Identify whether it is:
   - compile error
   - test failure
   - runtime panic
   - logic bug
   - performance issue
   - concurrency issue
   - environment or container issue
3. Inspect the exact package and function involved.
4. Add logging or tighter tests only where useful.
5. Fix the root cause, not only the symptom.
6. Re-run targeted tests.
7. Re-run broader validation if needed.

Common traps:
- loop variable capture
- nil interface vs nil concrete value
- off-by-one indexing
- map iteration order assumptions
- shadowed variables
- ignored errors
- data races
- context not propagated
