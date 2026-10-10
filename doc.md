# Project: Self-Hosted Lua Script Licensing and Protection Platform (v2)

Rewritten after capturing a real-world key-system flow with an HTTP spy. Section 1 records what the capture shows. Everything else is the design built from it.

---

## READ FIRST: Instructions for AI Assistants

You are one of several AI assistants working in parallel on the same project. Each assistant is assigned ONE module (see "Module Assignments"). This document is the single source of truth. Follow it exactly so the pieces fit together when merged.

### Your job

1. Read this entire document.
2. Find your assigned module in "Module Assignments".
3. Do the research tasks for your module and produce a Research Log.
4. Build only that module, following the "Shared Contracts" so other modules integrate without changes.
5. Return the deliverables in the "Output Format".

### Hard rules

- **Do not use `goto`** in any Lua code.
- **Do not guess.** If anything is unclear, missing, or conflicts with the contracts, STOP and list your questions instead of assuming. Never invent endpoints, fields, or formats that are not in this document.
- **Do not change the Shared Contracts.** If you believe a contract is wrong, say so under "Contract Issues" and still implement it as written.
- **Do not rewrite or duplicate other modules.** Only build interfaces to them as defined by the contracts.
- **Do not hardcode secrets, keys, or URLs.** Use configuration and environment variables.
- **Do not add features that are not in the document.**
- **No unnecessary code:** no unused variables, no placeholder stubs presented as finished work, no dead branches.
- **Keep debug output minimal.** Only add it where it helps diagnose real failures, and never log plaintext keys, secrets, or payloads.
- **Write tests** for everything you build (section 19) and say how to run them.
- **Be honest about limits.** If something cannot be done securely in your environment (for example pure-Lua crypto speed), say so with numbers if you have them.
- **Clean-room rule.** Section 1 describes observed behavior of an existing commercial service so we can design something comparable. Do NOT copy that service's code, constants, hash functions, obfuscation, endpoint names, or branding. Design and implement your own. Use its public documentation only to understand user-facing behavior.

### Mandatory research (do this BEFORE writing any code)

Your training data is outdated and often wrong about library APIs, versions, and platform limits. You MUST use web search or browsing tools first. If you have no web access, say so in your first line and list every claim you could not verify.

1. **Search first, code second.** Complete your module's research tasks and produce a Research Log before any code.
2. **Use primary sources.** Official docs, RFCs, specs, source repos, and release notes beat blogs and forum answers.
3. **Check versions and dates.** Record the exact version of every library, API, or service you rely on and the date of the doc you read. Flag anything deprecated.
4. **Verify every API you call.** Function names, parameters, return values, limits, and pricing must come from docs you actually opened. Never write an API call from memory.
5. **Compare options before choosing.** For any library or service, list 2 to 3 candidates with pros, cons, license, and maintenance status (last release, open issues), then pick one with a reason.
6. **Look for prior art.** Search GitHub and package registries for open-source implementations of what you are building. Study design, edge cases, and known bugs. Note the license of anything you adapt.
7. **Cross-check security-critical facts** (crypto parameters, signature schemes, rate limits, platform behavior) with two independent sources or the official spec.
8. **Test claims when you can.** If you can run code, run it instead of trusting docs alone.
9. **Say what you could not find.** List it under "Unverified" and ask for a decision.
10. **Do not fabricate sources.** Every URL in your Research Log must be one you actually opened.

**Research Log format (required, placed before the code)**

| Topic | Source URL | Version / date | Key finding | Used for |
|-------|-----------|----------------|-------------|----------|

Then add: **Options compared**, **Prior art found**, **Unverified items**, **Decisions made and why** (each linked to a source in the table).

### Research tasks per module

| Module | Must research |
|--------|---------------|
| M1 API core | Current Cloudflare Workers limits (CPU time, subrequests, body size), D1 limits and consistency, Durable Objects for atomic counters, API key hashing and rate limiting best practice, constant-time comparison in Workers, the public documentation of existing Lua key-check services (user-facing behavior only) |
| M2 Database | D1 vs Postgres limits and migration tooling, index behavior for the access patterns in section 6, backup and restore options |
| M3 Loader SDK and crypto (Lua) | RFC 8032, RFC 7748, RFC 8439, RFC 5869, RFC 4231 vectors; existing pure-Lua/Luau crypto implementations and speed; Luau `bit32` and number precision limits; which crypto functions common executors expose; how executors inject identity headers into `request` and which header names each uses (see D10) |
| M4 Obfuscator front end | Current Luau grammar, existing Luau/Lua parsers (license, completeness, maintenance), AST formats, scope and upvalue analysis in the reference Lua compiler |
| M5 Obfuscator back end | Lua 5.1 and Luau bytecode formats, how `luac` and Luau handle varargs/upvalues/multiple returns, published VM-obfuscator designs and their weaknesses, Luau vs Lua 5.1 differences |
| M6 VM runtime generator | Fastest dispatch techniques in pure Lua/Luau, cost of closure-per-opcode vs if-chain vs table dispatch, published deobfuscation techniques against Lua VMs and counters |
| M7 Anti-tamper and watermarking | Detection methods and false-positive rates, how common executors expose `request`, `loadstring`, `getfenv`, published research on code watermarking and fingerprinting, leak-tracing designs |
| M8 Discord bot | Current discord.js (or chosen library) version and breaking changes, slash command and permission model, rate limits, interaction timeouts, current Discord developer policy |
| M9 Free-key flow | Current verification docs for each checkpoint provider (Linkvertise, Lootlabs, others), how bypass services work and how providers defend against them, token binding, provider ToS |
| M10 Payments | Chosen provider's webhook signature scheme, idempotency, refund and chargeback events, fees, regional restrictions |
| M11 Dashboard | Current stable version of chosen framework, Discord OAuth flow, session and CSRF handling, TOTP libraries |
| M12 Ops | Cloudflare logging, metrics, alerting; CI deploy patterns for Workers; secret management and rotation; multi-hostname and multi-region node setup |
| M13 Loader stub generator and CDN init packaging | Static asset caching on Cloudflare/R2, cache-busting strategies, executor filesystem APIs (`readfile`, `writefile`, `makefolder`) and their availability, safe on-disk cache validation |
| M14 Reviewer | Current OWASP API Security Top 10, known pitfalls of license-key systems, known crypto misuse patterns for the algorithms used |

### Output format

Return, in this order:

