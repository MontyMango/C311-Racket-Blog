; Group 5: Angel Perez
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

(struct blog (posts) #:mutable)
 

; ====================
; | Content of Blog  |
; ====================
; This sections *mostly* contain the text that will show up on the blog.
; Headers and the title can be found in the rendering portion of this code.

(define BLOG
  (blog
   (list (post "Second Post" "This is another post")
         (post "First Post" "This is my first post"))))

 
; ====================
; | main() or start |
; ====================
; This section contains where the website always begins to get its content from

; start
; DESCRIPTION: This program starts the web server locally, and is always required.
(define (start request)
  (render-blog-page request))
 
; parse-post: bindings -> post
; Extracts a post out of the bindings.
(define (parse-post bindings)
  (post (extract-binding/single 'title bindings)
        (extract-binding/single 'body bindings)))
 
; ==============================
; | HTML structure of the blog |
; ==============================
; This section contains the structure of the blog.
; (Side note: xexper consumes requests and produces HTML code from them)

; render-blog-page
; DESCRIPTION: This renders the title and top of the blog, and the requests
; Produces an HTML page of the content of the BLOG.
(define (render-blog-page request)

  ; response-generator
  ; DESCRIPTION: 
  (define (response-generator embed/url)
    (response/xexpr

  ; Header
     `(html (head (title "Group 5's Blog"))

  ; Body
            (body
  ; HTML Title
             (h1 "Group 5's Blog")

  ; Blog post rendering
             ,(render-posts)

  ; Blog post submission box
             (b "Input your title and message into the boxes below:")
             (form ((action
                     ,(embed/url insert-post-handler)))
                   (input ((name "title")))
                   (input ((name "body")))
                   (input ((type "submit"))))))))

  ; insert-post-handler
  ; DESCRIPTION: This handles inserting posts into the blog
  (define (insert-post-handler request)
    (blog-insert-post!
     BLOG (parse-post (request-bindings request)))
    (render-blog-page request))

  ; This consumes a response-gathering function and gives it an embed/url function.
  ; This transforms and builds functions into special URLs with links.
  (send/suspend/dispatch response-generator))

; blog-insert-post!
; DESCRIPTION: Takes the blog and the new post, and adds the new post on the top of the blog.
(define (blog-insert-post! a-blog a-post)
  (set-blog-posts! a-blog
                   (cons a-post (blog-posts a-blog))))


; ===================================
; | HTML Rendering Helper Functions |
; ===================================
; This section contains the functions that renders the racket code into HTML.
; (Side note: xexper consumes requests and produces HTML code from them)

; render-post
; DESCRIPTION: Takes an argument that has a post struct and renders it in HTML as a div. 
(define (render-post a-post)
  `(div ((class "post"))
        ,(post-title a-post)
        (p ,(post-body a-post))))
 
; render-posts
; DESCRIPTION: Takes an xexpr argument and renders multiple posts from it.
(define (render-posts)
  `(div ((class "posts"))
        ,@(map render-post (blog-posts BLOG))))
        ; ^ The @ here splices the list of xexpr
; ==============================================================
