class CoursesController < ApplicationController
  # login判定
  before_action :login, only: %i[ index show new edit create update destroy index_destroy import]
  before_action :admin_judge, only: %i[ new index_destroy import]

  # GET /courses or /courses.json
  def index
    @q = Course.ransack(params[:q])
    @courses = @q.result(distinct: true)
    @select_years = Course.pluck(:year).uniq
    @select_years.insert(0,"")
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course = Course.find(params[:id])
    @q = @course.assignments.ransack(params[:q], course_id_eq: @course.id)
    @assignments = @q.result(distinct: true)
  end

  # GET /courses/new
  def new
    @course = Course.new
    @q = Course.ransack(params[:q])
    @courses = @q.result(distinct: true)
    @select_years = Course.pluck(:year).uniq
    @select_years.insert(0,"")
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    
    if @course.save
      redirect_to new_course_path, notice: "科目が追加されました", flash: {color: :green}
      @assignment = Assignment.new({course_id:@course.id, teaching_assistant_id:"1", description:"dammy"})#追加行
      @assignment.save
    else
      redirect_to new_course_path, notice: "科目が追加されませんでした", flash: {color: :red}
    end

      #@assignment = Assignment.new({course_id:"1", teaching_assistant_id:"0", description:"dammy"})
      #render template: "assignments/index"  
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
    if params[:course_ids].nil?
      redirect_to index_destroy_courses_path, notice: "削除したい科目を選択してください", flash: {color: :red}
    else
      @courses = Course.where(id: params[:course_ids])
      @courses.destroy_all
      redirect_to index_destroy_courses_path, notice: "科目が削除されました", flash: {color: :green}
    end
  end

  def index_destroy
    @q = Course.ransack(params[:q])
    @courses = @q.result(distinct: true)
    @select_years = Course.pluck(:year).uniq
    @select_years.insert(0,"")
  end

  def import
    Course.import(params[:file])
    if params[:file].nil?
      redirect_to new_course_url, notice: "登録する科目マスタデータCSVファイルを選択してください", flash: {color: :red}
    else
      redirect_to courses_url, notice: "新規科目マスタデータを追加しました", flash: {color: :green}
    end
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
