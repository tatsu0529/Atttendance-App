class BasesController < ApplicationController
  
  def index
    @bases = Base.all
  end
  
  def edit
  end 
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点の更新に成功しました。"
      redirect_to @base
    else
      render :edit
    end
  end
  
  def create
  @base = Base.new(base_params)
    if @base.save
      flash[:info] = "拠点情報を追加しました。"
    end
  end 
  
  
  private
  
  def base_params
      params.require(:base).permit(:base_name, :base_number)
    end
  
end
