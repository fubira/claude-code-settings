# Go Refactoring Patterns

Tech-stack specific refactoring patterns and best practices for Go projects.

## Function Refactoring

### 1. Extract Function for Error Handling

**When to Apply**:

- Repetitive error handling patterns
- Error wrapping with context
- Error logging before return

**Pattern**:

```go
// Before
func ProcessData(filename string) error {
  data, err := os.ReadFile(filename)
  if err != nil {
    log.Printf("failed to read file %s: %v", filename, err)
    return fmt.Errorf("read file: %w", err)
  }

  parsed, err := ParseData(data)
  if err != nil {
    log.Printf("failed to parse data from %s: %v", filename, err)
    return fmt.Errorf("parse data: %w", err)
  }

  if err := ValidateData(parsed); err != nil {
    log.Printf("validation failed for %s: %v", filename, err)
    return fmt.Errorf("validate data: %w", err)
  }

  return nil
}

// After
func ProcessData(filename string) error {
  data, err := os.ReadFile(filename)
  if err != nil {
    return handleError(err, "read file", filename)
  }

  parsed, err := ParseData(data)
  if err != nil {
    return handleError(err, "parse data", filename)
  }

  if err := ValidateData(parsed); err != nil {
    return handleError(err, "validate data", filename)
  }

  return nil
}

func handleError(err error, operation, context string) error {
  log.Printf("%s failed for %s: %v", operation, context, err)
  return fmt.Errorf("%s: %w", operation, err)
}
```

---

### 2. Use Struct for Multiple Return Values

**When to Apply**:

- Function returns > 3 values
- Return values are related
- Caller always uses most values together

**Pattern**:

```go
// Before
func AnalyzeData(data []byte) (int, float64, string, error) {
  count := len(data)
  average := calculateAverage(data)
  summary := generateSummary(data)
  return count, average, summary, nil
}

// Hard to remember order
count, avg, summary, err := AnalyzeData(data)

// After
type AnalysisResult struct {
  Count   int
  Average float64
  Summary string
}

func AnalyzeData(data []byte) (*AnalysisResult, error) {
  return &AnalysisResult{
    Count:   len(data),
    Average: calculateAverage(data),
    Summary: generateSummary(data),
  }, nil
}

// Clear and self-documenting
result, err := AnalyzeData(data)
if err != nil {
  return err
}
fmt.Printf("Count: %d, Average: %.2f\n", result.Count, result.Average)
```

---

## Interface Design

### 3. Accept Interfaces, Return Structs

**When to Apply**:

- Function needs subset of type's methods
- Improving testability
- Reducing coupling

**Pattern**:

```go
// Before (tightly coupled to concrete type)
func ProcessOrder(db *sql.DB, orderID string) error {
  // Uses only Query and Exec from *sql.DB
  rows, err := db.Query("SELECT * FROM orders WHERE id = ?", orderID)
  // ...
}

// Hard to test - requires real database

// After (loosely coupled to interface)
type OrderQuerier interface {
  Query(query string, args ...interface{}) (*sql.Rows, error)
  Exec(query string, args ...interface{}) (sql.Result, error)
}

func ProcessOrder(db OrderQuerier, orderID string) error {
  rows, err := db.Query("SELECT * FROM orders WHERE id = ?", orderID)
  // ...
}

// Easy to test with mock
type mockDB struct{}

func (m *mockDB) Query(query string, args ...interface{}) (*sql.Rows, error) {
  // Return test data
  return nil, nil
}

func (m *mockDB) Exec(query string, args ...interface{}) (sql.Result, error) {
  // Return test result
  return nil, nil
}
```

---

### 4. Use Small Interfaces

**When to Apply**:

- Interface has many methods
- Consumers only need subset
- Following Interface Segregation Principle

**Pattern**:

