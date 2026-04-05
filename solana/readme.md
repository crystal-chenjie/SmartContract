### anchor new "Project name"

anchor 是 solana 项目的框架

使用anchor可框架可减少很多面对rust 复杂的语法


与Foundry初始化项目不同，创建Solana项目需要先根据你想用的语言和框架选择入口。主要有三条路径：

按照2024的训练营的代码来熟悉
https://github.com/solana-developers/developer-bootcamp-2024


### 🦀 路径一：使用 Anchor 框架 (Rust)

这是目前最主流、最高效的Solana智能合约开发方式。Anchor提供了类似Foundry/Hardhat的体验，集成了项目模板、测试框架和部署工具。

**1. 安装依赖**

在开始前，需要先安装 Rust 和 Solana 工具链。

```bash
# 安装 Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 安装 Solana CLI
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"

# 安装 Anchor CLI
cargo install --git https://github.com/coral-xyz/anchor anchor-cli --locked
```

**2. 创建项目**
打开终端，执行以下命令：

```bash
# 创建一个名为 my-anchor-project 的新项目
anchor init my-anchor-project

# 进入项目目录
cd my-anchor-project

# 构建项目，验证环境
anchor build
```

这个命令会生成一个标准的Anchor项目结构：
*   `programs/`: 存放Rust智能合约代码。
*   `tests/`: 存放TypeScript测试文件。
*   `app/` (可选): 存放前端代码。
*   `migrations/`: 部署脚本。
*   `Anchor.toml`: 项目配置文件。

**3. 编写合约**

在 `programs/my-anchor-project/src/lib.rs` 中，已经生成了一个简单的计数器合约示例。

```rust
use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod my_anchor_project {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Hello World from Anchor!");
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
```

**4. 测试与部署**

*   **测试**：在终端运行 `anchor test`。它会自动启动一个本地验证器，编译合约，并运行在 `tests/` 目录下的测试脚本。
*   **部署**：可以部署到本地网络 (`anchor deploy --provider.cluster localnet`) 或开发网 (`anchor deploy --provider.cluster devnet`)。


### 🚀 额外选择：快速创建前端 dApp

如果你的目标不仅是链上合约，还包括一个完整的去中心化应用（dApp），可以使用社区脚手架工具 `create-solana-pwa`，它能快速生成一个集成了钱包适配器和 PWA（渐进式Web应用）功能的 Next.js 项目。

```bash
# 使用 npm 创建新项目
npx create-solana-pwa my-solana-dapp
cd my-solana-dapp

# 启动开发服务器
npm run dev
```

