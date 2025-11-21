# TypeScript RORO Pattern

**Tech Stack**: TypeScript/React
**Category**: Code Structure
**Added**: 2025-01-19

## Overview

RORO (Receive an Object, Return an Object) is a parameter passing pattern that improves function readability, maintainability, and extensibility by using object parameters and return values.

## Problem

Traditional function signatures with multiple positional parameters suffer from:

```typescript
// ❌ Bad: Multiple positional parameters
function createUser(name: string, email: string, age: number, isActive: boolean) {
  // ...
}

// Hard to understand at call site
createUser('John', 'john@example.com', 25, true);
```

Issues:
- Parameter order must be memorized
- Adding new parameters breaks existing calls
- Optional parameters must come last
- Poor readability at call sites

## Solution

Use object parameters and return values:

```typescript
// ✅ Good: RORO pattern
interface CreateUserParams {
  name: string;
  email: string;
  age: number;
  isActive: boolean;
}

interface CreateUserResult {
  user: User;
  token: string;
}

function createUser(params: CreateUserParams): CreateUserResult {
  const { name, email, age, isActive } = params;
  // ...
  return { user, token };
}

// Self-documenting at call site
createUser({
  name: 'John',
  email: 'john@example.com',
  age: 25,
  isActive: true
});
```

## Benefits

1. **Self-documenting**: Parameter names visible at call sites
2. **Flexible ordering**: No need to remember parameter order
3. **Easy to extend**: Add new optional parameters without breaking changes
4. **Better defaults**: Use destructuring with default values
5. **Return multiple values**: Return structured data instead of tuples

## Advanced Patterns

### With Default Values

```typescript
interface FetchDataParams {
  url: string;
  method?: 'GET' | 'POST';
  timeout?: number;
}

function fetchData({
  url,
  method = 'GET',
  timeout = 5000
}: FetchDataParams) {
  // ...
}
```

### With React Hooks

```typescript
interface UseUserParams {
  userId: string;
  refreshInterval?: number;
}

interface UseUserResult {
  user: User | null;
  loading: boolean;
  error: Error | null;
  refresh: () => void;
}

function useUser({ userId, refreshInterval = 0 }: UseUserParams): UseUserResult {
  // ...
  return { user, loading, error, refresh };
}
```

## When to Use

- Functions with 3+ parameters
- Functions with optional parameters
- Functions that return multiple values
- Public APIs that may evolve over time

## When NOT to Use

- Single-parameter functions (unless object makes sense semantically)
- Performance-critical inner loops (object creation overhead)
- Very simple utility functions (e.g., `add(a, b)`)

## Related Patterns

- Builder Pattern
- Options Object Pattern
- Named Parameters (other languages)

## References

- [Elegant patterns in modern JavaScript: RORO](https://www.freecodecamp.org/news/elegant-patterns-in-modern-javascript-roro-be01e7669cbd/)
- [TypeScript Handbook: Object Types](https://www.typescriptlang.org/docs/handbook/2/objects.html)
