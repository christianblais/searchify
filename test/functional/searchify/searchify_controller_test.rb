require 'test_helper'

module Searchify
  class SearchifyControllerTest < ActionController::TestCase
    test "should get search" do
      get :search
      assert_response :success
    end
  
  end
end
