class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :overtime]
  before_action :set_attendance, only: :request_overtime
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :set_one_month, only: [:edit_one_month, :overtime]


UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
REQUEST_ERROR_MSG = "残業申請に失敗しました。やり直してください。"
REPLY_ERROR_MSG = "残業の返信に失敗しました。やり直してください。"

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
  
  # 残業申請モーダル表示
  def overtime
    @attendance = current_user.attendances.find_by(worked_on: params[:date])
  end 
  
  # 残業申請
  def request_overtime
    # @attendance = Attendance.find(params[:id])
    if @attendance.started_at.present?
      if @attendance.update_attributes(overtime_params)
        flash[:success] = "残業を申請しました。"
      else
        flash[:danger] = REQUEST_ERROR_MSG
      end 
    end
    redirect_to user_url(current_user)
  end 
  
  # 残業確認モーダル表示
  def overtime_confirmation
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {finish_time: nil})
    @attendance = Attendance.where.not(finish_time: nil)
  end
  
  # 残業申請への返信
  def reply_overtime
    @attendance = Attendance.where.not(finish_time: nil)
      if @attendance.update_attributes(reply_overtime_params)
        flash[:success] = "申請に返信しました。"
      else
        flash[:danger] = REPLY_ERROR_MSG
      end
    redirect_to user_url(current_user)
  end 
  
  private
  
  # 出退勤時
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end
  
  # 残業申請時
  def overtime_params
    params.require(:attendance).permit(:finish_time, :work_contents, :mark_of_instructor)
  end 
  
  def reply_overtime_params
    params.require(:user).permit(attendances: [:mark_of_instructor, :change])[:attendances]
  end 
  
end
