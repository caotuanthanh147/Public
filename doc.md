# Project: Self-Hosted Lua Script Licensing and Protection Platform

---

## READ FIRST: Instructions for AI Assistants

You are one of several AI assistants working in parallel on the same project. Each assistant is assigned ONE module (see "Module Assignments" below). This document is the single source of truth. Follow it exactly so the pieces fit together when merged.

### Your job

1. Read this entire document.
2. Find your assigned module in "Module Assignments".
3. Build only that module, following the "Shared Contracts" so other modules can integrate without changes.
4. Return the deliverables in the "Output Format" below.

### Hard rules

- **Do not guess.** If anything is unclear, missing, or conflicts with the contracts, STOP and list your questions instead of assuming. Never invent endpoints, fields, or formats that are not in this document.
- **Do not change the Shared Contracts.** If you believe a contract is wrong, say so in a "Contract Issues" section and still implement the contract as written.
- **Do not rewrite or duplicate other modules.** Only build interfaces to them as defined by the contracts.
- **Do not hardcode secrets, keys, or URLs.** Use configuration and environment variables.
- **Do not add features that are not in the document** (no extra stats, no extra commands, no extra endpoints).
- **No unnecessary code:** no unused variables, no placeholder stubs presented as finished work, no dead branches.
- **Keep debug output (log/warn) minimal.** Only add it where it helps diagnose real failures, and never log plaintext keys, secrets, or payloads.
- **Write tests** for everything you build (see section 19), and say how to run them.
- **Be honest about limits.** If something cannot be done securely in your environment (for example, pure-Lua crypto speed), state that clearly with numbers if you have them.

### Mandatory research (do this BEFORE writing any code)

Your training data is outdated and often wrong about library APIs, versions, and platform limits. You MUST use web search / browsing tools to research online first. If you have no web access, say so in your first line and list every claim you could not verify.

**Rules**

1. **Search first, code second.** Complete the research tasks for your module (see "Research tasks per module") and produce a Research Log before any code.
2. **Use primary sources.** Official docs, RFCs, specs, source repositories, and release notes beat blog posts and forum answers.
3. **Check versions and dates.** Record the exact version of every library, API, or service you rely on and the date of the doc you read. Prefer current stable releases. Flag anything deprecated.
4. **Verify every API you call.** Function names, parameters, return values, limits, and pricing must come from docs you actually opened. Never write an API call from memory.
5. **Compare options before choosing.** For any library or service choice, list at least 2 to 3 candidates with pros, cons, license, maintenance status (last release, open issues), and pick one with a reason.
6. **Look for existing solutions.** Search GitHub and package registries for open-source implementations of what you are building. Study their design, edge cases, and known bugs. Do not copy code with incompatible licenses; note the license of anything you adapt.
7. **Cross-check important facts.** Anything security-critical (crypto parameters, signature schemes, rate limits, platform behavior) needs two independent sources or the official spec.
8. **Test claims when you can.** If you can run code, run it to confirm behavior instead of trusting docs alone.
9. **Say what you could not find.** If something cannot be verified, list it under "Unverified" and ask for a decision. Do not fill gaps with guesses.
10. **Do not fabricate sources.** Every URL in your Research Log must be one you actually opened. No invented links, versions, or quotes.

**Research Log format (required, placed before the code)**

| Topic | Source URL | Version / date | Key finding | Used for |
|-------|-----------|----------------|-------------|----------|

Then add:

- **Options compared:** table of candidates, license, last release, verdict
- **Prior art found:** relevant open-source projects and what you learned from them
- **Unverified items:** things you could not confirm
- **Decisions made and why:** each linked to a source in the table

### Research tasks per module

| Module | Must research |
|--------|---------------|
| M1 API core | Current Cloudflare Workers limits (CPU time, subrequests, body size), D1 limits and consistency behavior, Durable Objects for atomic counters, current best practice for API key hashing and rate limiting, constant-time comparison in Workers |
| M2 Database | D1 vs Postgres limits and migration tooling, index behavior for the access patterns in section 3, backup and restore options |
| M3 Loader and crypto | RFC 8032 (Ed25519), RFC 7748 (X25519), RFC 8439 (ChaCha20-Poly1305), RFC 5869 (HKDF), RFC 4231 (HMAC-SHA256 vectors), existing pure-Lua/Luau implementations and their speed, Luau `bit32` behavior and number precision limits, which crypto functions common executors expose |
| M4 Obfuscator front end | Current Luau grammar and syntax additions, existing Luau/Lua parsers (license, completeness, maintenance), AST formats, how scope and upvalue analysis is done in the reference Lua compiler |
| M5 Obfuscator back end | Lua 5.1 and Luau bytecode formats and instruction sets, how `luac` and the Luau compiler handle varargs, upvalues, and multiple returns, existing Lua VM-obfuscator designs and published weaknesses, Luau differences from Lua 5.1 (integer division, `continue`, compound ops) |
| M6 VM runtime generator | Fastest known dispatch techniques in pure Lua/Luau, performance cost of closure-per-opcode vs if-chain vs table dispatch, published deobfuscation techniques against Lua VMs and how to counter them |
| M7 Anti-tamper and watermarking | Known detection methods and their false-positive rates, how common executors expose functions like `request`, `loadstring`, `getfenv`, current published research on code watermarking and fingerprinting, leak-tracing designs |
| M8 Discord bot | Current discord.js (or chosen library) version and breaking changes, slash command and permission model, rate limits, interaction timeout rules, current Discord developer policy and ToS limits on bots |
| M9 Free-key flow | Current API/verification docs for each checkpoint provider, how bypass services work and how providers defend against them, token binding approaches, provider ToS limits |
| M10 Payments | Chosen provider's current webhook signature scheme, idempotency handling, refund and chargeback events, fees, and regional restrictions |
| M11 Dashboard | Current stable version of the chosen framework, Discord OAuth flow, session and CSRF handling, TOTP libraries |
| M12 Ops | Current Cloudflare logging/metrics/alerting options, CI deploy patterns for Workers, secret management and rotation options |
| M13 Reviewer | Current OWASP API Security Top 10, known pitfalls of license-key systems, known crypto misuse patterns for the algorithms used |

