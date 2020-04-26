class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_attendance
    @attendance = Attendance.find(params[:id])
  end
  
  def set_base
    @base = Base.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def superior_user
    redirect_to root_url unless current_user.superior?
  end 
  
  def month
    @month = Date.current
  end 
  
  def one_month
    @month = current_user.attendances.find_by(worked_on: params[:date])
    @first_day = @month.worked_on.beginning_of_month
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    # ユーザーに紐づく一ヶ月分のレコードを検索し、取得する
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  end 
  
  def set_one_month
    @first_day = params[:date].nil? ?
    @month.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    # ユーザーに紐づく一ヶ月分のレコードを検索し、取得する
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        one_month.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
    
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end
  
  # ユーザーに紐づく働いている日を検索し、取得する
  def set_overtime
    @attendances = @user.attendances.where(worked_on)
  end 
  
  def users
    @users = User.where(superior: true).where.not(id: current_user)
  end
end