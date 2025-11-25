# 外部プロセス統合パターン

**Category**: Code Structure
**Tech Stack**: Cross-stack (Node.js, Deno, Bun, Electron)
**Date Added**: 2025-01-19
**Source Project**: codearts-nfc-reader-electron

## Problem

JavaScriptランタイムから外部スクリプト（Python、Ruby等）を実行し、結果を取得する必要がある場合、セキュリティとエラーハンドリングが課題となる。

## Solution

`spawn()` を使用し、引数を配列で渡すことでコマンドインジェクションを防止。stdout/stderrをストリームで処理し、タイムアウトとエラーハンドリングを実装。

## Implementation

```typescript
import { spawn } from 'child_process'

function executePythonScript(
  scriptPath: string,
  args: string[],
  timeout: number = 5000
): Promise<string> {
  return new Promise((resolve, reject) => {
    // 引数を配列で渡す（コマンドインジェクション防止）
    const python = spawn('python3', [scriptPath, ...args])

    let stdout = ''
    let stderr = ''

    // タイムアウト設定
    const timer = setTimeout(() => {
      python.kill()
      reject(new Error(`Timeout after ${timeout}ms`))
    }, timeout)

    python.stdout.on('data', (data) => {
      stdout += data.toString()
    })

    python.stderr.on('data', (data) => {
      stderr += data.toString()
    })

    python.on('close', (code) => {
      clearTimeout(timer)

      if (code === 0) {
        resolve(stdout.trim())
      } else {
        reject(new Error(`Script failed (exit ${code}): ${stderr}`))
      }
    })

    python.on('error', (error) => {
      clearTimeout(timer)
      reject(error)
    })
  })
}

// 使用例
const result = await executePythonScript(
  'scripts/nfc_read.py',
  ['--format', 'json', '--timeout', '5']
)
const data = JSON.parse(result)
```

## Benefits

- **セキュリティ**: コマンドインジェクション防止
- **堅牢性**: タイムアウトとエラーハンドリング
- **柔軟性**: 任意の外部コマンド実行に対応

## Trade-offs

- プロセス起動のオーバーヘッド
- 大量データの場合はストリーム処理が必要

## When to Use

- PythonやRubyなどの外部スクリプトを実行する場合
- システムコマンドを安全に実行する必要がある場合
- ライブラリのネイティブバインディングが利用できない場合

## When Not to Use

- 高頻度で呼び出す処理（オーバーヘッドが大きい）
- ネイティブバインディングが利用可能な場合

## Related Patterns

- [Electron Security Best Practices](../../best-practices/electron-security.md)

## References

- [Node.js child_process documentation](https://nodejs.org/api/child_process.html)
