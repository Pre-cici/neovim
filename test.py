#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
debug_test.py - 用来测试 Python 调试功能的脚本

覆盖点：
- 普通函数调用栈（step in / step out / stack trace）
- for 循环与条件分支（条件断点）
- 异常捕获与未捕获异常
- 线程（多线程时断点/切换线程）
- asyncio（异步断点与任务切换）
- 可选：等待输入，方便你 attach 调试器
"""

from __future__ import annotations

import asyncio
import os
import threading
import time
from dataclasses import dataclass
from typing import List


@dataclass
class User:
    name: str
    scores: List[int]

    @property
    def avg(self) -> float:
        # 测试 property + step in
        return sum(self.scores) / max(len(self.scores), 1)


def fib(n: int) -> int:
    # 测试递归/调用栈
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)


def risky_divide(a: int, b: int) -> float:
    # 测试异常（在这里下断点，然后把 b 设成 0）
    return a / b


def worker(name: str, repeat: int = 3) -> None:
    # 测试线程断点：在这里下断点，看能否切换线程栈
    for i in range(repeat):
        time.sleep(0.2)
        print(f"[thread:{name}] tick={i}")


async def async_worker(tag: str) -> int:
    # 测试异步断点：在 await 前后 step
    await asyncio.sleep(0.1)
    total = 0
    for i in range(5):
        await asyncio.sleep(0)  # 让出事件循环，方便观察任务切换
        total += i
    print(f"[async:{tag}] total={total}")
    return total


def compute(users: List[User]) -> int:
    # 测试列表/循环/条件：可以在 if 处下条件断点（例如 u.name == "bob"）
    best = -1
    for u in users:
        avg = u.avg
        if avg > best:
            best = int(avg)
    return best


def main() -> None:
    print("=== debug_test start ===")
    print("PID =", os.getpid())

    # 方便你 attach：设置环境变量 DEBUG_WAIT=1 会等待你按回车
    if os.getenv("DEBUG_WAIT") == "1":
        input("DEBUG_WAIT=1: 已暂停，attach 调试器后按回车继续... ")

    users = [
        User("alice", [80, 90, 100]),
        User("bob", [60, 70, 65]),
        User("carol", [88, 92, 85]),
    ]

    best = compute(users)  # 建议在这里下断点：step into compute / property avg
    print("best(avg int) =", best)

    # 递归测试：建议在 fib 内打断点，看调用栈
    n = 6
    print(f"fib({n}) =", fib(n))

    # 线程测试
    t = threading.Thread(target=worker, args=("A", 5), daemon=True)
    t.start()

    # 异常测试（捕获）
    try:
        x = risky_divide(10, 2)
        print("10/2 =", x)
        # 你可以在调试器里把下一行的 b 改成 0，触发异常
        y = risky_divide(10, 0)  # 在这里下断点，观察异常
        print("10/0 =", y)
    except ZeroDivisionError as e:
        print("caught ZeroDivisionError:", e)

    # asyncio 测试
    async def run_async() -> None:
        r1, r2 = await asyncio.gather(async_worker("X"), async_worker("Y"))
        print("async results:", r1, r2)

    asyncio.run(run_async())

    # 等线程结束一会儿（给你时间在 worker 里调试）
    t.join(timeout=2.0)

    # 未捕获异常（可选）：设置环境变量 CRASH=1 会在末尾故意崩溃
    if os.getenv("CRASH") == "1":
        raise RuntimeError("CRASH=1: 故意抛出未捕获异常，测试调试器异常定位")

    print("=== debug_test end ===")


if __name__ == "__main__":
    main()
