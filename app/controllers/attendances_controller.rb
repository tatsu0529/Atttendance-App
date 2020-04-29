class AttendancesController < ApplicationController
  before_action :set_user, only: :edit_one_month
  before_action :set_attendance, only: :request_overtime
  before_action :logged_in_user, only: [:update, :edit_one_month]
  # before_action :month, only: :edit_one_month
  before_action :one_month, only: :edit_one_month
  # before_action :set_one_month, only: :edit_one_month
  before_action :users

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
    if @attendance.update_attributes(overtime_params)
      # 24時間を足す
      # if @attendance.tomorrow == "1"
      #   @attendance = @attendance.finish_time + 1
      # end 
      flash[:success] = "残業を申請しました。"
    end 
    redirect_to user_url(current_user)
  end 
  
  # 残業確認
  def overtime_confirmation
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {finish_time: nil})
    @attendance = Attendance.where.not(finish_time: nil).where(mark_by_instructor: nil)
  end
  
  # 残業申請への返信
  def reply_overtime
    reply_overtime_params.each do |id, finish_time|
      attendance = Attendance.find(id)
      if attendance.update(finish_time)
        flash[:success] = "申請に返信しました。"
      end
    end 
    redirect_to user_url(current_user)
  end 
  
  # 1ヶ月分の勤怠申請
  def request_one_month
    if Attendance.where(['user_id = ?', current_user.id])\
                 .where(worked_on: params[:date])\
                 .update(request_one_month: params[:user][:attendance][:request_one_month])
      flash[:success] = "1ヶ月分の勤怠を申請しました。"
    end
    redirect_to user_url(current_user)
  end 
  
  # 1ヶ月分の勤怠申請確認
  def attendance_confirmation
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {request_one_month: nil})
    @attendance = Attendance.where.not(request_one_month: nil).where(approval_by_boss: nil)
  end 
  
  # 1ヶ月分の勤怠申請の返信
  def reply_attendance
    one_month_params.each do |id, one_month_attendance|
      attendance = Attendance.find(id)
      if attendance.update(one_month_attendance)
      flash[:success] = "勤怠申請の返信をしました。"
      end 
    end 
    redirect_to user_url(current_user)
  end 
  
  # 勤怠変更の確認
  def attendance_change
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {request_for_change: nil})
    @attendance = Attendance.where.not(request_for_change: nil)
  end 
  
  def reply_change
    reply_change_params.each do |id, attendance_change|
      attendance = Attendance.find(id)
      if attendance.update(attendance_change)
        flash[:success] = "申請に返信しました。"
      end
    end 
    redirect_to user_url(current_user)
  end 
  
  def confirm_log_change
    @user = User.find(params[:id])
    if params[:B].blank?
      @day = "-" + params[:A] + "-" if params[:A].present?
      @attendances = @user.attendances.where('worked_on LIKE ?' , "%#{@day}%")
    else
      @day = params[:B] + "-" + params[:A]
      @attendances = @user.attendances.where('worked_on LIKE ?', "#{@day}%")
    end
  end
    
  private
  
  # 1ヶ月の勤怠更新時
  def attendances_params
    params.require(:user).permit(attendances: [:latest_started_at, :latest_finished_at, :note, :request_for_change, :tomorrow])[:attendances]
  end
  
  # 残業申請時
  def overtime_params
    params.require(:attendance).permit(:finish_time, :work_contents, :mark_of_instructor, :tomorrow)
  end 
  
  # 残業申請への返信
  def reply_overtime_params
    params.require(:user).permit(attendances: [:mark_by_instructor, :change])[:attendances]
  end
  
  # 勤怠変更への返信
  def reply_change_params
    params.require(:user).permit(attendances: [:approve_change, :change])[:attendances]
  end 
  
  # 1ヶ月分の勤怠への返信
  def one_month_params
    params.require(:user).permit(attendances: [:change, :approval_by_boss])[:attendances]
  end 

end