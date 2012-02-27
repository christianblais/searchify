module Searchify
  module SearchifyHelper
    def searchify(*args)
      options = args.extract_options!

      # searchify options
      collection  = options.delete(:collection) || args.shift || extract_collection
      search_url  = options.delete(:search_url) || extract_search_url(collection, options.delete(:scopes), options.delete(:search_strategy))
      select_url  = options.delete(:select_url) || extract_select_url(options.delete(:action))

      # tag options
      options[:class] = [:searchify].push(options[:class]).flatten.compact
      options[:data]  = {:'select-url' => select_url, :'search-url' => search_url}.merge(options[:data] || {})

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

    def extract_search_url(collection, params=nil, search_strategy=nil)
      params ||= {}

      url = "#{searchify_path}/search/#{collection}.json?"

      params = searchify_scopes.merge(params) if Searchify::Config.scope_awareness

      params[:search_strategy] = search_strategy if search_strategy

      url << params.map do |k,v|
        if v.kind_of?(Array)
          v.map{ |e| "#{k}[]=#{e}" }
        else
          "#{k}=#{v}"
        end
      end.join('&')
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

      if Searchify::Config.scope_awareness && !searchify_scopes.empty?
        url += '?'
        url << searchify_scopes.map do |k,v|
          if v.kind_of?(Array)
            v.map{ |e| "#{k}[]=#{e}" }
          else
            "#{k}=#{v}"
          end
        end.join('&')
      end

      url
    end
  end
end

class ActionView::Helpers::FormBuilder

  def searchify(field, *args)
    options = args.extract_options!

    # searchify options
    model_name  = options.delete(:model_name) || extract_model_name(field)
    field_name  = options.delete(:field_name) || extract_field_name(field)
    collection  = options.delete(:collection) || extract_collection(model_name)
    search_url  = options.delete(:search_url) || extract_search_url(collection, options.delete(:scopes), options.delete(:search_strategy))

    # field options
    options[:class] = [:searchify].push(options[:class]).flatten.compact
    options[:data]  = {:'search-url' => search_url}.merge(options[:data] || {})

    # default id
    options[:id] ||= "#{object_name.gsub(/\[/, '_').gsub(/\]/, '')}_#{field_name}"

    # value
    label_method = options.delete(:label_method) || Searchify::Config.label_method
    
    # fetch the value only if object respond_to model_name
    html_value = object.respond_to?(model_name) ? object.send(model_name).try(label_method) : ""

    hidden_field(field_name, :id => "#{options[:id]}_hidden") + @template.text_field_tag(:searchify, html_value, options)
  end

  protected

  def extract_collection(model_name)
    model_name.to_s.tableize
  end

  def extract_search_url(collection, params=nil, search_strategy=nil)
    params ||= {}
    
    url = "#{@template.searchify_path}/search/#{collection}.json?"
    params[:search_strategy] = search_strategy if search_strategy

    url << params.map do |k,v|
      if v.kind_of?(Array)
        v.map{ |e| "#{k}[]=#{e}" }
      else
        "#{k}=#{v}"
      end
    end.join('&')
  end

  def extract_model_name(field)
    field[/_id$/] ? field[0..-4] : field
  end

  def extract_field_name(field)
    field[/_id$/] ? field : "#{field}_id"
  end
end
