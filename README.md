Searchify
=========
Searchify provides a quick way to search your collections. Type, choose, enjoy!

Requirements
------------
* Rails 3.1
* jQuery
* jQuery UI (for the autocomplete widget)

Installation
------------
First, install the gem

    gem install searchify

Mount the engine to the desired route in `config/routes.rb`

    mount Searchify::Engine => "/searchify", :as => "searchify"

Add both jquery-ui and searchify to your `app/assets/javascripts/application.js` file

    //= require jquery-ui
    //= require searchify/searchify

Usage
-----
#### Autocomplete search

Searchify is intented to be used on a per model basis. You type, you choose, you are redirected to the chosen resource show page.
Calling it on an index page, it infers the model to be searched with the controller name, or the `resource_class` helper, if it exists.
For example, consider the following line of code on your `/posts` page:

    <%= autocomplete %>

This will triggers an AJAX call to /searchify/search/posts.json page and jQuery handles the response with its autocomplete widget.

If you want to specify the collection, i.e. searching for `users` on the `posts` page, just write this:

    <%= autocomplete :users %>

If you don't want to be redirected to the chosen resource page, you can specify the `select_url` option with the special `(id)` value.
For example, to land on the edit page, you could write:

    <%= autocomplete :select_url => "/posts/(id)/edit" %>

#### In place autocomplete

Searchify can also be used in a form. For example, let's say that a post belongs to a user of your choice.:

    <%= form_for(@post) do |f| %>
        <div class="field">
            <%= f.label :user %><br />
            <%= f.autocomplete :user %>
        </div>
    <% end %>

Searchify will include a `user_id` field in your form, which will be automatically populated.

#### Search stategies

By default, Searchify does a case insensitive search on `name`, `title` and `abbreviation` fields of your models, if they exist. You can of course specify
a custom search strategy by defining a class method named `search_strategy` in your model. It should returns an array of hash.

    class User < ActiveRecord::Base
        def self.search_strategy(term, scopes)
            columns = %w( username, first_name, last_name )

            scoped = where( columns.map{ |c| "(#{c} ILIKE :term)" }.join(' OR '), :term => "%#{term}%")

            scopes.each do |key, value|
              scoped = scoped.send(key, value) if respond_to?(key)
            end

            scoped.map do |user|
              {:label => user.username, :id => resource.id}
            end
        end
    end