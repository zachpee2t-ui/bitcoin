# Clarinet BTC (demo)

A minimal Clarinet project implementing a BTC-like fungible token (SIP-010 style) on Stacks. The token is named `Bitcoin` with symbol `BTC` and 8 decimals. Mint/Burn are restricted to the contract admin (the deployer by default).

> Note: This is a demo token for development/testing, not a bridge to mainchain Bitcoin.

## Project structure

```
clarinet-btc/
├─ Clarinet.toml
├─ contracts/
│  └─ bitcoin.clar
```

## Requirements

- Clarinet installed: https://github.com/hirosystems/clarinet

## Quickstart

From this directory:

```sh
clarinet check
```

Open a console to interact:

```sh
clarinet console
```

In the console, you can call the contract functions, e.g. (replace `ST...` with actual principals from the console):

```clarity
(contract-call? .bitcoin get-name)
(contract-call? .bitcoin get-symbol)
(contract-call? .bitcoin get-decimals)
(contract-call? .bitcoin get-total-supply)

;; Admin (deployer) mints 1 BTC (1e8 base units) to themselves
(contract-call? .bitcoin mint u100000000 tx-sender)

;; Check balance
(contract-call? .bitcoin get-balance tx-sender)

;; Transfer 0.1 BTC from sender to recipient
(contract-call? .bitcoin transfer u10000000 tx-sender 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA none)
```

## Admin functions

- `get-admin` — returns current admin principal
- `set-admin` — change admin (only callable by current admin)
- `mint` — mint tokens to a recipient (only admin)
- `burn` — burn tokens from a sender (only admin)

## Notes

- Decimals are set to `8` to mirror Bitcoin’s 8 decimal places.
- `transfer` follows the SIP-010 signature and enforces that `tx-sender` equals the `sender` argument.
- This contract includes a local definition of the SIP-010 trait and implements the required functions.
