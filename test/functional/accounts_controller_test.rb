require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "user creation" do
    assert_difference('User.count') do
		get :create, {
			:user => {
				:email => 'eugeniodepalo@gmail.com',
				:password => 'solidusso3*',
				:password_confirmation => 'solidusso3*'
			}
		}
		
		assert_response :ok
	end
  end
  
  test "fail user creation" do
    assert_no_difference('User.count') do
		get :create, {
			:user => {
				:email => 'eugeniodepalo@gmail.com',
				:password => 'solidusso3*',
				:password_confirmation => 'solidusso'
			}
		}
		
		assert_response :unprocessable_entity
	end
  end
end
