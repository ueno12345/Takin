class AssignmentsController < ApplicationController
  before_action :login, only: %i[ index show new create edit update deatroy]
  before_action :set_assignment, only: %i[ show edit update ]

  # GET /assignments or /assignments.json
  def index
    @course = Course.find(params[:course_id])
    @assignments = @course.assignments.where(course_id: @course.id)
  end

  # GET /assignments/1 or /assignments/1.json
  def show
  end

  # GET /assignments/new
  def new
    @course = Course.find(params[:course_id])
    @assignment = Assignment.new
    @teaching_assistants = TeachingAssistant.all
  end

  # GET /assignments/1/edit
  def edit
    @course = Course.find(params[:course_id])
    @assignment = @course.assignments.find(params[:assignment_id])
  end  

  # POST /assignments or /assignments.json
  def create
    @course = Course.find(params[:course_id]) 
    @teaching_assistants = TeachingAssistant.where(id: params[:teaching_assistant_ids])
    @teaching_assistants.each do |teaching_assistant|
    @assignment = Assignment.new({course_id:@course.id,teaching_assistant_id:teaching_assistant.id, description:""})

      if Assignment.where(course_id: @course.id).where(teaching_assistant_id: teaching_assistant.id).count >= 1
        #データが重複しないようにif文ではじく
        next
      else
      @assignment.save
      end
    end

    redirect_to course_assignments_path(@course), notice: "TA候補が追加されました．"
  end

  # PATCH/PUT /assignments/1 or /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to assignment_url(@assignment), notice: "Assignment was successfully updated." }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assignment = Assignment.find(params[:assignment_id])
    @work_hour = @assignment.work_hours.find(params[:id])
    @work_hour.destroy
    redirect_to course_assignments_path, notice: "割当時間が削除されました"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignment_params
      params.require(:assignment).permit(:course_id, :teaching_assistant_id, :description)
    end
end
