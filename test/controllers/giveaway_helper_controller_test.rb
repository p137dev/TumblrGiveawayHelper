require 'test_helper'

class GiveawayHelperControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get process" do
    get :process
    assert_response :success
  end

end