### Output format

Return, in this order:

0. **Research Log** (required format above). No code before this.
1. **Summary**: what you built and what you did not build.
2. **Assumptions and questions**: anything that needs a decision (reference the Open Decisions D1 to D9 where relevant).
3. **File tree**: the files you are delivering, using the repo layout below.
4. **Code**: each file in its own fenced block with the path above it.
5. **Tests**: test files and exact commands to run them.
6. **Integration notes**: what other modules must provide to you, and what you provide to them.
7. **Contract Issues**: problems found in this document (or "none").

### Repo layout (all modules use this)

```
/
  doc.md
  contracts/            # shared schemas, error codes, test vectors
  api/                  # edge API (TypeScript)
  db/                   # migrations and seed data
  loader/               # Lua loader and crypto primitives
  obfuscator/
    parser/
    compiler/
    vm-template/
    cli/
  bot/                  # Discord bot
  dashboard/            # admin web UI
  tools/                # watermark extractor, build scripts
  tests/                # cross-module and end-to-end tests
```

---

## Shared Contracts (Do Not Change)

### Encoding and types

- Binary data in JSON: **base64url without padding**.
- Timestamps: **Unix seconds, integer**.
- IDs: **lowercase hex strings, 16 bytes** unless stated otherwise.
- Hashes: **SHA-256, hex**.
- All request and response bodies: **JSON, UTF-8**.
- HWID, IP, and user identifiers are always **hashed server-side** before storage.

### Request envelope (loader to API)

```json
{
  "v": 1,
  "ts": 1760000000,
  "nonce": "<base64url, 16 bytes>",
  "sid": "<session id, absent before handshake>",
  "body": "<base64url ciphertext after handshake, plain object during handshake>"
}
```

### Response envelope (API to loader)

```json
{
  "v": 1,
  "ts": 1760000001,
  "ok": true,
  "code": "ok",
  "body": "<base64url ciphertext or plain object during handshake>",
  "sig": "<base64url signature over v|ts|ok|code|body>"
}
```

### Error codes (the only ones the loader may receive)

`ok`, `denied`, `expired`, `blacklisted`, `rate_limited`, `update_required`, `bad_request`, `server_error`

The loader must treat any unknown code as `denied`.

### Validate request body (decrypted)

```json
{
  "key": "<plaintext key>",
  "hwid": "<raw hwid string>",
  "script_id": "<id>",
  "place_id": 0,
  "user_id": 0,
  "loader_version": "1.0.0"
}
```

### Validate response body (decrypted)

```json
{
  "tier": "free|paid|lifetime|reseller",
  "expires_at": 0,
  "discord_id": "<string or null>",
  "note": "<string or null>",
  "session_token": "<base64url>",
  "session_expires_at": 0
}
```

### Payload response body (decrypted by loader)

```json
{
  "build_hash": "<hex>",
  "bundle": "<base64url bytes>",
  "bundle_sig": "<base64url signature over build_hash|bundle>"
}
```

### Key derivation labels (HKDF info strings)

- `"session-key"`: derived from the shared secret and both nonces
- `"payload-key"`: derived from session key, build hash, and watermark id
- `"const-key"`: used inside the VM bundle for constant encryption chains

### Admin API auth

`Authorization: Bearer <admin token>` plus audit entry for every mutating call.

### Bytecode container (obfuscator to loader/VM runtime)

```
magic (4 bytes) | format version (1) | build hash (32) | function count (varint)
| functions[ ... ] | encrypted constant pool | trailer checksum
```

The obfuscator CLI must emit a **manifest JSON** per build:

```json
{ "build_hash": "", "format_version": 1, "opcode_seed": "", "created_at": 0 }
```

