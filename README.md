# Web Security & Pre-Sales Solution Lab

![Status](https://img.shields.io/badge/Status-In--Progress-orange)
![Focus](https://img.shields.io/badge/Focus-Cybersecurity%20%7C%20Pre--Sales-blue)
![Platform](https://img.shields.io/badge/Platform-DVWA-red)
![License](https://img.shields.io/badge/License-Educational-green)

A hands-on **web security attack & defense** training repository with a **pre-sales solution** perspective. By exploiting real vulnerabilities in DVWA, each module translates low-level injection techniques into deliverable business security proposals.

---

## Project Structure

```
Web-Security-PreSales-Lab/
│
├── SQL-Injection/                         # SQL Injection Lab
│   ├── README.md                          # Module overview & pre-sales summary
│   ├── DVWA-SQL-Injection.pdf             # Full penetration testing report
│   └── payloads.sql                       # Payload reference handbook
│
├── XSS/                                   # Cross-Site Scripting Lab
│   ├── README.md                          # XSS overview & navigation
│   ├── Reflect-XSS/                       # Reflected XSS module
│   │   ├── README.md                      # Technical walkthrough (Low/Med/High)
│   │   └── DVWA Reflected XSS ...pdf      # Penetration testing report
│   ├── STORE-XSS/                         # Stored XSS module
│   │   ├── README.md                      # Technical walkthrough (Low/Med/High)
│   │   └── DVWA Stored XSS ...pdf         # Penetration testing report
│   └── DOM-XSS/                           # DOM Based XSS module
│       ├── README.md                      # Technical walkthrough (Low/Med/High)
│       └── DVWA DOM Based XSS ...pdf      # Penetration testing report
│
├── CSRF/                                  # Cross-Site Request Forgery Lab
│   └── README.md                          # Defense strategies & experiments
│
├── Case-Study/                            # Industry Case Studies (Pre-Sales)
│   └── README.md                          # Business scenario analysis
│
└── README.md                              # ← You are here
```

---

## Module Roadmap

Each module covers: **source code audit** | **payload exploitation** | **business impact analysis** | **pre-sales remediation advice**

### 1. [SQL Injection](./SQL-Injection/)

> **Status: Completed**

- Numeric & string-based injection, Hex encoding bypass, Collation conflict resolution
- Deliverables: Full penetration testing report (PDF), payload script library

### 2. [XSS (Cross-Site Scripting)](./XSS/)

> **Status: Completed**

Three sub-modules covering the full XSS attack surface:

| Sub-Module | Key Technique | Bypass Highlights |
|-----------|--------------|-------------------|
| [Reflected XSS](./XSS/Reflect-XSS/) | URL parameter injection | Case manipulation, nested tags, alternative event handlers |
| [Stored XSS](./XSS/STORE-XSS/) | Persistent payload in DB | `maxlength` bypass, field-level defense gap ("barrel effect") |
| [DOM Based XSS](./XSS/DOM-XSS/) | Client-side DOM manipulation | `</select>` tag closure, `#` fragment bypass (invisible to server) |

**Pre-Sales Perspective:**
- How to explain CSP (Content Security Policy) and output encoding to non-technical stakeholders
- Why WAF alone cannot defend against DOM XSS
- Business risk quantification: cookie theft → account takeover → data breach

### 3. [CSRF (Cross-Site Request Forgery)](./CSRF/)

> **Status: Planned**

- Exploiting authenticated sessions to perform unauthorized actions
- Business scenarios: unauthorized fund transfers, admin configuration changes
- Pre-Sales focus: Token mechanisms and `SameSite` cookie attribute

### 4. [Case Study (Industry Scenarios)](./Case-Study/)

> **Status: In Progress**

- Mapping lab techniques to real-world business environments (e-commerce, OA systems, etc.)
- Practice articulating security risks to non-technical clients and decision-makers

---

## Vulnerability Coverage Matrix

| Vulnerability | DVWA Low | DVWA Medium | DVWA High | Report | Pre-Sales Analysis |
|:---:|:---:|:---:|:---:|:---:|:---:|
| SQL Injection | Done | Done | Done | PDF | Included |
| Reflected XSS | Done | Done | Done | PDF | Included |
| Stored XSS | Done | Done | Done | PDF | Included |
| DOM Based XSS | Done | Done | Done | PDF | Included |
| CSRF | - | - | - | - | Planned |

---

## Toolbox

| Category | Tool | Purpose |
|----------|------|---------|
| Target Platform | [DVWA](https://github.com/digininja/DVWA) | Deliberately vulnerable web application |
| Web Environment | phpStudy (WAMP) | PHP + MySQL + Apache runtime |
| Proxy & Intercept | Burp Suite | HTTP traffic interception & request tampering |
| Browser | Chrome / Firefox DevTools (F12) | DOM inspection, `maxlength` bypass, network analysis |
| Documentation | Markdown + PDF | Professional report formatting |

---

## Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/Gothbo/Web-Security-PreSales-Lab.git

# 2. Set up DVWA on your local environment (phpStudy recommended)

# 3. Pick a module and start training
#    Recommended order: SQL Injection → XSS → CSRF
```

**Suggested Learning Path:**

```
SQL Injection (foundation — understand server-side injection)
      ↓
Reflected XSS (URL-based script injection)
      ↓
Stored XSS (persistent attacks, field-level defense gaps)
      ↓
DOM Based XSS (client-side attacks, # fragment bypass)
      ↓
CSRF (session-based attacks)
      ↓
Case Study (translate techniques into business proposals)
```

---

## Disclaimer

All content in this repository is for **authorized security training and educational purposes only**. All tests were conducted on local DVWA instances. Do not use these techniques against any system without explicit written authorization. Unauthorized access to computer systems is illegal.

---

## References

- [DVWA Official Repository](https://github.com/digininja/DVWA)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)
- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [CWE-79: XSS](https://cwe.mitre.org/data/definitions/79.html)
- [CWE-89: SQL Injection](https://cwe.mitre.org/data/definitions/89.html)
