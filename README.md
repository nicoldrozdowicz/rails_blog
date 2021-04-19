# Project Summary
This is a RESTful API for a blog with both posts and comments (implemented using Rails).

A majority of this code is Rails App boilerplate. If you want to take a look at the meaty stuff, I suggest checking out:
- `app/models/post`
- `app/models/comment`
- `app/controllers/posts_controller`
- `app/controllers/comments_controller`
- `spec/controllers/posts_controller_spec`
- `spec/controllers/comments_controller_spec`
- `db/schema`
- `config/routes`

# Some highlights...
Both of the controllers (`PostsController` and `CommentsController`) follow RESTful best practices.
- The endpoints respond with JSON
- The paths use plural nouns that correspond to the resource the verb is acting upon, and RESTful conventions are used to map the verbs to CRUD operations. For instance, a `PUT` to `/posts/:id/` points to the `update` action in the `Posts` controller. It will update the appropriate post based on information provided in the request body.
- Nested resources use hierarchical URLs. For instance, a `POST` to `/posts/:post_id/comments/` points to the `create` action in the `Comments` controller. It will create a new comment that belongs to the appropriate post.

Both of the controllers are thoroughly tested. See `spec/controllers/posts_controller_spec` and `spec/controllers/comments_controller_spec` if you're interested in checking out how I went about testing these API endpoints. 