---

## Module Assignments

Give each AI exactly one of these. Copy the whole document plus the assignment line.

| ID | Module | Primary sections | Depends on |
|----|--------|------------------|------------|
| M1 | **API core**: validate, keys, sessions, blacklist, rate limits, admin API | 3, 4, 5, 15 | contracts |
| M2 | **Database**: migrations, indexes, seed data, backup notes | 3 | contracts |
| M3 | **Loader and crypto (Lua)**: handshake, SHA-256, HMAC, stream cipher, signature verify, test vectors | 6, 7 | contracts, M1 interface |
| M4 | **Obfuscator front end**: Luau parser, AST, analysis, transforms | 8.1 to 8.2 (items 1, 2, 6) | contracts |
| M5 | **Obfuscator back end**: bytecode compiler, container format, differential test harness | 8.2 (items 3, 4), 8.3 | M4 interface |
| M6 | **VM runtime generator**: template, shuffled dispatch, constant decryption, integrity-linked keys | 8.2 (items 5, 6, 7, 8, 9) | M5 bytecode spec |
| M7 | **Anti-tamper, watermarking, leak tools** | 9, 10 | M3, M6 interfaces |
| M8 | **Discord bot** | 12 | M1 admin API |
| M9 | **Free-key flow** | 11 | M1 |
| M10 | **Payments and webhooks** | 14 | M1 |
| M11 | **Dashboard** | 13 | M1 admin API |
| M12 | **Ops**: logging, metrics, alerts, CI, deployment, runbooks | 16, 19 | all |
| M13 | **Reviewer**: audits other modules against contracts and security rules | all | all |

### Assignment line to append when sending

```
YOUR MODULE: <ID and name from the table>. Build only this module. Follow every rule in "READ FIRST" and every contract in "Shared Contracts".
```

### Suggested parallel waves

- **Wave 1 (start together):** M1, M2, M3, M4
- **Wave 2 (after wave 1 interfaces are agreed):** M5, M8, M9, M10, M11
- **Wave 3:** M6, M7, M12
- **Always last:** M13 reviewer over merged output

---

## Reviewer Prompt (use for M13 and for cross-checking any module)

```
You are a strict reviewer. Compare the submitted code against doc.md.
Check, in order:
1. Does it follow every Shared Contract exactly (field names, encodings, error codes, labels)?
2. Is there any use of goto, hardcoded secret, plaintext key logging, or invented API?
3. Are there unused variables, dead code, or placeholder stubs presented as complete?
4. Are replay protection, timestamp skew, and uniform error responses implemented where required?
5. Are tests present, deterministic, and do they cover failure paths?
6. Security issues: injection, missing auth checks, race conditions (especially HWID binding), timing leaks, unbounded input.
7. Research: is there a Research Log with real, opened sources, versions, and dates? Spot-check at least 3 cited URLs and 3 API calls against current docs. Flag any API usage, version, or limit that is not backed by the log, and any fabricated or dead source.
Return: a numbered list of defects with file, line, severity (blocker/major/minor), and a concrete fix. Do not rewrite the whole module.
```

## Merge and Integration Checklist (for you)

- [ ] All modules use the same envelope, error codes, and encodings.
- [ ] Test vectors in `/contracts` pass in both TypeScript and Lua.
- [ ] Loader decrypts a payload produced by the API for the same session.
- [ ] Obfuscator output runs under the loader's VM runtime and matches the original script's behavior.
- [ ] Bot and dashboard only use documented admin endpoints.
- [ ] No module introduced a new contract field without updating this document.
- [ ] Every module returned a Research Log with real sources, versions, and dates.
- [ ] No module used an API, limit, or version that is missing from its log.
- [ ] Library and service choices across modules are compatible (same versions, same runtime targets).
- [ ] Unverified items from all modules are resolved or recorded in Open Decisions.
- [ ] Reviewer pass completed with no open blockers.

---

A Luarmor-style system: key and license management, server-gated script delivery, per-session encrypted payloads, a custom VM-based obfuscator, leak tracing, Discord integration, payments, and operations.

---

## 0. Ground Rules

- **Client code is never trusted.** Everything on the user's machine can eventually be dumped. Security comes from keeping the real script on the server until validation passes, making every payload unique, and detecting and punishing leaks.
- **Layers, not one wall.** Server gate, signed responses, per-session encryption, VM obfuscation, anti-tamper, watermarking, and monitoring each raise cost for an attacker.
- **No `goto` in any Lua code** (loader, VM runtime, templates). Use loops, flags, and functions instead.
- **Never hardcode secrets in the repo.** Use environment secrets and a rotation plan.
- **Every decision that cannot be verified gets written to the Open Decisions list (section 17) before code is written.**

---

## 1. Goals

