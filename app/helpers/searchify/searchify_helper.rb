module Searchify
  module SearchifyHelper
    def autocomplete(*args)
      options = args.extract_options!

      collection  = options[:collection] || args.shift || extract_collection
      search_url  = options[:search_url] || extract_search_url(collection)
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

    def extract_search_url(collection)
      "/searchify/search/#{collection}.json"
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
    search_url  = options[:search_url] || extract_search_url(collection)

    hidden_field(field_name) + @template.text_field_tag(:searchify, nil, :class => :searchify, :data => {:'search-url' => search_url})
  end

  protected

  def extract_collection(model_name)
    model_name.to_s.tableize
  end

  def extract_search_url(collection)
    "/searchify/search/#{collection}.json"
  end

  def extract_model_name(field)
    field[/_id$/] ? field[0..-4] : field
  end

  def extract_field_name(field)
    field[/_id$/] ? field : "#{field}_id"
  end
end