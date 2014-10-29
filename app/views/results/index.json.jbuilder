json.array!(@results) do |result|
  json.extract! result, :id, :response, :response_code, :datetime, :test_suite_run_id, :test_case_id
  json.url result_url(result, format: :json)
end
