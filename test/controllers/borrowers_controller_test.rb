require 'test_helper'

class BorrowersControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

end
