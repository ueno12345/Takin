class CoursesController < ApplicationController
  # login判定
  before_action :login, only: %i[ index show new edit create update destroy index_destroy import]
  before_action :admin_judge, only: %i[ new index_destroy import]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course = Course.find(params[:id])
    @assignments = @course.assignments.where(course_id: @course.id)
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    #@CourseID = Course.find(params[:id])
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
        @assignment = Assignment.new({course_id:@course.id, teaching_assistant_id:"1", description:"dammy"})#追加行
        @assignment.save
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
      
      #@assignment = Assignment.new({course_id:"1", teaching_assistant_id:"0", description:"dammy"})
      #render template: "assignments/index"  

    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @courses = Course.where(id: params[:course_ids])
    @courses.destroy_all
    redirect_to index_destroy_courses_path, notice: "科目が削除されました"
  end

  def index_destroy
    @courses = Course.all
  end

  def import
    Course.import(params[:file])
    redirect_to courses_url, notice: "新規TAマスタデータを追加しました"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:year, :term, :number, :name, :instructor, :time_budget, :description)
    end
end
