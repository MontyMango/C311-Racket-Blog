; Group 3: Cameron Harter, 
; Click run and the web server will start automatically with the website popping up automatically

#lang web-server/insta
(define (start request)
  (response/xexpr
   '(html
     ; HTML Head
     (head
      (title "Group 4's Blog")
      )

     ; HTML Body
     (body
      (h1 "This website is under construction!")
     )
    )
  )
)

; Below here is some syntax that will be used in this program
; Reference: https://docs.racket-lang.org/continue/index.html


; #3: Basic Blog
; (define BLOG (list (post "First Post!" "Hey, this is my first post!")))