无论选择哪种方式，建议先通过 **Solana Playground** ([beta.solpg.io](https://beta.solpg.io)) 这个在线IDE快速体验，无需在本地安装任何环境即可完成编写、部署和测试。



好，我们采用 Anchor 框架来完整地走一遍创建 Solana 项目的流程。

Anchor 是 Solana 官方推荐的开发框架，能极大地简化开发工作，它可以像 **Foundry** 一样让你专注于合约逻辑，而不用处理大量底层模板代码。

下面我们分为 **环境准备、项目创建、编写代码、测试运行** 四个步骤。

---

### ⚙️ 第一步：环境准备

在创建项目之前，需要先安装 Rust、Solana 和 Anchor 这三个必备工具。

**1. 安装 Rust**

打开终端，执行以下命令，并根据提示选择 `1` 进行默认安装：
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**2. 安装 Solana CLI**

使用 Solana 官方推荐的安装工具：
```bash
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"
```
安装完成后，刷新环境变量并验证版本：
```bash
solana --version
```

**3. 安装 Anchor CLI**

推荐使用 Anchor Version Manager (AVM) 进行安装，这是官方推荐的安装方式：
```bash
# 安装 AVM
cargo install --git https://github.com/coral-xyz/anchor avm --locked --force

# 安装最新版本的 Anchor CLI
avm install latest

# 使用刚刚安装的版本
avm use latest
```
验证安装：
```bash
anchor --version
```

> **💡 提示**：如果遇到权限或依赖问题，请查阅 [Anchor 官方安装文档](https://www.anchor-lang.com/docs/installation) 获取针对你操作系统的详细说明。

---

### 🚀 第二步：创建并运行一个 Counter 项目

环境就绪后，我们来创建一个计数器项目，这也是学习 Anchor 的 "Hello World"。

**1. 初始化项目**

在你想存放项目的目录下执行：
```bash
anchor init counter_project
cd counter_project
```
这个命令会为你生成一个完整的项目脚手架，其中 `programs/` 目录存放合约代码，`tests/` 目录存放测试代码。

**2. 编写合约代码**

打开 `programs/counter_project/src/lib.rs`，用以下代码替换原有内容。这是一个标准的计数器程序，包含初始化 (`initialize`) 和递增 (`increment`) 两个功能：

```rust
use anchor_lang::prelude::*;

// 声明你的程序ID (在初次构建后会被自动替换)
declare_id!("11111111111111111111111111111111");

#[program]
pub mod counter_project {
    use super::*;

    // 初始化计数器，将其值设为0
    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        let counter = &mut ctx.accounts.counter;
        counter.count = 0;
        msg!("计数器已初始化，当前值为：{}", counter.count);
        Ok(())
    }

    // 递增计数器，使其值加1
    pub fn increment(ctx: Context<Increment>) -> Result<()> {
        let counter = &mut ctx.accounts.counter;
        counter.count += 1;
        msg!("计数器已递增，当前值为：{}", counter.count);
        Ok(())
    }
}

// 'initialize' 函数所需的账户集合
#[derive(Accounts)]
pub struct Initialize<'info> {
    // 1. 初始化一个名为 'counter' 的新账户，存储 Counter 结构体
    // 2. 由 'user' 支付创建账户的费用
    // 3. 为账户分配 8(Anchor 内部使用) + 8(u64 大小) 字节的空间
    #[account(init, payer = user, space = 8 + 8)]
    pub counter: Account<'info, Counter>,
    // 交易签名者（即用户），需要是可变状态以支付租金
    #[account(mut)]
    pub user: Signer<'info>,
    // Solana 系统程序，负责创建新账户
    pub system_program: Program<'info, System>,
}

// 'increment' 函数所需的账户集合
#[derive(Accounts)]
pub struct Increment<'info> {
    // 已有的计数器账户，需要是可变状态以便修改其内部的 'count' 字段
    #[account(mut)]
    pub counter: Account<'info, Counter>,
}

// 定义 Counter 账户的数据结构
#[account]
pub struct Counter {
    pub count: u64, // 存储一个 64 位的整数
}
```

**3. 构建并测试**

现在，让我们见证奇迹的时刻。在项目根目录下运行：
```bash
anchor test
```

当这个命令执行时，Anchor 会在后台做一系列事情：
1.  **启动一个本地 Solana 测试节点**。
2.  **编译你的合约代码**，并自动更新 `lib.rs` 开头的 `declare_id!` 为你生成的正式程序ID。
3.  **将合约部署到本地节点**。
4.  **运行 `tests/` 目录下的测试文件**，与你的新合约进行交互。

如果一切顺利，你将看到类似下面的输出，表示测试通过，你的第一个 Solana 程序就成功运行了！

```text
    Finished test [unoptimized + debuginfo] target(s)
     Running tests/counter_project.ts

  counter_project
    ✔ Initialize Counter (225ms)
    ✔ Increment Counter (405ms)


✨  Done in 2.34s.
```

---

### 💡 项目与合约结构解析

为了更好地理解你刚刚做了什么，我们来拆解一下 Counter 示例中的关键概念：

1.  **`#[program]` 模块**：这里定义了你的智能合约的所有公开接口（即指令，Instructions）。`initialize` 和 `increment` 都是可以被客户端调用的函数。

2.  **`#[derive(Accounts)]` 结构体**：这是 Anchor 的核心优势之一。你在这里声明一个函数需要操作哪些账户以及它们需要满足什么条件（如是否可写 `mut`、是否是新创建的 `init`）。Anchor 会自动为你生成所有繁琐的账户安全验证代码。
    *   `Initialize` 结构体告诉 Anchor，调用 `initialize` 函数需要传入一个将要创建的计数器账户 (`counter`)、一个支付费用的用户 (`user`) 和系统程序 (`system_program`)。
    *   `Increment` 结构体则简单得多，只需要一个可写的计数器账户。

3.  **`#[account]` 结构体**：这定义了你的账户的数据结构。在 Solana 中，账户是数据的存储地。这里的 `Counter` 结构体告诉 Anchor，`counter` 这个账户里只存储一个 `u64` 类型的数字。

4.  **`Context<T>`**：这是 Anchor 的"上下文"类型。你的函数通过它来获取传入的账户 (`ctx.accounts`)、调用者的签名信息等。

---

### 🎯 总结与下一步

恭喜！你已经成功地使用 Anchor 创建、构建并测试了你的第一个 Solana 程序。这整个过程与使用 Foundry 在以太坊上开发的感觉非常相似。

**接下来，你可以：**

*   **探索前端交互**：Anchor 会自动生成 IDL（接口描述文件），你可以像使用 Ethers.js 调用以太坊合约一样，在前端轻松调用你的 Solana 程序。
*   **深入学习**：你可以从计数器程序开始，学习添加更复杂的功能，比如权限控制 (`has_one`)、跨程序调用 (CPI)，或者在 Anchor 框架内使用 Solidity 编写合约 (`anchor init my-project --solidity`)。
*   **部署到开发网 (Devnet)**：修改 `Anchor.toml` 文件中的 `cluster = "devnet"`，然后用 `solana airdrop 2` 获取一些测试用的 SOL，最后运行 `anchor deploy` 即可将你的程序部署到公开的测试网络。

如果你对某个步骤，比如如何编写前端交互代码，或者如何为这个计数器程序添加更复杂的逻辑有疑问，随时可以继续问我。