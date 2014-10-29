json.array!(@notification_rules) do |notification_rule|
  json.extract! notification_rule, :id, :name, :script, :args, :test_case_id, :test_suite_id
  json.url notification_rule_url(notification_rule, format: :json)
end