| # | Goal | Priority |
|---|------|----------|
| G1 | Key lifecycle: create, redeem, bind HWID, expire, revoke, blacklist | Must |
| G2 | Server-side script storage and gated delivery | Must |
| G3 | Signed server responses, replay protection | Must |
| G4 | Per-session payload encryption | Must |
| G5 | Discord bot for users and admins | Must |
| G6 | Free-key flow (checkpoints) with server-side verification | Should |
| G7 | Custom VM obfuscator (Lua/Luau to custom bytecode and runtime) | Should (hard) |
| G8 | Anti-tamper and environment checks in the loader | Should |
| G9 | Per-user watermarking and leak tracing | Should |
| G10 | Payments with auto key issue | Should |
| G11 | Admin dashboard and reseller roles | Should |
| G12 | Analytics, alerts, audit log, status page | Should |
| G13 | Auto-blacklist and abuse detection | Could |

---

## 2. Architecture

```
                 +------------------+
  Discord users  |  Discord bot     |-----+
                 +------------------+     |
                                          v
 +-----------+   HTTPS    +---------------------------+     +-----------+
 |  Loader   |<---------->|  API (edge worker)        |<--->|  DB       |
 |  (Lua)    |  signed    |  /validate /payload /free |     | (SQL)     |
 +-----------+  + encrypt |  /admin /webhooks         |     +-----------+
                          +-------------+-------------+
                                        |
                          +-------------v-------------+     +-----------+
                          | Build pipeline            |---->| Blob store|
                          | (obfuscator + VM + packer)|     | (R2/S3)   |
                          +---------------------------+     +-----------+

 Dashboard (web) ---> Admin API       Payment provider ---> Webhook endpoint
```

### Recommended stack

| Layer | Choice | Reason |
|-------|--------|--------|
| API | Cloudflare Workers (TypeScript) | Cheap, global, no server to manage |
| Database | D1 (SQLite) or Postgres (Supabase) | Relational keys, logs |
| Nonce and rate state | Durable Objects or KV | Atomic counters, TTL |
| Blob storage | R2 | Encrypted script bundles |
| Obfuscator | Node/TypeScript CLI | Shares types with API |
| Discord bot | Node (discord.js) or Python | Slash commands |
| Dashboard | Next.js or SvelteKit | Admin UI |
| CI | GitHub Actions | Build and deploy |

---

## 3. Data Model

```sql
-- Projects: one per product/script family
CREATE TABLE projects (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  owner_id      TEXT NOT NULL,
  signing_key_id TEXT NOT NULL,       -- which keypair signs responses
  created_at    INTEGER NOT NULL
);

-- Scripts: versioned, belong to a project
CREATE TABLE scripts (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL REFERENCES projects(id),
  name          TEXT NOT NULL,
  place_ids     TEXT,                 -- JSON array, optional game gating
  active_version INTEGER NOT NULL,
  created_at    INTEGER NOT NULL
);

CREATE TABLE script_versions (
  script_id     TEXT NOT NULL REFERENCES scripts(id),
  version       INTEGER NOT NULL,
  blob_ref      TEXT NOT NULL,        -- R2 key of the built bundle
  build_hash    TEXT NOT NULL,
  notes         TEXT,
  created_at    INTEGER NOT NULL,
  PRIMARY KEY (script_id, version)
);

-- Keys
CREATE TABLE keys (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL REFERENCES projects(id),
  key_hash      TEXT NOT NULL UNIQUE, -- store hash, not plaintext
  tier          TEXT NOT NULL,        -- free | paid | lifetime | reseller
  status        TEXT NOT NULL,        -- active | revoked | blacklisted | expired
  hwid_hash     TEXT,
  hwid_resets   INTEGER NOT NULL DEFAULT 0,
  last_reset_at INTEGER,
  discord_id    TEXT,
  roblox_user_id INTEGER,
  note          TEXT,
  created_by    TEXT NOT NULL,
  created_at    INTEGER NOT NULL,
  expires_at    INTEGER,              -- null = never
  first_used_at INTEGER,
  last_used_at  INTEGER
);

CREATE TABLE key_scripts (            -- which scripts a key may load
  key_id        TEXT NOT NULL REFERENCES keys(id),
  script_id     TEXT NOT NULL REFERENCES scripts(id),
  PRIMARY KEY (key_id, script_id)
);

-- Sessions: one per successful load
CREATE TABLE sessions (
  id            TEXT PRIMARY KEY,
  key_id        TEXT NOT NULL REFERENCES keys(id),
  script_id     TEXT NOT NULL,
  version       INTEGER NOT NULL,
  hwid_hash     TEXT NOT NULL,
  ip_hash       TEXT NOT NULL,
  roblox_user_id INTEGER,
  place_id      INTEGER,
  watermark_id  TEXT NOT NULL,        -- links payload to this user
  created_at    INTEGER NOT NULL,
  expires_at    INTEGER NOT NULL
);

-- Blacklist entries beyond keys
CREATE TABLE blacklist (
  id            TEXT PRIMARY KEY,
  kind          TEXT NOT NULL,        -- hwid | ip | roblox_user | discord
  value_hash    TEXT NOT NULL,
  reason        TEXT,
  created_by    TEXT NOT NULL,
  created_at    INTEGER NOT NULL
);

-- Free key flow
CREATE TABLE checkpoints (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL,
  position      INTEGER NOT NULL,
  provider      TEXT NOT NULL,        -- linkvertise | workink | custom
  config        TEXT NOT NULL         -- JSON
);

CREATE TABLE free_attempts (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL,
  fingerprint   TEXT NOT NULL,        -- hwid hash or ip hash
  step          INTEGER NOT NULL,
  token_hash    TEXT NOT NULL,
  started_at    INTEGER NOT NULL,
  step_started_at INTEGER NOT NULL,
  completed_at  INTEGER
);

-- Admin and audit
CREATE TABLE admins (
  id            TEXT PRIMARY KEY,
  discord_id    TEXT,
  role          TEXT NOT NULL,        -- owner | admin | reseller | support
  api_token_hash TEXT,
  quota_keys    INTEGER,
  created_at    INTEGER NOT NULL
);

CREATE TABLE audit_log (
  id            TEXT PRIMARY KEY,
  actor_id      TEXT NOT NULL,
  action        TEXT NOT NULL,
  target        TEXT,
  detail        TEXT,
  created_at    INTEGER NOT NULL
);

CREATE TABLE events (                 -- analytics and abuse signals
  id            TEXT PRIMARY KEY,
  key_id        TEXT,
  type          TEXT NOT NULL,        -- validate_ok | validate_fail | tamper | leak_suspect ...
  detail        TEXT,
  created_at    INTEGER NOT NULL
);
```

