class AssignmentsController < ApplicationController
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

  def output
    @teaching_assistant = TeachingAssistant.find(params[:teaching_assistant_id])
    
    # ============== #
    # 様式1作成
    # ============== #
    file_form1 = "public/excel/form1.xlsx"
    workbook_form1 = RubyXL::Parser.parse(file_form1)
    worksheet_form1 = workbook_form1[1]

    # 氏名追加処理
    worksheet_form1.add_cell(9, 20, @teaching_assistant.name)
    # worksheet[9][20].change_border(:bottom, "medium")
    worksheet_form1.add_cell(18, 2, @teaching_assistant.name)

    # 学生番号追加処理
    worksheet_form1.add_cell(18, 21, @teaching_assistant.number)

    # 所属分岐
    if @teaching_assistant.grade == "M1" or @teaching_assistant.grade == "M2" then
      worksheet_form1.add_cell(20, 15, @teaching_assistant.grade)
      worksheet_form1.add_cell(19, 2, "大学院環境生命自然科学研究科")
      worksheet_form1.add_cell(19, 15, "前")

    elsif @teaching_assistant.grade == "D1" or @teaching_assistant.grade == "D2" or @teaching_assistant.grade == "D3" then
      worksheet_form1.add_cell(20, 15, @teaching_assistant.grade)
      worksheet_form1.add_cell(19, 2, "大学院環境生命自然科学研究科")
      worksheet_form1.add_cell(19, 15, "後")

    else
      worksheet_form1.add_cell(22, 14, @teaching_assistant.grade)
    end

    # 割り当てられた講義
    @assignments = Assignment.where(teaching_assistant_id: @teaching_assistant.id)
    count = 0;
    
    @assignments.each do |assignment|
      @work_hours = WorkHour.where(assignment_id: assignment.id)
      @work_hours.each do |work_hour|

        puts "-----------------"
        puts work_hour.dtstart.strftime('%Y-%m-%d %H:%M') 
        puts "-----------------"
      end
    end

    workbook_form1.write("public/excel/writed_form1.xlsx")

    # ============== #
    # 様式2作成
    # ============== #
    file_form2 = "public/excel/form2.xlsx"
    workbook_form2 = RubyXL::Parser.parse(file_form2)
    worksheet_form2 = workbook_form2[1]

    workbook_form2.write("public/excel/writed_form2.xlsx")

    # redirect_to teaching_assistant_path(@teaching_assistant), notice: "CSVOKまる？？"
    # file_path = Rails.root.join('public', 'excel','form1.xlsx')
    # send_file "test.xlsx" , type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'inline'
    # send_file("public/excel/test100.xlsx", filename: 'test.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment')
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