0. **Research Log** (no code before this).
1. **Summary**: what you built and what you did not build.
2. **Assumptions and questions**: anything needing a decision (reference Open Decisions D1 to D10).
3. **File tree** using the repo layout below.
4. **Code**: each file in its own fenced block with the path above it.
5. **Tests**: test files and exact commands to run them.
6. **Integration notes**: what other modules must provide to you and what you provide to them.
7. **Contract Issues**: problems found in this document (or "none").

### Repo layout (all modules use this)

```
/
  doc.md
  contracts/            # shared schemas, error codes, test vectors
  api/                  # edge API (TypeScript)
  db/                   # migrations and seed data
  loader/
    sdk/                # key-check library (Lua)
    stub/               # stub generator
    init/               # cached init script (Lua)
    crypto/             # pure-Lua primitives
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

## 1. Reference Findings (from an HTTP spy capture)

A script hub using an existing commercial key system was run with an HTTP spy, and every request it made was logged. This section records what was observed. Items are tagged **[observed]** (seen directly in the capture), **[inferred]** (a reasonable reading, not confirmed), or **[unknown]** (not visible). Keys, fingerprints, and project IDs from the capture are deliberately left out of this document.

### 1.1 Observed request sequence

| Step | Request | What it returned |
|------|---------|------------------|
| 1 | Hub script fetched from a public GitHub raw URL | The hub itself: a table mapping game IDs to project script IDs, a UI, and calls to the key-check library |
| 2 | `GET /library.lua` on the vendor's SDK host | A public, obfuscated key-check library, with a comment pointing to the vendor's documentation |
| 3 | `GET /sync` on the SDK host | JSON: `cf` (edge location), `st` (server time), `nodes` (list of 8 regional auth hostnames) |
| 4 | `GET <random node>/check_key?key=...&script_id=...` with two custom headers (`clienttime`, plus a hash header) | JSON: `code` (`KEY_VALID`), `message`, `data` (`note`, `auth_expire`, `total_executions`) |
| 5 | `GET /files/v3/loaders/<script_id>.lua` | A small loader stub (see 1.3) |
| 6 | `GET <node>/status` | JSON: `message`, `versions` (protocol version mapped to a handler name), `instances` (9 hostnames), `active` |
| 7 | `GET <node>/v8/auth/<script_id>/init?t=<encoded blob>&v=<version>&k=<key>` | A non-JSON body (`text/html`) of encoded characters in a custom alphabet |

### 1.2 Observed behaviors and design takeaways

1. **Two public layers.** A small, public SDK does the cheap check (`check_key`). A separate loader does the real delivery. **[observed]**
   - Takeaway: keep the user-facing key check cheap and separate from script delivery, so a typo or expired key never touches the heavy path.
2. **Time sync before auth.** The SDK first calls `/sync`, computes the difference between server time and local `os.time()`, and uses the corrected time as `clienttime`. **[observed]** The hash header covers key, a version string, script ID, and the time. **[observed]** The exact hash algorithm is not described here and must not be copied (clean-room rule).
   - Takeaway: server-supplied time offset makes timestamp checks tolerate wrong client clocks. Our proof header is designed independently (section 8).
3. **Many auth nodes.** `/sync` hands out a list of regional hostnames and the client picks one at random. **[observed]** All responses came through Cloudflare. **[observed]**
   - Takeaway: multiple hostnames give regional latency and resilience against a single domain being blocked or throttled. With Workers a single anycast hostname is enough to start; the node list is still worth supporting in the contract.
4. **Health and version endpoint.** `/status` reports whether the service is active, which protocol versions exist, and which instances are live. **[observed]**
   - Takeaway: gives loaders a way to pick a compatible protocol version and gives you a kill switch.
5. **The loader file is a tiny stub, not the script.** Its header says not to save it and to always run it through `loadstring`. **[observed]** It embeds a block of per-fetch data containing numbers, encoded strings, and a timestamp matching the fetch time. **[observed]** Its purpose is likely integrity or key derivation for the next stage. **[inferred]**
   - Takeaway: serve a unique stub per fetch so a saved copy goes stale.
6. **Cached init script.** The stub looks for a cached init file on disk (a folder plus an `init-<build>.lua` file). If it is missing or too small, it downloads the init from a CDN, writes it to disk, and runs it with a build identifier. **[observed]**
   - Takeaway: the heavy loader code is static and cacheable on a CDN, so bandwidth is cheap and updates ship by changing the build identifier. The real script is not in it. Our stub generator and init cache validation (M13) copy this idea with our own design.
7. **The auth init call returns an encoded blob, not JSON.** The request carries an encoded token, a protocol version, and the key; the response is a long opaque string. **[observed]** What the token contains and how the response is decoded is not visible in the capture. **[unknown]**
   - Takeaway: opaque, encrypted responses are the norm. Our spec uses standard authenticated encryption (section 9) instead of a custom alphabet.
8. **Key in the URL.** The key was passed in the query string on two requests. **[observed]**
   - Takeaway: query strings end up in proxy logs and analytics. Our contract sends keys in a POST body.
9. **Executor-injected identity headers.** The logged request headers include a `User-Agent` and two identity headers carrying what looks like a device fingerprint, which the script itself did not set. **[observed]** Because the spy logs after the call returns, this suggests the executor adds these headers to the headers table during the call. **[inferred]**
   - Takeaway: the most reliable HWID source may be executor-injected headers that the server reads, instead of a string the script sends. Which executors do this, and under which header names, must be researched (D10).
10. **Multi-script routing by game.** The hub maps game IDs to project script IDs and shows a "not supported" message for others. **[observed]** A `keyless` flag exists per entry. **[observed]**
    - Takeaway: data model needs scripts bound to game/place IDs, per-script key requirements, and a keyless option.
11. **Free-key links.** Free keys come from vendor-hosted pages (`get_key?for=<project slug>`) using ad checkpoint providers, including Linkvertise and Lootlabs. **[observed]**
    - Takeaway: confirms the checkpoint flow in section 14, with per-project slugs.
12. **Saved key on disk.** The hub stores the key in a local file so users do not retype it. **[observed]**
    - Takeaway: the SDK should support an optional key cache file.
13. **Response shape.** A valid key returns a stable code (`KEY_VALID`), a message, and a small data block with a note, an expiry timestamp, and an execution counter. **[observed]**
    - Takeaway: matches our `check_key` contract (section 5). Other codes the vendor uses are **[unknown]** from this capture and must be taken from its documentation.
14. **Unique per-user data returned to scripts.** The data block (note, expiry, executions) is what a protected script can use to gate features. **[observed]**

### 1.3 What the capture does NOT tell us

- How the init token is built and how the encoded response is decrypted
- The structure of the downloaded init script (it was not in the capture)
- The obfuscation or VM format of the final script
- Server-side rules (rate limits, HWID reset rules, blacklist logic)

Those parts are designed from scratch in this document.

---

## 2. Goals

| # | Goal | Priority |
|---|------|----------|
| G1 | Key lifecycle: create, redeem, bind HWID, expire, revoke, blacklist | Must |
| G2 | Server-side script storage and gated delivery | Must |
| G3 | Lightweight `check_key` SDK with time sync and node list | Must |
| G4 | Static loader stub plus cached init, updated by build id | Must |
| G5 | Signed server responses, replay protection | Must |
| G6 | Per-session payload encryption | Must |
| G7 | Discord bot for users and admins | Must |
| G8 | Free-key flow (checkpoints) with server-side verification | Should |
| G9 | Custom VM obfuscator (Lua/Luau to custom bytecode and runtime) | Should (hard) |
| G10 | Anti-tamper and environment checks | Should |
| G11 | Per-user watermarking and leak tracing | Should |
| G12 | Payments with auto key issue | Should |
| G13 | Dashboard and reseller roles | Should |
| G14 | Analytics, alerts, audit log, status page | Should |
| G15 | Auto-blacklist and abuse detection | Could |

---

## 3. Ground Rules

- **Client code is never trusted.** Everything on the user's machine can eventually be dumped. Security comes from keeping the real script server-side until validation passes, making every payload unique, and detecting and punishing leaks.
- **Layers, not one wall:** server gate, signed responses, per-session encryption, VM obfuscation, anti-tamper, watermarking, monitoring.
- **No `goto`** in any Lua code.
- **No secrets in the repo.** Environment secrets and a rotation plan.
- **Unverified decisions go to the Open Decisions list (section 20) before code is written.**

---

## 4. Architecture

```
 Discord bot ----------------------+
                                   v
 +-----------+  1 sync/status   +----------------------------+     +-----------+
 | SDK       |----------------->|  API (edge nodes)          |<--->|  DB       |
 | (Lua)     |  2 check_key     |  /sync /status /check_key  |     +-----------+
 +-----+-----+                  |  /auth/*  /admin /webhooks |
       |                        +-------------+--------------+     +-----------+
       | 3 fetch stub                         |                    | Blob store|
       v                                      v                    +-----------+
 +-----------+  4 cached init  +----------------------------+            ^
 | Stub      |---------------->| Static CDN (init + stubs)  |            |
 | (Lua)     |  5 auth/init    +----------------------------+            |
 +-----+-----+  6 payload                                       +--------+--------+
       |                                                         | Build pipeline  |
       +-- decrypt, run in VM runtime                            | obfuscator + VM |
                                                                 +-----------------+
 Dashboard ---> Admin API       Payment provider ---> Webhook endpoint
```

### Recommended stack

| Layer | Choice | Reason |
|-------|--------|--------|
| API | Cloudflare Workers (TypeScript) | Cheap, global, no server to manage |
| Database | D1 (SQLite) or Postgres (Supabase) | Relational keys, logs |
| Nonce and rate state | Durable Objects or KV | Atomic counters, TTL |
| Blob and static storage | R2 behind Cloudflare CDN | Encrypted bundles and cached init |
| Obfuscator | Node/TypeScript CLI | Shares types with API |
| Discord bot | Node (discord.js) or Python | Slash commands |
| Dashboard | Next.js or SvelteKit | Admin UI |
| CI | GitHub Actions | Build and deploy |

---

## 5. Shared Contracts (Do Not Change)

### 5.1 Encoding and types

- Binary data in JSON: **base64url without padding**.
- Timestamps: **Unix seconds, integer**.
- IDs: **lowercase hex strings, 16 bytes** unless stated otherwise.
- Hashes: **SHA-256, hex**.
- Bodies: **JSON, UTF-8**, except the static files and the `auth/init` and `auth/payload` responses noted below.
- HWID, IP, and user identifiers are hashed server-side before storage.
- **Keys and secrets never appear in URLs.** All calls that carry a key use POST with a JSON body.

### 5.2 Common request headers (SDK/stub to API)

| Header | Meaning |
|--------|---------|
| `x-ts` | Client time corrected by the offset from `/sync` |
| `x-nonce` | 16 random bytes, base64url, single use |
| `x-lv` | Loader/SDK version |
| `x-proof` | HMAC-SHA256 over `method \| path \| x-ts \| x-nonce \| sha256(body)` using the proof key baked into the SDK build. Filters casual spam and tampered clients. It is not a strong secret. |

The server also reads **executor-injected identity headers** (header names per executor are configured server-side; see D10). These are the primary HWID source when present.

### 5.3 Public endpoints

| Endpoint | Method | Returns |
|----------|--------|---------|
| `/sync` | GET | `{ "st": <server time>, "nodes": ["https://..."], "colo": "<edge id>" }` |
| `/status` | GET | `{ "active": true, "versions": { "<proto>": "<handler>" }, "nodes": ["..."] }` |
| `/check_key` | POST | JSON envelope (5.4) |
| `/loaders/<script_id>.lua` | GET | The unique stub (5.6) |
| `/static/init_<build>.lua` | GET | Cached init script (CDN, long cache) |
| `/auth/<script_id>/init` | POST | `text/plain`: base64url ciphertext (5.5) |
| `/auth/<script_id>/payload` | POST | `text/plain`: base64url ciphertext (5.5) |
| `/auth/<script_id>/heartbeat` | POST | Optional; JSON envelope; can return a kill signal |
| `/free/start`, `/free/step`, `/free/claim` | POST | JSON envelope (section 14) |

### 5.4 JSON response envelope

```json
{
  "code": "KEY_VALID",
  "message": "The provided key is valid.",
  "data": { "note": null, "auth_expire": 0, "total_executions": 0 }
}
```

Response headers: `x-ts` (server time) and `x-sig` (Ed25519 signature over `code | message | canonical(data) | x-ts`).

**Codes (the only ones the SDK may receive):**
`KEY_VALID`, `KEY_INVALID`, `KEY_EXPIRED`, `KEY_BLACKLISTED`, `HWID_MISMATCH`, `SCRIPT_NOT_ALLOWED`, `RATE_LIMITED`, `UPDATE_REQUIRED`, `BAD_REQUEST`, `SERVER_ERROR`

Any unknown code must be treated as a denial.

### 5.5 Request and response bodies

**`/check_key` request**
```json
{ "key": "<plaintext key>", "script_id": "<id>", "lv": "1.0.0" }
```

**`/auth/<script_id>/init` request**
```json
{
  "v": 1,
  "key": "<plaintext key>",
  "build": "<build id>",
  "place_id": 0,
  "game_id": 0,
  "user_id": 0,
  "hello": "<base64url: ephemeral X25519 public key (32 bytes) | client nonce (16 bytes)>"
}
```

**`/auth/<script_id>/init` response** (decoded from base64url after decrypting with the session key; the first 32 bytes of the response are the server's ephemeral public key in clear, followed by ciphertext and tag)
```json
{
  "session_token": "<base64url>",
  "session_expires_at": 0,
  "tier": "free|paid|lifetime|reseller",
  "auth_expire": 0,
  "discord_id": null,
  "note": null,
  "payload_ref": "<opaque>"
}
```

**`/auth/<script_id>/payload` request**
```json
{ "v": 1, "session_token": "<base64url>", "payload_ref": "<opaque>" }
```

**`/auth/<script_id>/payload` response** (decrypted)
```json
{
  "build_hash": "<hex>",
  "bundle": "<base64url bytes>",
  "bundle_sig": "<base64url Ed25519 signature over build_hash | bundle>"
}
```

### 5.6 Loader stub contract

- Small Lua text file, unique per fetch.
- Contains a per-fetch data block (fetch time, stub id, build id, a per-stub random value used by the init script for integrity-linked key derivation).
- Behavior:
  1. Look for a cached init file in the cache folder (name includes the build id).
  2. If the file exists and passes validation (size and hash check against the value embedded in the stub), run it.
  3. Otherwise download `/static/init_<build>.lua`, validate it, write it to the cache folder, and run it.
  4. Pass the build id and the per-fetch data block to the init script.
- The stub never contains the real script.

### 5.7 Key derivation labels (HKDF info strings)

- `"session-key"`: from the X25519 shared secret and both nonces
- `"payload-key"`: from session key, build hash, and watermark id
- `"const-key"`: used inside the VM bundle for constant encryption chains

### 5.8 Admin API auth

`Authorization: Bearer <admin token>`, plus an audit entry for every mutating call.

### 5.9 Bytecode container (obfuscator to loader/VM runtime)

```
magic (4 bytes) | format version (1) | build hash (32) | function count (varint)
| functions[ ... ] | encrypted constant pool | trailer checksum
```

The obfuscator CLI emits a manifest per build:

```json
{ "build_hash": "", "format_version": 1, "opcode_seed": "", "created_at": 0 }
```

---

## 6. Data Model

```sql
CREATE TABLE projects (
  id            TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  slug          TEXT NOT NULL UNIQUE,   -- used by free-key pages
  owner_id      TEXT NOT NULL,
  signing_key_id TEXT NOT NULL,
  created_at    INTEGER NOT NULL
);

CREATE TABLE scripts (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL REFERENCES projects(id),
  name          TEXT NOT NULL,
  keyless       INTEGER NOT NULL DEFAULT 0,   -- 1 = no key needed
  active_version INTEGER NOT NULL,
  created_at    INTEGER NOT NULL
);

CREATE TABLE script_games (               -- routing by game/place
  script_id     TEXT NOT NULL REFERENCES scripts(id),
  game_id       INTEGER NOT NULL,
  PRIMARY KEY (script_id, game_id)
);

CREATE TABLE script_versions (
  script_id     TEXT NOT NULL REFERENCES scripts(id),
  version       INTEGER NOT NULL,
  blob_ref      TEXT NOT NULL,
  build_hash    TEXT NOT NULL,
  init_build    TEXT NOT NULL,          -- which CDN init this version uses
  notes         TEXT,
  created_at    INTEGER NOT NULL,
  PRIMARY KEY (script_id, version)
);

CREATE TABLE keys (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL REFERENCES projects(id),
  key_hash      TEXT NOT NULL UNIQUE,
  tier          TEXT NOT NULL,          -- free | paid | lifetime | reseller
  status        TEXT NOT NULL,          -- active | revoked | blacklisted | expired
  hwid_hash     TEXT,
  hwid_resets   INTEGER NOT NULL DEFAULT 0,
  last_reset_at INTEGER,
  discord_id    TEXT,
  roblox_user_id INTEGER,
  note          TEXT,
  total_executions INTEGER NOT NULL DEFAULT 0,
  created_by    TEXT NOT NULL,
  created_at    INTEGER NOT NULL,
  expires_at    INTEGER,
  first_used_at INTEGER,
  last_used_at  INTEGER
);

CREATE TABLE key_scripts (
  key_id        TEXT NOT NULL REFERENCES keys(id),
  script_id     TEXT NOT NULL REFERENCES scripts(id),
  PRIMARY KEY (key_id, script_id)
);

CREATE TABLE sessions (
  id            TEXT PRIMARY KEY,
  key_id        TEXT,                   -- null for keyless scripts
  script_id     TEXT NOT NULL,
  version       INTEGER NOT NULL,
  hwid_hash     TEXT NOT NULL,
  ip_hash       TEXT NOT NULL,
  roblox_user_id INTEGER,
  place_id      INTEGER,
  watermark_id  TEXT NOT NULL,
  created_at    INTEGER NOT NULL,
  expires_at    INTEGER NOT NULL
);

CREATE TABLE blacklist (
  id            TEXT PRIMARY KEY,
  kind          TEXT NOT NULL,          -- hwid | ip | roblox_user | discord
  value_hash    TEXT NOT NULL,
  reason        TEXT,
  created_by    TEXT NOT NULL,
  created_at    INTEGER NOT NULL
);

CREATE TABLE nodes (
  id            TEXT PRIMARY KEY,
  hostname      TEXT NOT NULL UNIQUE,
  region        TEXT,
  active        INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE protocol_versions (
  version       TEXT PRIMARY KEY,
  handler       TEXT NOT NULL,
  min_loader    TEXT,
  active        INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE checkpoints (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL,
  position      INTEGER NOT NULL,
  provider      TEXT NOT NULL,          -- linkvertise | lootlabs | custom
  config        TEXT NOT NULL
);

CREATE TABLE free_attempts (
  id            TEXT PRIMARY KEY,
  project_id    TEXT NOT NULL,
  fingerprint   TEXT NOT NULL,
  step          INTEGER NOT NULL,
  token_hash    TEXT NOT NULL,
  started_at    INTEGER NOT NULL,
  step_started_at INTEGER NOT NULL,
  completed_at  INTEGER
);

CREATE TABLE admins (
  id            TEXT PRIMARY KEY,
  discord_id    TEXT,
  role          TEXT NOT NULL,          -- owner | admin | reseller | support
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

CREATE TABLE events (
  id            TEXT PRIMARY KEY,
  key_id        TEXT,
  type          TEXT NOT NULL,          -- validate_ok | validate_fail | tamper | leak_suspect ...
  detail        TEXT,
  created_at    INTEGER NOT NULL
);
```

Indexes: `keys(key_hash)`, `keys(discord_id)`, `sessions(key_id, created_at)`, `events(key_id, created_at)`, `blacklist(kind, value_hash)`, `script_games(game_id)`.

### Key design

- Format: `PREFIX-XXXXX-XXXXX-XXXXX-XXXXX` from 128 bits of CSPRNG output, base32.
- Store only a hash (SHA-256 with a server pepper). Show the plaintext once at creation.
- Optional checksum character so typos fail before hitting the database.
- HWID is hashed with a per-project salt.

---

## 7. Module Assignments

Give each AI exactly one row. Send the whole document plus the assignment line.

| ID | Module | Primary sections | Depends on |
|----|--------|------------------|------------|
| M1 | **API core**: sync, status, check_key, auth init/payload, keys, sessions, blacklist, rate limits, admin API, node list | 5, 6, 8, 16 | contracts |
| M2 | **Database**: migrations, indexes, seed data, backup notes | 6 | contracts |
| M3 | **Loader SDK and crypto (Lua)**: sync client, check_key client, key cache file, init client, SHA-256, HMAC, stream cipher, signature verify, test vectors | 8, 9 | contracts, M1 interface |
| M4 | **Obfuscator front end**: Luau parser, AST, analysis, transforms | 10.1 to 10.2 (items 1, 2, 6) | contracts |
| M5 | **Obfuscator back end**: bytecode compiler, container format, differential test harness | 10.2 (items 3, 4), 10.3 | M4 interface |
| M6 | **VM runtime generator**: template, shuffled dispatch, constant decryption, integrity-linked keys | 10.2 (items 5 to 9) | M5 bytecode spec |
| M7 | **Anti-tamper, watermarking, leak tools** | 11, 12 | M3, M6 interfaces |
| M8 | **Discord bot** | 15 | M1 admin API |
| M9 | **Free-key flow** | 14 | M1 |
| M10 | **Payments and webhooks** | 17 | M1 |
| M11 | **Dashboard** | 16 | M1 admin API |
| M12 | **Ops**: logging, metrics, alerts, CI, deployment, multi-hostname nodes, runbooks | 18, 19 | all |
| M13 | **Loader stub generator and CDN init packaging**: unique stubs, init build pipeline, cache validation | 5.6, 8 | M3, M1 |
| M14 | **Reviewer**: audits other modules against contracts and security rules | all | all |

### Assignment line to append when sending

```
YOUR MODULE: <ID and name from the table>. Build only this module. Follow every rule in "READ FIRST" and every contract in "Shared Contracts".
```

### Suggested parallel waves

- **Wave 1:** M1, M2, M3, M4
- **Wave 2 (after interfaces are agreed):** M5, M8, M9, M10, M11, M13
- **Wave 3:** M6, M7, M12
- **Always last:** M14 over the merged output

### Reviewer prompt (M14, and for cross-checking any module)

```
You are a strict reviewer. Compare the submitted code against doc.md.
Check, in order:
1. Does it follow every Shared Contract exactly (field names, encodings, headers, error codes, labels)?
2. Is there any use of goto, hardcoded secret, plaintext key in a URL or log, or invented API?
3. Are there unused variables, dead code, or placeholder stubs presented as complete?
4. Are replay protection, timestamp skew handling, and uniform error responses implemented where required?
5. Are tests present, deterministic, and do they cover failure paths?
6. Security issues: injection, missing auth checks, race conditions (especially HWID binding), timing leaks, unbounded input.
7. Research: is there a Research Log with real, opened sources, versions, and dates? Spot-check at least 3 cited URLs and 3 API calls against current docs. Flag unbacked claims and fabricated or dead sources.
8. Clean-room: does anything copy a third-party service's code, constants, hash functions, endpoint names, or branding?
Return a numbered list of defects with file, line, severity (blocker/major/minor), and a concrete fix. Do not rewrite the whole module.
```

### Merge and integration checklist

- [ ] All modules use the same headers, envelope, error codes, and encodings.
- [ ] Test vectors in `/contracts` pass in both TypeScript and Lua.
- [ ] SDK completes sync, check_key, and a valid response signature check against the API.
- [ ] A fresh stub downloads, validates, caches, and runs the init script; a second run uses the cache.
- [ ] Loader decrypts a payload produced by the API for the same session.
- [ ] Obfuscator output runs under the VM runtime and matches the original script's behavior.
- [ ] Bot and dashboard only use documented admin endpoints.
- [ ] No module introduced a contract field without updating this document.
- [ ] Every module returned a Research Log with real sources, versions, and dates.
- [ ] Library and service choices are compatible across modules.
- [ ] Unverified items are resolved or recorded in Open Decisions.
- [ ] Every "done" claim has a command and output attached (section 22.1).
- [ ] Reviewer was a different model from the author and ran the tests itself.
- [ ] Real-environment executor tests are recorded for the current phase.
- [ ] Reviewer pass completed with no open blockers.

---

## 8. Loader Flow (Step by Step)

1. **Sync.** The SDK calls `/sync`, computes `offset = st - os.time()`, and keeps the node list. If the call fails, the SDK reports a generic network failure and stops.
2. **Status (optional).** The SDK calls `/status` and checks `active` and that its protocol version is listed. If not, it shows an update message.
3. **Key cache.** If a saved key file exists, the SDK offers that key first. The file stores only the key.
4. **Check key.** The SDK picks a node at random, sends `POST /check_key` with the common headers (5.2), and verifies `x-sig`. On `KEY_VALID` it exposes `note`, `auth_expire`, and `total_executions` to the calling script.
5. **Fetch stub.** The script fetches `/loaders/<script_id>.lua` and runs it. The server generates a unique stub.
6. **Init script.** The stub loads the cached init or downloads it from the CDN (5.6), validates it, and runs it.
7. **Auth init.** The init script generates an ephemeral X25519 key and a nonce, and sends `POST /auth/<script_id>/init`. The server checks:
   - key exists, active, not expired, not blacklisted (skipped when the script is keyless)
   - key is entitled to this script and this game
   - HWID (from executor-injected headers, see D10) is bound or can be bound
   - blacklist hits on HWID, IP, user id
   - rate limits, `x-ts` window, and nonce uniqueness
8. **Session.** The server creates a session with a `watermark_id`, derives the session key, and returns the encrypted session blob.
9. **Payload.** The init script calls `/auth/<script_id>/payload`. The server encrypts the bundle with a key derived from the session key, build hash, and watermark id.
10. **Run.** The init script decrypts, verifies `bundle_sig`, and hands the bytecode to the embedded VM runtime.
11. **Heartbeat (optional).** The server can end a running session if the key is revoked or flagged.

### Rules

- Every request carries `x-ts` and a one-time `x-nonce`; the server rejects stale or reused values.
- Failure messages shown to the user are generic. Details go to the server's event log.
- The SDK and init are rebuilt periodically so static signatures do not persist.

---

## 9. Cryptography Plan

| Need | Approach |
|------|----------|
| Response authenticity | Ed25519 signatures, public key embedded in SDK and init |
| Key agreement | X25519 ephemeral exchange |
| Payload encryption | ChaCha20-Poly1305 (or ChaCha20 + HMAC-SHA256) |
| Key derivation | HKDF-SHA256 |
| Hashing | SHA-256 with pepper/salt |
| Request proof | HMAC-SHA256 (5.2), explicitly a spam filter, not a trust anchor |
| Replay protection | `x-ts` window (with `/sync` offset) plus server-stored nonces |

### The pure-Lua problem (hard)

Executors give no guaranteed crypto library, so the loader needs its own primitives:

- SHA-256, HMAC, and ChaCha20 in pure Lua/Luau with `bit32` are fast enough.
- Ed25519 verification and X25519 are slow in pure Lua (bignum arithmetic). Options:
  1. Implement both once with optimized field arithmetic; cost is acceptable at load time.
  2. Use executor-native crypt functions when present and verify equivalence in tests.
  3. Fall back to HMAC with a per-build secret (weaker, because the secret ships in the loader).
- The choice is D2 and must be benchmarked on target executors.

### Test requirements

- Known-answer vectors for every primitive (RFC vectors), run against the Lua implementation in CI.
- Cross-implementation tests: TypeScript encrypts and Lua decrypts, and the reverse.

---

## 10. Custom VM Obfuscator (The Hard Part)

### 10.1 Pipeline

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

### 10.2 Components

1. **Parser.** Luau syntax is required: type annotations, `continue`, compound assignment, string interpolation, `if` expressions, generics. Use an existing Luau-capable parser or write one (D1).
2. **Semantic analysis.** Scope resolution, upvalue capture, vararg handling, method calls, multiple assignment and returns.
3. **Compiler to custom bytecode.** A register-based design (like Lua 5.1) maps well and is faster than stack-based.
   - Instruction set: loads, moves, table ops, arithmetic and comparison, concat, calls (varargs and multi-returns), closures and upvalues, loops, jumps, returns, `SETLIST`, length, not/neg.
   - Luau additions: `continue` lowering, compound ops lowered to base ops, integer division.
4. **Per-build randomization.** Opcode numbering, register allocation order where safe, instruction field order and widths, handler order and naming.
5. **VM runtime generator.** A template emitter that produces a different interpreter each build. Dispatch strategies vary per build: if/elseif chain, binary-search tree of comparisons, table of closures. No `goto`.
6. **Constant and string protection.** Constants stored encrypted and decrypted lazily. Per-function constant keys derived from a chain, so one decrypted function does not unlock others.
7. **Control-flow hardening.** Flattening via a state-variable dispatcher, opaque predicates, dead-code and junk-instruction insertion, instruction substitution.
8. **Nested VMs (optional, advanced).** Compile sensitive functions to a second, different VM.
9. **Runtime integrity.** Checksums over VM source and bytecode feed key derivation, so tampering corrupts decryption instead of tripping a detectable branch. The stub's per-fetch value (5.6) is mixed in.

### 10.3 Correctness testing (critical)

- Corpus of real scripts plus synthetic edge cases: varargs, multiple returns, nested closures and upvalues, metatables, coroutines, pcall/error, string methods, numeric edge cases, deep recursion, large tables, `table.unpack` with nils.
- Differential testing: run original and protected versions under the same Luau runtime and compare outputs and side effects.
- Fuzzing: random program generator for the supported subset.
- Performance benchmarks: slowdown ratio per script type, with a per-function opt-out (`--@novm`) for hot loops.
- Every build produces a manifest (opcode seed, version, hash) stored server-side for debugging.

### 10.4 Realistic limits

A VM raises the cost of static analysis, but a skilled attacker can still instrument the runtime. Combine it with watermarking and server-side detection.

---

## 11. Anti-Tamper and Environment Checks

Goal: raise effort and generate signals, not guarantee safety.

- Verify critical functions are native and unmodified where detectable (`loadstring`, `request`, `getfenv`, debug functions).
- Detect common instrumentation: hooked HTTP functions, remote-spy wrappers, debug hooks.
- Verify environment consistency (expected globals, executor identification, version).
- Timing sanity checks (single-stepping inflates timings).
- Integrity checksums feed key derivation (10.2 item 9).
- Silent failure: on a failed check, report a `tamper` event to the server and load nothing, with no explanatory message.
- Server-side correlation: repeated tamper events plus HWID churn raises an abuse score.
- Note: the observed reference flow shows that HTTP spies can see the SDK's requests in plain form. Treat request contents as visible to the user and rely on encryption and server-side checks.

---

## 12. Watermarking and Leak Tracing

- Each session gets a unique `watermark_id`.
- The server mixes the watermark into the delivered payload in semantically neutral ways: constant encoding order, junk-instruction patterns, key-derivation salts, identifier fragments inside encrypted constants.
- `sessions` maps `watermark_id` to `key_id`.
- Leak workflow:
  1. Receive a leaked dump.
  2. Run the extractor to recover the watermark.
  3. Look up the session and key.
  4. Auto-revoke, blacklist HWID/IP/user id, write to the audit log, notify an admin channel.
- Build the watermark extractor as a first-class tool and test that it survives renaming and reformatting.
- Each payload is unique, so a leaked file from one user cannot serve as a generic cracked loader.

---

## 13. Service Responsibilities by Layer

| Layer | Public? | Contains | Must never contain |
|-------|---------|----------|--------------------|
| SDK | Yes | Sync, check_key client, key cache, verification public key | Script code, private keys |
| Stub | Yes (unique per fetch) | Per-fetch data, cache logic | Script code |
| Init (CDN) | Yes (static, cached) | Crypto, handshake client, VM runtime loader | Script code, secrets |
| Payload | Per session, encrypted | Protected script bytecode | Anything usable without the session key |

---

## 14. Free Key System

1. A free-key page per project slug starts an attempt. The server creates a `free_attempts` row with an opaque token bound to a fingerprint (HWID hash and IP hash).
2. Each checkpoint provider (Linkvertise, Lootlabs, others) redirects back with a completion token.
3. The server verifies each step:
   - token matches the attempt and step order
   - minimum time elapsed since step start
   - provider-side verification where an API exists
   - one attempt per fingerprint per cooldown window
4. After the final step, `claim` issues a time-limited free key.
5. Anti-bypass: single-use short-lived tokens bound to IP and fingerprint, random step secrets per attempt, monitoring for abnormal completion speed.
6. Tier `free` controls which features stay gated.

---

## 15. Discord Bot

User commands: `/redeem`, `/getscript`, `/status`, `/resethwid`, `/free`, `/mykeys`.

Admin commands: `/key create`, `/key revoke`, `/key extend`, `/key info`, `/blacklist add`, `/whitelist`, `/stats`, `/leak lookup`.

- Linking a Discord ID to a key on redeem. Roles are granted for active keys and removed on expiry or revoke.
- HWID reset has a cooldown per key and a monthly cap, and is audit-logged.
- Anything containing a key or script uses ephemeral responses.
- Admin permission checks happen server-side via the admin API.
- Scheduled job for expiry reminders and role cleanup.

---

## 16. Admin API and Dashboard

### Admin API

| Endpoint | Purpose |
|----------|---------|
| `POST /admin/keys` | Create one or bulk |
| `PATCH /admin/keys/:id` | Extend, change tier, edit note |
| `POST /admin/keys/:id/revoke` | Revoke |
| `POST /admin/keys/:id/reset-hwid` | Reset with cooldown and counter |
| `POST /admin/blacklist` | Add entry |
| `POST /admin/scripts/:id/versions` | Upload new build |
| `POST /admin/scripts/:id/activate` | Switch active version, rollback |
| `POST /admin/nodes` | Add or disable an auth hostname |
| `POST /admin/protocol-versions` | Register or retire a protocol version |
| `GET /admin/analytics/*` | Stats |
| `GET /admin/audit` | Audit log |

### Dashboard pages

Overview, Keys (search, filter, bulk actions, import/export), Scripts (upload, build status, versions, activate/rollback, game routing), Users (Discord link, HWID and session history), Blacklist, Leak tools, Audit log, Resellers, Nodes and protocol versions, Settings (signing key rotation, webhooks, rate limits).

Auth: Discord OAuth plus optional TOTP. Every mutation produces an audit entry.

---

## 17. Payments

- Webhook verifies the provider signature and idempotency key.
- On confirmed payment: create key, assign scripts, deliver by DM or email, store the order reference.
- Refunds and chargebacks revoke the key and optionally blacklist.
- A reconciliation job compares provider orders to issued keys.

---

## 18. Security of the Service Itself

- Cloudflare in front: WAF, DDoS protection, bot rules on public endpoints.
- Rate limits per IP, per key, per HWID, per project; escalating lockouts on invalid keys.
- Secrets in the platform secret store with a rotation procedure.
- Signing keys: separate keypair per project, verification key embedded in SDK and init builds, rotation with a window where the server signs with both.
- Admin tokens scoped and hashed; short-lived dashboard sessions.
- Strict input validation and body size limits on every endpoint.
- Database least privilege; encrypted backups; tested restores.
- Separate staging and production.
- Dependency scanning and pinned versions in CI.
- Keys, tokens, and HWIDs never in URLs or logs.

---

## 19. Operations

- Structured logs with request ids; no plaintext keys.
- Metrics: sync and check_key success rates, auth latency, tamper events, free-flow conversion, build failures, CDN hit ratio for init files.
- Alerts: failure spikes, many HWIDs per key, signing errors, webhook failures, error budget breaches.
- Status page and an outage plan: when the API is unreachable the loader does not run the script.
- Daily backups with retention; disaster recovery runbook.
- Versioned API with a minimum-loader-version gate (`UPDATE_REQUIRED`), driven by `protocol_versions`.
- Multi-hostname setup: at least two hostnames behind Cloudflare so one blocked domain does not stop the service.
- Load test before launch.

---

## 20. Open Decisions (Resolve Before Coding Each Area)

| # | Decision | Options | Blocking |
|---|----------|---------|----------|
| D1 | Luau parser | existing library vs custom | Obfuscator |
| D2 | Ed25519 and X25519 in loader | pure Lua vs executor native vs HMAC fallback | Crypto |
| D3 | Database | D1 vs Postgres | Backend |
| D4 | Bytecode model | register-based vs stack-based | Compiler |
| D5 | Free-key providers | which providers and their verification APIs | Free flow |
| D6 | Payment provider | which one and its webhook format | Payments |
| D7 | Target executors | which environments must work | Loader |
| D8 | Scripts per key model | single script vs multi-script entitlements | Schema |
| D9 | Offline behavior | strict deny vs short grace cache | Loader |
| D10 | HWID source | executor-injected identity headers (names per executor), script-supplied value, or both; spoofing risk of each | API, SDK |
| D11 | Single hostname vs multi-node from day one | one anycast hostname, or several | Ops |
| D12 | Init cache location and validation | folder name, hash check, behavior when write is unavailable | Stub |

---

## 21. Roadmap

### Phase 1: Core (weeks 1-2)
- [ ] Repo, CI, environments
- [ ] Schema and migrations
- [ ] Key generation, hashing, `check_key` endpoint
- [ ] `/sync` and `/status`
- [ ] Admin API for keys
- [ ] Basic SDK: sync, check_key, key cache file (plain, no crypto yet)

### Phase 2: Delivery (weeks 3-4)
- [ ] Stub generator and static init on CDN
- [ ] Init cache with validation
- [ ] Script storage and gated delivery (unencrypted, test only)
- [ ] HWID capture via executor headers (after D10)

### Phase 3: Secure Channel (weeks 5-6)
- [ ] Pure-Lua SHA-256, HMAC, stream cipher with test vectors
- [ ] Signed responses and SDK verification
- [ ] X25519 handshake and session keys
- [ ] Nonce and timestamp replay protection with sync offset
- [ ] Per-session encrypted payloads
- [ ] Rate limiting and invalid-key lockouts

### Phase 4: Discord and Operations (weeks 7-8)
- [ ] Bot: user and admin commands, role sync
- [ ] HWID reset with cooldown
- [ ] Audit log, event logging, alerts
- [ ] Blacklist system

### Phase 5: Free Keys and Payments (weeks 9-10)
- [ ] Checkpoint flow with server-side verification
- [ ] Anti-bypass timing and token binding
- [ ] Payment webhook and auto issue
- [ ] Refund and chargeback handling

### Phase 6: Obfuscator Foundations (weeks 11-14)
- [ ] Parser decision and implementation
- [ ] AST transforms
- [ ] Bytecode design and compiler
- [ ] VM runtime template
- [ ] Differential test harness and corpus

### Phase 7: Obfuscator Hardening (weeks 15-18)
- [ ] Per-build opcode and encoding randomization
- [ ] Generated, shuffled VM runtime
- [ ] Constant encryption with key chains
- [ ] Control-flow flattening, opaque predicates, junk insertion
- [ ] Integrity-linked key derivation
- [ ] Performance tuning and `@novm` opt-out

### Phase 8: Tamper, Watermark, Leak Tools (weeks 19-21)
- [ ] Environment and instrumentation checks
- [ ] Silent tamper reporting
- [ ] Watermark injection and extractor
- [ ] Leak response workflow

### Phase 9: Dashboard and Resellers (weeks 22-24)
- [ ] Dashboard pages
- [ ] Reseller roles and quotas
- [ ] Analytics views

### Phase 10: Launch Readiness (weeks 25-26)
- [ ] Load and abuse testing
- [ ] Key rotation drill
- [ ] Backup restore drill
- [ ] Status page
- [ ] Docs for admins and script developers

---

## 22. Testing Strategy

| Area | Tests |
|------|-------|
| Crypto | RFC known-answer vectors, cross-language round trips |
| API | Unit and integration tests, replay and expiry cases, concurrency on HWID bind |
| SDK and stub | Behavior under failures, bad signatures, clock skew (using sync offset), network errors, cache corruption |
| Obfuscator | Differential tests, fuzzing, performance regression suite |
| Free flow | Bypass attempts: replay, skipped steps, fast completion, multi-account |
| Security | Brute-force simulation, malformed input, auth boundary tests, keys-in-URL scan |
| Ops | Chaos tests: DB down, blob store down, signing key missing, one node unreachable |

### 22.1 Verification Requirements (guards against "claimed done, never proven")

**Principle:** a module is done only when its claims were checked by something other than the AI that wrote it.

**Rules for every AI**
- State exactly what you ran and the output. If you could not run something, say "not run" and why. Never write "should work" or "tested" without a command and a result.
- Do not write tests that only restate your own implementation. Tests must come from an outside source: RFC vectors, the original script's behavior, a spec, or a second implementation.
- Do not report a partial solution as complete. List the cases you did not cover (for example varargs, upvalues, replay, clock skew, cache corruption).
- If an approach fails, report the failure and the counterexample. Do not quietly switch to an easier problem.

**Independent review**
- The reviewer (M14) must be a different model or provider from the module's author.
- Reviewers must run the tests themselves, not read the author's claim that they pass.
- Anything security-critical (crypto, key validation, HWID binding, replay protection) gets two independent reviews.
- Disagreements between reviewers go to Open Decisions instead of being resolved by guesswork.

**Real-environment tests (done by a human on real executors; AIs cannot do these)**

| Test | What to record |
|------|----------------|
| SDK sync + check_key on each target executor | Pass/fail, latency, any missing functions |
| Executor identity headers on `request` | Which header names each executor injects (feeds D10) |
| Stub cache: first run, second run, corrupted cache file, no write permission | Behavior and error messages |
| Pure-Lua crypto speed (SHA-256, ChaCha20, X25519, Ed25519 verify) | Milliseconds per operation on low-end and high-end executors |
| Full load of a protected script | Total load time, memory use, correct behavior vs unprotected original |
| Clock skew (set device time wrong by minutes) | Auth still works via `/sync` offset |
| Network failure mid-load, blocked node, blocked domain | Generic failure message, no crash, no partial script load |
| HTTP spy on the finished flow | Confirm no key, secret, or usable script appears in plaintext in any logged request or response |

**Obfuscator proof of correctness**
- Differential test every release against the full corpus; any mismatch blocks the release.
- Report slowdown per script type with numbers.
- Keep a failing-case list. A case that fails is fixed or documented, never dropped.

**Human sign-off checklist (before each phase is marked done)**
- [ ] Every claim in the AI's summary has a command and an output attached.
- [ ] Tests were run by someone other than the author.
- [ ] Real-environment tests for this phase are recorded in a table with dates and executors.
- [ ] Known gaps are listed, not hidden.

---

## 23. Definition of Done

- A key can be created, redeemed, bound to a HWID, extended, reset, and revoked end to end.
- The SDK performs sync and `check_key` with corrected time and verified signatures.
- The stub is unique per fetch, and the init script is cached and validated on disk.
- The real script is never retrievable without passing server validation.
- Every payload is encrypted per session and uniquely watermarked.
- A tampered or replayed request fails safely and is logged.
- The obfuscator passes differential tests on the full corpus with a documented performance cost.
- A leaked payload traces to a key and that key can be auto-revoked.
- Admin actions are audited; secrets rotate without downtime.
- Runbooks exist for outage, key rotation, and restore.
