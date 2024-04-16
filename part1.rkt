; Group 5: Cameron Harter
; Click run and the web server will start automatically with the website popping up automatically
; Reference: https://docs.racket-lang.org/continue/index.html
#lang web-server/insta

; WHEN EDITING CODE BE SURE TO USE THE
; ` (back-quote) INSTEAD OF ' (single-quote) if you're editing HTML code
; ' (single-quotes) if you're checking an HTML variable.


; ==============
; | Structures |
; ==============
; This section contains the "building blocks" of the website
(struct post (title body))


; ====================
; | Content of Blog  |
; ====================
; This sections *mostly* contain the text that will show up on the blog.
; Headers and the title can be found in the rendering portion of this code.
(define BLOG
  (list (post "How are you doing today?" "Comment below on how your doing today!")
        (post "Welcome to the new blog!" "This is a brand new post!")))



; ====================
; | main() or start |
; ====================
; This section contains where the website always begins to get its content from

; start
; DESCRIPTION: This program starts the web server locally,and is always required.
(define (start request)
  (render-blog-page BLOG request))



; ==============================
; | HTML structure of the blog |
; ==============================
; This section contains the structure of the blog.
; (Side note: xexper consumes requests and produces HTML code from them)

; render-blog-page
; DESCRIPTION: This renders the title and top of the blog, and the requests
(define (render-blog-page blog-posts request)

  ; response-generator
  ; DESCRIPTION: 
  (define (response-generator embed/url)
    (response/xexpr
     `(html

       ; Header
       (head (title "Group 5's Blog"))

       ; Body
       (body
        ; HTML Title
        (h2 "Group 5's Blog")
        (h3 "Welcome!")

        ; Blog post rendering
        ,(render-posts blog-posts)
        ))))

  ; This consumes a response-gathering function and gives it an embed/url function.
  ; This transforms and builds functions into special URLs with links.
  (send/suspend/dispatch response-generator)
)

; ===================================
; | HTML Rendering Helper Functions |
; ===================================
; This section contains the functions that renders the racket code into HTML.
; (Side note: xexper consumes requests and produces HTML code from them)

; render-post
; DESCRIPTION: Takes an argument that has a post struct and renders it in HTML as a div. 
(define (render-post blog-post)
  `(div ((class "post"))
        ,(post-title blog-post)
        (p ,(post-body blog-post))))

; render-posts
; DESCRIPTION: Takes an xexpr argument and renders multiple posts from it.
(define (render-posts blog-posts)
  `(div ((class "posts"))
        ,@(map render-post blog-posts)))
       ; ^ The @ here splices the list of xexpr
; ==============================================================
