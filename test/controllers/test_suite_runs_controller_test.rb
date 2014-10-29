require 'test_helper'

class TestSuiteRunsControllerTest < ActionController::TestCase
  setup do
    @test_suite_run = test_suite_runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:test_suite_runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create test_suite_run" do
    assert_difference('TestSuiteRun.count') do
      post :create, test_suite_run: { end_time: @test_suite_run.end_time, start_time: @test_suite_run.start_time, test_suite_id: @test_suite_run.test_suite_id }
    end

    assert_redirected_to test_suite_run_path(assigns(:test_suite_run))
  end

  test "should show test_suite_run" do
    get :show, id: @test_suite_run
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @test_suite_run
    assert_response :success
  end

  test "should update test_suite_run" do
    patch :update, id: @test_suite_run, test_suite_run: { end_time: @test_suite_run.end_time, start_time: @test_suite_run.start_time, test_suite_id: @test_suite_run.test_suite_id }
    assert_redirected_to test_suite_run_path(assigns(:test_suite_run))
  end

  test "should destroy test_suite_run" do
    assert_difference('TestSuiteRun.count', -1) do
      delete :destroy, id: @test_suite_run
    end

    assert_redirected_to test_suite_runs_path
  end
end
