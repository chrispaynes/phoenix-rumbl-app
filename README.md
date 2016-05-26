# Rumbl App

## Project Description

Phoenix Rumbl App based on code from [Programming Phoenix]( https://pragprog.com/book/phoenix/programming-phoenix "Programming Phoenix").


## Project Status - Work In Progress

###Chapter 5 - Authenticating Users - Page 81
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
15. Create SessionController to render login form and redirect users after login
16. Create def login_by_username_and_pass in auth.ex
17. Create session_view.ex
16. Create session/new template to show login form

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