json.array!(@assertions) do |assertion|
  json.extract! assertion, :id, :field, :expected_value, :test_case_id
  json.url assertion_url(assertion, format: :json)
end
