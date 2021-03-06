class Users::CorrectionsController < ApplicationController
  layout 'user'
  before_action :authenticate_user!
  before_action :find_correction, only: [:edit, :update]

  def index
    @corrections = Correction.where(user: current_user).where("grade = 1.0")
  end

  def edit
  end

  def update
    @correction.update_attributes(correction_params)
    if @correction.valid?
      @correction.save
      @paper.grade_it
      @paper.user.calculate_score
      redirect_to users_user_corrections_path(current_user.id), flash: { success: "Paper graded!" }
    else
      render 'edit'
    end
  end

  private
    def correction_params
      params.require(:correction).permit(:user_id, :paper_id, :grade, :observations)
    end

    def find_paper
      @paper = @correction.paper
    end

    def find_correction
      @correction = Correction.find(params[:id])
      find_paper
    end
end
