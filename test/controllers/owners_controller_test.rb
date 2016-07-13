require 'test_helper'

class OwnersControllerTest < ActionController::TestCase
  setup do
    @owner = owners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:owners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create owner" do
    assert_difference('Owner.count') do
      post :create, owner: { first_name: @owner.first_name, last_name: @owner.last_name, num_titles: @owner.num_titles, place_avg: @owner.place_avg, team_name: @owner.team_name, total_points_avg: @owner.total_points_avg }
    end

    assert_redirected_to owner_path(assigns(:owner))
  end

  test "should show owner" do
    get :show, id: @owner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @owner
    assert_response :success
  end

  test "should update owner" do
    patch :update, id: @owner, owner: { first_name: @owner.first_name, last_name: @owner.last_name, num_titles: @owner.num_titles, place_avg: @owner.place_avg, team_name: @owner.team_name, total_points_avg: @owner.total_points_avg }
    assert_redirected_to owner_path(assigns(:owner))
  end

  test "should destroy owner" do
    assert_difference('Owner.count', -1) do
      delete :destroy, id: @owner
    end

    assert_redirected_to owners_path
  end
end
