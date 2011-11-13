module Searchify
  class SearchifyController < ActionController::Base

    respond_to :js

    skip_before_filter :verify_authenticity_token

    layout false

    DEFAULT_COLUMNS = %w( name title abbreviation )

    def search
      resource_class  = params[:collection].classify.constantize
      search_term     = params[:term]
      search_keyword  = extract_search_key(resource_class)

      scopes = params.except("controller", "action", "format", "collection", "term", "page")

      collection = if resource_class.respond_to?(:search_strategy)
        resource_class.search_strategy(search_term, scopes)
      else
        columns = DEFAULT_COLUMNS & resource_class.column_names

        scoped = resource_class.where( columns.map{ |c| "(#{c} #{search_keyword} :term)" }.join(' OR '), :term => "%#{search_term}%")

        scopes.each do |key, value|
          scoped = scoped.send(key, value) if resource_class.respond_to?(key)
        end

        scoped.map do |resource|
          {:label => resource.name, :id => resource.id}
        end
      end

      render :json => collection.to_json
    end

    protected

    def extract_search_key(resource_class)
      case resource_class.connection.adapter_name
        when 'MySQL', 'Mysql2', 'SQLite'
          'LIKE'
        when 'PostgreSQL'
          'ILIKE'
      end
    end
  end
end
