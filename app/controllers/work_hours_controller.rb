class WorkHoursController < ApplicationController
  before_action :login, only: %i[ index show new edit create update destroy]
  before_action :set_work_hour, only: %i[ show edit update destroy ]

  # GET /work_hours or /work_hours.json
  def index
    @work_hours = WorkHour.all
  end

  # GET /work_hours/1 or /work_hours/1.json
  def show
  end

  # GET /work_hours/new
  def new
    @course = Course.find(params[:course_id])
    @work_hour = WorkHour.new
    @assignments = @course.assignments.includes(:teaching_assistant)

  end
  #def new
  #  @course = Course.find(params[:course_id])
  #  @work_hour = @course.work_hours.build
  #end
  

  # GET /work_hours/1/edit
  def edit
    @course = Course.find(params[:course_id])
    @work_hour = WorkHour.find(params[:id])
    @assignments = @course.assignments.includes(:teaching_assistant)
  end
  

  # POST /work_hours or /work_hours.json
  def create
    @course = Course.find(params[:course_id])
    @work_hour = WorkHour.new(work_hour_params)

    if @work_hour.assignment_id.blank?
      @work_hour.assignment_id = @course.assignments.find { |a| a.teaching_assistant_id == 1 }&.id
    end
  
    respond_to do |format|
      if @work_hour.save
        format.html { redirect_to course_assignments_path, notice: "Work hour was successfully created." }
        format.json { render :show, status: :created, location: @work_hour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /work_hours/1 or /work_hours/1.json
  def update
    respond_to do |format|
      if @work_hour.update(work_hour_params)
        #format.html { redirect_to work_hour_url(@work_hour), notice: "Work hour was successfully updated." }
        format.html { redirect_to course_assignments_path, notice: "Work hour was successfully updated." }
        format.json { render :show, status: :ok, location: @work_hour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_hours/1 or /work_hours/1.json
  def destroy
    @work_hour.destroy

    respond_to do |format|
      format.html { redirect_to work_hours_url, notice: "Work hour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_hour
      @work_hour = WorkHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_hour_params
      params.require(:work_hour).permit(:dtstart, :dtend, :actual_working_minutes, :assignment_id)
      #params[:work_hour][:assignment_id].blank? && params[:work_hour][:assignment_id] = Assignment.where(teaching_assistant_id: 1, course_id: YOUR_COURSE_ID).first.id
      #params.require(:work_hour).permit(:dtstart, :dtend, :actual_working_minutes, :assignment_id)
    end
end
