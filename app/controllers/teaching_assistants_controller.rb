class TeachingAssistantsController < ApplicationController
  before_action :set_teaching_assistant, only: %i[ show edit update destroy ]

  # GET /teaching_assistants or /teaching_assistants.json
  def index
    @teaching_assistants = TeachingAssistant.all
  end

  # GET /teaching_assistants/1 or /teaching_assistants/1.json
  def show
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

  # DELETE /teaching_assistants/1 or /teaching_assistants/1.json
  def destroy
    @teaching_assistant.destroy

    respond_to do |format|
      format.html { redirect_to teaching_assistants_url, notice: "Teaching assistant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def remove
    @teaching_assistants = TeachingAssistant.all
  end

  def import
    TeachingAssistant.import(params[:file])
    redirect_to teaching_assistants_url, notice: "aa"
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
