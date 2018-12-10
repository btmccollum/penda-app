# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project

- [x] Include at least one has_many relationship (x has_many y; e.g. User has_many Recipes) 
    - A User has_many comments, which is also inherited by the Client and Business classes
    - A Project has_many comments
- [x] Include at least one belongs_to relationship (x belongs_to y; e.g. Post belongs_to User)
    - A project belongs_to both a Client and a Business user
    - A comment belongs_to both a User and a project
- [x] Include at least two has_many through relationships (x has_many y through z; e.g. Recipe has_many Items through Ingredients)
    - A Client has_many Businesses through Projects
    - A Business has_many Clients through Projects
- [x] Include at least one many-to-many relationship (x has_many y through z, y has_many x through z; e.g. Recipe has_many Items through Ingredients, Item has_many Recipes through Ingredients)
    - A Client has_many Businesses through Projects, and a Business has_many Clients through Projects
- [x] The "through" part of the has_many through includes at least one user submittable attribute, that is to say, some attribute other than its foreign keys that can be submitted by the app's user (attribute_name e.g. ingredients.quantity)
    - A project has many attributes that are submittable by the business, and a client can view these and has the ability to make comments to the business
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
    - A user has many validations for key data such as validating the uniqueness of a username and email, and expects that information such as first name, last name, password, password confirmation, etc. are present
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
    - most recently active users, url: /most-recently-active
        scope :most_recently_active, -> { select('users.id, users.username').joins(:time_entries).select('time_entries.updated_at').where('users.id IS time_entries.user_id').order("time_entries.updated_at DESC").limit(10).uniq }
    - Projects sorted by active or completed
- [x] Include signup (how e.g. Devise) 
    - Started with Devise but instead created a custom sign up system for both types of users
- [x] Include login (how e.g. Devise)
    - Started with Devise but instead created a custom log in system for both types of users through a singular Sessions controller
- [x] Include logout (how e.g. Devise)
    - Same as above, I started with Devise but instead created a custom log out route for both types of users through a singular Sessions controller
- [x] Include third party signup/login (how e.g. Devise/OmniAuth)
    - Same as above, a custom Sessions controller currently permits a user to login/signup through Facebook and Google
- [x] Include nested resource show or index (URL e.g. users/2/recipes)
    - project time entries index, '/projects/:project_id/time_entries'
- [x] Include nested resource "new" form (URL e.g. recipes/1/ingredients/new)
    - new time entries for projects '/projects/:project_id/time_entries/new'
- [x] Include form display of validation errors (form URL e.g. /recipes/new)
    - forms display validation errors

Confirm:
- [x] The application is pretty DRY
- [x] Limited logic in controllers
- [x] Views use helper methods if appropriate
- [x] Views use partials if appropriate
    -partials used for user forms