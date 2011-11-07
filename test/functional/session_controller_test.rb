require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "session creation fail" do
    post :create, { :user_session => { :login => 'eugenio', :password => 'solidus' } }
	
	assert_response :unauthorized
  end
end
