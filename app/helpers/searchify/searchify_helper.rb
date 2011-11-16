module Searchify
  module SearchifyHelper
    def searchify(*args)
      options = args.extract_options!

      # searchify options
      collection  = options[:collection] || args.shift || extract_collection
      search_url  = options[:search_url] || extract_search_url(collection, options.delete(:scopes) || {})
      select_url  = options[:select_url] || extract_select_url(options.delete(:action))

      # tag options
      options[:class] = [:searchify].push(options[:class]).flatten.compact
      options[:data]  = {:'select-url' => select_url, :'search-url' => search_url}

      text_field_tag(:searchify, nil, options)
    end

    protected

    def extract_collection
      if defined?(resource_class)
        resource_class.model_name.tableize
      else
        controller.controller_name
      end
    end

    def extract_search_url(collection, scopes={})
      url = "#{searchify_path}/search/#{collection}.json?"
      
      scopes = searchify_scopes.merge(scopes) if Searchify::Config.scope_awareness

      url << scopes.map{ |k,v| "#{k}=#{v}" }.join('&')
    end

    def extract_select_url(action)
      url = if defined?(collection_path)
        "#{collection_path}/(id)"
      else
        "#{request.path}/(id)"
      end

      action ||= Searchify::Config.default_action

      unless [nil, :show, 'show'].include?(action)
        url << "/#{action}"
      end

      url
    end
  end
end

class ActionView::Helpers::FormBuilder

  def searchify(field, *args)
    options = args.extract_options!

    # searchify options
    model_name  = options[:model_name] || extract_model_name(field)
    field_name  = options[:field_name] || extract_field_name(field)
    collection  = options[:collection] || extract_collection(model_name)
    search_url  = options[:search_url] || extract_search_url(collection, options.delete(:scopes) || {})

    # field options
    options[:class] = [:searchify].push(options[:class]).flatten.compact
    options[:data]  = {:'search-url' => search_url}

    hidden_field(field_name) + @template.text_field_tag(:searchify, nil, :class => :searchify, :data => {:'search-url' => search_url})
  end

  protected

  def extract_collection(model_name)
    model_name.to_s.tableize
  end

  def extract_search_url(collection, scopes={})
    "#{searchify_path}/search/#{collection}.json?" + scopes.map{ |k,v| "#{k}=#{v}" }.join('&')
  end

  def extract_model_name(field)
    field[/_id$/] ? field[0..-4] : field
  end

  def extract_field_name(field)
    field[/_id$/] ? field : "#{field}_id"
  end
end