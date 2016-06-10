# Rumbl App

Phoenix Rumbl App based on code from [Programming Phoenix]( https://pragprog.com/book/phoenix/programming-phoenix "Programming Phoenix").


# Project Status - Work In Progress


##Part II: Writing Interactive and Maintainable Applications

###Chapter 12 - Observer and Umbrellas
1. Create the Rumbrella umbrella project outside of the rumble app
> <b>Inside of the Rumbrella App</b>
2. Mix a new info_sys supervision tree
3. Replace the supervisor in rumbrella/apps/info_sys/lib/info_sys.ex
4. Rename the Rumbl.InfoSys module in rumbl/apps/info_sys/lib/info_sys.ex
5. Move rumbl/lib/rumbl/info_sys.ex to rumbrella/apps/info_sys/lib/info_sys.ex
6. Rename the Rumbl.InfoSys.Supervisor module in rumbl/lib/rumbl/info_sys/supervisor.ex
7. Move rumbl/lib/rumbl/info_sys/supervisor.ex to rumbrella/apps/info_sys/lib/info_sys/supervisor.ex
8. Rename the Rumbl.InfoSys.Wolfram module in rumbl/lib/rumbl/info_sys/wolfram.ex
9. Move rumbl/lib/rumbl/info_sys/wolfram.ex to rumbrella/apps/info_sys/lib/info_sys/wolfram.ex
10. Add def start() and "use application" to rumbrella/apps/info_sys/lib/info_sys/wolfram.ex
11. Find all occurrences of "Rumbl.InfoSys" and replace with "InfoSys"

###Chapter 11 - OTP
1. Create a counter server in lib/rumbl/counter.ex
2. Modify lib/rumbl/counter.ex to use OTP
3. Add the Counter server to the Rumbl's application supervision tree in lib/rumbl.ex
4. Add def handle_info() callback to lib/rumbl/counter.ex
5. Implement protocol to crash the counter in lib/rumbl/counter.ex
6. Create the InfoSys Supervisor in lib/rumbl/info_sys/supervisor.ex
7. Add the InfoSys Supervisor to Rumbl's supervision tree in lib/rumbl.ex
8. Create the proxy in lib/rumbl/info_sys.ex
9. Add :sweet_xml parser to mix.exs
10 Run Mix.deps get to grab Hex dependency
11. Visit the WolframAlpha Developer Portal and signup for an account. Retrieve an AppID/Developer API Key
12. Create config/dev.secret.exs and input the API Key
13. Add "/config/dev.secret.exs" to the .gitignore file
14. Import dev.secret.exs into config/dev.exs
14. Implement the Wolfram backend in lib/rumbl/infy_sys/wolfram.ex
15. Refactor Rumbl.InfoSys to collect results and ignore crashed backends in lib/rumbl/info_sys.ex
16. Add monitoring and timeouts to lib/rumbl/info_sys.ex
17. Integrate Rumbl.InfoSys into the video_channel in web/channels/video_channel.ex
18. Seed the database with a "wolfram" user in priv/repo/seeds.exs
19. Mix run the backend seeds


###Chapter 10 - Using Channels
1. Create ES6 video object in web/static/js/video.js
2. Update web/static/js/app.js to compensate for video initialization in web/static/js/video.js
3. Refactor web/static/js/socket.js to establish and export a socket object
4. Add video channel definition in web/channels/user_socket.ex
5. Build a Channel Module to process incoming events in web/channels/video_channel.ex
6. Join the channel to the client in web/static/js/video.js
7. TEST: Add message pings to def join() in web/channels/video_channel.ex
8. Add server-side function call to web/static/js/video.js
9. Add client-side event handling and annotation rendering to web/static/js/video.js
10. Rework web/channels/video_channel.ex to broadcast new_annotation events to all the clients

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

###Chapter 3 - Controllers, Views, and Templates
1. Mix a new Phoenix Application and name it rumbl
2. Configure Ecto database
3. Rework jumbotron message in web/templates/page/index.html.eex
4. Hard code in Rumbl.User data in web/models/user.ex
5. Rework lib/rumbl/repo.ex to use an "in memory repository"
6. Define and populate a def all() Rumbl.User data structure
7. Create def get() and def get_by() to retrieve user data
8. Create user routes in web/router.ex
9. Create a user controller in web/controllers/user_controller.ex
10. Create a user view in views/user_view.ex
11. Create a user/index template in web/templates/user/index.html.eex
12. Add def show() action to web/controllers/user_controller.ex
13. Create a /users/:id template in web/templates/user/show.html
14. Create a user template in web/templates/user/user.html.eex
15. Rework web/templates/page/index.html.eex to render "user.html"

###Chapter 2 - The Lay of the Land
Note: This chapter covers installation and provides basic Elixir and Phoenix tutorials.
Complete steps 1-5 prior to building the Rumbl App.

1. Install Elixir >=1.1.0
2. Install the Hex Package Manager
3. Install >=PostgreSQL
4. Install Node >=5.3.0
5. Install the Phoenix Archive
6. Mix a new Phoenix App
7. Mix Phoenix dependencies
8. Mix Ecto.Create
9. Add Routes for HelloController and PageController in web/router.ex
10. Create HelloController in web/controllers/hello_controller.ex
11. Create Hello_View in web/views/hello_view.ex
12. Create Hello World template in web/templates/hello/world.html.eex
13. Rework web/router.ex to include dynamic routes
14. Rework def world to map the inbound name parameter in web/controllers/hello_controller.ex

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
