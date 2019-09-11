require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael)
  end

  test "login helpers" do
    assert_not logged_in?
    assert_not_equal @user, current_user
    
    log_in(@user)
    assert logged_in?
    assert_equal @user, current_user
  end
end
