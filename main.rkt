; Group 3: Cameron Harter, (add your names here!)
; Click run and the web server will start automatically with the website popping up automatically
; Reference: https://docs.racket-lang.org/continue/index.html
#lang web-server/insta

; The body of a "post"
(struct post (title body))

(define posts
  (post "Post 2"
   ))





; |==============================|
; | HTML RENDERING               |
; |==============================|
; There are multiple ways to render the HTML (Follow section 4 for different ways!)
; Uncomment the function you want to use!

; ==========================
; | X-expression - Function|
; ==========================
; DESCRIPTION: This is the "simplest" way of rendering the HTML,
; by converting quotation marks (" ") into body text but the
; drawback is you can only do body text with this rendering.

;(define xexpr/c
;  (flat-rec-contract
;   xexpr
;   (or/c string?
;         (cons/c symbol? (listof xexpr))
;         (cons/c symbol?
;                 (cons/c (listof (list/c symbol? string?))
;                         (listof xexpr))))))
; ==============================================================

; =================
; | X-expression |
; =================
; DESCRIPTION: This is the "simplest" way of rendering the HTML,
; by converting quotation marks (" ") into body text but the
; drawback is you can only do body text with this rendering.

;(define xexpr/c
;  (flat-rec-contract
;   xexpr
;   (or/c string?
;         (cons/c symbol? (listof xexpr))
;         (cons/c symbol?
;                 (cons/c (listof (list/c symbol? string?))
;                         (listof xexpr))))))
; ==============================================================

