class WorkHoursController < ApplicationController
  before_action :set_work_hour, only: %i[ show edit update destroy ], except: [:update_multiple]

  # GET /work_hours or /work_hours.json
  def index
    @work_hours = WorkHour.all
  end

  # GET /work_hours/1 or /work_hours/1.json
  def show
  end

  # GET /work_hours/new
  def new
    @work_hour = WorkHour.new
  end

  # GET /work_hours/1/edit
  def edit
  end

  # POST /work_hours or /work_hours.json
  #def create
  #  @work_hour = WorkHour.new(work_hour_params)
  #
  #  respond_to do |format|
  #    if @work_hour.save
  #      #format.html { redirect_to work_hour_url(@work_hour), notice: "Work hour was successfully created." }
  #      format.html { redirect_to assignments_url, notice: "Work hour was successfully created." }
  #      format.json { render :show, status: :created, location: @work_hour }
  #    else
  #      format.html { render :new, status: :unprocessable_entity }
  #      format.json { render json: @work_hour.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  def create
    @work_hour = WorkHour.new(work_hour_params_create)
    puts "@work_hour: #{@work_hour.inspect}" 
    puts "params: #{params.inspect}" 

  
    #@assignment = Assignment.find(params[:assignment_id]) これはできなかった
    @assignment = Assignment.find(@work_hour.assignment_id)
    puts "@assignment: #{@assignment.inspect}" 
  
    @course = Course.find(@assignment.course_id)
    puts "@course: #{@course.inspect}" 


    respond_to do |format|
      if @work_hour.save
        puts "Work hour successfully created." 
        #format.html { redirect_to course_assignments_path(@course), notice: "Work hour was successfully created." }
        #format.html { redirect_to assignments_url, notice: "Work hour was successfully created." }
        format.html { redirect_to assignments_url }
        #format.js   # <- 追加
        format.json { render :show, status: :created, location: @work_hour }
      else
        puts "Failed to create work hour: #{@work_hour.errors.full_messages}" 
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /work_hours/1 or /work_hours/1.json
  def update
    respond_to do |format|
      if @work_hour.update(work_hour_params)
        format.html { redirect_to work_hour_url(@work_hour), notice: "Work hour was successfully updated." }
        format.json { render :show, status: :ok, location: @work_hour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
      end
    end
  end
   #PATCH/PUT /work_hours/1 or /work_hours/1.json
#  def update_multiple
#    @work_hours = WorkHour.where(assignment_id: params[:assignment_ids])
#    puts "work hours = #{@work_hours.inspect}"
#    respond_to do |format|
#      if @work_hours.update_all
#        format.html { redirect_to assignments_url, notice: "Work hour was successfully updated." }
#        format.json { render :show, status: :ok, location: @work_hour }
#      else
#        format.html { redirect_to assignments_url, notice: "Faild to Update" }
#        #format.html { render :edit, status: :unprocessable_entity }
#        format.json { render json: @work_hour.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  def update_multiple
    puts "Inside update_multiple action"
    puts "work_hours params: #{params[:work_hours].inspect}"
    params[:work_hours].each do |_, wh_params|
      work_hour = WorkHour.find(wh_params[:id])
      work_hour.update(work_hour_params(wh_params.except(:id)))
    end
    
    redirect_to assignments_url
  end



#  # DELETE /work_hours/1 or /work_hours/1.json
#  def destroy
#    @work_hour.destroy#

#    respond_to do |format|
#      format.html { redirect_to work_hours_url, notice: "Work hour was successfully destroyed." }
#      format.json { head :no_content }
#    end
#  end

  def destroy
    @work_hour = WorkHour.find(params[:id])
    course_id = @work_hour.course.id   # コースのIDを取得します。モデルの関連性によります。
    @work_hour.destroy

    respond_to do |format|
      #format.html { redirect_to assignments_url, notice: "Work hour was successfully destroyed." }
      format.html { redirect_to course_assignments_url(course_id) } # リダイレクト先を変更
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_hour
      @work_hour = WorkHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_hour_params(wh_params)
      wh_params.permit(:dtstart, :dtend, :actual_working_minutes, :assignment_id)
    end
    
    def work_hour_params_create
      params.require(:work_hour).permit(:dtstart, :dtend, :actual_working_minutes, :assignment_id)
    end
end

#              <%#= button_to "削除", work_hour_path(work_hour), method: :delete, class: 'btn btn-danger' %>