```go
// Before (large interface)
type Storage interface {
  Create(key string, data []byte) error
  Read(key string) ([]byte, error)
  Update(key string, data []byte) error
  Delete(key string) error
  List(prefix string) ([]string, error)
  Backup(destination string) error
  Restore(source string) error
  Compress() error
  Decompress() error
}

// Most code only needs Read/Write
func ProcessData(storage Storage, key string) error {
  data, err := storage.Read(key)
  // ...
  return storage.Update(key, processed)
}

// After (small, focused interfaces)
type Reader interface {
  Read(key string) ([]byte, error)
}

type Writer interface {
  Update(key string, data []byte) error
}

type ReadWriter interface {
  Reader
  Writer
}

type Lister interface {
  List(prefix string) ([]string, error)
}

type BackupRestore interface {
  Backup(destination string) error
  Restore(source string) error
}

// Clear intent, easy to mock
func ProcessData(storage ReadWriter, key string) error {
  data, err := storage.Read(key)
  // ...
  return storage.Update(key, processed)
}

func ListKeys(storage Lister, prefix string) ([]string, error) {
  return storage.List(prefix)
}
```

---

## Error Handling

### 5. Use Custom Error Types for Rich Context

**When to Apply**:

- Need to check error type (not just message)
- Error needs additional context
- Caller needs to handle different errors differently

**Pattern**:

```go
// Before (string-based errors)
func ValidateUser(user *User) error {
  if user.Email == "" {
    return errors.New("email is required")
  }
  if !strings.Contains(user.Email, "@") {
    return errors.New("email is invalid")
  }
  if user.Age < 18 {
    return errors.New("user must be 18 or older")
  }
  return nil
}

// Hard to distinguish error types
err := ValidateUser(user)
if err != nil {
  // Can only check string message
  if err.Error() == "email is required" {
    // Handle missing email
  }
}

// After (custom error types)
type ValidationError struct {
  Field   string
  Message string
}

func (e *ValidationError) Error() string {
  return fmt.Sprintf("%s: %s", e.Field, e.Message)
}

func ValidateUser(user *User) error {
  if user.Email == "" {
    return &ValidationError{Field: "email", Message: "required"}
  }
  if !strings.Contains(user.Email, "@") {
    return &ValidationError{Field: "email", Message: "invalid format"}
  }
  if user.Age < 18 {
    return &ValidationError{Field: "age", Message: "must be 18 or older"}
  }
  return nil
}

// Type-safe error handling
err := ValidateUser(user)
if err != nil {
  var validationErr *ValidationError
  if errors.As(err, &validationErr) {
    fmt.Printf("Validation failed for %s: %s\n",
      validationErr.Field, validationErr.Message)
    // Handle validation error specifically
  }
}
```

---

### 6. Use errors.Is and errors.As Instead of Type Assertion

**When to Apply**:

- Checking error type or value
- Wrapped errors need to be unwrapped
- Following modern Go error handling

**Pattern**:

```go
// Before (type assertion)
func HandleError(err error) {
  if netErr, ok := err.(*net.OpError); ok {
    fmt.Println("Network error:", netErr)
  }
}

// Problem: Doesn't work with wrapped errors
wrappedErr := fmt.Errorf("failed to connect: %w", netErr)
HandleError(wrappedErr) // Won't detect the net.OpError

// After (errors.As)
func HandleError(err error) {
  var netErr *net.OpError
  if errors.As(err, &netErr) {
    fmt.Println("Network error:", netErr)
  }
}

// Works with wrapped errors
wrappedErr := fmt.Errorf("failed to connect: %w", netErr)
HandleError(wrappedErr) // Correctly detects the net.OpError

// For sentinel errors, use errors.Is
var ErrNotFound = errors.New("not found")

func HandleError(err error) {
  if errors.Is(err, ErrNotFound) {
    fmt.Println("Resource not found")
  }
}

wrappedErr := fmt.Errorf("get user: %w", ErrNotFound)
HandleError(wrappedErr) // Correctly detects ErrNotFound
```

---

## Concurrency Refactoring

### 7. Use Worker Pool for Bounded Concurrency

**When to Apply**:

