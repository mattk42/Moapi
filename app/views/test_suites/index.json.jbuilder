json.array!(@test_suites) do |test_suite|
  json.extract! test_suite, :id, :oauth_url, :client_id, :username, :password, :interval, :name
  json.url test_suite_url(test_suite, format: :json)
end
