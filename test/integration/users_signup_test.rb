require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid sign up information' do
    get signup_path

    assert_no_difference 'User.count' do
      post_user(name: "",         email: "user@invalid",
                password: "foo",  password_confirmation: "bar")
    end

    assert_select 'form[action="/signup"]'
    assert_template 'users/new'
  end

  test 'invalid sign up error messages' do
    get signup_path

    post_user(name:  "",     email: "",
              password: "",  password_confirmation: "")

    assert_error_message 'Email'
    assert_error_message 'Name'
    assert_error_message 'Password'
  end

  test 'valid sign up logs in & redirects to user profile' do
    get signup_path

    assert_difference 'User.count', 1 do
      post_user(name:  "Foo Bar",     email: "foo@example.com",
                password: "foobar",  password_confirmation: "foobar")
    end

    follow_redirect!
    assert_template 'users/show'

    assert_not flash.empty?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end

  def post_user(user_params)
    post signup_path, params: { user: user_params }
  end

  def assert_error_message(field)
    assert_select "li", "#{field.capitalize} can't be blank"
  end
end
