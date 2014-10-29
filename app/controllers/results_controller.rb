class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :edit, :update, :destroy]

  # GET /results
  # GET /results.json
  def index
    @test_suite = TestSuite.find(params[:test_suite_id])
   
    if params[:test_case_id].present?
      @test_case = @test_suite.test_cases.find(params[:test_case_id])
      @results = @test_case.results.group_by{|r| TestCase.find(r.test_case_id) }
    else
      #All results are useless unless they are grouped by there test case
      @login_results=@test_suite.login_results.to_a
      @results = @test_suite.results.group_by{|r| TestCase.find(r.test_case_id) }
    end

  end

  # GET /results/1
  # GET /results/1.json
  def show
    @test_suite = TestSuite.find(params[:test_suite_id])
  end

  # GET /results/new
  def new
    @test_suite = TestSuite.find(params[:test_suite_id])
    @result = Result.new
  end

  # GET /results/1/edit
  def edit
    @test_suite = TestSuite.find(params[:test_suite_id])
  end

  # POST /results
  # POST /results.json
  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to test_suite_result_path(@test_suite,@result), notice: 'Result was successfully created.' }
        format.json { render :show, status: :created, location: @result }
      else
        format.html { render :new }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    @test_suite = TestSuite.find(params[:test_suite_id])

    respond_to do |format|
      if @result.update(result_params)
        format.html { redirect_to test_suite_result_path(@test_suite,@result), notice: 'Result was successfully updated.' }
        format.json { render :show, status: :ok, location: @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @test_suite = TestSuite.find(params[:test_suite_id])

    @result.destroy
    respond_to do |format|
      format.html { redirect_to test_suite_result_url(@test_suite), notice: 'Result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_result
      @result = Result.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def result_params
      params.require(:result).permit(:response, :response_code, :datetime, :test_suite_run_id, :test_case_id)
    end
end
