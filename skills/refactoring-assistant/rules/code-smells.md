# Code Smells Detection and Refactoring Patterns

Detailed rules for detecting code smells and applying appropriate refactoring patterns.

## Common Code Smells (Language Agnostic)

### 1. Long Method (長すぎる関数)

**Detection Criteria**:

- Function/method exceeds 50 lines (excluding comments)
- Function has multiple distinct responsibilities
- Hard to understand without scrolling

**Symptoms**:

- Many local variables
- Multiple levels of abstraction mixed together
- Comments marking different "sections" within function

**Refactoring Patterns**:

1. **Extract Method**
   - Identify cohesive code blocks
   - Create new function with descriptive name
   - Replace original code with function call

2. **Decompose Conditional**
   - Extract complex conditions to named functions
   - Improves readability and testability

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
function processOrder(order: Order): void {
  // Validate order
  if (!order.items || order.items.length === 0) {
    throw new Error('Order has no items');
  }
  if (!order.customer || !order.customer.email) {
    throw new Error('Invalid customer');
  }

  // Calculate total
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }

  // Apply discount
  if (order.customer.loyaltyLevel === 'gold') {
    total *= 0.9;
  } else if (order.customer.loyaltyLevel === 'silver') {
    total *= 0.95;
  }

  // Send email
  const emailBody = `Thank you for your order...`;
  sendEmail(order.customer.email, emailBody);

  // Update inventory
  for (const item of order.items) {
    updateInventory(item.productId, -item.quantity);
  }
}

// After (Refactored)
function processOrder(order: Order): void {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  sendOrderConfirmation(order, total);
  updateInventoryForOrder(order);
}

function validateOrder(order: Order): void {
  if (!order.items || order.items.length === 0) {
    throw new Error('Order has no items');
  }
  if (!order.customer || !order.customer.email) {
    throw new Error('Invalid customer');
  }
}

function calculateOrderTotal(order: Order): number {
  const subtotal = order.items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );
  return applyLoyaltyDiscount(subtotal, order.customer.loyaltyLevel);
}

function applyLoyaltyDiscount(amount: number, level: string): number {
  const discounts: Record<string, number> = {
    gold: 0.9,
    silver: 0.95,
  };
  return amount * (discounts[level] || 1);
}

function sendOrderConfirmation(order: Order, total: number): void {
  const emailBody = `Thank you for your order. Total: $${total}`;
  sendEmail(order.customer.email, emailBody);
}

function updateInventoryForOrder(order: Order): void {
  for (const item of order.items) {
    updateInventory(item.productId, -item.quantity);
  }
}
```

**Example (Go)**:

```go
// Before (Code Smell)
func ProcessOrder(order *Order) error {
  // Validation
  if order.Items == nil || len(order.Items) == 0 {
    return errors.New("order has no items")
  }
  if order.Customer == nil || order.Customer.Email == "" {
    return errors.New("invalid customer")
  }

  // Calculate total
  var total float64
  for _, item := range order.Items {
    total += item.Price * float64(item.Quantity)
  }

  // Apply discount
  switch order.Customer.LoyaltyLevel {
  case "gold":
    total *= 0.9
  case "silver":
    total *= 0.95
  }

  // Send email and update inventory...
  // (50+ more lines)
}

// After (Refactored)
func ProcessOrder(order *Order) error {
  if err := validateOrder(order); err != nil {
    return err
  }

  total := calculateOrderTotal(order)

  if err := sendOrderConfirmation(order, total); err != nil {
    return err
  }

  return updateInventoryForOrder(order)
}

func validateOrder(order *Order) error {
  if order.Items == nil || len(order.Items) == 0 {
    return errors.New("order has no items")
  }
  if order.Customer == nil || order.Customer.Email == "" {
    return errors.New("invalid customer")
  }
  return nil
}

