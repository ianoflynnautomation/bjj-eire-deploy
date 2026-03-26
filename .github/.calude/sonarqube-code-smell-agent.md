# SonarQube Code Smell Fix — LLM Prompt Guide

> **Purpose:** A structured, LLM-optimised prompt template for resolving SonarQube code smells in Java and Cucumber (BDD) projects.
> **Priority Order:** Critical → Major → Minor

---

## How to Use This Prompt

Copy the **Master Prompt** below, paste your SonarQube findings into the designated section, and submit to your LLM. Follow the formatting rules for best results.

---

## Master LLM Prompt

```
You are a senior software engineer specialising in Java and Cucumber BDD test automation.
Your task is to fix SonarQube code smells from the findings provided below.

### Instructions

- Fix issues in STRICT priority order: Critical first, then Major, then Minor
- For each fix, output ONLY the corrected code block followed by a bullet-point explanation
- Do NOT rewrite unrelated code — surgical fixes only
- Preserve existing logic, variable names, and method signatures unless they ARE the issue
- Apply SonarQube rule IDs where referenced (e.g. squid:S1192, gherkin:S1)
- If a fix requires a new import, include it
- If a fix changes test behaviour, flag it explicitly with ⚠️ WARNING

### Output Format (repeat per issue)

**[SEVERITY] Rule: <SonarQube Rule ID> — <Short Rule Title>**
**File:** `<FileName.java>` | Line: `<N>`

```java
// Fixed code here
```

**Why this fix:**
- <Bullet point 1: what the smell was>
- <Bullet point 2: why it is a problem>
- <Bullet point 3: what the fix does>
- <Bullet point 4: any trade-offs or caveats>

---

### SonarQube Findings (paste yours below)

<PASTE YOUR SONARQUBE EXPORT OR ISSUE LIST HERE>
```

---

## Critical Issues — Java (Fix First)

Prompt additions to include when Critical Java issues are present:

```
For CRITICAL Java issues, apply the following rules strictly:

- squid:S2068 — Hard-coded credentials: Replace with environment variables or a secrets manager; never log or expose them
- squid:S2755 — XML external entity (XXE): Disable DOCTYPE declarations and external entity resolution on all XML parsers
- squid:S3649 — SQL injection: Use PreparedStatement or parameterised queries; never concatenate user input into SQL
- squid:S4823 — Unsafe deserialization: Validate class types before deserializing; prefer JSON over Java serialization
- squid:S2095 — Resource leaks: Wrap all Closeable resources in try-with-resources blocks
- squid:S1874 — Deprecated API usage: Replace with the recommended modern equivalent; document why if deferral is necessary
```

---

## Critical Issues — Cucumber / Gherkin (Fix First)

Prompt additions to include when Critical Cucumber issues are present:

```
For CRITICAL Cucumber issues, apply the following rules strictly:

- Undefined steps: Every Gherkin step MUST have a matching @Given/@When/@Then definition — add the missing glue code
- Missing step definitions cause test suite failures — treat as blocker
- Ambiguous step definitions: Consolidate or rename to ensure a 1-to-1 step-to-definition mapping
- Scenario without assertions: Every Scenario must end with at least one Then step containing a verification
```

---

## Major Issues — Java (Fix Second)

Prompt additions to include when Major Java issues are present:

```
For MAJOR Java issues, apply the following rules:

- squid:S1192 — Duplicated string literals: Extract repeated strings (≥3 occurrences) into a named constant (static final)
- squid:S1172 — Unused method parameters: Remove the parameter or justify its existence with a comment if part of an interface contract
- squid:S1135 — TODO/FIXME comments: Resolve the outstanding work; if deferred, link to a tracked issue ID
- squid:S00112 — Generic exceptions thrown: Replace RuntimeException/Exception with a specific, descriptive custom or standard exception
- squid:S1066 — Collapsible if statements: Merge nested if conditions using && to reduce nesting depth
- squid:S1854 — Dead assignments: Remove variables assigned but never read; this signals logic errors or dead code
- squid:S2259 — Null pointer dereference: Add null checks, use Optional<T>, or annotate with @NonNull/@Nullable
- squid:S3776 — Cognitive complexity too high: Extract sub-logic into private methods; target complexity ≤ 15 per method
```

---

## Major Issues — Cucumber / Gherkin (Fix Second)

Prompt additions to include when Major Cucumber issues are present:

```
For MAJOR Cucumber issues, apply the following rules:

- gherkin:S1 — Scenario too long (>10 steps): Split into smaller, focused scenarios; each should test one behaviour
- Background overuse: Move only truly shared setup into Background; scenario-specific setup belongs in the scenario itself
- Hardcoded test data in steps: Extract into Examples tables (Scenario Outline) or external data files
- Missing tags: Every Feature and Scenario must have at least one tag (e.g. @smoke, @regression, @critical)
- Imperative step language: Rewrite "click button X" style steps to declarative "the user submits the form" style
- Conjunctive steps (And/But overuse): Ensure And/But steps are only used where the conjunction is semantically meaningful
```

---

## Minor Issues — Java & Cucumber (Fix Last)

Prompt additions to include when Minor issues are present:

```
For MINOR issues, apply the following rules (do not prioritise over Critical/Major):

Java:
- squid:S1220 — Default package: Move all classes into a named package
- squid:S100  — Method naming: Rename to camelCase following Java conventions
- squid:S1481 — Unused local variables: Remove unless required by a catch block (rename to _ if Java 21+)
- squid:S106  — Standard output usage: Replace System.out.println with a proper logger (SLF4J/Logback)

Cucumber:
- Scenario titles not descriptive: Rename to clearly describe the business behaviour being tested
- Feature file not matching class name: Align .feature file names with the domain concept they test
- Duplicate scenario names within a feature: Rename for uniqueness to avoid reporting confusion
```

---

## Full Prompt Assembly Checklist

When preparing your prompt to the LLM, include:

- [ ] Paste the **Master LLM Prompt** at the top
- [ ] Add the **Critical Java** block if any Critical Java issues exist
- [ ] Add the **Critical Cucumber** block if any Critical Cucumber issues exist
- [ ] Add the **Major Java** block if any Major Java issues exist
- [ ] Add the **Major Cucumber** block if any Major Cucumber issues exist
- [ ] Add the **Minor** block only after all Critical and Major issues are resolved
- [ ] Paste your raw SonarQube findings at the bottom of the prompt
- [ ] Specify your Java version (e.g. Java 17, Java 21) for version-appropriate fixes
- [ ] Specify your Cucumber/JUnit version if relevant (e.g. Cucumber 7, JUnit 5)

---

## LLM Prompt Best Practices Applied

- **Role assignment** — LLM is set as a senior engineer to anchor tone and expertise level
- **Strict priority ordering** — Critical before Major before Minor; prevents the LLM from fixating on easy minor wins
- **Surgical fix instruction** — Prevents over-engineering or unintended rewrites of unrelated code
- **Structured output format** — Enforces consistent, reviewable output per issue
- **Bullet-point explanations** — Each fix includes what, why, and trade-offs for traceability
- **Rule ID anchoring** — Grounds the LLM to specific SonarQube rules, reducing hallucination
- **Warning flag for behaviour changes** — Explicit ⚠️ signals protect test integrity
- **Version context** — Requesting Java/Cucumber version ensures syntactically valid suggestions

---
