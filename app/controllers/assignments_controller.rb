class AssignmentsController < ApplicationController

  before_action :login, only: %i[ index show new create edit update deatroy]

  # 使用中
  # GET /assignments or /assignments.json
  def index
    @course = Course.find(params[:course_id])
    @q = @course.assignments.ransack(params[:q], course_id_eq: @course.id)
    @q.sorts = "work_hours_dtstart ASC" if @q.sorts.empty?
    @assignments = @q.result(distinct: true)
    @sum_actual_working_minutes = @assignments.map { |assignment| assignment.work_hours.sum(:actual_working_minutes) }.sum
  end

  # GET /assignments/1 or /assignments/1.json
  def show
    # ============#
    # 使用してない =#
    # ============#
  end

  # GET /assignments/new
  def new
    @course = Course.find(params[:course_id])
    @assignment = Assignment.new
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true)
    @select_years = TeachingAssistant.where.not(id: 1).pluck(:year).uniq
  end

  # GET /assignments/1/edit
  def edit
    # ============#
    # 使用してない =#
    # ============#
    # @course = Course.find(params[course_id:])
    # @assignment = @course.assignments.find(params[assignment_id:])
    # @work_hour = @assignment.work_hours.find(params[id:])
  end  

  # POST /assignments or /assignments.json
  def create
    @course = Course.find(params[:course_id]) 
    if params[:teaching_assistant_ids].nil?
      redirect_to new_course_assignment_path(@course), notice: "追加したいTA候補を選択してください", flash: {color: :red}
    else  
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
      redirect_to course_assignments_path(@course), notice: "TA候補が追加されました．", flash: {color: :green}
    end
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

  def index_destroy
    @course = Course.find(params[:course_id])
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true).joins(:assignments).where(assignments: {course_id: @course.id})
    @select_years = TeachingAssistant.joins(:assignments).where.not(id: 1).where(assignments: { course_id: @course.id }).pluck(:year).uniq
    @select_years.insert(0,"")
  end
  

  def TAdestroy
    if params[:teaching_assistant_ids].nil?
      redirect_to index_destroy_course_assignments_path, notice: "削除したいTA候補を選択してください", flash: {color: :red}
    else
      @assignments = Assignment.where(teaching_assistant_id: params[:teaching_assistant_ids])
      @assignments.destroy_all
      redirect_to index_destroy_course_assignments_path, notice: "TA候補が削除されました", flash: {color: :green}
    end
  end

  # (非同期時の調べ物)割当の削除ボタンを押すとこの処理に来る
  def destroy
    @assignment = Assignment.find(params[:assignment_id])
    @work_hour = @assignment.work_hours.find(params[:id])
    @work_hour.destroy

    respond_to do |format|
      # format.turbo_stream
      format.html { redirect_to course_assignments_path, notice: "Work hour was successfully destroyed." }
      format.json { head :no_content }
      # redirect_to course_assignments_path, notice: "割当時間が削除されました", flash: {color: :green}
      format.turbo_stream
    end
  end

  def output_index
    @teaching_assistant = TeachingAssistant.find(params[:id])
    @assignments = Assignment.where(teaching_assistant_id: params[:id])
    date_start = Date.new(@teaching_assistant.year, 4, 1) 
    date_end = Date.new(@teaching_assistant.year+1, 3, 31) 
    count = WriteForm1(date_start, date_end)
    WriteForm2(date_start, date_end)

    @output_excel1_files_name = [];
    for i in 1..count do
      @output_excel1_files_name.push("/excel/writed_form1-#{i}.xlsx")
    end
    @output_excel2_file_name = "/excel/writed_form2.xlsx"

  end

  def output
    @teaching_assistant = TeachingAssistant.find(params[:teaching_assistant_id])
    date_start = Date.new(@teaching_assistant.year, 4, 1) 
    date_end = Date.new(@teaching_assistant.year+1, 4, 1) 

    if params[:form] == '1'
      WriteForm1(date_start, date_end)
      file_path = Rails.root.join('public', 'excel','writed_form1-1.xlsx')
      send_file file_path, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment'
    else
      WriteForm2(date_start, date_end)
      file_path = Rails.root.join('public', 'excel','writed_form2.xlsx')
      send_file file_path, type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment'
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def assignment_params
      params.require(:assignment).permit(:course_id, :teaching_assistant_id, :description)
    end

    # 帳票の様式1を書き込む処理を行うメソッド
    def WriteForm1(date_start, date_end)
      # 書き込むファイル名 勤務予定が15個ごと書き込んだエクセルファイルを作成するので，ファイル名を変えたい．保存ファイル名の変えない部分
      first = "public/excel/writed_form1"
      # ファイル名を変更するためのマジックナンバー
      file_change_count = 1

      # 様式1のエクセルファイルを読み込む
      file_form1 = "public/excel/form1.xlsx"
      # エクセルを読み込む処理
      workbook_form1 = RubyXL::Parser.parse(file_form1)
      # エクセルの書き込みを行うシートを指定「0からスタートする」
      worksheet_form1 = workbook_form1[1]

      # 書き込みを行いたいTAが持っている割当をDBから持ってくる
      @assignments = Assignment.where(teaching_assistant_id: @teaching_assistant.id)
      # 今書き込んでいる割当の数-1
      count = 0;
      # 合計勤務時間
      sum_work_time = 0
      # 曜日を変換するための配列
      days = ["日", "月", "火", "水", "木", "金", "土"]

      # 氏名追加処理
      worksheet_form1.add_cell(9, 20, @teaching_assistant.labo[0...-1])
      # worksheet[9][20].change_border(:bottom, "medium")
      worksheet_form1.add_cell(18, 2, @teaching_assistant.name)

      # 学生番号追加処理
      worksheet_form1.add_cell(18, 21, @teaching_assistant.number)

      # 所属分岐　学年ごとに分岐されている
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
      @assignments.each do |assignment|
        @work_hours = WorkHour.where(assignment_id: assignment.id).where(dtstart: date_start..).where(dtend: ..date_end).order(:dtstart)
        @course = Course.where(id: assignment.course_id)
        @work_hours.each do |work_hour|
          worksheet_form1.add_cell(36+count, 1, @course.first.number)
          worksheet_form1.add_cell(36+count, 3, @course.first.name)
          worksheet_form1.add_cell(36+count, 8, @course.first.term)
          worksheet_form1.add_cell(36+count, 9, days[work_hour.dtstart.wday])
          worksheet_form1.add_cell(36+count, 11, work_hour.dtstart.strftime('%Y-%m-%d %H:%M') )
          worksheet_form1.add_cell(36+count, 16, work_hour.dtend.strftime('%Y-%m-%d %H:%M') )
          worksheet_form1.add_cell(36+count, 20, work_hour.actual_working_minutes )
          sum_work_time = sum_work_time + work_hour.actual_working_minutes
          count += 1

          if count == 15 then
            # とりあえず今まで作成したものを保存する
            workbook_form1.write("#{first}-#{file_change_count}.xlsx")
            # workbook_form1.write("#{first}.xlsx")
            file_change_count +=1
            file_form1 = "public/excel/form1.xlsx"
            count = 0

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
          end
        end
      end

      # 複数ファイルを書き込んでいくときに最後に書き込み終了して保存するファイル
      workbook_form1.write("#{first}-#{file_change_count}.xlsx")
      # workbook_form1.write("#{first}.xlsx")

      return file_change_count
    end


    # 帳票の様式2を書き込む処理を行うメソッド
    def WriteForm2(date_start, date_end)
      file_form2 = "public/excel/form2.xlsx"
      workbook_form2 = RubyXL::Parser.parse(file_form2)
      worksheet_form2 = workbook_form2[0]
      # 割り当てられた講義
      @assignments = Assignment.where(teaching_assistant_id: @teaching_assistant.id)
      count = 0;
      sum_work_time = 0
      days = ["日", "月", "火", "水", "木", "金", "土"]
      months_start = { 1 => [47,7], 2  => [47,14], 3  => [47,21], 4  => [15,0], 5  => [15,7], 6  => [15,14], 7  => [15,21], 8  => [31,0], 9  => [31,7], 10  => [31,14], 11  => [31,21], 12  => [47,0]}
      months_time = [0,0,0,0,0,0,0,0,0,0,0,0]
      day_of_week = [6,0,1,2,3,4,5]
      add_num = 0
      teachers = ""

      # 氏名追加処理
      worksheet_form2.add_cell(2, 4, @teaching_assistant.name)

      # 研究室名
      worksheet_form2.add_cell(1, 18, @teaching_assistant.labo + "研究室")

      # 学生番号
      worksheet_form2.add_cell(2, 18, @teaching_assistant.number)

      # 所属分岐
      if @teaching_assistant.grade == "M1" or @teaching_assistant.grade == "M2" then
        # worksheet_form1.add_cell(20, 15, @teaching_assistant.grade)
        worksheet_form2.add_cell(1, 18, "大学院環境生命自然科学研究科")
        worksheet_form2.add_cell(8, 4, "TA")
        worksheet_form2.add_cell(3, 18, "1")
      elsif @teaching_assistant.grade == "D1" or @teaching_assistant.grade == "D2" or @teaching_assistant.grade == "D3" then
        # worksheet_form1.add_cell(20, 15, @teaching_assistant.grade)
        worksheet_form2.add_cell(1, 18, "大学院環境生命自然科学研究科")
        worksheet_form2.add_cell(8, 4, "TA")
        worksheet_form2.add_cell(3, 18, "2")
      else
        worksheet_form2.add_cell(8, 4, "SA")
        worksheet_form2.add_cell(3, 18, "なし")
      end

      # 勤務時間を記入
      @assignments.each do |assignment|
        @work_hours = WorkHour.where(assignment_id: assignment.id).where(dtstart: date_start..).where(dtend: ..date_end).order(:dtstart)
        @course = Course.where(id: assignment.course_id)
        teachers = teachers + @course.first.instructor + "  "

        @work_hours.each do |work_hour|
          year = work_hour.dtstart.strftime('%Y').to_i
          month = work_hour.dtstart.strftime('%m').to_i
          day =  work_hour.dtstart.strftime('%d').to_i

          for i in 0..6 do
            # 初めて日曜になる日を見つける
            if 0 == Date.new(year,month,1+i).wday then
              add_num = 6 - (1+i)
            end
          end

          week_count = (day+add_num).div(7)

          line = months_start[month][0] + week_count*2
          row = months_start[month][1]+day_of_week[work_hour.dtstart.wday]
          
          #if  worksheet_form2[line][row].value != "" then
          #  writed_data = worksheet_form2[line][row].value
          #  worksheet_form2.add_cell(line, row, writed_data.to_i+work_hour.actual_working_minutes)
          #else 
          #  worksheet_form2.add_cell(line, row, work_hour.actual_working_minutes )
          #end
          count += 1
        end
      end
      worksheet_form2.add_cell(5, 18, teachers)
      workbook_form2.write("public/excel/writed_form2.xlsx")
      # workbook_form2.write("public/excel/writed_form2.pdf")
    end
end
