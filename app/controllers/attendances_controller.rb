class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: :edit_one_month


UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはよう"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
  end  
  
  def overtime
    @attendance = Attendance.find_by(worked_on: params[:date])
  end 
  
  def request_overtime
    @attendance = Attendance.find(params[:id])
    if @attendance.update_attributes(overtime_params)
      flash[:success] = "残業を申請しました。"
      redirect_to users_url
    end 
  end 
  
  private
  
  def overtime_params
    params.require(:attendance).permit(:finish_time, :work_contents)
  end 
  
end