func calculateOrderTotal(order *Order) float64 {
  subtotal := 0.0
  for _, item := range order.Items {
    subtotal += item.Price * float64(item.Quantity)
  }
  return applyLoyaltyDiscount(subtotal, order.Customer.LoyaltyLevel)
}

func applyLoyaltyDiscount(amount float64, level string) float64 {
  discounts := map[string]float64{
    "gold":   0.9,
    "silver": 0.95,
  }
  if multiplier, ok := discounts[level]; ok {
    return amount * multiplier
  }
  return amount
}
```

---

### 2. Duplicate Code (重複コード)

**Detection Criteria**:

- Same code block appears 3+ times
- Similar logic with minor variations
- Copy-pasted code with slight modifications

**Symptoms**:

- Fixing a bug requires changing multiple places
- Inconsistent behavior between "duplicates"
- High maintenance cost

**Refactoring Patterns**:

1. **Extract Function**
   - Create shared function for common logic
   - Parameterize differences

2. **Introduce Parameter Object**
   - If duplicates differ only in data, use structured parameters

3. **Use Strategy Pattern**
   - If duplicates differ in behavior, use strategy/function composition

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
function createUserNotification(user: User): void {
  const message = `Hello ${user.name}`;
  const timestamp = new Date().toISOString();
  const notification = {
    message,
    timestamp,
    userId: user.id,
    type: 'user',
  };
  saveNotification(notification);
}

function createOrderNotification(order: Order): void {
  const message = `Order #${order.id} confirmed`;
  const timestamp = new Date().toISOString();
  const notification = {
    message,
    timestamp,
    orderId: order.id,
    type: 'order',
  };
  saveNotification(notification);
}

function createPaymentNotification(payment: Payment): void {
  const message = `Payment of $${payment.amount} received`;
  const timestamp = new Date().toISOString();
  const notification = {
    message,
    timestamp,
    paymentId: payment.id,
    type: 'payment',
  };
  saveNotification(notification);
}

// After (Refactored)
type NotificationParams = {
  message: string;
  type: string;
  entityId: string;
};

function createNotification(params: NotificationParams): void {
  const { message, type, entityId } = params;
  const notification = {
    message,
    timestamp: new Date().toISOString(),
    [`${type}Id`]: entityId,
    type,
  };
  saveNotification(notification);
}

function createUserNotification(user: User): void {
  createNotification({
    message: `Hello ${user.name}`,
    type: 'user',
    entityId: user.id,
  });
}

function createOrderNotification(order: Order): void {
  createNotification({
    message: `Order #${order.id} confirmed`,
    type: 'order',
    entityId: order.id,
  });
}

function createPaymentNotification(payment: Payment): void {
  createNotification({
    message: `Payment of $${payment.amount} received`,
    type: 'payment',
    entityId: payment.id,
  });
}
```

---

### 3. Deep Nesting (深すぎるネスト)

**Detection Criteria**:

- Nesting level > 3
- Multiple nested if/for/while statements
- Hard to follow control flow

**Symptoms**:

- Code drifts to the right ("arrow code")
- Difficult to understand conditions
- High cognitive load

**Refactoring Patterns**:

1. **Early Return (Guard Clauses)**
   - Check error conditions first and return early
   - Reduces nesting for happy path

2. **Extract Method**
   - Move nested logic to separate function

3. **Invert Conditions**
   - Use negative conditions to return early

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
function processData(data: Data | null): Result | null {
  if (data) {
    if (data.isValid) {
      if (data.items && data.items.length > 0) {
        const results = [];
        for (const item of data.items) {
          if (item.isActive) {
            if (item.value > 0) {
              results.push(transformItem(item));
            }
          }
        }
        return { results };
      }
    }
  }
  return null;
}

// After (Refactored)
function processData(data: Data | null): Result | null {
  if (!data) return null;
  if (!data.isValid) return null;
  if (!data.items || data.items.length === 0) return null;

  const results = data.items
    .filter(item => item.isActive && item.value > 0)
    .map(transformItem);

  return { results };
}
```

