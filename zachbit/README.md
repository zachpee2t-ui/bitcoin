# ZachBit — Clarity smart contract (Clarinet)

A minimal name registry smart contract for the Stacks blockchain. It lets accounts register a unique name, update optional metadata, transfer ownership, and revoke a name.

## Prerequisites
- Clarinet >= 3.7
- Node.js (optional, for the Clarinet-provided TS tooling in this scaffold)

## Quick start
```bash
cd zachbit
clarinet check
```

## Contract overview
Contract file: `contracts/zachbit.clar`

Data model:
- `registry` map: `{ name: string-ascii(48) } -> { owner: principal, meta: (optional string-utf8(256)) }`

Errors:
- `u100` — name already registered
- `u101` — name not registered
- `u102` — caller is not the owner
- `u103` — invalid name (empty)

Public functions:
- `(register (name string-ascii(48)) (meta (optional string-utf8(256)))) -> (response bool uint)`
- `(transfer (name string-ascii(48)) (new-owner principal)) -> (response bool uint)`
- `(set-meta (name string-ascii(48)) (meta (optional string-utf8(256)))) -> (response bool uint)`
- `(revoke (name string-ascii(48))) -> (response bool uint)`

Read-only functions:
- `(is-registered (name string-ascii(48))) -> bool`
- `(get-owner (name string-ascii(48))) -> (optional principal)`
- `(get-meta (name string-ascii(48))) -> (optional string-utf8(256))`

## Examples (Clarinet console)
Start the console from this directory:
```bash
clarinet console
```
Then call the contract (the contract identifier is `.zachbit`):
```clojure
(contract-call? .zachbit register "alice" (some "Alice profile"))
(contract-call? .zachbit set-meta "alice" (some "Updated"))
(contract-call? .zachbit transfer "alice" tx-sender)
(contract-call? .zachbit revoke "alice")

;; Read-only
(contract-call? .zachbit is-registered "alice")
(contract-call? .zachbit get-owner "alice")
(contract-call? .zachbit get-meta "alice")
```

## Scripts
- `clarinet check` — typecheck and validate all contracts
- `clarinet console` — interactive REPL for calling contract functions
- `clarinet test` — run tests under `tests/` (none included yet)

## Install Clarinet (if needed)
- macOS (Homebrew): `brew install hirosystems/clarinet/clarinet`
- Linux (install script): `curl --proto '=https' --tlsv1.2 -sSf https://get.hiro.so/clarinet/install.sh | sh`
  - Ensure `~/.clarinet/bin` is on your `PATH`.

## Project layout
- `Clarinet.toml` — Clarinet project configuration
- `contracts/` — Clarity contracts (add your own here)
- `settings/` — network configs (Devnet/Testnet/Mainnet)
- `tests/` — contract tests (Vitest + TS scaffold)
