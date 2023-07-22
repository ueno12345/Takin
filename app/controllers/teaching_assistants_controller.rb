class TeachingAssistantsController < ApplicationController
  before_action :login, only: %i[ index show new create edit update deatroy index_destroy import]
  before_action :admin_judge, only: %i[ new index_destroy]
  before_action :set_teaching_assistant, only: %i[ show edit update ]

  # GET /teaching_assistants or /teaching_assistants.json
  def index
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true)
    @select_years = TeachingAssistant.where.not(id: 1).pluck(:year).uniq
  end

  # GET /teaching_assistants/1 or /teaching_assistants/1.json
  def show
    if params[:id].to_i == 1
      render plain: "アクセスが制限されています", status: :forbidden
    else
      @teaching_assistant = TeachingAssistant.find(params[:id])
      @q = @teaching_assistant.assignments.ransack(params[:q], teaching_assistant_id_eq: @teaching_assistant.id)
      @assignments = @q.result(distinct: true)
      @sum_actual_working_minutes = @assignments.map { |assignment| assignment.work_hours.sum(:actual_working_minutes) }.sum
    end
  end

  # GET /teaching_assistants/new
  def new
    @teaching_assistant = TeachingAssistant.new
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true)
    @select_years = TeachingAssistant.where.not(id: 1).pluck(:year).uniq
  end

  # GET /teaching_assistants/1/edit
  def edit
    # ============#
    # 使用してない =#
    # ============#
  end

  # POST /teaching_assistants or /teaching_assistants.json
  def create
    @teaching_assistant = TeachingAssistant.new(teaching_assistant_params)
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true)
    @select_years = TeachingAssistant.where.not(id: 1).pluck(:year).uniq

    respond_to do |format|
      if @teaching_assistant.save
        redirect_to new_teaching_assistant_path, notice: "TAが追加されました", flash: {color: :green}
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @teaching_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teaching_assistants/1 or /teaching_assistants/1.json
  def update
    respond_to do |format|
      if @teaching_assistant.update(teaching_assistant_params)
        format.html { redirect_to teaching_assistant_url(@teaching_assistant), notice: "Teaching assistant was successfully updated." }
        format.json { render :show, status: :ok, location: @teaching_assistant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @teaching_assistant.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #   if params[:teaching_assistant_ids].nil?
  #     redirect_to index_destroy_teaching_assistants_path, notice: "削除したいTAを選択してください", flash: {color: :red}
  #   else
  #     @teaching_assistants = TeachingAssistant.where(id: params[:teaching_assistant_ids])
  #     @teaching_assistants.destroy_all
  #     redirect_to index_destroy_teaching_assistants_path, notice: "TAが削除されました", flash: {color: :green}
  #   end
  # end
  def destroy
    if params[:teaching_assistant_ids].nil?
      redirect_to index_destroy_teaching_assistants_path, notice: "削除したいTAを選択してください", flash: {color: :red}
    else
      @teaching_assistants = TeachingAssistant.where(id: params[:teaching_assistant_ids])
      Assignment.where(teaching_assistant_id: @teaching_assistants.pluck(:id)).update_all(teaching_assistant_id: 1)
      @teaching_assistants.destroy_all
      redirect_to index_destroy_teaching_assistants_path, notice: "TAが削除されました", flash: {color: :green}
    end
  end

  def index_destroy
    @q = TeachingAssistant.ransack(params[:q])
    @teaching_assistants = @q.result(distinct: true)
    @select_years = TeachingAssistant.where.not(id: 1).pluck(:year).uniq
  end

  def import
    TeachingAssistant.import(params[:file])
    if params[:file].nil?
      redirect_to new_teaching_assistant_url, notice: "登録するTAマスタデータCSVファイルを選択してください", flash: {color: :red}
    else
      if params[:file].content_type == "text/csv"|| params[:file].content_type == "application/vnd.ms-excel"
        redirect_to teaching_assistants_url, notice: "新規TAマスタデータを追加しました", flash: {color: :green}
      else
        redirect_to new_teaching_assistant_url, notice: "CSVファイルのみを受け付けます", flash: {color: :red}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teaching_assistant
      @teaching_assistant = TeachingAssistant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def teaching_assistant_params
      params.require(:teaching_assistant).permit(:year, :number, :name, :grade, :labo, :description)
    end
end
