class TestCase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :test_suite
  has_many :results, dependent: :destroy
end
