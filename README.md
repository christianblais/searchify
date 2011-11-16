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

Finally, call the `searchify()` method on all `.searchify` field.

    $('.searchify').searchify();

Usage
-----
### Autocomplete search

Searchify is intended to be used on a per model basis. You type, you choose, you are redirected to the chosen resource show page.
Calling it on an index page, it infers the model to be searched with the controller name, or the `resource_class` helper, if it exists.
For example, consider the following line of code on your `/posts` page:

    <%= searchify %>

This will triggers an AJAX call to `/searchify/search/posts.json` page and jQuery will handle the response with its autocomplete widget.

If you want to specify the collection, i.e. searching for `users` on the `posts` page, just write this:

    <%= searchify :users %>

When a selection is made, you are redirected to the chosen resource show page. If you want to land on any other member action, the `action` option is for you.

    <%= searchify :action => :edit %>

If your redirect is more complex, you can always redefine the `select_url` option. The `(id)` keyword will be replaced by the id of the selected resource.

    <%= searchify :select_url => "/more/complex/path/(id)/with/custom/action" %>

### In place autocomplete

Searchify can also be used in a form. For example, let's say that a post belongs to a user of your choice:

    <%= form_for(@post) do |f| %>
        <div class="field">
            <%= f.label :user %><br />
            <%= f.searchify :user %>
        </div>
    <% end %>

Searchify will include a `user_id` field in your form, which will be automatically populated with your search. Searchify uses the `label_method` option to display the object.

### Scopes

Searchify is by default scopes aware. Let's say you are here:

`/posts?created_by=3`

Assuming your `Post` model responds to the `created_by` method, it will be included in the search.

You may also force your own scopes into a searchify field by adding the `scopes` options, as follow:

    <%= searchify :scopes => {:created_by => 3} %>

### Configuration

You can always override the defaults with an initializer. Options are as follow:

    Searchify::Config.configure do |config|

        # Extract those keys from the params hash
        config.scope_exclusion  = %w( controller action format collection term page )

        # Default column names on which you want to do your search
        config.column_names     = %w( name title abbreviation )

        # If true, searchify will apply url scopes to your search
        config.scope_awareness  = true

        # Limit the number of results in one search
        config.limit            = 30

        # Database search key. Default is 'ILIKE' for Postgres, 'LIKE' for others.
        config.search_key       = nil

        # Method to be called on each resource
        config.label_method     = :name

        # Default action on which you want to land after a selection. Could be :show, :edit or any custom member action
        config.default_action   = :show
    end

### Search stategies

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