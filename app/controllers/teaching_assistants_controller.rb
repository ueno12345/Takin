# require 'rubyXL'
# require 'axlsx'

class TeachingAssistantsController < ApplicationController
  before_action :set_teaching_assistant, only: %i[ show edit update ]

  # GET /teaching_assistants or /teaching_assistants.json
  def index
    @teaching_assistants = TeachingAssistant.all
  end

  # GET /teaching_assistants/1 or /teaching_assistants/1.json
  def show
    @teaching_assistant = TeachingAssistant.find(params[:id])
    @assignments = @teaching_assistant.assignments.where(teaching_assistant_id: @teaching_assistant.id)
  end

  # GET /teaching_assistants/new
  def new
    @teaching_assistant = TeachingAssistant.new
  end

  # GET /teaching_assistants/1/edit
  def edit
  end

  # POST /teaching_assistants or /teaching_assistants.json
  def create
    @teaching_assistant = TeachingAssistant.new(teaching_assistant_params)

    respond_to do |format|
      if @teaching_assistant.save
        format.html { redirect_to teaching_assistant_url(@teaching_assistant), notice: "Teaching assistant was successfully created." }
        format.json { render :show, status: :created, location: @teaching_assistant }
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

  def destroy
    @teaching_assistants = TeachingAssistant.where(id: params[:teaching_assistant_ids])
    @teaching_assistants.destroy_all
    redirect_to index_destroy_teaching_assistants_path, notice: "TAが削除されました"
  end

  def index_destroy
    @teaching_assistants = TeachingAssistant.all
  end

  def import
    TeachingAssistant.import(params[:file])
    redirect_to teaching_assistants_url, notice: "新規TAマスタデータを追加しました"
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

    # 帳票出力処理を行う
    def output_ticket
      # RubyXL::Parser.parse("path/to/excel/form1.xlsx")
      # 新規エクセルファイルを作成
      workbook = RubyXL::Workbook.new
      workbook.write("path/to/desired/Excel/file.xlsx")
    end
end
