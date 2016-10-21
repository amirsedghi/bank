require 'test_helper'

class LendingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get main_lender" do
    get :main_lender
    assert_response :success
  end

  test "should get main_borrower" do
    get :main_borrower
    assert_response :success
  end

end
