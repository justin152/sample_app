require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path

    assert_template 'static_pages/home'

    assert_select "a[href=?]", root_path, 2

    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", users_path, 0
    assert_select "a[href=?]", logout_path, 0
    assert_select "a[href=?]", users_path, 0
    assert_select "a[href=?]", edit_user_path(@user), 0

    log_in_as @user
    get root_path

    assert_select "a[href=?]", users_path, 1
    assert_select "a[href=?]", edit_user_path(@user), 1

    get contact_path
    assert_select "title", full_title("Contact")

    get signup_path
    assert_select "title", full_title("Sign up")

    get help_path
    assert_select "title", full_title("Help")

    get about_path
    assert_select "title", full_title("About")
  end
end