- Processing many items concurrently
- Need to limit concurrent operations
- Avoid resource exhaustion

**Pattern**:

```go
// Before (unbounded goroutines - dangerous!)
func ProcessItems(items []Item) {
  for _, item := range items {
    go processItem(item) // Could spawn millions of goroutines!
  }
}

// After (worker pool)
func ProcessItems(items []Item, numWorkers int) error {
  jobs := make(chan Item, len(items))
  results := make(chan error, len(items))

  // Start workers
  for w := 0; w < numWorkers; w++ {
    go worker(jobs, results)
  }

  // Send jobs
  for _, item := range items {
    jobs <- item
  }
  close(jobs)

  // Collect results
  var errs []error
  for i := 0; i < len(items); i++ {
    if err := <-results; err != nil {
      errs = append(errs, err)
    }
  }

  if len(errs) > 0 {
    return fmt.Errorf("encountered %d errors", len(errs))
  }
  return nil
}

func worker(jobs <-chan Item, results chan<- error) {
  for item := range jobs {
    results <- processItem(item)
  }
}
```

---

### 8. Use Context for Cancellation

**When to Apply**:

- Long-running operations
- Need to cancel operations
- Propagating deadlines/timeouts

**Pattern**:

```go
// Before (no cancellation)
func FetchData(urls []string) ([]Response, error) {
  var responses []Response
  for _, url := range urls {
    resp, err := http.Get(url) // Blocks forever if server doesn't respond
    if err != nil {
      return nil, err
    }
    defer resp.Body.Close()

    data, err := io.ReadAll(resp.Body)
    if err != nil {
      return nil, err
    }
    responses = append(responses, Response{URL: url, Data: data})
  }
  return responses, nil
}

// After (with context)
func FetchData(ctx context.Context, urls []string) ([]Response, error) {
  var responses []Response
  for _, url := range urls {
    // Check cancellation
    select {
    case <-ctx.Done():
      return nil, ctx.Err()
    default:
    }

    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil {
      return nil, err
    }

    resp, err := http.DefaultClient.Do(req)
    if err != nil {
      return nil, err
    }
    defer resp.Body.Close()

    data, err := io.ReadAll(resp.Body)
    if err != nil {
      return nil, err
    }
    responses = append(responses, Response{URL: url, Data: data})
  }
  return responses, nil
}

// Usage with timeout
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

responses, err := FetchData(ctx, urls)
```

---

## Struct Design

### 9. Use Functional Options for Flexible Configuration

**When to Apply**:

- Struct has many optional fields
- Default values are sensible
- Adding new options without breaking API

**Pattern**:

```go
// Before (many optional parameters)
func NewServer(addr string, timeout time.Duration, maxConns int, enableTLS bool, certFile, keyFile string) *Server {
  return &Server{
    Addr:      addr,
    Timeout:   timeout,
    MaxConns:  maxConns,
    EnableTLS: enableTLS,
    CertFile:  certFile,
    KeyFile:   keyFile,
  }
}

// Hard to use, especially with defaults
server := NewServer(":8080", 30*time.Second, 100, false, "", "")

// After (functional options)
type Server struct {
  addr      string
  timeout   time.Duration
  maxConns  int
  enableTLS bool
  certFile  string
  keyFile   string
}

type Option func(*Server)

func WithTimeout(timeout time.Duration) Option {
  return func(s *Server) {
    s.timeout = timeout
  }
}

func WithMaxConnections(max int) Option {
  return func(s *Server) {
    s.maxConns = max
  }
}

func WithTLS(certFile, keyFile string) Option {
  return func(s *Server) {
    s.enableTLS = true
    s.certFile = certFile
    s.keyFile = keyFile
  }
}

func NewServer(addr string, opts ...Option) *Server {
  // Defaults
  s := &Server{
    addr:     addr,
    timeout:  30 * time.Second,
    maxConns: 100,
  }

  // Apply options
  for _, opt := range opts {
    opt(s)
  }

  return s
}

// Easy to use, clear intent
server := NewServer(":8080")
serverWithTLS := NewServer(":8443",
  WithTimeout(60*time.Second),
  WithTLS("cert.pem", "key.pem"),
)
```

