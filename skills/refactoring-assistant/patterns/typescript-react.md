# TypeScript/React Refactoring Patterns

Tech-stack specific refactoring patterns and best practices for TypeScript and React projects.

## React Component Refactoring

### 1. Extract Custom Hook

**When to Apply**:

- Component has complex state logic
- Same logic is used in multiple components
- Component is hard to test due to state management

**Pattern**:

```typescript
// Before
function UserProfile() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchUser()
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!user) return null;

  return <div>{user.name}</div>;
}

// After
function useUser() {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setLoading(true);
    fetchUser()
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  return { user, loading, error };
}

function UserProfile() {
  const { user, loading, error } = useUser();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;
  if (!user) return null;

  return <div>{user.name}</div>;
}
```

---

### 2. Component Composition (Prop Drilling Elimination)

**When to Apply**:

- Props are passed through multiple levels
- Component has too many props (> 7)
- Children need access to parent state

**Pattern**:

```typescript
// Before
function App() {
  const [theme, setTheme] = useState('light');
  return <Dashboard theme={theme} setTheme={setTheme} />;
}

function Dashboard({ theme, setTheme }: Props) {
  return <Sidebar theme={theme} setTheme={setTheme} />;
}

function Sidebar({ theme, setTheme }: Props) {
  return <ThemeToggle theme={theme} setTheme={setTheme} />;
}

// After (Context)
const ThemeContext = createContext<ThemeContextValue | undefined>(undefined);

function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState('light');
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) throw new Error('useTheme must be used within ThemeProvider');
  return context;
}

function App() {
  return (
    <ThemeProvider>
      <Dashboard />
    </ThemeProvider>
  );
}

function Dashboard() {
  return <Sidebar />;
}

function Sidebar() {
  return <ThemeToggle />;
}

function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  return <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>Toggle</button>;
}
```

---

### 3. Split Large Component

**When to Apply**:

- Component file exceeds 200 lines
- Component has multiple responsibilities
- Component is hard to understand

**Pattern**:

```typescript
// Before (Large Component)
function UserDashboard() {
  const { user } = useUser();
  const { orders } = useOrders(user.id);
  const { notifications } = useNotifications(user.id);

  return (
    <div className={styles.dashboard}>
      {/* Header section (50 lines) */}
      <header>
        <h1>{user.name}</h1>
        <img src={user.avatar} alt={user.name} />
        <div>Email: {user.email}</div>
        {/* ... many more lines */}
      </header>

      {/* Orders section (80 lines) */}
      <section>
        <h2>Recent Orders</h2>
        {orders.map(order => (
          <div key={order.id}>
            {/* ... complex order display logic */}
          </div>
        ))}
      </section>

      {/* Notifications section (50 lines) */}
      <section>
        <h2>Notifications</h2>
        {/* ... complex notification logic */}
      </section>
    </div>
  );
}

// After (Split Components)
function UserDashboard() {
  const { user } = useUser();

  return (
    <div className={styles.dashboard}>
      <DashboardHeader user={user} />
      <RecentOrders userId={user.id} />
      <NotificationList userId={user.id} />
    </div>
  );
}

function DashboardHeader({ user }: { user: User }) {
  return (
    <header className={styles.header}>
      <h1>{user.name}</h1>
      <img src={user.avatar} alt={user.name} />
      <div>Email: {user.email}</div>
    </header>
  );
}

function RecentOrders({ userId }: { userId: string }) {
  const { orders } = useOrders(userId);

  return (
    <section className={styles.orders}>
      <h2>Recent Orders</h2>
      {orders.map(order => (
        <OrderItem key={order.id} order={order} />
      ))}
    </section>
  );
}

function OrderItem({ order }: { order: Order }) {
  return (
    <div className={styles.orderItem}>
      {/* Order display logic */}
    </div>
  );
}

function NotificationList({ userId }: { userId: string }) {
  const { notifications } = useNotifications(userId);

  return (
    <section className={styles.notifications}>
      <h2>Notifications</h2>
      {notifications.map(notification => (
        <NotificationItem key={notification.id} notification={notification} />
      ))}
    </section>
  );
}
```

---

