module Searchify
  class SearchifyController < ::ApplicationController

    respond_to :js

    skip_before_filter :verify_authenticity_token

    layout false

    def search
      resource_class  = params[:collection].classify.constantize
      search_term     = params[:term]
      search_keyword  = extract_search_key(resource_class)

      collection = if resource_class.respond_to?(:search_strategy)
        resource_class.search_strategy(search_term, current_scopes)
      else
        columns = Config.column_names & resource_class.column_names

        scoped = resource_class.where( columns.map{ |c| "(#{c} #{search_keyword} :term)" }.join(' OR '), :term => "%#{search_term}%")

        searchify_scopes.each do |key, value|
          scoped = scoped.send(key, value) if resource_class.respond_to?(key)
        end

        scoped.limit(Config.limit).map do |resource|
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
