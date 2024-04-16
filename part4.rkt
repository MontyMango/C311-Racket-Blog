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
(struct blog (posts) #:mutable)
 
; and post is a (post title body comments)
; where title is a string, body is a string,
; and comments is a (listof string)
(struct post (title body comments) #:mutable)
 
; ====================
; | Content of Blog  |
; ====================
; This sections *mostly* contain the text that will show up on the blog.
; Headers and the title can be found in the rendering portion of this code.

(define BLOG
  (blog
   (list (post "Hello Again!"
               "This is another message test."
               (list))
         (post "Our First Post!"
               "This is our first post message, hello!"
               (list "First comment!")))))
 
; blog-insert-post!: blog post -> void
; Consumes a blog and a post, adds the post at the top of the blog.
(define (blog-insert-post! a-blog a-post)
  (set-blog-posts! a-blog
                   (cons a-post (blog-posts a-blog))))
 
 
; post-insert-comment!: post string -> void
; Consumes a post and a comment string.  As a side-effect, 
; adds the comment to the bottom of the post's list of comments.
(define (post-insert-comment! a-post a-comment)
  (set-post-comments!
   a-post
   (append (post-comments a-post) (list a-comment))))
 
; ====================
; | main() or start |
; ====================
; This section contains where the website always begins to get its content from

; start
; DESCRIPTION: This program starts the web server locally, and is always required.

(define (start request)
  (render-blog-page request))
 
; ==============================
; | HTML structure of the blog |
; ==============================
; This section contains the structure of the blog.
; (Side note: xexper consumes requests and produces HTML code from them)

; render-blog-page
; DESCRIPTION: This renders the title and top of the blog, and the requests

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
             ,(render-posts embed/url)
             (b "Input your title and message into the boxes below:")
             (form ((action
            ; Blog post submission box
                     ,(embed/url insert-post-handler)))
                   (input ((name "title")))
                   (input ((name "body")))
                   (input ((type "submit"))))))))
 
  ; parse-post: bindings -> post
  ; Extracts a post out of the bindings.
  (define (parse-post bindings)
    (post (extract-binding/single 'title bindings)
          (extract-binding/single 'body bindings)
          (list)))

  ; insert-post-handler
  ; DESCRIPTION: This handles inserting posts into the blog
  (define (insert-post-handler request)
    (blog-insert-post!
     BLOG (parse-post (request-bindings request)))
    (render-blog-page request))

  ; This consumes a response-gathering function and gives it an embed/url function.
  ; This transforms and builds functions into special URLs with links.
  (send/suspend/dispatch response-generator))
 
; Function to render the detailed page for a single post.
; Consumes a post and request, and produces a detail page
; of the post. The user will be able to insert new comments.
(define (render-post-detail-page a-post request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html (head (title "Post Details"))
            (body
             (h1 "Post Details")
             (h2 ,(post-title a-post))
             (p ,(post-body a-post))
             ,(render-as-itemized-list
               (post-comments a-post))
             (form ((action
                     ,(embed/url insert-comment-handler)))
                   (input ((name "comment")))
                   (input ((type "submit"))))))))
 ; Parse comment data from request bindings.
  (define (parse-comment bindings)
    (extract-binding/single 'comment bindings))

 ; This handler is responsible for inserting a new comment.
  (define (insert-comment-handler a-request)
    (post-insert-comment!
     a-post (parse-comment (request-bindings a-request)))
    (render-post-detail-page a-post a-request))
  (send/suspend/dispatch response-generator))
 
 
; Function to render a singular post.
; The fragment contains a link to show a detailed view of the post.
(define (render-post a-post embed/url)
  (define (view-post-handler request)
    (render-post-detail-page a-post request))
  `(div ((class "post"))
        ;Use of hyperlink that you can click
        (a ((href ,(embed/url view-post-handler)))
           ,(post-title a-post))
        (p ,(post-body a-post))
        ;Allows for the user to see how many comments there are on a post
        (div ,(number->string (length (post-comments a-post)))
             " comment(s)")))
 
; This function allows all posts to be rendered
(define (render-posts embed/url)
  (define (render-post/embed/url a-post)
    (render-post a-post embed/url))
  `(div ((class "posts"))
        ,@(map render-post/embed/url (blog-posts BLOG))))
 
; Helper function to render a list as an unordered list.
(define (render-as-itemized-list fragments)
  `(ul ,@(map render-as-item fragments)))
 
; Helper function to render an item as a list item.
(define (render-as-item a-fragment)
  `(li ,a-fragment))
