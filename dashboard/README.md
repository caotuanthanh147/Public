# Dashboard (module M11)

Admin web UI for the Self-Hosted Lua Script Licensing and Protection Platform
(doc.md §16). Next.js 16 + Tailwind 4 + shadcn/ui.

The dashboard drives the REAL api/ router (modules M1 + M9): the dev harness
(`/api/gw/*` route) imports `../api/src` and dispatches in-process over
node:sqlite, so every mutation rendered here is an actual audited admin call.
Production talks to the Workers deployment instead.

## Run (local)

```
bun install
bun run dev        # http://localhost:3000
```

Local dev mode (`DASH_DEV_MODE`, default on) auto-authenticates the seeded
owner admin so the demo works without credentials. For production-style
auth set `DASH_DEV_MODE=false` and use an admin token (Settings → login),
Discord OAuth (`DASH_DISCORD_CLIENT_ID` / `DASH_DISCORD_CLIENT_SECRET`), and
the optional TOTP second factor.

## Layout

- `src/app/api/gw/[...path]/route.ts` — gateway to the real api/ router
- `src/app/api/dash/*` — login/logout (token + TOTP), Discord OAuth
  (state-checked), info, demo key validation, TOTP enrollment
- `src/server/` — in-process store (doc §6 schema via api/src/db.ts
  DOC_SCHEMA_SQL + dash_totp), session cookies, sqlite handle
- `src/components/dashboard/` — the §16 pages: Overview, Keys, Scripts,
  Sessions, Blacklist, Audit, Nodes & protocol, Free-key flow (M9 public
  page), Settings
- `src/lib/` — typed API client + shared useApiData hook

Docs: RESEARCH-M11.md, DECISIONS-M11.md, ../api/VERIFICATION-M9-M11.md,
../api/CCP-M9-M11.md (read endpoints + totp column proposals).
