;; Bitcoin fungible token on Stacks (demo) - SIP-010 style interface
;; This contract represents a BTC-like token on Stacks. Mint/Burn are restricted to the admin (deployer by default).

(define-trait sip-010-ft-standard
  (
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-balance (principal) (response uint uint))
    (get-total-supply () (response (optional uint) uint))
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
  )
)

;; Underlying token
(define-fungible-token btc)

;; Admin is set to the deployer at publish time
(define-data-var admin principal tx-sender)

;; Errors
(define-constant ERR-NOT-AUTHORIZED u100)

;; Token metadata
(define-constant TOKEN-NAME "Bitcoin")
(define-constant TOKEN-SYMBOL "BTC")
(define-constant TOKEN-DECIMALS u8)

;; SIP-010 required read-onlys
(define-read-only (get-name)
  (ok TOKEN-NAME)
)

(define-read-only (get-symbol)
  (ok TOKEN-SYMBOL)
)

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS)
)

(define-read-only (get-total-supply)
  (ok (some (ft-get-supply btc)))
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance btc who))
)

;; SIP-010 required transfer
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (if (is-eq tx-sender sender)
      (begin
        (try! (ft-transfer? btc amount sender recipient))
        (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
  )
)

;; Admin helpers
(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-public (set-admin (new-admin principal))
  (if (is-eq tx-sender (var-get admin))
      (begin
        (var-set admin new-admin)
        (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
  )
)

;; Mint/Burn restricted to admin
(define-public (mint (amount uint) (recipient principal))
  (if (is-eq tx-sender (var-get admin))
      (begin
        (try! (ft-mint? btc amount recipient))
        (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
  )
)

(define-public (burn (amount uint) (sender principal))
  (if (is-eq tx-sender (var-get admin))
      (begin
        (try! (ft-burn? btc amount sender))
        (ok true)
      )
      (err ERR-NOT-AUTHORIZED)
  )
)
