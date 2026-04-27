# XSS (Cross-Site Scripting) Training Lab

> DVWA-based full-spectrum XSS attack & defense training, covering Reflected / Stored / DOM Based XSS across Low, Medium, and High security levels.

---

## Module Structure

```
XSS/
├── README.md                          ← You are here
├── Reflect-XSS/
│   ├── README.md                      ← Reflected XSS technical walkthrough
│   └── DVWA Reflected XSS 渗透测试训练报告.pdf
├── STORE-XSS/
│   ├── README.md                      ← Stored XSS technical walkthrough
│   └── DVWA Stored XSS 渗透测试训练报告.pdf
└── DOM-XSS/
    ├── README.md                      ← DOM Based XSS technical walkthrough
    └── DVWA DOM Based XSS 渗透测试训练报告.pdf
```

| Module | Focus | Link |
|--------|-------|------|
| **Reflected XSS** | URL parameter injection, instant execution, social engineering | [Enter Module](./Reflect-XSS/) |
| **Stored XSS** | Persistent payload in database, affects all visitors | [Enter Module](./STORE-XSS/) |
| **DOM Based XSS** | Pure frontend vulnerability, invisible to server & WAF | [Enter Module](./DOM-XSS/) |

Each module contains:
- **README.md** — Source code analysis, bypass techniques, payloads, and fix for each DVWA level
- **PDF Report** — Professional penetration testing report with business risk analysis

---

## What is XSS?

Cross-Site Scripting (XSS) is a code injection attack where an attacker injects malicious scripts into web pages viewed by other users. When a victim's browser renders the page, the script executes with the victim's session privileges — enabling cookie theft, session hijacking, page defacement, and phishing.

XSS consistently ranks in the **OWASP Top 10** and remains one of the most prevalent web vulnerabilities worldwide.

---

## Three Types at a Glance

### Reflected XSS

```
Attacker → Crafts malicious URL → Victim clicks → Server reflects payload → Browser executes
```

The payload travels through a URL parameter, hits the server, and is reflected back into the HTML response without sanitization. Requires the victim to click a crafted link.

### Stored XSS

```
Attacker → Submits payload via form → Stored in database → ANY visitor loads the page → Browser executes
```

The payload is permanently stored on the server (database, comment field, etc.). Every user who visits the affected page is automatically attacked — no malicious link needed.

### DOM Based XSS

```
Attacker → Crafts malicious URL → Victim clicks → JavaScript reads URL → Writes payload into DOM → Browser executes
```

The payload never reaches the server. Client-side JavaScript reads from an untrusted source (URL, hash fragment) and writes directly into the DOM. Server logs and WAF see nothing.

---

## Comparison Matrix

| | Reflected | Stored | DOM Based |
|---|---|---|---|
| **Payload location** | Server HTTP response | Database | Browser DOM |
| **Passes through server** | Yes | Yes | **No** |
| **Persistence** | One-time (URL) | Permanent (DB) | One-time (URL/Fragment) |
| **Trigger** | Victim clicks link | Victim visits page | Victim clicks link |
| **Impact scope** | Single user | **All visitors** | Single user |
| **WAF detectable** | Yes | Yes | **No** |
| **Server log visible** | Yes | Yes | **No** (especially `#` fragments) |
| **Stealth level** | Medium | Low | **High** |
| **Severity** | High | **Critical** | High-Critical |
| **DVWA Module** | [Reflect-XSS](./Reflect-XSS/) | [STORE-XSS](./STORE-XSS/) | [DOM-XSS](./DOM-XSS/) |

---

## Key Bypass Techniques Covered

| Technique | Used In | Description |
|-----------|---------|-------------|
| Direct `<script>` injection | All — Low | No defense, payload executes directly |
| Case manipulation (`<ScRiPt>`) | Reflected/Stored — Medium | `str_replace` is case-sensitive |
| Nested/Double-write (`<scr<script>ipt>`) | Reflected/Stored — Medium | Inner tag removed, outer fragments reassemble |
| Alternative tags (`<img>`, `<svg>`) | All — Medium/High | Event handlers bypass `<script>`-only filters |
| Closing parent tags (`</select>`) | DOM — Medium | Required when injection point is inside `<select>` |
| `#` URL fragment bypass | DOM — High | Fragment never sent to server, bypasses server-side whitelist |
| `maxlength` bypass (F12/Burp) | Stored — Medium/High | Frontend restriction, not a security measure |

---

## Defense Overview

All three XSS types share the same fundamental fix: **output encoding**.

### The One Fix That Matters

```php
// Server-side: encode ALL output
$output = htmlspecialchars($input, ENT_QUOTES, 'UTF-8');
```

```javascript
// Client-side: use safe DOM APIs
element.textContent = userInput;  // NOT innerHTML, NOT document.write()
```

### Defense in Depth

| Layer | Measure | Protects Against |
|-------|---------|-----------------|
| **Code** | `htmlspecialchars()` / `textContent` | All XSS types |
| **HTTP** | `Content-Security-Policy: script-src 'self'` | Inline script execution |
| **Cookie** | `HttpOnly` flag | Cookie theft via `document.cookie` |
| **Session** | Anti-CSRF tokens | Cross-site form submission |
| **Database** | Prepared Statements | SQL injection (defense in depth) |
| **Architecture** | Template engines with auto-escaping | Developer oversight |
| **Testing** | Automated XSS scanners + DOM-aware tools | Regression & detection |

---

## Environment Setup

### Prerequisites

| Tool | Purpose |
|------|---------|
| [DVWA](https://github.com/digininja/DVWA) | Vulnerable web application (target) |
| PHP + MySQL (e.g., phpStudy) | DVWA runtime environment |
| Burp Suite | HTTP interception & request modification |
| Browser DevTools (F12) | DOM inspection, `maxlength` bypass, network analysis |

### Quick Start

1. Install and configure DVWA
2. Login with `admin` / `password`
3. Navigate to **DVWA Security** → Set security level
4. Choose an XSS module and follow the corresponding README

### Recommended Training Order

```
1. Reflected XSS (simplest attack model, understand the basics)
       ↓
2. Stored XSS  (persistent attacks, learn field-level defense gaps)
       ↓
3. DOM Based XSS (client-side attacks, understand the # fragment trick)
```

---

## Key Takeaways

1. **Output encoding is the only reliable XSS defense** — blacklist filtering (`str_replace`, `preg_replace`) can always be bypassed
2. **Security must cover ALL fields** — Stored XSS Medium/High secured `message` but forgot `name` (barrel effect)
3. **Frontend code is an attack surface** — DOM XSS proves that server-side defenses alone are insufficient
4. **`#` fragments are invisible to servers** — a critical blind spot for traditional security monitoring
5. **Frontend restrictions are not security** — `maxlength`, client-side validation can be bypassed in seconds

---

## Disclaimer

This repository is for **authorized security training and educational purposes only**. All tests were conducted on local DVWA instances. Do not use these techniques against any system without explicit written authorization. Unauthorized access to computer systems is illegal.

## References

- [DVWA Official Repository](https://github.com/digininja/DVWA)
- [OWASP Top 10 — A03:2021 Injection](https://owasp.org/Top10/A03_2021-Injection/)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)
- [OWASP DOM Based XSS](https://owasp.org/www-community/attacks/DOM_Based_XSS)
- [CWE-79: Improper Neutralization of Input During Web Page Generation](https://cwe.mitre.org/data/definitions/79.html)
