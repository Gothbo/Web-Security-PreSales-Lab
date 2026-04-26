# 🧩 SQL Injection (SQL 注入) 专项实验室

本模块记录了针对 **DVWA** 环境中 SQL 注入漏洞的完整攻防演练。通过对不同安全等级的源码审计，验证了从基础注入到高级绕过（如编码绕过、字符序冲突解决）的技术可行性。

---

## 📂 模块产出 (Deliverables)

- 📄 [**核心实战报告 (PDF)**](./DVWA-SQL-Injection.pdf) : 包含详尽的源码分析、攻击步骤截图及售前防御方案。
- 🔑 [**Payload 手册 (SQL)**](./payloads.sql) : 结构化整理的实战注入语句，含详细的排障注释。

---

## 🚀 技术要点总结 (Technical Summaries)

### 1. 注入点类型分析
* **String-based (字符串型)**: 需要考虑单引号 `'` 闭合及注释符 `#` 的使用。
* **Numeric-based (数字型)**: 往往出现在 `Medium` 等级，无需引号闭合，但需配合抓包（HackBar/Burp）或修改前端 DOM 提交。

### 2. 高级绕过技巧
* **Hex 编码绕过**: 针对 `mysqli_real_escape_string()` 对引号的过滤，利用十六进制（如 `0x7573657273`）绕过字符串检测。
* **Collation 冲突处理**: 实战中遇到 `Illegal mix of collations` 报错，通过显式声明 `COLLATE utf8_general_ci` 成功统一字符序。

---

## 💼 售前视角：业务价值 (Business Perspective)

> [!NOTE]
> **风险定义**：SQL 注入是 Web 应用的“致命伤”，攻击者可借此绕过身份验证、窃取核心数据库甚至获取服务器控制权。

### 典型案例：大学生就业管理系统
* **风险点**：若简历搜索或管理员登录接口存在注入，学生个人隐私（手机号、学籍信息）面临大规模泄露。
* **商业影响**：一旦发生脱库（Data Dump），平台将面临公信力丧失、企业用户流失以及《个人信息保护法》相关的合规处罚。

### 推荐防御方案：
1. **代码层面**：强制推行 **PDO 预处理 (Prepared Statements)**。
2. **产品层面**：部署 **WAF (Web 应用防火墙)** 实现恶意流量的实时清洗。

---

## 🛠️ 实验环境
- **靶场**: DVWA v1.10
- **环境**: phpStudy (Apache 2.4 + MySQL 5.7)
- **工具**: HackBar / Burp Suite / Browser DevTools
