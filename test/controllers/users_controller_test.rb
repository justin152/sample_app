require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get  signup_path
    assert_response :success

    assert_select "title", "Sign up | #{full_title}"
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_response :success

    assert_select "input[value='#{@user.name}']"
    assert_select "input[value='#{@user.email}']"
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: { user: { admin: true } }
    assert_not @other_user.reload.admin?
  end
end
