# Rails Resource Routing: Index and Show

## Learning Goals

- Explain the benefits of RESTful routing conventions in Rails
- Use `resources` to generate routes
- Understand how to view all routes in a Rails application

## Introduction

In this module, we'll be building out full CRUD with the five RESTful routes for
one resource. We'll be making an API for birding enthusiasts, so the resource
we'll be working with is birds. In this lesson, we'll cover the two routes for
**read** actions to display information about the birds in our database: the
`index` and `show` actions.

<table border="1" cellpadding="4" cellspacing="0">
  <tr>
    <th>HTTP Verb</th>
    <th>Path</th>
    <th>Controller#Action</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><strong>GET</strong></td>
    <td><strong>/birds</strong></td>
    <td><strong>birds#index</strong></td>
    <td><strong>Show all birds</strong></td>
  </tr>
  <tr>
    <td>POST</td>
    <td>/birds</td>
    <td>birds#create</td>
    <td>Create a new bird</td>
  </tr>
  <tr>
    <td><strong>GET</strong></td>
    <td><strong>/birds/:id</strong></td>
    <td><strong>birds#show</strong></td>
    <td><strong>Show a specific bird</strong></td>
  </tr>
  <tr>
    <td>PATCH or PUT</td>
    <td>/birds/:id</td>
    <td>birds#update</td>
    <td>Update a specific bird</td>
  </tr>
  <tr>
    <td>DELETE</td>
    <td>/birds/:id</td>
    <td>birds#destroy</td>
    <td>Delete a specific bird</td>
  </tr>
</table>

## Video Walkthrough

<iframe width="560" height="315" src="https://www.youtube.com/embed/czpDsqpbV20?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe>

## Setup

To start, we'll need to make a `Bird` model and generate some sample data for
our API. Let's use a Rails generator to set up our model:

```sh
rails g model Bird name species --no-test-framework
```

After generating the model, run the migration:

```sh
rails db:migrate
```

Next, we'll create some seed data in the `db/seeds.rb` file:

```rb
Bird.create!(name: "Black-Capped Chickadee", species: "Poecile Atricapillus")
Bird.create!(name: "Grackle", species: "Quiscalus Quiscula")
Bird.create!(name: "Common Starling", species: "Sturnus Vulgaris")
Bird.create!(name: "Mourning Dove", species: "Zenaida Macroura")
```

To add these birds to our database, run the seed file:

```sh
rails db:seed
```

## Creating RESTful Routes with Resources

To set up our `index` and `show` actions, we'll first need to create some
routes. Recall that the RESTful convention for these routes is as follows:

```txt
GET /birds      => show a list of all birds
GET /birds/:id  => show one specific bird
```

Just like in previous lessons, we can create routes for these actions in Rails
like so:

```rb
# config/routes.rb

Rails.application.routes.draw do
  get '/birds', to: 'birds#index'
  get '/birds/:id', to: 'birds#show'
end
```

We can verify that these routes were added successfully by viewing all of our
app's routes using a handy Rake task. In your terminal, run `rails routes`. You
should see something like this:

```txt
Prefix  Verb  URI Pattern           Controller#Action
 birds  GET   /birds(.:format)      birds#index
        GET   /birds/:id(.:format)  birds#show
```

Rails has a tool for us that will make it even easier to create routes following
RESTful conventions: `resources`.

Edit the `config/routes.rb` file like so:

```rb
Rails.application.routes.draw do
  resources :birds
end
```

Then, run `rails routes` again:

```txt
Prefix  Verb    URI Pattern           Controller#Action
 birds  GET     /birds(.:format)      birds#index
        POST    /birds(.:format)      birds#create
  bird  GET     /birds/:id(.:format)  birds#show
        PATCH   /birds/:id(.:format)  birds#update
        PUT     /birds/:id(.:format)  birds#update
        DELETE  /birds/:id(.:format)  birds#destroy
```

With just one line of code — `resources :birds` — Rails created all the RESTful
routes we need and mapped them to the appropriate controller action!

With great power comes great responsibility. Even though we'll eventually add
all of these RESTful routes to our API, for the time being, we only need two:
the `index` and `show` routes. We can still use `resources` and customize which
routes are created like so:

```rb
Rails.application.routes.draw do
  resources :birds, only: [:index, :show]
end
```

Running `rails routes` now will give us the same output as when we wrote out the
routes by hand:

```txt
Prefix  Verb  URI Pattern           Controller#Action
 birds  GET   /birds(.:format)      birds#index
        GET   /birds/:id(.:format)  birds#show
```

As a rule, **you should only generate routes that your API is actually using**.
If you create a route using `resources`, but don't implement the controller
action for that route, your API's consumers (any clients using your API) will
get an unexpected response if they try to use a route that doesn't exist.

## Handling the Index and Show Actions

To complete our first couple RESTful actions, let's set up a controller:

```sh
rails g controller Birds --no-test-framework
```

In the controller, add the following code:

```rb
# app/controllers/bird_controller.rb

class BirdsController < ApplicationController

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # GET /birds/:id
  def show
    bird = Bird.find_by(id: params[:id])
    if bird
      render json: bird
    else
      render json: { error: "Bird not found" }, status: :not_found
    end
  end

end
```

Run `rails s` and visit the `/birds` and `/birds/1` endpoints in the browser to
check your work!

## Conclusion

Rails encourages developers to follow **REST conventions** by providing built-in
tools like the `resource` method to quickly create RESTful routes and their
corresponding controller actions. By following the **convention over
configuration** paradigm, not only do we speed up our development time, we also
get the benefit of these handy abstractions that are built into Rails.

## Resources

- [Rails Resource Routing](https://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default)
- [`resources` method](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html)
