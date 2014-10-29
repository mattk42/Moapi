class TestSuiteRun < ActiveRecord::Base
  has_many :results, dependent: :destroy
  has_many :login_results, dependent: :destroy
  belongs_to :test_suites

  def did_pass?
    login_result=self.login_results
    test_case_results=self.results

    #if (!login_result[0].pass)
    #  return false
    #end
  
    test_case_results.each do |result|
      if (!result.pass)
        return false
      end
    end
    return true
  end

  def save_and_check_notifications
    save!

    test_suite=TestSuite.find(self.test_suite_id)

    #If we are updating to set the completion of a test_suite, we should send notifications for any failures that happened
    failures=self.results.find_by(:pass=>false)

    #Find by is dumb and returns just the one result if there is only one. drop it into an array so we can resure the same code
    if (failures.is_a? Result)
      failures=[failures]
    end

    #No need to continue if no failures, otherwise get the count
    if (failures.nil?)
      return
    end

    #Create a summary of the failures
    summary=""
    failures.each do |failure|
      test_case=TestCase.find(failure.test_case_id)
      summary="#{summary}\nTest case #{test_case.id} failed with #{failure.response_code.to_s} - #{failure.reason.to_s}"
    end

    #Fire off each of the notification rules with their specific arguments
    test_suite.notification_rules.each do |rule|
      args=rule.args
      args=args.gsub '{TEST_SUITE_NAME}', "#{test_suite.name.to_s}"
      args=args.gsub '{SUMMARY}', "#{summary}"
      system "#{rule.script} #{args}"
    end
  end

end
