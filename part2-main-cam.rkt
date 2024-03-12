; Group 3: Cameron Harter
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

; post
; DESCRIPTION:  
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
; DESCRIPTION: This program starts the web server locally,
; and is always required.
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

        ; Blog post submission box
        (b "Input your title and message into the boxes below:")
        (form
         ((action
           ,(embed/url insert-post-handler)))
         (input ((name "title")))
         (input ((name "body")))
         (input ((type "submit"))))
        ))))

  ; insert-post-handler
  ; DESCRIPTION: 
  (define (insert-post-handler request)
    (render-blog-page
     (cons (parse-post (request-bindings request))
           blog-posts)
     request))

  ; This consumes a response-gathering function and gives it an embed/url function.
  ; This transforms and builds functions into special URLs with links.
  (send/suspend/dispatch response-generator)
  
  ; "What makes these URLs special is this:
  ; when a web browser visits one of them, our web application restarts,
  ; not from start, but from the handler that we associate with the URL.
  ; In the handler phase-1, the use of embed/url associates the link with
  ; the handler phase-2, and vice versa."
)


; ======================
; | Request inspection |
; ======================

; can-parse-post?
; DESCRIPTION: Checks to see if the POST can be parsed
(define (can-parse-post? binding)
  (and (exists-binding? 'title binding)
       (exists-binding? 'body binding))
)

; parse-post
; DESCRIPTION: Takes a post binding and parses it, creating a new post.
(define (parse-post bindings)
  (post (extract-binding/single 'title bindings)
       (extract-binding/single 'body bindings))
)

; ====================================================
; | HTML Rendering Helper Functions (From section 4) |
; ====================================================
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

; render-as-itemized-list
; DESCRIPTION: Takes a list and renders it as an unordered list (or ul in HTML).
;(define (render-as-itemized-list fragments)
;  `(ul ,@(map render-as-item fragments)))
      ; ^ The @ here splices the list of xexpr 

; render-as-item
; DESCRIPTION: Takes an xexper and renders it as a list item (or ol in HTML)
;(define (render-as-item a-fragment)
;  `(li ,a-fragment))

; ==============================================================
