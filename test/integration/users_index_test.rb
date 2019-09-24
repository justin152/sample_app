require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @admin = users(:malory)
    @inactive_user = users(:robert)
  end

  test 'index only shows active users' do
    log_in_as(@user)
    get users_path

    assert_select "a[href=?]", user_path(@user), text: @user.name
    assert_select "a[href=?]", user_path(@inactive_user),
                  text: @inactive_user.name, count: 0
  end

  test 'show redirects inactive users' do
    log_in_as(@user)
    get user_path @user

    assert_template 'users/show'

    get user_path @inactive_user

    assert_redirected_to root_path
    assert_not flash.empty?
  end

  test "visit index with friendly forwarding" do
    get users_path
    assert_redirected_to login_url
    assert_equal users_url, forwarding_url

    log_in_as(@user)
    assert_redirected_to users_url
    assert_nil forwarding_url
  end

  test "index including pagination" do
    log_in_as(@user)
    get users_path

    assert_select "div.pagination", count: 2

    User.paginate(page: 1).each do |user|
      assert_select "a[href=?]", user_path(user), text: user.name if user.activated?
    end
  end

  test "only admin can delete users" do
    user_count = User.count

    delete logout_path
    delete user_path(@user)

    assert_equal user_count, User.count
    assert_redirected_to login_url

    log_in_as @user
    get users_path

    assert_select "a[href=?]", user_path(@user), text: "delete", count: 0

    delete user_path(@user)

    assert_redirected_to root_url

    get users_path

    assert_select "a[href=?]", user_path(@user), text: @user.name
    assert_equal user_count, User.count

    log_in_as @admin
    get users_path

    assert_select "a[href=?]", user_path(@user), text: "delete", count: 1

    delete user_path(@user)

    assert_redirected_to users_path

    follow_redirect!

    assert_select "div.alert-success", "User deleted"
    assert_select "a[href=?]", user_path(@user), text: @user.name, count: 0
    assert_not_equal user_count, User.count
  end
end
