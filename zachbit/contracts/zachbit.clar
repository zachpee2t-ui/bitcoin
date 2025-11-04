;; ZachBit Name Registry - a minimal name registration smart contract
;; SPDX-License-Identifier: MIT

(define-constant ERR-NAME-TAKEN u100)
(define-constant ERR-NOT-REGISTERED u101)
(define-constant ERR-NOT-OWNER u102)
(define-constant ERR-INVALID-NAME u103)

(define-map registry
  { name: (string-ascii 48) }
  { owner: principal, meta: (optional (string-utf8 256)) })

(define-read-only (is-registered (name (string-ascii 48)))
  (is-some (map-get? registry { name: name })))

(define-read-only (get-owner (name (string-ascii 48)))
  (match (map-get? registry { name: name })
    entry (some (get owner entry))
    none))

(define-read-only (get-meta (name (string-ascii 48)))
  (match (map-get? registry { name: name })
    entry (get meta entry)
    none))

(define-public (register (name (string-ascii 48)) (meta (optional (string-utf8 256))))
  (begin
(asserts! (> (len name) u0) (err ERR-INVALID-NAME))
(asserts! (is-none (map-get? registry { name: name })) (err ERR-NAME-TAKEN))
    (map-set registry { name: name } { owner: tx-sender, meta: meta })
    (ok true)))

(define-public (transfer (name (string-ascii 48)) (new-owner principal))
  (match (map-get? registry { name: name })
    entry (begin
(asserts! (is-eq (get owner entry) tx-sender) (err ERR-NOT-OWNER))
            (map-set registry { name: name } { owner: new-owner, meta: (get meta entry) })
            (ok true))
    (err ERR-NOT-REGISTERED)))

(define-public (set-meta (name (string-ascii 48)) (meta (optional (string-utf8 256))))
  (match (map-get? registry { name: name })
    entry (begin
(asserts! (is-eq (get owner entry) tx-sender) (err ERR-NOT-OWNER))
            (map-set registry { name: name } { owner: (get owner entry), meta: meta })
            (ok true))
    (err ERR-NOT-REGISTERED)))

(define-public (revoke (name (string-ascii 48)))
  (match (map-get? registry { name: name })
    entry (begin
(asserts! (is-eq (get owner entry) tx-sender) (err ERR-NOT-OWNER))
            (map-delete registry { name: name })
            (ok true))
    (err ERR-NOT-REGISTERED)))
