require 'test_helper'

class NotificationRulesControllerTest < ActionController::TestCase
  setup do
    @notification_rule = notification_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notification_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notification_rule" do
    assert_difference('NotificationRule.count') do
      post :create, notification_rule: { args: @notification_rule.args, name: @notification_rule.name, script: @notification_rule.script, test_case_id: @notification_rule.test_case_id, test_suite_id: @notification_rule.test_suite_id }
    end

    assert_redirected_to notification_rule_path(assigns(:notification_rule))
  end

  test "should show notification_rule" do
    get :show, id: @notification_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notification_rule
    assert_response :success
  end

  test "should update notification_rule" do
    patch :update, id: @notification_rule, notification_rule: { args: @notification_rule.args, name: @notification_rule.name, script: @notification_rule.script, test_case_id: @notification_rule.test_case_id, test_suite_id: @notification_rule.test_suite_id }
    assert_redirected_to notification_rule_path(assigns(:notification_rule))
  end

  test "should destroy notification_rule" do
    assert_difference('NotificationRule.count', -1) do
      delete :destroy, id: @notification_rule
    end

    assert_redirected_to notification_rules_path
  end
end