Indexes: `keys(key_hash)`, `keys(discord_id)`, `sessions(key_id, created_at)`, `events(key_id, created_at)`, `blacklist(kind, value_hash)`.

---

## 4. Key Design

- Format: `PREFIX-XXXXX-XXXXX-XXXXX-XXXXX` using 128 bits from a CSPRNG, base32 encoded.
- Store only a hash (SHA-256 with a server pepper). Show the plaintext once at creation.
- Optional checksum character so typos are rejected before hitting the database.
- Keys are bound to a project. A key can unlock one or many scripts through `key_scripts`.
- HWID is hashed with a per-project salt before storage.

---

## 5. API Specification

All responses are JSON and signed (section 7). All requests include a timestamp and a nonce.

### Public (loader-facing)

| Endpoint | Purpose |
|----------|---------|
| `POST /v1/handshake` | Client sends ephemeral public key and nonce, server returns its ephemeral key and a session challenge |
| `POST /v1/validate` | Key, HWID, place, user id; returns status, tier, expiry, session token |
| `POST /v1/payload` | Session token; returns encrypted script bundle for the session |
| `POST /v1/heartbeat` | Optional periodic check; can revoke a running session |
| `GET  /v1/free/start` | Begin free-key flow |
| `POST /v1/free/step` | Verify a checkpoint completion token |
| `POST /v1/free/claim` | Issue a free key after all steps pass |

### Admin

| Endpoint | Purpose |
|----------|---------|
| `POST /admin/keys` | Create one or bulk |
| `PATCH /admin/keys/:id` | Extend, change tier, edit note |
| `POST /admin/keys/:id/revoke` | Revoke |
| `POST /admin/keys/:id/reset-hwid` | Reset with cooldown and counter |
| `POST /admin/blacklist` | Add entry |
| `POST /admin/scripts/:id/versions` | Upload new build |
| `POST /admin/scripts/:id/activate` | Switch active version, rollback |
| `GET  /admin/analytics/*` | Stats |
| `GET  /admin/audit` | Audit log |

### Webhooks

| Endpoint | Purpose |
|----------|---------|
| `POST /webhooks/payments/:provider` | Verify signature, issue key, notify user |

### Error handling

- Return generic errors to the loader (`denied`, `expired`, `blacklisted`, `update_required`) with a short code. Never leak which check failed in detail for ambiguous cases.
- Uniform response timing for invalid keys to reduce probing.

---

## 6. Loader Protocol (Step by Step)

1. Loader generates an ephemeral keypair (or random session secret if using the lighter scheme) and a nonce.
2. `handshake`: sends public value and nonce. Server replies with its public value, a server nonce, and a signature over the transcript.
3. Loader verifies the signature against the embedded public verification key. If it fails, abort silently.
4. Both sides derive a session key (HKDF over shared secret and both nonces).
5. `validate`: loader sends key, HWID, place id, user id, timestamp, encrypted under the session key. Server checks:
   - key exists, active, not expired, not blacklisted
   - project and script entitlement
   - HWID bound or bindable
   - blacklist (HWID, IP, user id)
   - rate limits and nonce uniqueness
6. Server creates a session row with a `watermark_id` and returns an encrypted session token.
7. `payload`: server returns the script bundle encrypted under a key derived from session key + build hash + watermark id.
8. Loader decrypts, verifies the bundle hash/signature, and hands bytecode to the embedded VM runtime.
9. Optional heartbeat: server can respond with a kill signal if the key was revoked or flagged.