## TypeScript Refactoring

### 4. Replace Conditional with Polymorphism

**When to Apply**:

- Multiple if/else or switch statements checking type/kind
- Same conditional pattern appears in multiple places
- Adding new types requires changing many places

**Pattern**:

```typescript
// Before
type Shape =
  | { kind: 'circle'; radius: number }
  | { kind: 'rectangle'; width: number; height: number }
  | { kind: 'triangle'; base: number; height: number };

function calculateArea(shape: Shape): number {
  switch (shape.kind) {
    case 'circle':
      return Math.PI * shape.radius ** 2;
    case 'rectangle':
      return shape.width * shape.height;
    case 'triangle':
      return (shape.base * shape.height) / 2;
  }
}

function calculatePerimeter(shape: Shape): number {
  switch (shape.kind) {
    case 'circle':
      return 2 * Math.PI * shape.radius;
    case 'rectangle':
      return 2 * (shape.width + shape.height);
    case 'triangle':
      // Complex calculation...
      return 0; // Simplified
  }
}

// After (Polymorphism)
interface Shape {
  calculateArea(): number;
  calculatePerimeter(): number;
}

class Circle implements Shape {
  constructor(private radius: number) {}

  calculateArea(): number {
    return Math.PI * this.radius ** 2;
  }

  calculatePerimeter(): number {
    return 2 * Math.PI * this.radius;
  }
}

class Rectangle implements Shape {
  constructor(
    private width: number,
    private height: number
  ) {}

  calculateArea(): number {
    return this.width * this.height;
  }

  calculatePerimeter(): number {
    return 2 * (this.width + this.height);
  }
}

class Triangle implements Shape {
  constructor(
    private base: number,
    private height: number
  ) {}

  calculateArea(): number {
    return (this.base * this.height) / 2;
  }

  calculatePerimeter(): number {
    // Complex calculation
    return 0; // Simplified
  }
}

// Usage
const shapes: Shape[] = [
  new Circle(5),
  new Rectangle(4, 6),
  new Triangle(3, 4),
];

shapes.forEach(shape => {
  console.log('Area:', shape.calculateArea());
  console.log('Perimeter:', shape.calculatePerimeter());
});
```

---

### 5. Use Discriminated Unions Instead of Optional Fields

**When to Apply**:

- Type has many optional fields
- Only certain combinations of fields are valid
- Hard to ensure type safety

**Pattern**:

```typescript
// Before (Unclear valid states)
type RequestState = {
  loading?: boolean;
  data?: User;
  error?: Error;
};

// Problem: All combinations are technically valid
const state1: RequestState = {}; // Valid but unclear
const state2: RequestState = { loading: true, data: user }; // Valid but nonsensical
const state3: RequestState = { data: user, error: err }; // Valid but contradictory

// After (Explicit valid states)
type RequestState =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: User }
  | { status: 'error'; error: Error };

// Only valid combinations allowed
const state1: RequestState = { status: 'idle' };
const state2: RequestState = { status: 'loading' };
const state3: RequestState = { status: 'success', data: user };
const state4: RequestState = { status: 'error', error: err };

// Type-safe handling
function handleState(state: RequestState) {
  switch (state.status) {
    case 'idle':
      return 'Not started';
    case 'loading':
      return 'Loading...';
    case 'success':
      return state.data.name; // TypeScript knows data exists
    case 'error':
      return state.error.message; // TypeScript knows error exists
  }
}
```

---

## CSS Modules Organization

### 6. Extract Common Styles

**When to Apply**:

- Same style rules duplicated across modules
- Design system tokens scattered
- Inconsistent styling

**Pattern**:

```css
/* Before: Duplicated in multiple .module.css files */
.button {
  padding: 8px 16px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
}

.submitButton {
  padding: 8px 16px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  background: blue;
}

/* After: Extract to shared variables */
/* styles/tokens.css */
:root {
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --border-radius: 4px;
  --font-size-body: 14px;
  --font-weight-medium: 500;
}

/* styles/mixins.module.css */
.buttonBase {
  padding: var(--spacing-sm) var(--spacing-md);
  border-radius: var(--border-radius);
  font-size: var(--font-size-body);
  font-weight: var(--font-weight-medium);
}

/* components/Button.module.css */
@import '../styles/tokens.css';

.button {
  composes: buttonBase from '../styles/mixins.module.css';
}

.submitButton {
  composes: buttonBase from '../styles/mixins.module.css';
  background: blue;
}
```

