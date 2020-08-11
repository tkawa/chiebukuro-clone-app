class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @posted_questions = @user.questions
    # 1. user が回答した質問　かつ　user が投稿した質問ではない
    @answered_questions = Question.joins(
      "INNER JOIN answers ON answers.question_id = questions.id
      WHERE answers.user_id = #{params[:id]} and questions.user_id != #{params[:id]}"
    ).uniq
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_back_or(@user)
    else
      render :new
    end
  end

  def update
    if @user.save
      redirect_to @user, flash: { success: 'User was successfully updated.'}
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to @user, flash: { success: 'User was successfully destroyed.'}
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
