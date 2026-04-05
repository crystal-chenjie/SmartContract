### foundry 

foundry 可用来创建 solidity 项目

foundry 是一个rust写的框架

solidity 中文文档
https://learnblockchain.cn/docs/solidity/

foundry 中文文档
https://learnblockchain.cn/docs/foundry/i18n/zh/getting-started/installation.html


forge init “项目名”
forge init --empty "项目名"

# 创建 Foundry 项目但不初始化 Git
forge init --no-git --empty <project-name>


目录/文件	作用说明
src/	这是你所有智能合约的“家”，我们写的 *.sol 文件都放在这里。
test/	用于存放测试合约，测试文件通常以 .t.sol 结尾。
script/	用于存放部署脚本（通常以 .s.sol 结尾）或与其他合约交互的脚本。
lib/	依赖库文件夹，通过 forge install 安装的库（如 OpenZeppelin）会放在这里。
foundry.toml	项目的核心配置文件，你可以在这里设置 Solidity 编译器版本、优化器等参数。


forge build
forge test

anvil 部署


在项目根目录创建 remappings.txt，添加以下内容
@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/

在 foundry.toml 中添加 remappings 配置
[profile.default]
src = "src"
out = "out"
libs = ["lib"]
remappings = [
    "@openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/",
]


常用 OpenZeppelin 组件
类别	    常用合约	                    导入路径
代币标准	ERC20, ERC721, ERC1155	    @openzeppelin/contracts/token/
权限控制	Ownable, AccessControl	    @openzeppelin/contracts/access/
工具类	  ReentrancyGuard, Pausable	    @openzeppelin/contracts/utils/








安装成功后，你可以在 Solidity 合约中这样导入和使用：

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(address initialOwner)
        ERC20("MyToken", "MTK")
        Ownable(initialOwner)
    {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}
forge build
如果编译成功，说明 OpenZeppelin 已正确安装并可正常使用