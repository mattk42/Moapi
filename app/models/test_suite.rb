class TestSuite < ActiveRecord::Base
  has_many :test_cases, dependent: :destroy
  has_many :notification_rules, dependent: :destroy
  has_many :test_suite_runs, dependent: :destroy
  has_many :results, through: :test_suite_runs
  has_many :login_results, through: :test_suite_runs

  def last_run
    TestSuiteRun.order(:start_time=>:desc).limit(1).find_by(:test_suite_id=>self.id)
  end
end