**Example (Go)**:

```go
// Before (Code Smell)
func ProcessData(data *Data) (*Result, error) {
  if data != nil {
    if data.IsValid {
      if data.Items != nil && len(data.Items) > 0 {
        var results []TransformedItem
        for _, item := range data.Items {
          if item.IsActive {
            if item.Value > 0 {
              results = append(results, TransformItem(item))
            }
          }
        }
        return &Result{Results: results}, nil
      }
    }
  }
  return nil, errors.New("invalid data")
}

// After (Refactored)
func ProcessData(data *Data) (*Result, error) {
  if data == nil {
    return nil, errors.New("data is nil")
  }
  if !data.IsValid {
    return nil, errors.New("data is invalid")
  }
  if data.Items == nil || len(data.Items) == 0 {
    return nil, errors.New("no items")
  }

  results := make([]TransformedItem, 0, len(data.Items))
  for _, item := range data.Items {
    if !item.IsActive || item.Value <= 0 {
      continue
    }
    results = append(results, TransformItem(item))
  }

  return &Result{Results: results}, nil
}
```

---

### 4. Long Parameter List (長すぎる引数リスト)

**Detection Criteria**:

- Function has > 5 parameters
- Related parameters often passed together
- New features require adding more parameters

**Symptoms**:

- Function calls are hard to read
- Easy to mix up parameter order
- High coupling

**Refactoring Patterns**:

1. **Introduce Parameter Object** (TypeScript: RORO pattern, Go: struct)
   - Group related parameters into object/struct
   - Name the parameter object meaningfully

2. **Preserve Whole Object**
   - Pass entire object instead of individual fields

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
function createUser(
  name: string,
  email: string,
  age: number,
  address: string,
  phone: string,
  country: string,
  isActive: boolean
): User {
  // Implementation
}

// Hard to read
createUser('John', 'john@example.com', 30, '123 Main St', '555-0100', 'USA', true);

// After (Refactored - RORO pattern)
type CreateUserParams = {
  name: string;
  email: string;
  age: number;
  address: string;
  phone: string;
  country: string;
  isActive: boolean;
};

function createUser(params: CreateUserParams): User {
  const { name, email, age, address, phone, country, isActive } = params;
  // Implementation
}

// Easy to read
createUser({
  name: 'John',
  email: 'john@example.com',
  age: 30,
  address: '123 Main St',
  phone: '555-0100',
  country: 'USA',
  isActive: true,
});
```

**Example (Go)**:

```go
// Before (Code Smell)
func CreateUser(name, email string, age int, address, phone, country string, isActive bool) (*User, error) {
  // Implementation
}

// Hard to read
user, err := CreateUser("John", "john@example.com", 30, "123 Main St", "555-0100", "USA", true)

// After (Refactored)
type CreateUserParams struct {
  Name     string
  Email    string
  Age      int
  Address  string
  Phone    string
  Country  string
  IsActive bool
}

func CreateUser(params CreateUserParams) (*User, error) {
  // Implementation
}

