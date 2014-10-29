require 'rest_client'
require 'json'
@threads=[]
@test_suites = TestSuite.all
@test_suites.each do |test_suite| 
  thread=Thread.new do
    if (test_suite.last_run.start_time > Time.now - test_suite.interval.seconds )
      p "Skipping #{test_suite.name}, last run was at #{test_suite.last_run.start_time} which is less than #{test_suite.interval}s before #{Time.now}\n"
    else
      p "Running #{test_suite.name}, last run was at #{test_suite.last_run.start_time} which is more than #{test_suite.interval}s before #{Time.now}\n"
    end
  end #end thread
  @threads.append(thread)
end

@threads.each do |thread|
  p "Waiting on #{thread}"
  thread.join
end
