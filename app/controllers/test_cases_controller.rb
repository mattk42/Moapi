class TestCasesController < ApplicationController
  before_action :set_test_case, only: [:show, :edit, :update, :destroy]

  # GET /test_suites/:test_suite_id/test_cases
  # GET /test_suites/:test_suite_id/test_cases.json
  def index
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_cases = @test_suite.test_cases
  end

  # GET /test_suites/:test_suite_id/test_cases/1
  # GET /test_suites/:test_suite_id/test_cases/1.json
  def show
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case = @test_suite.test_cases.find(params[:id])
  end

  # GET /test_suites/:test_suite_id/test_cases/new
  def new
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case = @test_suite.test_cases.build
  end

  # GET /test_suites/:test_suite_id/test_cases/1/edit
  def edit
    @test_suite = TestSuite.find(params[:test_suite_id])
  end

  # POST /test_suites/:test_suite_id/test_cases
  # POST /test_suites/:test_suite_id/test_cases.json
  def create
    @test_case = TestCase.new(test_case_params)
    @test_suite = TestSuite.find(params[:test_suite_id])

    #Make sure the tc is linked to the ts
    @test_case.test_suite_id=@test_suite.id

    respond_to do |format|
      if @test_case.save
        format.html { redirect_to test_suite_test_case_path(@test_suite,@test_case), notice: 'Test case was successfully created.' }
        format.json { render :show, status: :created, location: @test_case }
      else
        format.html { render :new }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_suites/:test_suite_id/test_cases/1
  # PATCH/PUT /test_suites/:test_suite_id/test_cases/1.json
  def update
    @test_suite = TestSuite.find(params[:test_suite_id])
    respond_to do |format|
      if @test_case.update(test_case_params)
        format.html { redirect_to test_suite_test_cases_path(@test_suite,@test_case), notice: 'Test case was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_case }
      else
        format.html { render :edit }
        format.json { render json: @test_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_suites/:test_suite_id/test_cases/1
  # DELETE /test_suites/:test_suite_id/test_cases/1.json
  def destroy
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case.destroy
    respond_to do |format|
      format.html { redirect_to test_suite_test_cases_url, notice: 'Test case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_case
      @test_case = TestCase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_case_params
      params.require(:test_case).permit(:name, :endpoint, :method, :params, :timeout, :test_suite_id)
    end
end
