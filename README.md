# DVWA SQL Injection Analysis & Practice

这是一个基于 **DVWA** (Damn Vulnerable Web Application) 的 SQL 注入实战项目。本项目深入分析了从简单到高难度的 SQL 注入绕过技巧，并提供了详细的源码审计报告。

## 🌟 技术亮点 (Key Highlights)
- **底层原理分析**：不仅是 Payload，还分析了 `Collation Conflict` (字符序冲突) 产生的根本原因。
- **实战绕过**：演示了如何绕过 `mysqli_real_escape_string` 过滤函数。
- **全等级覆盖**：涵盖了数字型注入（Numeric）与字符串型注入（String）。

## 🛠 实验环境
- **工具**: phpStudy, Burp Suite, Browser DevTools
- **数据库**: MySQL 5.7.26
- **核心逻辑**: 利用十六进制编码 (Hex) 与指定字符集 (Collation) 解决注入报错。

## 📂 文件说明
- `SQL_Injection_Practice_based_on_DVWA.pdf`: 完整图文实验报告。
- `remediation.md`: 针对不同等级的修复建议与预处理语句示例。
