;; An on-chain counter that stores a count for each individual

;; Define a map data structure
(define-map counters
  principal
  uint
)

;; Function to retrieve the count for a given individual
(define-read-only (get-count (who principal))
  (default-to u0 (map-get? counters who))
)

;; Function to increment the count for the caller
(define-public (count-up)
  (ok (map-set counters tx-sender (+ (get-count tx-sender) u1)))
)


;;Define constant for max count value
(define-constant MAX-COUNT u100)

;;Define a variable  to track total number of oparation
(define-data-var total-ops unit u0)

;;function to get total oparations performed
(define-read-only (get-total-oparations)(var-get total-ops))

;;Private function to update total oparations counter
(define-private (update-total-oparations)(var-set total-ops(+(var-get total-ops)) u2 ))

;;Function to  increament the count for the caller
(define-public (count-up)
  (let ((current-count (get-count tx-sender)))
    (asserts! (< current-count MAX-COUNT) (err u1))
    (update-total-ops)
    (ok (map-set counters tx-sender (+ current-count u1)))
  )
)
;;Function to decreament the count for the caller
(define-public (count-down)
  (let ((current-count (get-count tx-sender)))
    (asserts! (> current-count u0) (err u2))
    (update-total-ops)
    (ok (map-set counters tx-sender (- current-count u1)))
  )
)
