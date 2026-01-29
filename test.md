---
title: Render Markdown 测试
description: 用于测试 render-markdown / markdown 渲染效果
tags: [test, markdown, render]
---

# Render Markdown 测试文档

> 用于测试：标题层级、列表、引用、代码、表格、任务清单、脚注、数学、提示块、链接、图片占位等。

---

## 1. 文本与样式

普通文本、**粗体**、*斜体*、~~删除线~~、`行内代码`、==高亮(如果支持)==。

中文/English 混排：Hello 世界。  
换行测试（这里是行尾两个空格产生的硬换行）。  

> 引用块（一级）
>
> > 引用嵌套（二级）
> >
> > - 引用中的列表
> > - 第二项

---

![test img](./test.png)



## 2. 标题层级

### 2.1 三级标题
#### 2.1.1 四级标题
##### 2.1.1.1 五级标题

---

## 3. 列表

### 3.1 无序列表
- 第一项
- 第二项
  - 子项 2.1
  - 子项 2.2
    - 子子项 2.2.1
- 第三项

### 3.2 有序列表
1. 第一
2. 第二
3. 第三
   1. 3.1
   2. 3.2
- Item 1
- Item 2
  - Nest 1
  * Nest 2
    - Nest 2.a
    - Nest 2.b
  - Nest 3
    1. Nest 4
    2. Nest 5
  - [x] Nest 6
  - [ ] Nest 7
  - [>] Nest 8
### 3.3 任务清单
- [ ] 未完成任务
- [x] 已完成任务
- [ ] 带子项
  - [x] 子项已完成
  - [x] 子项未完成

---

## 4. 代码块

### 4.1 Lua

```lua
local M = {}

function M.hello(name)
  name = name or "world"
  print("Hello, " .. name .. "!")
end

return M
```


```python
from dataclasses import dataclass

@dataclass
class User:
    name: str
    age: int = 18

u = User("Alice", 20)
print(u)

```

```json
{
  "name": "render-markdown",
  "enabled": true,
  "features": ["tables", "code", "math", "task-lists"]
}
```

```diff 
- old line
+ new line
@@ -1,3 +1,3 @@
-foo
+bar
 baz
```


|  列A |  列B | 列C                        |
| -- | - | ------------------------ |
|   1 |  ✅  | 左对齐                       |
|  20 |  ❌  | 右侧                        |
| 300 |  ⏳  | 长文本测试：这是一段比较长的内容看看是否换行或截断 |




