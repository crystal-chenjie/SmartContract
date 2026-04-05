# Sui Move

 - 在新加坡是个优势


好的，我们采用 Sui 官方推荐的 Move 语言来创建项目。

与 Foundry 和 Anchor 类似，Sui 提供了完整的 CLI 工具来管理项目的整个生命周期：**创建 → 构建 → 测试 → 部署**。

---

### ⚙️ 第一步：环境准备

在创建项目之前，需要先安装 Sui CLI。打开终端，执行以下命令：

```bash
# 安装 Sui CLI（使用官方安装脚本）
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install --locked --git https://github.com/MystenLabs/sui.git sui

# 验证安装
sui --version
```

> **💡 提示**：如果安装遇到问题，可以查阅 [Sui 官方安装文档](https://docs.sui.io/guides/developer/getting-started/sui-install) 获取针对你操作系统的详细说明。

---

### 🚀 第二步：创建并运行一个 Counter 项目

环境就绪后，我们来创建一个计数器项目，这也是学习 Sui Move 的 "Hello World"。

**1. 初始化项目**

在你想存放项目的目录下执行：

```bash
# 创建一个名为 counter 的新 Move 项目
sui move new counter

# 进入项目目录
cd counter
```

这个命令会生成一个标准的 Sui Move 项目结构：

```
counter/
├── Move.toml      # 项目配置文件（包名、版本、依赖、地址映射）
├── sources/       # 存放 Move 源文件（.move）
│   └── counter.move
└── tests/         # 存放测试文件
    └── counter_tests.move
```

**2. 编写合约代码**

打开 `sources/counter.move`，用以下代码替换原有内容：

```rust
module counter::counter {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Counter 对象：存储一个计数值
    public struct Counter has key, store {
        id: UID,
        value: u64,
    }

    /// 创建一个新的 Counter 对象并转移给调用者
    public entry fun create(ctx: &mut TxContext) {
        let counter = Counter {
            id: object::new(ctx),
            value: 0,
        };
        transfer::transfer(counter, tx_context::sender(ctx));
    }

    /// 递增计数器的值
    public entry fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1;
    }

    /// 获取计数器的当前值（只读）
    public fun value(counter: &Counter): u64 {
        counter.value
    }
}
```

**3. 构建项目**

在项目根目录下运行：

```bash
sui move build
```

成功构建会返回类似以下的输出：


```text
UPDATING GIT DEPENDENCY https://github.com/MystenLabs/sui.git
INCLUDING DEPENDENCY Sui
INCLUDING DEPENDENCY MoveStdlib
BUILDING counter
```

**4. 编写并运行测试**

创建 `tests/counter_tests.move` 文件，添加以下测试代码：

```rust
#[test_only]
module counter::counter_tests {
    use sui::test_scenario;
    use counter::counter::{Self, Counter};

    #[test]
    fun test_counter_increment() {
        // 创建测试场景，模拟 admin 用户
        let admin = @0xADMIN;
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;

        // 第一笔交易：创建 Counter
        {
            counter::create(test_scenario::ctx(scenario));
        };

        // 第二笔交易：调用 increment
        test_scenario::next_tx(scenario, admin);
        {
            let counter = test_scenario::take_from_sender<Counter>(scenario);
            counter::increment(&mut counter);
            assert!(counter::value(&counter) == 1, 0);
            test_scenario::return_to_sender(scenario, counter);
        };

        test_scenario::end(scenario_val);
    }
}
```

运行测试：

```bash
sui move test
```

如果一切顺利，你将看到类似下面的输出：

```text
BUILDING counter
Running Move unit tests
[ PASS    ] 0x0::counter_tests::test_counter_increment
Test result: OK. Total tests: 1; passed: 1; failed: 0
```

---

### 📂 项目结构解析

| 目录/文件 | 作用说明 |
| :--- | :--- |
| `Move.toml` | 项目的配置文件，定义了包名、版本、依赖项和地址映射 |
| `sources/` | 存放 Move 源文件（`.move` 扩展名），每个文件通常定义一个模块 |
| `tests/` | 存放测试文件，以 `#[test]` 注解标记测试函数，只在测试模式下编译 |

**Move.toml 示例**：

```toml
[package]
name = "counter"
version = "0.0.1"
edition = "2024.beta"

[dependencies]
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }

[addresses]
counter = "0x0"
```

---

### 🔑 Sui Move 核心概念速览

与 Solidity 和 Rust 不同，Sui Move 有几个独特的概念需要了解：

| 概念 | 说明 |
| :--- | :--- |
| **对象（Object）** | Sui 的基本存储单元。结构体需要 `has key` 能力，并以 `id: UID` 作为第一个字段 |
| **所有权** | 对象可以由地址拥有、由另一个对象拥有（动态字段）、共享（任何人可读/写）或不可变 |
| **`entry` 函数** | 可由交易直接调用的入口函数 |
| **`init` 函数** | 模块发布时自动执行一次的特殊函数，常用于初始化 |
| **一次性见证（OTW）** | 确保某个类型只能被实例化一次的设计模式，常用于代币发行 |

---

### 🚢 下一步：部署到测试网

**1. 配置 Sui 客户端**

```bash
# 设置测试网环境
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet

# 创建或导入钱包地址
sui client addresses
```

**2. 领取测试代币（水龙头）**

```bash
# 在 Sui 测试网上领取测试 SUI
sui client faucet
```

**3. 部署合约**

```bash
sui client publish --gas-budget 10000000
```

部署成功后，你会看到一个 **Package ID**，这就是你合约的唯一标识符，之后可以通过它来调用合约函数。

---

### 📚 常用 CLI 命令速查

| 命令 | 作用 |
| :--- | :--- |
| `sui move new <name>` | 创建新项目 |
| `sui move build` | 构建项目 |
| `sui move test` | 运行测试 |
| `sui move test --coverage` | 生成测试覆盖率报告 |
| `sui client publish` | 部署合约 |
| `sui client call` | 调用合约函数 |

---

### 💡 与之前经验的对比

| 维度 | **Foundry (Solidity)** | **Anchor (Solana)** | **Sui Move** |
| :--- | :--- | :--- | :--- |
| 项目创建 | `forge init` | `anchor init` | `sui move new` |
| 构建命令 | `forge build` | `anchor build` | `sui move build` |
| 测试命令 | `forge test` | `anchor test` | `sui move test` |
| 部署命令 | `forge create` | `anchor deploy` | `sui client publish` |
| 核心数据模型 | 账户（Account） | 账户（Account） | 对象（Object） |

恭喜！你已经成功地使用 Sui Move 创建、构建并测试了你的第一个智能合约。如果你对某个步骤有疑问，或者想进一步了解如何开发 NFT、代币等项目，随时可以继续问我。