### Rules

- Every request has `ts` (server rejects beyond a small skew window) and a one-time `nonce` (stored with TTL).
- The loader never contains the real script, only the VM stub and verification key.
- Loader is itself obfuscated and rebuilt periodically so static signatures do not persist.

---

## 7. Cryptography Plan

| Need | Approach |
|------|----------|
| Response authenticity | Ed25519 signatures, public key embedded in loader |
| Key agreement | X25519 ephemeral exchange |
| Payload encryption | ChaCha20-Poly1305 (or ChaCha20 + HMAC-SHA256) |
| Key derivation | HKDF-SHA256 |
| Hashing | SHA-256 with pepper/salt |
| Replay protection | timestamp window + server-stored nonces |

### The pure-Lua problem (hard)

Executors give no guaranteed crypto library, so the loader needs its own primitives:

- Implement SHA-256, HMAC, ChaCha20 (or a simpler stream cipher) in pure Lua/Luau using `bit32`. These are fast enough.
- Ed25519 verification in pure Lua is slow (bignum math). Options:
  1. Implement Ed25519 verify once with optimized field arithmetic; cost is acceptable on load only.
  2. Use the executor's native crypt functions when present, and verify equivalence in tests.
  3. Fall back to HMAC with a per-build secret (weaker, because the secret ships in the loader).
- Decision belongs in section 17 and should be benchmarked on target executors.

### Test requirements

- Known-answer test vectors for every primitive (RFC vectors) run in CI against a Lua implementation.
- Cross-implementation tests: server (TypeScript) encrypts, loader (Lua) decrypts, and the reverse.

---

## 8. Custom VM Obfuscator (The Hard Part)

### 8.1 Pipeline

```
Source (.lua / Luau)
   |  parse
   v
AST
   |  analysis and transforms (rename, constant fold, string extract)
   v
IR / Control Flow Graph
   |  compile
   v
Custom bytecode (per-build opcode map)
   |  encrypt constants, chunk, optional split
   v
VM runtime generated from template (per-build shuffled)
   |  pack
   v
Bundle (VM + encrypted bytecode)  -> encrypted again per session by the server
```

### 8.2 Components

1. **Parser**
   - Luau syntax support is required for Roblox: type annotations, `continue`, compound assignment (`+=`), string interpolation, `if` expressions, generics.
   - Options: use an existing Luau-capable parser library, or write one. Decision in section 17.
2. **Semantic analysis**
   - Scope resolution, upvalue capture, vararg handling, method calls, multiple assignment and returns.
3. **Compiler to custom bytecode**
   - Register-based design (like Lua 5.1) maps well and is faster than stack-based.
   - Instruction set must cover: loads, moves, table ops, arithmetic and comparison, concat, calls (including varargs and multi-returns), closures and upvalues, loops, jumps, returns, `SETLIST`, length, and not/neg.
   - Luau-specific additions: `continue` lowering, compound ops lowered to base ops, integer division and similar.
4. **Per-build randomization**
   - Randomized opcode numbering.
   - Randomized register allocation order where safe.
   - Randomized instruction encoding layout (field order and widths).
   - Randomized handler order and naming in the generated VM.
5. **VM runtime generator**
   - Template-based emitter that produces a different interpreter each build.
   - Dispatch strategies that vary per build: if/elseif chain, binary-search tree of comparisons, table of closures. No `goto`.
   - Handlers inlined or split into closures randomly.
6. **Constant and string protection**
   - Constants stored encrypted, decrypted lazily at first use.
   - Per-function constant keys derived from a chain so one decrypted function does not unlock others.
7. **Control-flow hardening (compile-time)**
   - Control-flow flattening via a state-variable dispatcher.
   - Opaque predicates (always true or false expressions that are hard to simplify statically).
   - Dead-code and junk-instruction insertion.
   - Instruction substitution (equivalent arithmetic forms).
8. **Nested VMs (optional, advanced)**
   - Compile hot or sensitive functions to a second, different VM so cracking one interpreter is not enough.
9. **Runtime integrity**
   - Checksums over VM source/bytecode segments, with key derivation depending on the checksum, so tampering corrupts decryption instead of triggering a detectable branch.
   - Function identity checks on critical natives (see section 9).

### 8.3 Correctness testing (critical)

A broken obfuscator is worse than none. Required:

- Corpus of real scripts plus synthetic edge cases: varargs, multiple returns, nested closures and upvalues, metatables, coroutines, pcall/error, string methods, numeric edge cases, integer and float behavior, deep recursion, large tables, `table.unpack` with nils.
- Differential testing: run original and protected versions under the same Luau runtime and compare outputs and side effects.
- Fuzzing: random program generator for the supported subset.
- Performance benchmarks: report slowdown ratio per script type. Provide per-function opt-out (`--@novm`) for hot loops.
- Each build produces a manifest (opcode map seed, version, hash) stored server-side for debugging.