---

## Performance Optimization

### 7. Memoize Expensive Computations

**When to Apply**:

- Component re-renders frequently
- Expensive calculations in render
- Derived state can be cached

**Pattern**:

```typescript
// Before
function ProductList({ products, searchTerm, category }: Props) {
  // This filters on every render, even when products/searchTerm/category don't change
  const filteredProducts = products
    .filter(p => p.name.includes(searchTerm))
    .filter(p => p.category === category)
    .sort((a, b) => b.price - a.price);

  return (
    <div>
      {filteredProducts.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}

// After
function ProductList({ products, searchTerm, category }: Props) {
  const filteredProducts = useMemo(() => {
    return products
      .filter(p => p.name.includes(searchTerm))
      .filter(p => p.category === category)
      .sort((a, b) => b.price - a.price);
  }, [products, searchTerm, category]);

  return (
    <div>
      {filteredProducts.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
```

---

### 8. Avoid Inline Function Creation in JSX

**When to Apply**:

- Functions created in JSX on every render
- Child components re-render unnecessarily
- Performance issues in lists

**Pattern**:

```typescript
// Before
function TodoList({ todos }: { todos: Todo[] }) {
  const [completedIds, setCompletedIds] = useState<Set<string>>(new Set());

  return (
    <ul>
      {todos.map(todo => (
        <TodoItem
          key={todo.id}
          todo={todo}
          onToggle={() => {
            // New function created on every render
            const newSet = new Set(completedIds);
            if (newSet.has(todo.id)) {
              newSet.delete(todo.id);
            } else {
              newSet.add(todo.id);
            }
            setCompletedIds(newSet);
          }}
        />
      ))}
    </ul>
  );
}

// After
function TodoList({ todos }: { todos: Todo[] }) {
  const [completedIds, setCompletedIds] = useState<Set<string>>(new Set());

  const handleToggle = useCallback((todoId: string) => {
    setCompletedIds(prev => {
      const newSet = new Set(prev);
      if (newSet.has(todoId)) {
        newSet.delete(todoId);
      } else {
        newSet.add(todoId);
      }
      return newSet;
    });
  }, []);

  return (
    <ul>
      {todos.map(todo => (
        <TodoItem
          key={todo.id}
          todo={todo}
          onToggle={handleToggle}
        />
      ))}
    </ul>
  );
}

const TodoItem = memo(function TodoItem({ todo, onToggle }: TodoItemProps) {
  return (
    <li onClick={() => onToggle(todo.id)}>
      {todo.text}
    </li>
  );
});
```

---

## Best Practices

### General TypeScript

1. **Prefer `unknown` over `any`**
   - Forces type checking before use
   - Safer for external data

2. **Use `const` assertions for literal types**
   ```typescript
   const config = {
     api: 'https://api.example.com',
     timeout: 5000,
   } as const;
   // config.api is type "https://api.example.com", not string
   ```

3. **Use utility types**
   - `Partial<T>`, `Required<T>`, `Pick<T, K>`, `Omit<T, K>`
   - Avoid duplicating type definitions

### React

1. **Use function declarations for components**
   - Better for debugging (named function in stack traces)
   - Hoisted (can be used before definition in same file)

2. **Destructure props in parameter**
   ```typescript
   // Good
   function Button({ label, onClick }: ButtonProps) { }

   // Avoid
   function Button(props: ButtonProps) {
     const { label, onClick } = props;
   }
   ```

3. **Avoid `useEffect` for derived state**
   - Calculate during render or use `useMemo`
   - Reduces complexity and bugs

4. **Keep state minimal**
   - Don't store values that can be calculated
   - Reduces synchronization bugs

## References

- TypeScript Handbook: https://www.typescriptlang.org/docs/handbook/
- React Patterns: https://reactpatterns.com/
- React Performance: https://react.dev/learn/render-and-commit
