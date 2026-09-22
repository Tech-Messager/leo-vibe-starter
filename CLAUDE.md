# Claude Code Instructions
<!-- This file is loaded automatically at the start of every Claude Code session.
     Fill in the sections marked with <!-- Fill in --> to teach Claude your project. -->

## Project Context

- **Name**: 美股交易系统（Michael 的可重复操作规则）
- **Stack**: 纯 Markdown 文档 + Git 版本控制，无代码/依赖；Claude Code 用于记录交易、执行每周复盘
- **Goal**: 把分散的交易直觉变成可执行、可复盘、可进化的仓位管理与出场规则系统（账户目标 AUD $20,339 → $40,000）
- **Current focus**: 恢复纪律执行——`美股交易系统.md` 已连续多周复盘记录 NVDA 止损未核查、SMCI 仓位超限未处理、现金低于底线，需要先核实真实持仓/价格数据，再按模块2、3的规则执行动作并记入交易日志

## Coding Rules

### 1. Think before coding
State assumptions explicitly before writing code. If the requirement is ambiguous, name the ambiguity and ask — don't silently pick one interpretation. If a simpler approach exists, say so.

### 2. Simplicity first
Write the minimum code that solves the problem. No abstractions for single-use cases. No error handling for impossible scenarios. No features that weren't asked for. If 50 lines can do what 200 lines does, rewrite it.

### 3. Surgical changes
Touch only what the task requires. Don't improve adjacent code, fix unrelated style, or refactor things that aren't broken. If you notice unrelated dead code, mention it — don't delete it. Every changed line should trace directly to the request.

### 4. Goal-driven execution
For any non-trivial task, state a brief plan with verifiable checkpoints before starting:
```
1. [Step] → verify: [how to confirm it worked]
2. [Step] → verify: [how to confirm it worked]
```

## Communication Style

- Responses: short and direct. No trailing summaries — the diff speaks for itself.
- When referencing code: use `file_path:line_number` format.
- When uncertain: ask, don't assume.
- When blocked: say so immediately with the specific blocker.

## Project-Specific Rules

- 交易记录（`## 交易记录`）是 append-only：只追加新行，永远不要编辑或删除已有条目。
- 不要编造股价、财报日期或持仓数据。没有真实数据源可核实时，明确说"无法核实"，不要在复盘里假设或延续上一周的数字。
- 每次复盘前先确认是否已连续多周未执行计划中的动作（止损、减仓、补现金等）；如是，优先指出并推动执行，而不是重复写入相同的下周计划。
- 止损/止盈/仓位规则的数值以模块2、模块3中最新写明的为准，修改前先跟用户确认。

## What NOT to do

- Don't add comments that describe what the code does — good names do that.
- Don't create documentation files unless explicitly asked.
- Don't run destructive git commands (reset --hard, push --force) without confirming.
- Don't install packages without checking if an equivalent already exists in the project.

## Commit Style

trade-log: <股票> <买入/卖出><数量>股 @<价格>，<盈亏说明>，<日期>
weekly-review: <日期> 复盘完成

## Stack-Specific Notes

- 唯一的核心文件是 `美股交易系统.md`：模块2/3 是规则，模块4 是交易日志与每周复盘的存放位置。
- 本仓库没有代码、没有构建/测试流程；所有改动都是对这个 Markdown 文件的编辑。