### 8.4 Realistic limits

- A VM raises the cost of static analysis, but a skilled attacker can still instrument the runtime. Combine with watermarking and server-side detection rather than relying on the VM alone.

---

## 9. Anti-Tamper and Environment Checks (Loader)

Goal: raise effort and generate signals, not guarantee safety.

- Verify critical functions are native and unmodified where detectable (`loadstring`, `request`/`http` wrappers, `getfenv`, `debug` functions).
- Detect common instrumentation: hooked HTTP functions, remote-spy style wrappers, debug hooks.
- Verify environment consistency (expected globals, executor identification, version checks).
- Execution timing sanity checks (single-step debugging inflates timings).
- Integrity checksums feed key derivation (section 8.2 item 9), so failures corrupt output rather than branch on a flag.
- Silent failure mode: on a check failure, report an event to the server (`tamper`) and load nothing, with no explanatory message to the user.
- Server-side correlation: repeated tamper events plus HWID churn raises an abuse score.

---

## 10. Watermarking and Leak Tracing

- Each session gets a unique `watermark_id`.
- The server mixes the watermark into the delivered payload in ways that are semantically neutral but traceable:
  - variation in constant encoding order
  - unique junk-instruction patterns
  - distinct key-derivation salts
  - optional embedded identifier fragments inside encrypted constants
- Keep a mapping `watermark_id -> key_id` in `sessions`.
- Leak workflow:
  1. Receive a leaked dump.
  2. Run an extractor tool to recover the watermark.
  3. Look up the session and key.
  4. Auto-revoke, blacklist HWID/IP/user id, log to audit, notify admin channel.
- Build a **watermark extractor** as a first-class tool and test that it survives light transformations (renaming, reformatting).
- Because each payload is unique, a leaked file from one user cannot be reused as a generic cracked loader.

---

## 11. Free Key System

1. User requests a free key. Server creates a `free_attempts` row with an opaque token bound to a fingerprint (HWID hash and IP hash).
2. Each checkpoint (ad link provider) redirects back with a provider-signed or server-issued completion token.
3. Server verifies per step:
   - token matches the attempt and step order
   - minimum time elapsed since step start (blocks instant bypass)
   - provider-side verification API where available
   - one attempt per fingerprint per cooldown window
4. After the final step, `claim` issues a time-limited free key.
5. Anti-bypass:
   - tokens are single-use and short-lived
   - tokens are bound to IP/fingerprint
   - random step ordering or per-attempt step secrets
   - monitor completion-speed anomalies and flag
6. Free tier capabilities are controlled by `tier` so premium features stay gated.

---

## 12. Discord Bot

User commands: `/redeem`, `/getscript`, `/status`, `/resethwid`, `/free`, `/mykeys`.

Admin commands: `/key create`, `/key revoke`, `/key extend`, `/key info`, `/blacklist add`, `/whitelist`, `/stats`, `/leak lookup`.

Requirements:

- Link Discord ID to a key on redeem. Roles are granted automatically for active keys and removed on expiry or revoke.
- HWID reset: cooldown per key, monthly cap, audit logged.
- Private responses (ephemeral) for anything containing a key or script.
- Admin command permission checks happen server-side via the admin API, not only in the bot.
- Scheduled job: expiry reminders and role cleanup.

---

## 13. Dashboard

Pages:

- Overview: active keys, executions over time, failures, top scripts
- Keys: search, filter, bulk actions, import and export
- Scripts: upload, build status, versions, activate and rollback
- Users: Discord link, HWID history, session history
- Blacklist manager
- Leak tools: watermark lookup and extraction upload
- Audit log
- Resellers: create, quota, revoke
- Settings: signing key rotation, webhooks, rate limits

Auth: admin login via Discord OAuth plus optional TOTP. All mutations produce audit entries.

---

## 14. Payments

- Provider webhook verifies signature and idempotency key.
- On confirmed payment: create key, assign scripts, DM or email delivery, store order reference.
- Handle refunds and chargebacks: revoke and optionally blacklist.
- Reconciliation job compares provider orders against issued keys.

---

## 15. Security of the Service Itself

- Cloudflare in front: WAF, DDoS protection, bot rules on public endpoints.
- Rate limits per IP, per key, per HWID, and per project; stricter limits on invalid-key attempts with escalating lockouts.
- Secrets in the platform secret store; rotation procedure documented.
- Signing key management:
  - separate keypair per project
  - verification key embedded in loader builds
  - rotation plan: new loader builds ship with the new key while the server signs with both during a transition window
- Admin tokens scoped and hashed; short-lived dashboard sessions.
- Input validation on every endpoint, strict body size limits.
- Database least privilege; backups encrypted; restore tested.
- Separate staging and production environments.
- Dependency scanning and pinned versions in CI.

---

## 16. Operations

