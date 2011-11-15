module Searchify
  module SearchifyHelper
    def autocomplete(*args)
      options = args.extract_options!

      collection  = options[:collection] || args.shift || extract_collection
      search_url  = options[:search_url] || extract_search_url(collection, searchify_scopes, options[:scopes])
      select_url  = options[:select_url] || extract_select_url
      
      text_field_tag(:searchify, nil, :class => :searchify, :data => {:'select-url' => select_url, :'search-url' => search_url})
    end

    protected

    def extract_collection
      if defined?(resource_class)
        resource_class.model_name.tableize
      else
        controller.controller_name
      end
    end

    def extract_search_url(collection, searchify_scopes, scopes={})
      url = "/searchify/search/#{collection}.json?"

      scopes = searchify_scopes.merge(scopes) if Searchify::Config.scope_awareness

      url << scopes.map{ |k,v| "#{k}=#{v}" }.join('&')

      url
    end

    def extract_select_url
      if defined?(collection_path)
        "#{collection_path}/(id)"
      else
        "#{request.path}/(id)"
      end
    end
  end
end

class ActionView::Helpers::FormBuilder

  def autocomplete(field, *args)
    options = args.extract_options!

    model_name  = options[:model_name] || extract_model_name(field)
    field_name  = options[:field_name] || extract_field_name(field)
    collection  = options[:collection] || extract_collection(model_name)
    search_url  = options[:search_url] || extract_search_url(collection, options[:scopes])

    hidden_field(field_name) + @template.text_field_tag(:searchify, nil, :class => :searchify, :data => {:'search-url' => search_url})
  end

  protected

  def extract_collection(model_name)
    model_name.to_s.tableize
  end

  def extract_search_url(collection, scopes={})
    "/searchify/search/#{collection}.json?" + scopes.map{ |k,v| "#{k}=#{v}" }.join('&')
  end

  def extract_model_name(field)
    field[/_id$/] ? field[0..-4] : field
  end

  def extract_field_name(field)
    field[/_id$/] ? field : "#{field}_id"
  end
end