---

## Testing

### 10. Use Table-Driven Tests

**When to Apply**:

- Testing multiple scenarios
- Similar test logic with different inputs
- Need comprehensive coverage

**Pattern**:

```go
// Before (repetitive tests)
func TestValidateEmail_Empty(t *testing.T) {
  err := ValidateEmail("")
  if err == nil {
    t.Error("expected error for empty email")
  }
}

func TestValidateEmail_NoAt(t *testing.T) {
  err := ValidateEmail("invalidemail")
  if err == nil {
    t.Error("expected error for email without @")
  }
}

func TestValidateEmail_Valid(t *testing.T) {
  err := ValidateEmail("test@example.com")
  if err != nil {
    t.Errorf("unexpected error for valid email: %v", err)
  }
}

// After (table-driven)
func TestValidateEmail(t *testing.T) {
  tests := []struct {
    name    string
    email   string
    wantErr bool
  }{
    {
      name:    "empty email",
      email:   "",
      wantErr: true,
    },
    {
      name:    "no @ symbol",
      email:   "invalidemail",
      wantErr: true,
    },
    {
      name:    "no domain",
      email:   "test@",
      wantErr: true,
    },
    {
      name:    "valid email",
      email:   "test@example.com",
      wantErr: false,
    },
    {
      name:    "valid email with subdomain",
      email:   "test@mail.example.com",
      wantErr: false,
    },
  }

  for _, tt := range tests {
    t.Run(tt.name, func(t *testing.T) {
      err := ValidateEmail(tt.email)
      if (err != nil) != tt.wantErr {
        t.Errorf("ValidateEmail() error = %v, wantErr %v", err, tt.wantErr)
      }
    })
  }
}
```

---

## Best Practices

### General Go

1. **Accept interfaces, return concrete types**
   - Makes functions flexible
   - Makes return values explicit

2. **Use `defer` for cleanup**
   - Ensures cleanup happens even on error
   - Keep resource acquisition and release close

3. **Prefer composition over embedding**
   - Only embed when "is-a" relationship is clear
   - Use explicit fields for "has-a" relationships

4. **Keep package API surface small**
   - Export only what's necessary
   - Internal implementation details should be private

5. **Use meaningful variable names**
   - `i`, `j`, `k` for short loops only
   - `ctx` for context.Context
   - `err` for errors

### Error Handling

1. **Wrap errors with context**
   ```go
   if err != nil {
     return fmt.Errorf("failed to process user %s: %w", userID, err)
   }
   ```

2. **Handle errors, don't just check**
   - Avoid `if err != nil { return err }` everywhere
   - Add context, log, or handle specifically

3. **Use sentinel errors for expected cases**
   ```go
   var ErrNotFound = errors.New("not found")
   ```

### Concurrency

1. **Channels vs Mutexes**
   - Channels: For passing ownership
   - Mutexes: For protecting shared state

2. **Close channels from sender side**
   - Receiver can't tell difference between closed and empty

3. **Always check for context cancellation in loops**
   ```go
   for {
     select {
     case <-ctx.Done():
       return ctx.Err()
     default:
     }
     // Work...
   }
   ```

### Performance

1. **Pre-allocate slices when size is known**
   ```go
   items := make([]Item, 0, len(source))
   ```

2. **Use `strings.Builder` for string concatenation**
   - More efficient than `+` or `fmt.Sprintf` in loops

3. **Benchmark before optimizing**
   - Use `go test -bench` to measure
   - Use `pprof` for profiling

## References

- Effective Go: https://go.dev/doc/effective_go
- Go Code Review Comments: https://github.com/golang/go/wiki/CodeReviewComments
- Uber Go Style Guide: https://github.com/uber-go/guide/blob/master/style.md
