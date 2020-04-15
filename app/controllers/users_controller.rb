class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_user, only: [:destroy, :edit, :edit_basic_info, :update_basic_info]
  # before_action :correct_user, only: [:edit, :update]
  before_action :set_one_month, only: :show
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end
  
  def attended_employees
    @attendance = Attendance.where.not(started_at: nil).where(finished_at: nil)
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @overtime_sum = @attendances.where.not(finish_time: nil).count
    @attendance = Attendance.all
    @link_to = 0
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後ログインする
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザーの更新に成功しました。"
      redirect_to users_url
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :affiliation, :employee_number)
    end
    
end
