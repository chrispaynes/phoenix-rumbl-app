# Rumbl App

## Project Description

Phoenix Rumbl App based on code from [Programming Phoenix]( https://pragprog.com/book/phoenix/programming-phoenix "Programming Phoenix").


## Project Status - Work In Progress

###Chapter 8 - Testing MVC - Page 129

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
14. Convert foreign-key constraint errors to readable error messages in web/models/video.ex

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