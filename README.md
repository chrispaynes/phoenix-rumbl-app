# Rumbl App

Phoenix Rumbl App based on code from [Programming Phoenix]( https://pragprog.com/book/phoenix/programming-phoenix "Programming Phoenix").


# Project Status - Work In Progress


##Part II: Writing Interactive and Maintainable Applications
###Chapter 10 - Using Channels - Page 186
1. Create ES6 video object
2. Update video player to use video object in web/static/js/app.js
3. Refactor a web/static/js/socket.js to establish a socket connection
4. Add channel definition in web/channels/user_socket.ex
5. Build a Channel Module to process incoming events
6. Join the channel to the client in web/static/js/video.js
7. Add message pings to join function in web/channels/video_channel.ex
8. Add server-side function call to web/static/js/video.js
9. Add client-side event handling and annotation rendering to web/static/js/video.js
10. Connect conversation to the server-side in web/channels/video_channel.ex


###Chapter 9 - Watching Videos
1. Add link to "My Videos" in web/templates/layout/app.html.eex
2. Create watch_controller to allow any user to watching videos
3. Create web/templates/watch/show.html.eex to display videos
4. Create web/views/watch_view.ex
5. Add get /watch/:id to the :browser pipeline in router 
6. Replace "show" button with "watch" and links to watch_path(...)
7. Create a JavaScript player object to embed video in web/static/js/player.js
8. Import js/player.js into app.js
9. Create css/video.css
10. Add slug column to database
11. Create add_slug_to_video migration
12. Migrate the changes to the DB
13. Add the :slug to the video schema
14. Update the video changeset
15. Create private slugify_title() and slugify() functions in web/models/video.ex
15. Implement Phoenix.Param for Rumbl.Video
16. Create Rumbl.Permalink custom type
17. Customize video model primary key to use Rumbl.Permalink

##Part I: Building With Functional MVC
###Chapter 8 - Testing MVC
1. Update assert in test/controllers/page_controller_test.exs
2. Create test data with test/support/test_helpers.ex
3. Import test_helpers and Ecto.Changeset in test/support/conn_case.ex
4. Create build new test/controllers/video_controller_test.exs
6. Configure setup in video_controller_test to grab config map
7. Implement the tag module in video_controller_test
8. Corrected scope for "resources "/videos", VideoController" in web/router.ex

> <b>Testing Plugs</b>

10. Validate other users cannot view, edit, update or destroy another user's videos
11. Create test/controllers/auth_test.exs to test the authentication plug
12. Add setup block to test/controllers/auth_test.exs 
13. Create login and tests
14. Create user assigns placement test
15. Create nil user session call test
16. Create test for valid username and password
17. Create test for not found user
18. Create test for login with password mismatch
19. Reduce password hashing rounds

> <b>Testing Views and Templates</b>

20. Create test to ensure videoView renders index.html
21. Create test to ensure videoView renders new.html

> <b>Testing Models</b>

22. Import TestHelpers to test/support/model_case.ex
23. Create test/models/user_test.exs for side effect free test
24. Create test for changeset with valid and invalid attributes
25. Create test to verify usernames are not too long
26. Create test for user password length
27. Create test to verify password hashes
28. Create test/models/user_repo_test.exs for user tests with side effects
29. Create test to verify unique_constraints on usernames are converted to an error
30. Create test/models/category_repo_test.exs for category tests with side effects
31. Create test to verify alphabetical/1 orders by name properly



###Chapter 7 - Ecto Queries and Constraints
1. Generate category model using "mix phoenix.gen.model"
2. Update create_category.exs migration file
3. Add referential constraints to Video schema
4. Generate a migration for add_category_id_to_video
5. Make database enforce constraint between videos and categories in create_category.exs
6. Migrate migrations to database
7. Create database seeds for video category names in /priv/repo/seeds.exs
8. Hydrate the database using "mix run priv/repo/seeds.exs" 
9. Update priv/repo/seeds.exs to prevent duplicating categories
10. Create query functions in web/models/category.ex to sort and fetch categories
11. Create load_categories function plug in video_controller
12. Add category dropdown menu to web/templates/video/form.html.eex
13. Add @categories to web/templates/video/-new AND -edit.html.eex
14. Add changeset error message to web/models/user.ex
15. Convert foreign-key constraint errors to readable error messages in web/models/video.ex

###Chapter 6 - Generators and Relationships
1. Scaffold Video module with phoenix.gen.html mix task
2. Move defp authenticate from session_controller to auth.ex
3. Share def authenticate_user with all controllers and router within web.ex
4. Update :authenticate plug to authenticate_user in UserController
5. Define new scope "/manage" to contain video resources
6. Run ecto.migrate to update Repo with new Video Models
7. Update user.ex model schema have one-to-many relationship with videos
8. Link new and create video actions with current session user
9. Modify the default action for the video_controller
10. Create defp user_videos in video_controller
11. Update dep -index, -show, -edit, -update, and -delete to user depf user_videos

###Chapter 5 - Authenticating Users
1. Installed :comeonin dependency
2. Added :comeonin dependency as an application module
3. Created def registration_changeset
4. Created defp put_pass_hash(changeset)
5. Hashed Passwords for previous users in DB
6. Update user_controller to use def registration_changeset
7. Create Authentification Plug for logging users in and out
8. Add Plug to router.ex
9. Define authenticate function plug in user_controller
10. Send connection through authenticate function plug at start of user_controller
11. Add login functionality for users
12. Add def login to auth.ex
13. Pipe new users through def login
14. Add "/sessons" resources to web/router.ex to implement login/logout functionality
15. Add SessionController to render login form and redirect users after login
16. Add def login_by_username_and_pass in auth.ex
17. Add session_view.ex
18. Add session/new template to show login form
19. Add Register and login features to app.html
20. Add def logout to auth.ex and controller action to session_controller
21. Updated NPM Dependencies(Brunch and Babel-Brunch) & Mix Dependencies(Phoenix and Phoenix_HTML)

###Chapter 4 - Ecto and Changesets
1. Upgraded from {:phoenix_html, "~> 2.1"} to {:phoenix_html, "~> 2.3"}
http://www.phoenixframework.org/blog/upgrading-from-v10-to-v11
2. Enabled ErrorHelpers/2 and Changeset
3. Added :gettext dependency
4. Added web/gettext.ex
5. Added web/views/changset_view.ex
6. Added web/views/error_helpers.ex

##To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix