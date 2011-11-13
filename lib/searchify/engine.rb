module Searchify
  class Engine < Rails::Engine
    isolate_namespace Searchify

    initializer "extend Controller with Searchify helpers" do |app|
      ActionController::Base.send :include, Searchify::Controller
      ActionController::Base.helper_method :searchify_scopes
      ActionController::Base.helper Searchify::SearchifyHelper
    end
  end
end
