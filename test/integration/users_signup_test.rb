require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid user signup" do
    assert_no_difference 'User.count' do
      post users_path, user: {name: 'foo', email: 'invalid#.com', password: 'foo', password_confirmation: 'bar'}
    end
    assert_template 'users/new'
  end

end