- Structured logs with request ids; no plaintext keys in logs.
- Metrics: validate success and failure rates, latency, tamper events, free-flow conversion, build failures.
- Alerts: sudden failure spike, many HWIDs per key, signing errors, webhook failures, error budget breaches.
- Status page and an outage plan: define loader behavior when the API is unreachable (default: do not load).
- Backups daily with retention; disaster recovery runbook.
- Versioned API with a minimum-loader-version gate (`update_required`) so old loaders can be retired.
- Load test before launch.

---

## 17. Open Decisions (Resolve Before Coding Each Area)

| # | Decision | Options | Blocking |
|---|----------|---------|----------|
| D1 | Luau parser | existing library vs custom | Obfuscator |
| D2 | Ed25519 in loader | pure Lua vs executor native vs HMAC fallback | Crypto |
| D3 | Database | D1 vs Postgres | Backend |
| D4 | Bytecode model | register-based vs stack-based | Compiler |
| D5 | Free-key providers | which ad providers and their verification APIs | Free flow |
| D6 | Payment provider | which one and its webhook format | Payments |
| D7 | Target executors | which environments must work (affects crypto, anti-tamper) | Loader |
| D8 | Scripts per key model | single script vs multi-script entitlements | Schema |
| D9 | Offline behavior | strict deny vs short grace cache | Loader |

---

## 18. Roadmap

### Phase 1: Core (weeks 1-2)
- [ ] Repo, CI, environments
- [ ] Schema and migrations
- [ ] Key generation, hashing, validation endpoint
- [ ] Admin API for keys
- [ ] Basic loader with plain HTTP validation (no crypto yet)
- [ ] Script storage and gated delivery (unencrypted, test only)

### Phase 2: Secure Channel (weeks 3-4)
- [ ] Pure-Lua SHA-256, HMAC, stream cipher with test vectors
- [ ] Signed responses and loader verification
- [ ] Handshake and session key derivation
- [ ] Nonce and timestamp replay protection
- [ ] Per-session encrypted payloads
- [ ] Rate limiting and invalid-key lockouts

### Phase 3: Discord and Operations (weeks 5-6)
- [ ] Discord bot: user and admin commands, role sync
- [ ] HWID reset with cooldown
- [ ] Audit log, event logging, alerts
- [ ] Blacklist system

### Phase 4: Free Keys and Payments (weeks 7-8)
- [ ] Checkpoint flow with server-side verification
- [ ] Anti-bypass timing and token binding
- [ ] Payment webhook and auto issue
- [ ] Refund and chargeback handling

### Phase 5: Obfuscator Foundations (weeks 9-12)
- [ ] Parser decision and implementation
- [ ] AST transforms (rename, constant folding, string extraction)
- [ ] Bytecode design and compiler
- [ ] VM runtime template
- [ ] Differential test harness and corpus

### Phase 6: Obfuscator Hardening (weeks 13-16)
- [ ] Per-build opcode and encoding randomization
- [ ] Generated, shuffled VM runtime
- [ ] Constant encryption with key chains
- [ ] Control-flow flattening, opaque predicates, junk insertion
- [ ] Integrity-linked key derivation
- [ ] Performance tuning and `@novm` opt-out

### Phase 7: Tamper, Watermark, Leak Tools (weeks 17-19)
- [ ] Environment and instrumentation checks in loader
- [ ] Silent tamper reporting
- [ ] Watermark injection and extractor tool
- [ ] Leak response workflow (revoke and blacklist automation)

### Phase 8: Dashboard and Resellers (weeks 20-22)
- [ ] Admin dashboard pages
- [ ] Reseller roles and quotas
- [ ] Analytics views

### Phase 9: Launch Readiness (weeks 23-24)
- [ ] Load and abuse testing
- [ ] Key rotation drill
- [ ] Backup restore drill
- [ ] Status page
- [ ] Documentation for admins and script developers

---

## 19. Testing Strategy

| Area | Tests |
|------|-------|
| Crypto | RFC known-answer vectors, cross-language round trips |
| API | Unit and integration tests, replay and expiry cases, concurrency on HWID bind |
| Loader | Behavior under failures, bad signatures, clock skew, network errors |
| Obfuscator | Differential tests, fuzzing, performance regression suite |
| Free flow | Bypass attempts: replay, skipped steps, fast completion, multi-account |
| Security | Brute-force simulation, malformed input, auth boundary tests |
| Ops | Chaos tests: DB down, blob store down, signing key missing |

---

## 20. Definition of Done

- A key can be created, redeemed, bound to a HWID, extended, reset, and revoked end to end.
- The real script is never retrievable without passing server validation.
- Every payload is encrypted per session and uniquely watermarked.
- A tampered or replayed request fails safely and is logged.
- The obfuscator passes differential tests on the full corpus with a documented performance cost.
- A leaked payload can be traced to a key and that key auto-revoked.
- Admin actions are audited; secrets can be rotated without downtime.
- Runbooks exist for outage, key rotation, and restore.
