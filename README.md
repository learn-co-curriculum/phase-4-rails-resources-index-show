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

| HTTP Verb    | Path           | Controller#Action | Description              |
| ------------ | -------------- | ----------------- | ------------------------ |
| **GET**      | **/birds**     | **birds#index**   | **Show all birds**       |
| POST         | /birds         | birds#create      | Create a new bird        |
| **GET**      | **/birds/:id** | **birds#show**    | **Show a specific bird** |
| PATCH or PUT | /birds/:id     | birds#update      | Update a specific bird   |
| DELETE       | /birds/:id     | birds#destroy     | Delete a specific bird   |

<!-- ## Video Walkthrough -->
<!-- <iframe width="560" height="315" src="https://www.youtube.com/embed/czpDsqpbV20?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe> -->

## Setup

First, we'll need to install the dependencies as usual:

```console
$ bundle install
```

Next, we'll need to make a `Bird` model and generate some sample data for
our API. Let's use a Rails generator to set up our model:

```console
$ rails g model Bird name species --no-test-framework
```

After generating the model, run the migration:

```console
$ rails db:migrate
```

Next, we'll create some seed data in the `db/seeds.rb` file:

```rb
Bird.create!(name: "Black-Capped Chickadee", species: "Poecile Atricapillus")
Bird.create!(name: "Grackle", species: "Quiscalus Quiscula")
Bird.create!(name: "Common Starling", species: "Sturnus Vulgaris")
Bird.create!(name: "Mourning Dove", species: "Zenaida Macroura")
```

To add these birds to our database, run the seed file:

```console
$ rails db:seed
```

## Creating RESTful Routes with Resources

To set up our `index` and `show` actions, we'll first need to create some
routes. Recall that the RESTful convention for these routes is as follows:

```txt
GET /birds      => show a list of all birds
GET /birds/:id  => show one specific bird
```

Just like in previous lessons, we can build the routes for these actions in
Rails by hand, like so:

```rb
# config/routes.rb

Rails.application.routes.draw do
  get '/birds', to: 'birds#index'
  get '/birds/:id', to: 'birds#show'
end
```

We can verify that these routes were added successfully by viewing all of our
app's routes using a handy Rake task. In your terminal, run:

```console
$ rails routes
Prefix  Verb  URI Pattern           Controller#Action
 birds  GET   /birds(.:format)      birds#index
        GET   /birds/:id(.:format)  birds#show
```

However, there is a better way to build the routes: Rails provides a tool,
`resources`, that enforces RESTful conventions and saves us work.

Edit the `config/routes.rb` file like so:

```rb
Rails.application.routes.draw do
  resources :birds
end
```

Then, run `rails routes` again:

```console
$ rails routes
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

```console
$ rails routes
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

```console
$ rails g controller Birds --no-test-framework
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

In this lesson, we learned how to set up the two "Read" CRUD actions.
Specifically, we set up the routes to handle the requests as well as the
controller actions to return the requested information. We also learned how to
use a built-in tool, `resources`, as an easier way to set up routes that follow
**REST conventions**.

## Check For Understanding

Before you move on, make sure you can answer the following questions:

1. Tools like `resources` are examples of Rails' use of the **convention over
   configuration** paradigm. What are the advantages of this approach?
2. Why is it a good idea to limit the routes you create to ones that your API
   will actually use?

## Resources

- [Rails Resource Routing](https://guides.rubyonrails.org/routing.html#resource-routing-the-rails-default)
- [`resources` method](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html)