// Easy to read
user, err := CreateUser(CreateUserParams{
  Name:     "John",
  Email:    "john@example.com",
  Age:      30,
  Address:  "123 Main St",
  Phone:    "555-0100",
  Country:  "USA",
  IsActive: true,
})
```

---

### 5. Large Class/Module (大きすぎるクラス/モジュール)

**Detection Criteria**:

- File exceeds 300 lines
- Class/module has multiple responsibilities
- Many public methods/exports

**Symptoms**:

- Hard to understand the purpose
- Frequent merge conflicts
- Difficult to test

**Refactoring Patterns**:

1. **Extract Class/Module**
   - Identify cohesive groups of methods/functions
   - Create separate class/module for each responsibility

2. **Use Composition**
   - Instead of one large class, compose multiple smaller classes

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
class UserManager {
  createUser(data: UserData) { /* ... */ }
  updateUser(id: string, data: UserData) { /* ... */ }
  deleteUser(id: string) { /* ... */ }

  sendWelcomeEmail(user: User) { /* ... */ }
  sendPasswordResetEmail(user: User) { /* ... */ }

  validateEmail(email: string) { /* ... */ }
  validatePassword(password: string) { /* ... */ }

  hashPassword(password: string) { /* ... */ }
  comparePassword(plain: string, hashed: string) { /* ... */ }

  generateToken(user: User) { /* ... */ }
  verifyToken(token: string) { /* ... */ }
}

// After (Refactored)
class UserRepository {
  create(data: UserData) { /* ... */ }
  update(id: string, data: UserData) { /* ... */ }
  delete(id: string) { /* ... */ }
}

class UserEmailService {
  sendWelcomeEmail(user: User) { /* ... */ }
  sendPasswordResetEmail(user: User) { /* ... */ }
}

class UserValidator {
  validateEmail(email: string) { /* ... */ }
  validatePassword(password: string) { /* ... */ }
}

class PasswordService {
  hash(password: string) { /* ... */ }
  compare(plain: string, hashed: string) { /* ... */ }
}

class AuthTokenService {
  generate(user: User) { /* ... */ }
  verify(token: string) { /* ... */ }
}
```

---

### 6. Complex Conditional (複雑な条件式)

**Detection Criteria**:

- More than 3 conditions combined with && or ||
- Nested ternary operators
- Hard to understand the intent

**Symptoms**:

- Difficult to test all branches
- Easy to introduce bugs
- Unclear business logic

**Refactoring Patterns**:

1. **Extract to Named Function**
   - Create function with descriptive name
   - Improves readability and testability

2. **Use Guard Clauses**
   - Break down complex condition into multiple simple checks

3. **Introduce Explaining Variable**
   - Store intermediate results in named variables

**Example (TypeScript)**:

```typescript
// Before (Code Smell)
function canApproveOrder(order: Order, user: User): boolean {
  return (
    user.role === 'admin' ||
    (user.role === 'manager' && user.department === order.department) ||
    (user.role === 'supervisor' && user.teamId === order.teamId && order.amount < 1000)
  );
}

// After (Refactored)
function canApproveOrder(order: Order, user: User): boolean {
  if (isAdmin(user)) return true;
  if (isManagerOfDepartment(user, order)) return true;
  if (isSupervisorWithinLimit(user, order)) return true;
  return false;
}

function isAdmin(user: User): boolean {
  return user.role === 'admin';
}

function isManagerOfDepartment(user: User, order: Order): boolean {
  return user.role === 'manager' && user.department === order.department;
}

function isSupervisorWithinLimit(user: User, order: Order): boolean {
  return (
    user.role === 'supervisor' &&
    user.teamId === order.teamId &&
    order.amount < 1000
  );
}
```

---

## Tech-Stack Specific Thresholds

### TypeScript/React

- **Function length**: 50 lines (component render methods: 30 lines)
- **Component props**: 7 props max (use composition or context)
- **useEffect dependencies**: 5 max (split into multiple effects)
- **Nesting**: 3 levels max

### Go

- **Function length**: 50 lines
- **Function parameters**: 5 max (use struct)
- **Cyclomatic complexity**: 10 max
- **File length**: 500 lines (consider splitting package)

## When to Apply Refactoring

### High Priority

- Code smell affects security or correctness
- Code is being actively modified
- Adding tests (refactor first to make testable)

### Medium Priority

- Code is frequently read/reviewed
- Code smell causes maintenance issues
- Technical debt is accumulating

### Low Priority

- Code is stable and rarely touched
- Refactoring would require extensive testing
- Business priorities are more urgent

## References

For more detailed refactoring patterns and examples:

- TypeScript/React: See `patterns/typescript-react.md`
- Go: See `patterns/go.md`
- Real-world examples: `~/.claude/knowledge/patterns/`
