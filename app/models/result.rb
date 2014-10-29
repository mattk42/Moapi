class Result < ActiveRecord::Base
  belongs_to :test_case
  belongs_to :test_suite
end
