class AssertionsController < ApplicationController
  before_action :set_assertion, only: [:show, :edit, :update, :destroy]

  # GET /assertions
  # GET /assertions.json
  def index
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
    @assertions = Assertion.all
  end

  # GET /assertions/1
  # GET /assertions/1.json
  def show
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
  end

  # GET /assertions/new
  def new
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
    @assertion = Assertion.new
  end

  # GET /assertions/1/edit
  def edit
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
  end

  # POST /assertions
  # POST /assertions.json
  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
    @assertion = Assertion.new(assertion_params)

    respond_to do |format|
      if @assertion.save
        format.html { redirect_to test_suite_test_case_assertion_path(@test_suite,@test_case,@assertion), notice: 'Assertion was successfully created.' }
        format.json { render :show, status: :created, location: @assertion }
      else
        format.html { render :new }
        format.json { render json: @assertion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assertions/1
  # PATCH/PUT /assertions/1.json
  def update
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
    respond_to do |format|
      if @assertion.update(assertion_params)
        format.html { redirect_to test_suite_test_case_assertion_path(@test_suite,@test_case,@assertion), notice: 'Assertion was successfully updated.' }
        format.json { render :show, status: :ok, location: @assertion }
      else
        format.html { render :edit }
        format.json { render json: @assertion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assertions/1
  # DELETE /assertions/1.json
  def destroy
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_case= TestCase.find(params[:test_case_id])
    @assertion.destroy
    respond_to do |format|
      format.html { redirect_to test_suite_test_case_assertions_url(@test_suite,@test_case), notice: 'Assertion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assertion
      @assertion = Assertion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assertion_params
      params.require(:assertion).permit(:field, :expected_value, :test_case_id)
    end
end
