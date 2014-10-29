require 'rest_client'
require 'json'

@test_suite = TestSuite.find(1)
@test_suite_run = TestSuiteRun.new
@test_suite_run.start_time=Time.now
@test_suite_run.save

#Run the login, as defined by the testSuite
login_result = LoginResult.new(:response=>"N/A",:response_code=>0,:datetime=>Time.now,:test_suite_run_id=>@test_suite_run.id)
begin
  resp=RestClient::Request.execute :method=>:post, :url=>"#{@test_suite.base_url}/#{@test_suite.oauth_url}", :payload=>{:username => @test_suite.username, :password => @test_suite.password, :grant_type => "password", :client_id => @test_suite.client_id },:headers=>{},:timeout=>0.8
  rescue RestClient::ExceptionWithResponse=>e
    login_result.response_code=e.http_code
    login_result.response=e.http_body
    login_result.pass=0
    login_result.reason=e.message
  rescue Exception=>e
    login_result.pass=0
    login_result.reason=e.message
  else
    login_result.response=resp.body
    login_result.response_code=resp.code

    #A login is only succesfull with a 200 response
    if (resp.code.to_i == 200 )
      login_result.pass=1
    else
      login_result.pass=0
    end
  ensure
    login_result.save
    @test_suite_run.end_time=Time.now
    @test_suite_run.save
    print login_result

  #If the login failed there is no reason to continue running the test suite
  if( login_result.pass == false )
    exit 1
  end
end

jresp = JSON.parse resp
@token=jresp['value']

#Go through each of the test cases and run them
@test_suite.test_cases.each do |test_case|
  result = Result.new(:response=>"N/A",:response_code=>0,:datetime=>Time.now,:test_suite_run_id=>@test_suite_run.id,:test_case_id=>test_case.id)

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
 
  #Try the request, catch exceptions and log them as failures. If the request is good, check the assertions
  begin	
    if test_case.method == "GET"
      resp=RestClient::Request.execute :method=>test_case.method, :url=>"#{@test_suite.base_url}/#{test_case.endpoint}", :headers=>{:params=>parameters}, :timeout=>test_case.timeout
    else
      resp=RestClient::Request.execute :method=>test_case.method, :url=>"#{@test_suite.base_url}/#{test_case.endpoint}", :payload=>parameters, :headers=>{}, :timeout=>test_case.timeout
    end
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

    @assertions=Assertion.find_by(:test_case_id,test_case.id)
    @assertions=Assertion.all
    print @assetions
    @assertions.each do |assertion|
      if assertion.field=='CODE'
        if resp.code!=assertion.expected_value.to_i
          result.pass=0
          result.reason="Assertion #{assertion.id} failed! #{resp.code} != #{assertion.expected_value}" 
        end
      else
        regexp=Regexp.new assertion.expected_value
	print regexp.match('alksdjlakj')
        if !regexp.match(resp.body) 
          result.pass=0
          result.reason="Assertion #{assertion.id} failed!" 
        end 
      end
    end
  ensure
    result.save
  end	
end

@test_suite_run.end_time=Time.now
@test_suite_run.save

