class TestSuiteRunsController < ApplicationController
  before_action :set_test_suite_run, only: [:show, :edit, :update, :destroy]

  # GET /test_suite_runs
  # GET /test_suite_runs.json
  def index
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_suite_runs = @test_suite.test_suite_runs
  end

  # GET /test_suite_runs/1
  # GET /test_suite_runs/1.json
  def show
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_suite_runs = @test_suite.test_suite_runs.find(params[:id])
  end

  # GET /test_suite_runs/new
  def new
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_suite_run = TestSuiteRun.new
  end

  # GET /test_suite_runs/1/edit
  def edit
    @test_suite = TestSuite.find(params[:test_suite_id])
  end

  # POST /test_suite_runs
  # POST /test_suite_runs.json
  def create
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_suite_run = TestSuiteRun.new(test_suite_run_params)

    respond_to do |format|
      if @test_suite_run.save
        format.html { redirect_to test_suite_test_suite_runs(@test_suite_run,@test_suite_run), notice: 'Test suite run was successfully created.' }
        format.json { render :show, status: :created, location: @test_suite_run }
      else
        format.html { render :new }
        format.json { render json: @test_suite_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /test_suite_runs/1
  # PATCH/PUT /test_suite_runs/1.json
  def update
    @test_suite = TestSuite.find(params[:test_suite_id])

    respond_to do |format|
      if @test_suite_run.update(test_suite_run_params)
        format.html { redirect_to test_suite_test_suite_runs_path(@test_suite,@test_suite_run), notice: 'Test suite run was successfully updated.' }
        format.json { render :show, status: :ok, location: @test_suite_run }
      else
        format.html { render :edit }
        format.json { render json: @test_suite_run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /test_suite_runs/1
  # DELETE /test_suite_runs/1.json
  def destroy
    @test_suite = TestSuite.find(params[:test_suite_id])
    @test_suite_run.destroy
    respond_to do |format|
      format.html { redirect_to test_suite_test_suite_runs_url, notice: 'Test suite run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_test_suite_run
      @test_suite_run = TestSuiteRun.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def test_suite_run_params
      params.require(:test_suite_run).permit(:start_time, :end_time, :test_suite_id)
    end
end
