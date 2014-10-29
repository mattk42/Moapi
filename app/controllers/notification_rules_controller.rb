class NotificationRulesController < ApplicationController
  before_action :set_notification_rule, only: [:show, :edit, :update, :destroy]

  # GET /notification_rules
  # GET /notification_rules.json
  def index
    @test_suite=TestSuite.find(params[:test_suite_id])
    @notification_rules = @test_suite.notification_rules
  end

  # GET /notification_rules/1
  # GET /notification_rules/1.json
  def show
    @test_suite=TestSuite.find(params[:test_suite_id])
    @notification_rule = @test_suite.notification_rules.find(params[:id])
  end

  # GET /notification_rules/new
  def new
    @test_suite=TestSuite.find(params[:test_suite_id])
    @notification_rule = NotificationRule.new
  end

  # GET /notification_rules/1/edit
  def edit
    @test_suite=TestSuite.find(params[:test_suite_id])
  end

  # POST /notification_rules
  # POST /notification_rules.json
  def create
    @test_suite=TestSuite.find(params[:test_suite_id])
    @notification_rule = NotificationRule.new(notification_rule_params)

    respond_to do |format|
      if @notification_rule.save
        format.html { redirect_to test_suite_notification_rule_path(@test_suite,@notification_rule), notice: 'Notification rule was successfully created.' }
        format.json { render :show, status: :created, location: @notification_rule }
      else
        format.html { render :new }
        format.json { render json: @notification_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notification_rules/1
  # PATCH/PUT /notification_rules/1.json
  def update
    @test_suite=TestSuite.find(params[:test_suite_id])
    respond_to do |format|
      if @notification_rule.update(notification_rule_params)
        format.html { redirect_to test_suite_notification_rule_path(@test_suite,@notification_rule), notice: 'Notification rule was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification_rule }
      else
        format.html { render :edit }
        format.json { render json: @notification_rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notification_rules/1
  # DELETE /notification_rules/1.json
  def destroy
    @test_suite=TestSuite.find(params[:test_suite_id])
    @notification_rule.destroy
    respond_to do |format|
      format.html { redirect_to notification_rules_url, notice: 'Notification rule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification_rule
      @notification_rule = NotificationRule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_rule_params
      params.require(:notification_rule).permit(:name, :script, :args, :test_case_id, :test_suite_id)
    end
end
