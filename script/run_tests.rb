require 'rest_client'
require 'json'
@threads=[]
@test_suites = TestSuite.all
@test_suites.each do |test_suite| 
  #thread=Thread.new do
    if (!test_suite.last_run.nil? and test_suite.last_run.start_time > Time.now - test_suite.interval.seconds )
      p "Skipping #{test_suite.name}, last run was at #{test_suite.last_run.start_time} which is less than #{test_suite.interval}s before #{Time.now}\n"
    else
      #p "Running #{test_suite.name}, last run was at #{test_suite.last_run.start_time.nil?} which is more than #{test_suite.interval}s before #{Time.now}\n"
      test_suite_run = TestSuiteRun.new(:test_suite_id=>test_suite.id)
      test_suite_run.start_time=Time.now
      test_suite_run.save

      #Run the login, as defined by the testSuite. Catch exceptions and log them
      login_result = LoginResult.new(:response=>"N/A",:response_code=>0,:datetime=>Time.now,:test_suite_run_id=>test_suite_run.id,:test_suite_id=>test_suite.id)
      begin
        start_time=Time.now
        resp=RestClient::Request.execute :method=>:post, :url=>"#{test_suite.base_url}/#{test_suite.oauth_url}", :payload=>{:username => test_suite.username, :password => test_suite.password, :grant_type => "password", :client_id => test_suite.client_id },:headers=>{},:timeout=>0.8
        elapsed_time=Time.now-start_time
        login_result.response_time=elapsed_time
      rescue RestClient::ExceptionWithResponse=>e
        login_result.response_code=e.http_code
        login_result.response=e.http_body
        login_result.pass=false
        login_result.reason=e.message
        login_result.save
        test_suite_run.end_time=Time.now
        test_suite_run.save_and_check_notifications
      rescue Exception=>e
        login_result.pass=false
        login_result.reason=e.message
        login_result.save
        test_suite_run.end_time=Time.now
        test_suite_run.save_and_check_notifications
      else
        login_result.response=resp.body
        login_result.response_code=resp.code

        #A login is only succesfull with a 200 response
        if (resp.code.to_i == 200 )
          login_result.pass=true
        else
          login_result.pass=false
        end

        login_result.save
      end

      #If the login failed there is no reason to continue running the test suite
      if( login_result.pass == false )
        next
      end

      #Got a response, parse the json and get the key
      jresp = JSON.parse resp
      @token=jresp['value']

      #Go through each of the test cases and run them
      test_suite.test_cases.each do |test_case|
        p "running #{test_case.id}\n"
        result = Result.new(:response=>"N/A",:response_code=>0,:datetime=>Time.now,:test_suite_run_id=>test_suite_run.id,:test_case_id=>test_case.id)

        #Replace placeholder with the oauth token
        params=test_case.params.gsub '{TOKEN}', @token

        #Parse theough the parameters string and create a usable hash.
        #Syntax is key=>value, key=>value
        parameters={}
        params.split(',').each do |param|
          key,value=param.split('=>')
          key.strip!
          value.strip!
          parameters[key.to_sym]=value
        end
     
        # Try the request, catch exceptions and log them as failures. If the request is good, check the assertions
        begin	
          start_time=Time.now
          if test_case.method == "GET"
            resp=RestClient::Request.execute :method=>test_case.method, :url=>"#{test_suite.base_url}/#{test_case.endpoint}", :headers=>{:params=>parameters}, :timeout=>test_case.timeout
          else
            resp=RestClient::Request.execute :method=>test_case.method, :url=>"#{test_suite.base_url}/#{test_case.endpoint}", :payload=>parameters, :headers=>{}, :timeout=>test_case.timeout
          end
          elapsed_time=Time.now-start_time
          result.response_time=elapsed_time
        rescue RestClient::ExceptionWithResponse=>e
          result.response_code=e.http_code
          result.response=e.http_body
          result.pass=0
          result.reason=e.message
        rescue Exception=>e
          result.pass=0
          result.reason=e.message
        else
          result.response_code=resp.code
          result.response=resp.body
          result.pass=1

          # Check the assertions
          assertions=Assertion.find_by(:test_case_id,test_case.id)
          if(!assertions.nil?)
            assertions.each do |assertion|
              if assertion.field=='CODE'
                if resp.code!=assertion.expected_value.to_i
                  result.pass=0
                  result.reason="Assertion #{assertion.id} failed! #{resp.code} != #{assertion.expected_value}" 
                end
              else
                regexp=Regexp.new assertion.expected_value
                if !regexp.match(resp.body) 
                  result.pass=0
                  result.reason="Assertion #{assertion.id} failed!" 
          end #end if
        end #end if
            end # end assertion loop
          end #end assertion.nil?
        ensure
          result.save
        end	
      end

      #Save the run when we are done with it
      test_suite_run.end_time=Time.now
      test_suite_run.save_and_check_notifications
    end
  #end #end thread
  #@threads.append(thread)
end

#@threads.each do |thread|
#  p "Waiting on #{thread}"
#  thread.join
#end
