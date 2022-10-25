
(define-data-var counter int 0)
(define-data-var total-counts int 0)
(define-map counts principal { previous-value: int, current-value: int })

;; increment by one
(define-public (increment)
    (let
        (
            (previous-value (var-get counter))
            (current-value (+ previous-value 1))
        )
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter current-value)
        (print block-height)
        (ok (var-get counter))
    )
)

;; decrement by one
(define-public (decrement)
    (let
        (
            (previous-value (var-get counter))
            (current-value (- previous-value 1))
        )
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter current-value)
        (print block-height)
        (ok (var-get counter))
    )
)

;; increment by even numbers
(define-public (increment-by-even-numbers (even-number int))
    (let
        (
            (previous-value (var-get counter))
            (current-value (+ (var-get counter) even-number))
        )
        (asserts! (is-eq (is-even-or-odd even-number) "even") (err "increment only by even numbers"))
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter (+ previous-value even-number))
        (print block-height)
        (ok (var-get counter))
    )
)

;; decrement by even numbers
(define-public (decrement-by-even-numbers (even-number int))
    (let
        (
            (previous-value (var-get counter))
            (current-value (- (var-get counter) even-number))
        )
        (asserts! (is-eq (is-even-or-odd even-number) "even") (err "increment only by even numbers"))
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter (- previous-value even-number))
        (print block-height)
        (ok (var-get counter))
    )
)

;; increment by odd numbers
(define-public (increment-by-odd-numbers (odd-number int))
    (let
        (
            (previous-value (var-get counter))
            (current-value (+ (var-get counter) odd-number))
        )
        (asserts! (is-eq (is-even-or-odd odd-number) "odd") (err "increment only by odd numbers"))
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter (+ previous-value odd-number))
        (print block-height)
        (ok (var-get counter))
    )
)

;; decrement by odd numbers
(define-public (decrement-by-odd-numbers (odd-number int))
    (let
        (
            (previous-value (var-get counter))
            (current-value (- (var-get counter) odd-number))
        )
        (asserts! (is-eq (is-even-or-odd odd-number) "odd") (err "increment only by odd numbers"))
        (var-set total-counts (+ (var-get total-counts) 1))
        (map-set counts tx-sender { previous-value: previous-value, current-value: current-value })
        (var-set counter (- previous-value odd-number))
        (print block-height)
        (ok (var-get counter))
    )
)

;; get how many counts has been made
(define-read-only (get-total-counts) 
    (var-get total-counts)
)

;; get your latest count
(define-read-only (get-recent-count)
    (map-get? counts tx-sender)
)

;; get count at past blocks
(define-read-only (get-count-at-past-block (block uint))
    (at-block 
        (unwrap! (get-block-info? id-header-hash block) (err none)) 
        (ok (map-get? counts tx-sender))
    )
)

;; check if a number is even or odd
(define-read-only (is-even-or-odd (n int)) 
    (if (is-eq (mod n 2) 0) 
        "even" 
        "odd"
    )
)
